#!/bin/bash
# Hermes Blueprint — Update Mechanism
# Safely updates profiles and scripts from the Blueprint repository.
# NEVER overwrites customer customizations (config.yaml, CUSTOMER_DOMAIN.md, vault/wiki).
#
# Usage:
#   ./update.sh                           # Interactive update
#   ./update.sh --check                   # Dry run — show what would change
#   ./update.sh --profiles-only           # Only update profile templates
#   ./update.sh --scripts-only            # Only update scripts (backup, restore, health)
#   ./update.sh --profile zeus-renovation # Update a single profile
#   ./update.sh --source /path/to/blueprint # Custom Blueprint source
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HERMES_HOME="${HERMES_HOME:-$HOME/.hermes}"

# ── Defaults ──────────────────────────────────────────────────────────
SOURCE_DIR="${BLUEPRINT_SOURCE:-}"
CHECK_ONLY=false
PROFILES_ONLY=false
SCRIPTS_ONLY=false
PROFILE_FILTER=""
FORCE=false
VERBOSE=false

# ── Usage ─────────────────────────────────────────────────────────────
usage() {
    cat <<EOF
🔄  Hermes Blueprint — Update

Usage: ./update.sh [options]

Options:
  --check            Dry run — show what would change without applying
  --profiles-only    Only update profile templates (SOUL, AGENTS, skills)
  --scripts-only     Only update scripts (backup, restore, health, install)
  --profile NAME     Update a single profile only
  --source DIR       Path to Blueprint source (default: auto-detect)
  --force            Skip confirmation prompt
  -v, --verbose      Show detailed diffs
  -h, --help         Show this help

Examples:
  ./update.sh --check                        # See what's outdated
  ./update.sh --profiles-only                # Update all profiles
  ./update.sh --profile zeus-renovation      # Single profile
  ./update.sh --scripts-only --force          # Scripts, no prompt
EOF
    exit 0
}

# ── Parse Args ────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
    case "$1" in
        --check)         CHECK_ONLY=true; shift ;;
        --profiles-only) PROFILES_ONLY=true; shift ;;
        --scripts-only)  SCRIPTS_ONLY=true; shift ;;
        --profile)       PROFILE_FILTER="$2"; shift 2 ;;
        --source)        SOURCE_DIR="$2"; shift 2 ;;
        --force)         FORCE=true; shift ;;
        -v|--verbose)    VERBOSE=true; shift ;;
        -h|--help)       usage ;;
        *) echo "Unknown option: $1"; usage ;;
    esac
done

# ── Auto-detect Blueprint source ──────────────────────────────────────
if [ -z "$SOURCE_DIR" ]; then
    # Check common locations
    for candidate in \
        "$SCRIPT_DIR/.." \
        "$HERMES_HOME/product/blueprint" \
        "$HOME/.hermes/product/blueprint" \
        "/opt/hermes-blueprint"; do
        if [ -f "$candidate/install.sh" ] && [ -d "$candidate/templates/profiles" ]; then
            SOURCE_DIR="$(cd "$candidate" && pwd)"
            break
        fi
    done
fi

if [ -z "$SOURCE_DIR" ] || [ ! -d "$SOURCE_DIR/templates/profiles" ]; then
    echo "❌ Blueprint source not found."
    echo "   Set --source /path/to/blueprint or clone the repo first."
    exit 1
fi

# ── Preflight ─────────────────────────────────────────────────────────
say() { echo "   $*"; }
diff_section() { echo ""; echo "── $1 ────────────────────────────"; }

echo ""
echo "🔄  Hermes Blueprint — Update"
echo "═══════════════════════════════════════"
echo "   Source:  $SOURCE_DIR"
echo "   Target:  $HERMES_HOME"
if $CHECK_ONLY; then echo "   Mode:    CHECK ONLY (dry run)"; fi
echo ""

# ── Track changes ─────────────────────────────────────────────────────
UPDATED=0
SKIPPED=0
CONFLICTS=0

# ── Update Scripts ────────────────────────────────────────────────────
update_scripts() {
    diff_section "SCRIPTS"
    local script_count=0
    
    for script in backup.sh restore.sh install.sh system-health.sh; do
        local src="$SOURCE_DIR/scripts/$script"
        local dst="$HERMES_HOME/product/blueprint/scripts/$script"
        
        if [ ! -f "$src" ]; then
            continue
        fi
        
        if [ ! -f "$dst" ]; then
            if $CHECK_ONLY; then
                say "🆕 Would install: $script (new)"
                UPDATED=$((UPDATED + 1))
            else
                mkdir -p "$(dirname "$dst")"
                cp "$src" "$dst"
                chmod +x "$dst"
                say "✅ Installed: $script (new)"
                UPDATED=$((UPDATED + 1))
            fi
            script_count=$((script_count + 1))
            continue
        fi
        
        # Compare checksums
        if ! cmp -s "$src" "$dst"; then
            if $CHECK_ONLY; then
                say "📝 Would update: $script"
                if $VERBOSE; then
                    diff -u "$dst" "$src" 2>/dev/null | head -30
                fi
                UPDATED=$((UPDATED + 1))
            else
                cp "$src" "$dst"
                chmod +x "$dst"
                say "✅ Updated: $script"
                UPDATED=$((UPDATED + 1))
            fi
        else
            say "   $script — up to date"
        fi
        script_count=$((script_count + 1))
    done
    
    if [ "$script_count" -eq 0 ]; then
        say "   No scripts to update"
    fi
}

