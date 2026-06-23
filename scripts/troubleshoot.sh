#!/bin/bash
# Hermes Blueprint — Troubleshooting Guide
# Comprehensive diagnostic and resolution reference for customer deployments.
#
# Usage:
#   ./troubleshoot.sh                            # Full diagnostic scan
#   ./troubleshoot.sh --quick                     # Quick health check only
#   ./troubleshoot.sh --issue <CATEGORY>          # Targeted deep dive
#   ./troubleshoot.sh --report                    # Generate markdown report
#
# Categories:
#   install, profiles, config, gateway, memory, backup, cron, skills, all
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HERMES_HOME="${HERMES_HOME:-$HOME/.hermes}"
QUICK=false
ISSUE="all"
REPORT=false
VERBOSE=false

# ── Usage ─────────────────────────────────────────────────────────────
usage() {
    cat <<'EOF'
🔍  Hermes Blueprint — Troubleshooter

Usage: ./troubleshoot.sh [options]

Options:
  --quick              Fast health check (~10s)
  --issue CATEGORY     Deep-dive one area: install, profiles, config,
                       gateway, memory, backup, cron, skills, all
  --report             Output as markdown report (for sharing)
  -v, --verbose        Show raw command output for failed checks
  -h, --help           Show this help

Examples:
  ./troubleshoot.sh                           # Full scan
  ./troubleshoot.sh --quick                   # Quick health
  ./troubleshoot.sh --issue gateway           # Gateway deep dive
  ./troubleshoot.sh --issue config --report   # Config report
  ./troubleshoot.sh --report                  # Full markdown report
EOF
    exit 0
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --quick)   QUICK=true; shift ;;
        --issue)   ISSUE="$2"; shift 2 ;;
        --report)  REPORT=true; shift ;;
        -v|--verbose) VERBOSE=true; shift ;;
        -h|--help) usage ;;
        *) echo "Unknown option: $1"; usage ;;
    esac
done

# ── State ─────────────────────────────────────────────────────────────
PASS=0
WARN=0
FAIL=0
ISSUES_FOUND=()

say_ok()   { echo "   ✅ $*"; PASS=$((PASS + 1)); }
say_warn() { echo "   ⚠️  $*"; WARN=$((WARN + 1)); ISSUES_FOUND+=("⚠️  $*"); }
say_fail() { echo "   ❌ $*"; FAIL=$((FAIL + 1)); ISSUES_FOUND+=("❌ $*"); }
say_info() { echo "   ℹ️  $*"; }

section() {
    echo ""
    echo "── $1 ───────────────────────────────────────"
}

# ── Checks ────────────────────────────────────────────────────────────

check_hermes_installed() {
    if command -v hermes &>/dev/null; then
        local ver
        ver=$(hermes --version 2>/dev/null | head -1) || ver="unknown"
        say_ok "Hermes Agent installed ($ver)"
    else
        say_fail "Hermes Agent not found in PATH"
        say_info "Run: curl -sSL https://get.hermesagent.com | bash"
    fi
}

check_config() {
    if [ -f "$HERMES_HOME/config.yaml" ]; then
        say_ok "config.yaml exists"
        
        # Check for common misconfigurations
        if command -v hermes &>/dev/null; then
            local check_output
            check_output=$(hermes config check 2>&1) || true
            if echo "$check_output" | grep -qi "error\|invalid\|missing"; then
                say_warn "Config has validation warnings:"
                echo "$check_output" | grep -i "error\|invalid\|missing" | head -5 | while read -r line; do
                    echo "      $line"
                done
            else
                say_ok "Config passes validation"
            fi
        fi
        
        # Check for placeholder values
        if grep -q "YOUR_PROVIDER\|YOUR_MODEL\|YOUR_API_KEY" "$HERMES_HOME/config.yaml" 2>/dev/null; then
            say_warn "Config contains placeholder values (YOUR_*)"
            say_info "Run: hermes config set model.provider <your-provider>"
            say_info "Run: hermes config set model.api_key <your-key>"
        fi
        
        # Check provider set
        if grep -q "^  provider: ''$" "$HERMES_HOME/config.yaml" 2>/dev/null; then
            say_warn "Model provider is empty"
        fi
    else
        say_fail "config.yaml missing — Hermes cannot operate"
        say_info "Run: ./install.sh to regenerate"
    fi
    
    # Check .env
    if [ -f "$HERMES_HOME/.env" ]; then
        say_ok ".env exists"
        if grep -q "YOUR_" "$HERMES_HOME/.env" 2>/dev/null; then
            say_warn ".env contains placeholder values"
        fi
    else
        say_warn ".env not found — API keys may not be set"
    fi
}

