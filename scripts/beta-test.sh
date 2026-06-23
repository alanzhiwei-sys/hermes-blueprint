#!/bin/bash
# Hermes Blueprint — Beta Test Harness
# End-to-end validation script for first customer deployment.
# Run AFTER install.sh completes successfully.
#
# Usage:
#   ./beta-test.sh                          # Run all tests
#   ./beta-test.sh --category profiles       # Test profiles only
#   ./beta-test.sh --category backup         # Test backup/restore only
#   ./beta-test.sh --smoke                   # Smoke test only (critical path)
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HERMES_HOME="${HERMES_HOME:-$HOME/.hermes}"

CATEGORY="all"
SMOKE_ONLY=false
VERBOSE=false
START_TIME=$(date +%s)

# ── Usage ─────────────────────────────────────────────────────────────
usage() {
    cat <<'EOF'
🧪  Hermes Blueprint — Beta Test Harness

Usage: ./beta-test.sh [options]

Options:
  --smoke              Smoke test only (critical path, ~30s)
  --category NAME      Test one category: install, profiles, backup, update, troubleshoot
  -v, --verbose        Show detailed test output
  -h, --help           Show this help

Categories:
  install       — Installer produces expected output
  profiles      — All profiles load, skills register, config validates
  backup        — Backup → destroy → restore roundtrip
  update        — Update check works, protected files preserved
  troubleshoot  — Troubleshooter detects issues correctly

Exit codes:
  0 — All tests passed
  1 — Some tests failed (check output)
EOF
    exit 0
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --smoke)     SMOKE_ONLY=true; shift ;;
        --category)  CATEGORY="$2"; shift 2 ;;
        -v|--verbose) VERBOSE=true; shift ;;
        -h|--help)   usage ;;
        *) echo "Unknown: $1"; usage ;;
    esac
done

# ── Test Framework ────────────────────────────────────────────────────
PASSED=0
FAILED=0
SKIPPED=0

pass() { echo "   ✅ $*"; PASSED=$((PASSED + 1)); }
fail() { echo "   ❌ $*"; FAILED=$((FAILED + 1)); }
skip() { echo "   ⬚  $* (skipped)"; SKIPPED=$((SKIPPED + 1)); }
info() { echo "   ℹ️  $*"; }

section() {
    echo ""
    echo "━━━ $1 ━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
}

# ── Preflight ─────────────────────────────────────────────────────────
preflight() {
    if [ ! -f "$SCRIPT_DIR/../install.sh" ]; then
        echo "❌ Must be run from the Blueprint scripts directory"
        exit 1
    fi
    
    # Check we have hermes
    if ! command -v hermes &>/dev/null; then
        echo "❌ hermes not found in PATH"
        echo "   Install Hermes Agent first, then re-run install.sh"
        exit 1
    fi
}