# ── Update Profile Templates ──────────────────────────────────────────
update_profile() {
    local profile_name="$1"
    local src="$SOURCE_DIR/templates/profiles/$profile_name"
    local dst="$HERMES_HOME/profiles/$profile_name"
    
    if [ ! -d "$src" ]; then
        say "⚠️  Template not found: $profile_name — skipping"
        SKIPPED=$((SKIPPED + 1))
        return
    fi
    
    if [ ! -d "$dst" ]; then
        if $CHECK_ONLY; then
            say "🆕 Would create: $profile_name (new profile)"
        else
            # Use the scaffold script
            bash "$SOURCE_DIR/scripts/profile-scaffold.sh" \
                --profiles "$profile_name" \
                --templates "$SOURCE_DIR/templates/profiles" \
                --target "$HERMES_HOME/profiles" 2>&1 | grep "✅" || true
        fi
        UPDATED=$((UPDATED + 1))
        return
    fi
    
    local profile_updated=0
    
    # Files we update (safe to overwrite — not customer-editable)
    for file in SOUL.md AGENTS.md; do
        if [ -f "$src/$file" ] && [ -f "$dst/$file" ]; then
            if ! cmp -s "$src/$file" "$dst/$file"; then
                if $CHECK_ONLY; then
                    say "📝 $profile_name/$file — would update"
                    if $VERBOSE; then
                        diff -u "$dst/$file" "$src/$file" 2>/dev/null | head -20
                    fi
                else
                    cp "$src/$file" "$dst/$file"
                    say "✅ $profile_name/$file — updated"
                fi
                profile_updated=1
            fi
        elif [ -f "$src/$file" ] && [ ! -f "$dst/$file" ]; then
            if $CHECK_ONLY; then
                say "🆕 $profile_name/$file — would create"
            else
                cp "$src/$file" "$dst/$file"
                say "✅ $profile_name/$file — created"
            fi
            profile_updated=1
        fi
    done
    
    # Files we NEVER overwrite (customer-customized)
    for protected in CUSTOMER_DOMAIN.md config.yaml; do
        if [ -f "$src/$protected" ] && [ ! -f "$dst/$protected" ]; then
            if $CHECK_ONLY; then
                say "🆕 $profile_name/$protected — would create (new install)"
            else
                cp "$src/$protected" "$dst/$protected"
                say "✅ $profile_name/$protected — created"
            fi
            profile_updated=1
        elif [ -f "$src/$protected" ] && [ -f "$dst/$protected" ]; then
            if ! cmp -s "$src/$protected" "$dst/$protected"; then
                say "🔒 $profile_name/$protected — SKIPPED (customer-customized)"
                CONFLICTS=$((CONFLICTS + 1))
                if $VERBOSE; then
                    echo "      Template has updates. Review manually:"
                    echo "      diff $dst/$protected $src/$protected"
                fi
            fi
        fi
    done
    
    # Vault wiki files — update if they exist in template but not locally
    if [ -d "$src/vault/wiki" ] && [ -d "$dst/vault/wiki" ]; then
        for vault_file in "$src/vault/wiki"/*.md; do
            [ ! -f "$vault_file" ] && continue
            local vf_name=$(basename "$vault_file")
            local vf_dst="$dst/vault/wiki/$vf_name"
            
            if [ ! -f "$vf_dst" ]; then
                if $CHECK_ONLY; then
                    say "🆕 $profile_name/vault/wiki/$vf_name — would create"
                else
                    cp "$vault_file" "$vf_dst"
                    say "✅ $profile_name/vault/wiki/$vf_name — created"
                fi
                profile_updated=1
            elif ! cmp -s "$vault_file" "$vf_dst"; then
                # Also protected — wiki files may be customer-edited
                say "🔒 $profile_name/vault/wiki/$vf_name — SKIPPED (may be customized)"
                CONFLICTS=$((CONFLICTS + 1))
            fi
        done
    fi
    
    if [ "$profile_updated" -eq 1 ]; then
        UPDATED=$((UPDATED + 1))
    fi
}

# ── Main ──────────────────────────────────────────────────────────────

# Update scripts
if ! $PROFILES_ONLY; then
    update_scripts
fi

# Update profiles
if ! $SCRIPTS_ONLY; then
    diff_section "PROFILES"
    
    if [ -n "$PROFILE_FILTER" ]; then
        # Single profile
        update_profile "$PROFILE_FILTER"
    else
        # All profiles
        for profile_dir in "$SOURCE_DIR/templates/profiles"/*/; do
            profile_name=$(basename "$profile_dir")
            [ "$profile_name" = "MANIFEST.md" ] && continue
            update_profile "$profile_name"
        done
    fi
fi

# ── Summary ───────────────────────────────────────────────────────────
echo ""
echo "═══════════════════════════════════════"
if $CHECK_ONLY; then
    echo "🏁 CHECK COMPLETE (dry run)"
else
    echo "✅ UPDATE COMPLETE"
fi
echo ""
echo "   📝 Would update/create: $UPDATED items"
echo "   🔒 Protected (skipped): $CONFLICTS items"
echo ""

if [ "$CONFLICTS" -gt 0 ]; then
    echo "   ⚠️  Some protected files have upstream updates."
    echo "      Review manually: diff <installed> <template>"
    echo ""
fi

if $CHECK_ONLY; then
    echo "   Run without --check to apply changes."
else
    echo "   Run: ./system-health.sh  (to verify)"
fi
echo "═══════════════════════════════════════"