check_profiles() {
    if [ -d "$HERMES_HOME/profiles" ]; then
        local count
        count=$(ls -d "$HERMES_HOME/profiles"/*/ 2>/dev/null | wc -l)
        say_ok "$count profiles found"
        
        # Spot check each profile
        for profile_dir in "$HERMES_HOME/profiles"/*/; do
            [ ! -d "$profile_dir" ] && continue
            local pname
            pname=$(basename "$profile_dir")
            local issues=0
            
            [ ! -f "$profile_dir/SOUL.md" ] && issues=$((issues + 1))
            [ ! -f "$profile_dir/config.yaml" ] && issues=$((issues + 1))
            [ ! -f "$profile_dir/AGENTS.md" ] && issues=$((issues + 1))
            
            if [ "$issues" -gt 0 ]; then
                say_warn "$pname: missing $issues core file(s)"
            fi
        done
    else
        say_fail "No profiles directory found"
        say_info "Run: ./install.sh --all"
    fi
}

check_backup() {
    if [ -d "$HERMES_HOME/backups" ]; then
        local latest
        latest=$(ls -t "$HERMES_HOME/backups"/hermes-backup-*.tar.gz 2>/dev/null | head -1) || true
        if [ -n "$latest" ]; then
            local age_hours
            age_hours=$(( ($(date +%s) - $(stat -c %Y "$latest")) / 3600 ))
            if [ "$age_hours" -lt 24 ]; then
                say_ok "Backup exists ($age_hours hours old)"
            elif [ "$age_hours" -lt 168 ]; then
                say_warn "Backup is $age_hours hours old — consider running ./backup.sh"
            else
                say_fail "Backup is $((age_hours / 24)) days old — run ./backup.sh immediately"
            fi
        else
            say_warn "No backups found — run ./backup.sh"
        fi
    else
        say_warn "No backup directory exists"
        say_info "Run: mkdir -p $HERMES_HOME/backups && ./backup.sh"
    fi
}

check_cron() {
    if [ -f "$HERMES_HOME/cron/scheduler.db" ]; then
        say_ok "Cron scheduler database exists"
        
        # Check if scheduler is running
        if pgrep -f "hermes.*cron" > /dev/null 2>&1; then
            say_ok "Cron scheduler is running"
        else
            say_warn "Cron scheduler may not be running"
            say_info "Check: hermes cron status"
        fi
        
        # Check ticker
        if [ -f "$HERMES_HOME/cron/ticker_last_success" ]; then
            local last_tick
            last_tick=$(cat "$HERMES_HOME/cron/ticker_last_success" 2>/dev/null) || last_tick="unknown"
            say_ok "Last tick: $last_tick"
        else
            say_warn "No cron ticker heartbeat — scheduler may be stuck"
        fi
    else
        say_info "No cron database — may not be set up yet"
    fi
}

check_memory() {
    if command -v hermes &>/dev/null; then
        if hermes memory stats 2>/dev/null | grep -q "working\|episodic"; then
            say_ok "Mnemosyne memory is active"
        else
            say_warn "Memory engine may not be active"
            say_info "Run: hermes memory setup"
        fi
    fi
}

check_skills() {
    if [ -d "$HERMES_HOME/skills" ]; then
        local skill_count
        skill_count=$(find "$HERMES_HOME/skills" -name "SKILL.md" 2>/dev/null | wc -l)
        say_ok "$skill_count skills found"
    else
        say_info "No global skills directory"
    fi
    
    # Check for malformed skills
    if command -v hermes &>/dev/null; then
        local skill_list
        skill_list=$(hermes skills list 2>/dev/null) || true
        if echo "$skill_list" | grep -qi "error\|corrupted\|invalid"; then
            say_warn "Some skills may be corrupted"
            say_info "Run: hermes skills doctor"
        fi
    fi
}

check_disk() {
    local usage
    usage=$(df -h "$HERMES_HOME" 2>/dev/null | tail -1 | awk '{print $5}' | tr -d '%')
    local avail
    avail=$(df -h "$HERMES_HOME" 2>/dev/null | tail -1 | awk '{print $4}')
    
    if [ "${usage:-100}" -lt 80 ]; then
        say_ok "Disk ${usage}% used, ${avail} free"
    elif [ "${usage:-100}" -lt 95 ]; then
        say_warn "Disk ${usage}% used — running low (${avail} free)"
    else
        say_fail "Disk ${usage}% used — CRITICAL (${avail} free)"
        say_info "Clean up: hermes cache clean"
        say_info "Or: docker system prune -a"
    fi
}

check_gateway() {
    if command -v hermes &>/dev/null; then
        local gw_status
        gw_status=$(hermes gateway status 2>/dev/null) || true
        if echo "$gw_status" | grep -qi "running\|active"; then
            say_ok "Gateway is running"
        elif echo "$gw_status" | grep -qi "stopped\|inactive"; then
            say_warn "Gateway is stopped"
            say_info "Start: hermes gateway start"
        else
            say_info "Gateway status unknown (may not be configured)"
        fi
    fi
}

check_python() {
    if command -v python3 &>/dev/null; then
        local pyver
        pyver=$(python3 --version 2>&1)
        say_ok "Python: $pyver"
        
        # Check Hermes venv Python version
        if [ -f "$HERMES_HOME/hermes-agent/venv/bin/python" ]; then
            local venv_ver
            venv_ver=$("$HERMES_HOME/hermes-agent/venv/bin/python" --version 2>&1) || venv_ver="unknown"
            say_ok "Hermes venv: $venv_ver"
        fi
    else
        say_fail "Python 3 not found"
    fi
}

# ── Issue-specific deep dives ─────────────────────────────────────────

deep_install() {
    section "INSTALLATION DEEP DIVE"
    check_hermes_installed
    check_python
    
    # Check installation method
    if [ -f "$HERMES_HOME/.install_method" ]; then
        say_info "Install method: $(cat "$HERMES_HOME/.install_method")"
    fi
    
    # Check venv integrity
    if [ -d "$HERMES_HOME/hermes-agent/venv" ]; then
        say_ok "Hermes venv exists"
        if [ -f "$HERMES_HOME/hermes-agent/venv/bin/pip" ]; then
            local missing
            missing=$("$HERMES_HOME/hermes-agent/venv/bin/pip" check 2>&1 | grep -c "No broken" || true)
            if [ "$missing" -eq 0 ]; then
                say_warn "venv has broken dependencies"
                say_info "Fix: cd $HERMES_HOME/hermes-agent && venv/bin/pip install -e ."
            else
                say_ok "venv dependencies intact"
            fi
        fi
    else
        say_fail "Hermes venv missing — reinstall required"
    fi
}

deep_profiles() {
    section "PROFILES DEEP DIVE"
    check_profiles
    
    if [ -d "$HERMES_HOME/profiles" ]; then
        for profile_dir in "$HERMES_HOME/profiles"/*/; do
            [ ! -d "$profile_dir" ] && continue
            local pname
            pname=$(basename "$profile_dir")
            
            echo ""
            echo "   📁 $pname"
            
            # File presence
            for f in SOUL.md AGENTS.md config.yaml CUSTOMER_DOMAIN.md; do
                if [ -f "$profile_dir/$f" ]; then
                    echo "      ✅ $f"
                else
                    echo "      ⬚  $f (not present)"
                fi
            done
            
            # Config has model set?
            if [ -f "$profile_dir/config.yaml" ]; then
                local model
                model=$(grep "^  model:" "$profile_dir/config.yaml" 2>/dev/null | head -1 | awk '{print $2}') || model=""
                if [ -z "$model" ] || [ "$model" = "''" ]; then
                    echo "      ⚠️  No model configured"
                fi
            fi
            
            # Skills
            if [ -d "$profile_dir/skills" ]; then
                local sc
                sc=$(find "$profile_dir/skills" -name "SKILL.md" 2>/dev/null | wc -l)
                echo "      📚 $sc skills"
            fi
            
            # Vault
            if [ -d "$profile_dir/vault/wiki" ]; then
                local wc
                wc=$(find "$profile_dir/vault/wiki" -name "*.md" 2>/dev/null | wc -l)
                echo "      📝 $wc wiki pages"
            fi
        done
    fi
}

deep_config() {
    section "CONFIGURATION DEEP DIVE"
    check_config
    
    if [ -f "$HERMES_HOME/config.yaml" ]; then
        echo ""
        echo "   Active configuration summary:"
        echo ""
        
        # Show key settings
        for key in "model.provider" "model.model" "memory.provider" "terminal.backend" "context.engine"; do
            local val
            val=$(grep "^  ${key##*.}:" "$HERMES_HOME/config.yaml" 2>/dev/null | head -1 | awk '{$1=""; print $0}' | xargs) || val="not set"
            printf "   %-25s %s\n" "$key:" "$val"
        done
        
        # Gateway config
        if grep -q "telegram:" "$HERMES_HOME/config.yaml" 2>/dev/null; then
            echo ""
            echo "   Gateway: Telegram configured"
            local bot_token
            bot_token=$(grep "bot_token:" "$HERMES_HOME/config.yaml" 2>/dev/null | head -1 | awk '{print $2}') || bot_token="not set"
            if [ "$bot_token" = "YOUR_TELEGRAM_BOT_TOKEN" ] || [ -z "$bot_token" ]; then
                say_warn "Telegram bot token not configured"
            fi
        else
            echo ""
            echo "   Gateway: Not configured"
        fi
    fi
}

deep_gateway() {
    section "GATEWAY DEEP DIVE"
    check_gateway
    
    if command -v hermes &>/dev/null; then
        echo ""
        echo "   Gateway platforms:"
        hermes gateway list 2>/dev/null || say_warn "Could not list gateway platforms"
        
        echo ""
        echo "   Connected channels:"
        if [ -f "$HERMES_HOME/channel_directory.json" ]; then
            python3 -c "
import json
with open('$HERMES_HOME/channel_directory.json') as f:
    data = json.load(f)
for k, v in data.items():
    print(f'   {k}: {v.get(\"chat_id\", \"?\")} ({v.get(\"platform\", \"?\")})')
" 2>/dev/null || say_warn "Could not parse channel directory"
        else
            say_info "No channel directory"
        fi
    fi
}

deep_backup() {
    section "BACKUP DEEP DIVE"
    check_backup
    
    if [ -d "$HERMES_HOME/backups" ]; then
        echo ""
        echo "   Backup history:"
        ls -lht "$HERMES_HOME/backups"/hermes-backup-*.tar.gz 2>/dev/null | head -10 | while read -r line; do
            echo "   $line"
        done
        
        local total_size
        total_size=$(du -sh "$HERMES_HOME/backups" 2>/dev/null | awk '{print $1}')
        echo ""
        echo "   Total backup storage: $total_size"
    fi
}

deep_cron() {
    section "CRON DEEP DIVE"
    check_cron
    
    if command -v hermes &>/dev/null; then
        echo ""
        hermes cron list 2>/dev/null || say_warn "Could not list cron jobs"
    fi
}

deep_skills() {
    section "SKILLS DEEP DIVE"
    check_skills
    
    if command -v hermes &>/dev/null; then
        echo ""
        hermes skills list 2>/dev/null | head -30 || say_warn "Could not list skills"
    fi
}

# ── Run Checks ────────────────────────────────────────────────────────

echo ""
echo "🔍  Hermes Blueprint — Troubleshooter"
echo "═══════════════════════════════════════"
echo "   Hermes home: $HERMES_HOME"
echo "   Mode:        $(if $QUICK; then echo "Quick"; else echo "Full"; fi)"
echo "   Issue:       $ISSUE"

if $QUICK; then
    # Fast path — core health only
    check_hermes_installed
    check_config
    check_profiles
    check_backup
    check_disk
else
    case "$ISSUE" in
        all)
            check_hermes_installed
            check_python
            check_config
            check_profiles
            check_backup
            check_cron
            check_memory
            check_skills
            check_gateway
            check_disk
            ;;
        install)    deep_install ;;
        profiles)   deep_profiles ;;
        config)     deep_config ;;
        gateway)    deep_gateway ;;
        backup)     deep_backup ;;
        cron)       deep_cron ;;
        skills)     deep_skills ;;
        memory)     section "MEMORY"; check_memory ;;
        *)
            echo "❌ Unknown issue category: $ISSUE"
            echo "   Valid: install, profiles, config, gateway, memory, backup, cron, skills, all"
            exit 1
            ;;
    esac
fi

# ── Summary ───────────────────────────────────────────────────────────
echo ""
echo "═══════════════════════════════════════"
total=$((PASS + WARN + FAIL))
echo "   ✅ Passed:  $PASS/$total"
echo "   ⚠️  Warnings: $WARN"
echo "   ❌ Failed:  $FAIL"

if [ "$FAIL" -gt 0 ]; then
    echo ""
    echo "🔴 CRITICAL ISSUES FOUND:"
    for issue in "${ISSUES_FOUND[@]}"; do
        echo "   $issue"
    done
fi

# Health score (0-100)
if [ "$total" -gt 0 ]; then
    score=$(( (PASS * 100) / total ))
    echo ""
    if [ "$score" -ge 90 ]; then
        echo "   🟢 Overall health: $score/100 — Excellent"
    elif [ "$score" -ge 70 ]; then
        echo "   🟡 Overall health: $score/100 — Good, minor issues"
    elif [ "$score" -ge 50 ]; then
        echo "   🟠 Overall health: $score/100 — Needs attention"
    else
        echo "   🔴 Overall health: $score/100 — Critical"
    fi
fi

echo ""
echo "   For detailed help on any issue, run:"
echo "   ./troubleshoot.sh --issue <category>"
echo "═══════════════════════════════════════"

# ── Generate Markdown Report ──────────────────────────────────────────
if $REPORT; then
    REPORT_FILE="$HERMES_HOME/troubleshoot-report-$(date +%Y%m%d-%H%M%S).md"
    {
        echo "# Hermes Blueprint — Troubleshooting Report"
        echo ""
        echo "**Generated:** $(date)"
        echo "**Hermes Home:** $HERMES_HOME"
        echo "**Health Score:** $score/100"
        echo ""
        echo "## Summary"
        echo ""
        echo "| Status | Count |"
        echo "|--------|-------|"
        echo "| ✅ Passed | $PASS |"
        echo "| ⚠️  Warning | $WARN |"
        echo "| ❌ Failed | $FAIL |"
        echo ""
        
        if [ ${#ISSUES_FOUND[@]} -gt 0 ]; then
            echo "## Issues Found"
            echo ""
            for issue in "${ISSUES_FOUND[@]}"; do
                echo "- $issue"
            done
            echo ""
        fi
        
        echo "## Next Steps"
        echo ""
        echo "1. Fix critical (❌) issues first"
        echo "2. Address warnings (⚠️) based on priority"
        echo "3. Run \`./troubleshoot.sh\` again to verify fixes"
        echo "4. Set up automated health checks with \`./system-health.sh\`"
        echo ""
        echo "---"
        echo "*Generated by Hermes Blueprint Troubleshooter*"
    } > "$REPORT_FILE"
    
    echo ""
    echo "📄 Report saved: $REPORT_FILE"
fi