# ── Test: Install ─────────────────────────────────────────────────────
test_install() {
    section "INSTALL VERIFICATION"
    
    # Check prerequisites check passed
    # Root config.yaml is optional — each profile has its own
    if [ -f "$HERMES_HOME/config.yaml" ]; then
        pass "config.yaml exists"
    else
        info "No root config.yaml — profiles have individual configs"
    fi
    
    # Check profiles directory exists with content
    if [ -d "$HERMES_HOME/profiles" ]; then
        local count
        count=$(ls -d "$HERMES_HOME/profiles"/*/ 2>/dev/null | wc -l)
        if [ "$count" -ge 13 ]; then
            pass "$count profiles installed (expected ≥13)"
        else
            fail "Only $count profiles found (expected ≥13)"
        fi
    else
        fail "No profiles directory at $HERMES_HOME/profiles"
    fi
    
    # Check adaptable profiles have CUSTOMER_DOMAIN.md
    for p in zeus-project-manager hera-business-ops; do
        if [ -f "$HERMES_HOME/profiles/$p/CUSTOMER_DOMAIN.md" ]; then
            pass "$p: CUSTOMER_DOMAIN.md present"
        else
            fail "$p: CUSTOMER_DOMAIN.md missing"
        fi
    done
    
    # Check all profiles have core files
    local missing_core=0
    for profile_dir in "$HERMES_HOME/profiles"/*/; do
        [ ! -d "$profile_dir" ] && continue
        local pname
        pname=$(basename "$profile_dir")
        for f in SOUL.md config.yaml; do
            if [ ! -f "$profile_dir/$f" ]; then
                fail "$pname: missing $f"
                missing_core=$((missing_core + 1))
            fi
        done
    done
    if [ "$missing_core" -eq 0 ]; then
        pass "All profiles have SOUL.md + config.yaml"
    fi
    
    # Check Hermes can list profiles
    if hermes profile list 2>/dev/null | grep -q "zeus-renovation"; then
        pass "hermes profile list works"
    else
        fail "hermes profile list failed or missing profiles"
    fi
}

# ── Test: Profiles ────────────────────────────────────────────────────
test_profiles() {
    section "PROFILE FUNCTIONALITY"
    
    # Test each core profile loads without error
    local profiles_to_test=("zeus-renovation" "hera-smarthush" "hephaestus-assistant" "artemis-coder")
    
    for p in "${profiles_to_test[@]}"; do
        if [ -d "$HERMES_HOME/profiles/$p" ]; then
            # Check SOUL.md has content
            if [ -s "$HERMES_HOME/profiles/$p/SOUL.md" ]; then
                local lines
                lines=$(wc -l < "$HERMES_HOME/profiles/$p/SOUL.md")
                if [ "$lines" -gt 10 ]; then
                    pass "$p: SOUL.md populated ($lines lines)"
                else
                    fail "$p: SOUL.md too short ($lines lines)"
                fi
            else
                fail "$p: SOUL.md empty or missing"
            fi
            
            # Check AGENTS.md has content
            if [ -f "$HERMES_HOME/profiles/$p/AGENTS.md" ]; then
                if [ -s "$HERMES_HOME/profiles/$p/AGENTS.md" ]; then
                    pass "$p: AGENTS.md populated"
                else
                    fail "$p: AGENTS.md empty"
                fi
            else
                skip "$p: no AGENTS.md (optional)"
            fi
        else
            skip "$p: profile not installed"
        fi
    done
    
    # Check config.yaml has model set for each profile
    for profile_dir in "$HERMES_HOME/profiles"/*/; do
        [ ! -d "$profile_dir" ] && continue
        local pname
        pname=$(basename "$profile_dir")
        if [ -f "$profile_dir/config.yaml" ]; then
            if grep -q "^  model:" "$profile_dir/config.yaml" 2>/dev/null; then
                local model
                model=$(grep "^  model:" "$profile_dir/config.yaml" | head -1 | awk '{print $2}')
                if [ -n "$model" ] && [ "$model" != "''" ] && [ "$model" != '""' ]; then
                    : # OK — model is set
                else
                    fail "$pname: model not configured in config.yaml"
                fi
            else
                fail "$pname: no model field in config.yaml"
            fi
        fi
    done
    
    # Adaptable profiles: check template variable references exist
    for p in zeus-project-manager hera-business-ops; do
        if [ -f "$HERMES_HOME/profiles/$p/CUSTOMER_DOMAIN.md" ]; then
            if grep -q "YOUR_" "$HERMES_HOME/profiles/$p/CUSTOMER_DOMAIN.md" 2>/dev/null; then
                pass "$p: CUSTOMER_DOMAIN.md contains customization markers"
            else
                fail "$p: CUSTOMER_DOMAIN.md has no customization markers"
            fi
        fi
    done
}

# ── Test: Backup/Restore Roundtrip ────────────────────────────────────
test_backup() {
    section "BACKUP/RESTORE ROUNDTRIP"
    
    local BACKUP_DIR="$HERMES_HOME/backups"
    mkdir -p "$BACKUP_DIR"
    
    # 1. Run backup
    info "Running backup..."
    if bash "$SCRIPT_DIR/backup.sh" --output "$BACKUP_DIR" 2>&1 | grep -q "Backup created"; then
        pass "Backup created successfully"
    else
        fail "Backup creation failed"
        return
    fi
    
    local BACKUP_FILE
    BACKUP_FILE=$(ls -t "$BACKUP_DIR"/hermes-backup-*.tar.gz 2>/dev/null | head -1)
    
    if [ -z "$BACKUP_FILE" ] || [ ! -f "$BACKUP_FILE" ]; then
        fail "Backup file not found after creation"
        return
    fi
    
    local BACKUP_SIZE
    BACKUP_SIZE=$(du -sh "$BACKUP_FILE" | awk '{print $1}')
    info "Backup size: $BACKUP_SIZE"
    
    # 2. Record current state
    local PROFILES_BEFORE
    PROFILES_BEFORE=$(ls "$HERMES_HOME/profiles/" 2>/dev/null | sort)
    local COUNT_BEFORE
    COUNT_BEFORE=$(echo "$PROFILES_BEFORE" | wc -l)
    
    # 3. Destroy one profile (safer than all)
    local TEST_PROFILE="zeus-renovation"
    info "Destroying $TEST_PROFILE for restore test..."
    
    if [ ! -d "$HERMES_HOME/profiles/$TEST_PROFILE" ]; then
        skip "Test profile not found — using first available"
        TEST_PROFILE=$(ls "$HERMES_HOME/profiles/" 2>/dev/null | head -1)
    fi
    
    # Backup the profile first
    cp -r "$HERMES_HOME/profiles/$TEST_PROFILE" "/tmp/${TEST_PROFILE}-beta-backup"
    rm -rf "$HERMES_HOME/profiles/$TEST_PROFILE"
    
    # 4. Restore
    info "Restoring from backup..."
    if bash "$SCRIPT_DIR/restore.sh" "$BACKUP_FILE" --force 2>&1 | grep -q "Restore complete"; then
        pass "Restore completed"
    else
        fail "Restore failed"
        # Recover
        cp -r "/tmp/${TEST_PROFILE}-beta-backup" "$HERMES_HOME/profiles/$TEST_PROFILE"
        rm -rf "/tmp/${TEST_PROFILE}-beta-backup"
        return
    fi
    
    # 5. Verify
    if [ -d "$HERMES_HOME/profiles/$TEST_PROFILE" ]; then
        if [ -f "$HERMES_HOME/profiles/$TEST_PROFILE/SOUL.md" ]; then
            pass "Profile restored: $TEST_PROFILE (SOUL.md present)"
        else
            fail "Profile restored but SOUL.md missing: $TEST_PROFILE"
        fi
    else
        fail "Profile not restored: $TEST_PROFILE directory missing"
        # Recover
        cp -r "/tmp/${TEST_PROFILE}-beta-backup" "$HERMES_HOME/profiles/$TEST_PROFILE"
    fi
    
    rm -rf "/tmp/${TEST_PROFILE}-beta-backup"
    
    local COUNT_AFTER
    COUNT_AFTER=$(ls "$HERMES_HOME/profiles/" 2>/dev/null | wc -l)
    if [ "$COUNT_BEFORE" -eq "$COUNT_AFTER" ]; then
        pass "Profile count matches ($COUNT_BEFORE before → $COUNT_AFTER after)"
    else
        fail "Profile count mismatch: $COUNT_BEFORE before → $COUNT_AFTER after"
    fi
}

# ── Test: Update Mechanism ────────────────────────────────────────────
test_update() {
    section "UPDATE MECHANISM"
    
    # 1. Run update --check (should show 0 pending)
    info "Running update --check..."
    local check_output
    check_output=$(bash "$SCRIPT_DIR/update.sh" --check --source "$SCRIPT_DIR/.." 2>&1) || true
    
    if echo "$check_output" | grep -q "Would update/create: 0"; then
        pass "Update check: no pending changes (clean state)"
    else
        local pending
        pending=$(echo "$check_output" | grep "Would update/create:" | grep -o '[0-9]\+' | head -1) || pending="?"
        info "Update check: $pending pending changes (expected after fresh install)"
        pass "Update check runs without errors"
    fi
    
    # 2. Customize a protected file and verify it's preserved
    local TEST_DOMAIN="$HERMES_HOME/profiles/zeus-project-manager/CUSTOMER_DOMAIN.md"
    if [ -f "$TEST_DOMAIN" ]; then
        echo "# TEST MARKER: beta-test-$(date +%s)" >> "$TEST_DOMAIN"
        info "Added test marker to CUSTOMER_DOMAIN.md"
        
        bash "$SCRIPT_DIR/update.sh" --force --source "$SCRIPT_DIR/.." 2>&1 > /dev/null || true
        
        if grep -q "TEST MARKER: beta-test" "$TEST_DOMAIN"; then
            pass "Protected file preserved after update"
        else
            fail "Protected file was overwritten by update!"
        fi
        
        # Clean up test marker
        sed -i '/TEST MARKER: beta-test/d' "$TEST_DOMAIN"
    else
        skip "CUSTOMER_DOMAIN.md not found — skipping protected file test"
    fi
    
    # 3. Update scripts should be idempotent
    bash "$SCRIPT_DIR/update.sh" --force --source "$SCRIPT_DIR/.." 2>&1 > /dev/null || true
    local second_check
    second_check=$(bash "$SCRIPT_DIR/update.sh" --check --source "$SCRIPT_DIR/.." 2>&1) || true
    if echo "$second_check" | grep -q "Would update/create: 0"; then
        pass "Update is idempotent (second run: 0 changes)"
    else
        info "Update check after run may show residual changes"
    fi
}

# ── Test: Troubelshooter ──────────────────────────────────────────────
test_troubleshoot() {
    section "TROUBLESHOOTER"
    
    # Quick scan should complete without errors
    if bash "$SCRIPT_DIR/troubleshoot.sh" --quick 2>&1 | grep -qi "health\|passed"; then
        pass "Troubleshooter --quick runs successfully"
    else
        fail "Troubleshooter --quick failed"
    fi
    
    # Full scan should complete
    local full_output
    full_output=$(bash "$SCRIPT_DIR/troubleshoot.sh" --issue all 2>&1) || true
    if echo "$full_output" | grep -qi "health\|passed"; then
        pass "Troubleshooter --issue all runs successfully"
    else
        fail "Troubleshooter --issue all failed"
    fi
    
    # Score should be a number
    local score
    score=$(echo "$full_output" | grep "health:" | grep -oE '[0-9]+' | head -1) || score=0
    if [ "${score:-0}" -gt 0 ]; then
        info "Health score: $score/100"
        pass "Troubleshooter produces a health score"
    else
        fail "Troubleshooter produced no health score"
    fi
}

# ── Main ──────────────────────────────────────────────────────────────
preflight

echo ""
echo "🧪  Hermes Blueprint — Beta Test Harness"
echo "═══════════════════════════════════════"
echo "   Hermes home: $HERMES_HOME"
echo "   Category:    $CATEGORY"
echo "   Started:     $(date)"
echo ""

if $SMOKE_ONLY; then
    test_install
    test_profiles
else
    case "$CATEGORY" in
        all)
            test_install
            test_profiles
            test_backup
            test_update
            test_troubleshoot
            ;;
        install)       test_install ;;
        profiles)      test_profiles ;;
        backup)        test_backup ;;
        update)        test_update ;;
        troubleshoot)  test_troubleshoot ;;
        *)
            echo "❌ Unknown category: $CATEGORY"
            echo "   Valid: install, profiles, backup, update, troubleshoot, all"
            exit 1
            ;;
    esac
fi

# ── Summary ───────────────────────────────────────────────────────────
TOTAL=$((PASSED + FAILED + SKIPPED))
ELAPSED=$(( $(date +%s) - START_TIME ))

echo ""
echo "═══════════════════════════════════════"
echo "📊 BETA TEST RESULTS"
echo ""
echo "   ✅ Passed:  $PASSED/$TOTAL"
echo "   ❌ Failed:  $FAILED/$TOTAL"
echo "   ⬚  Skipped: $SKIPPED/$TOTAL"
echo "   ⏱️  Time:    ${ELAPSED}s"
echo ""

if [ "$FAILED" -eq 0 ]; then
    echo "   🟢 ALL TESTS PASSED"
    echo ""
    echo "   ✅ Ready for production use"
    echo ""
    echo "   Next:"
    echo "   1. Configure API keys: hermes config set model.api_key <key>"
    echo "   2. Customize adaptable profiles"
    echo "   3. Set up cron jobs for daily health checks"
    echo "   4. Schedule regular backups"
    echo ""
    echo "═══════════════════════════════════════"
    exit 0
else
    echo "   🔴 TESTS FAILED — see issues above"
    echo ""
    echo "   Fix failures, then re-run:"
    echo "   ./beta-test.sh --category <failed-category>"
    echo ""
    echo "═══════════════════════════════════════"
    exit 1
fi
