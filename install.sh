#!/bin/bash
# Hermes Blueprint — One-Command Installer
# Usage:
#   curl -sSL https://get.hermesblueprint.com | bash
#   ./install.sh
#   ./install.sh --dry-run --all
#
# Chains: scaffold → config-apply → memory-policy → health-check

set -euo pipefail

# ── Config ──────────────────────────────────────────────────────────

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
HERMES_HOME="${HERMES_HOME:-$HOME/.hermes}"

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
BOLD='\033[1m'
NC='\033[0m'

DRY_RUN=false
ALL=false
QUIET=false
SKIP_MEMORY=false
PROFILE_SELECTION=""

# ── CLI ─────────────────────────────────────────────────────────────

usage() {
    cat <<EOF
${BOLD}Hermes Blueprint Installer${NC}

Usage: $0 [OPTIONS]

Options:
  --dry-run         Show what would happen without making changes
  --all             Install all 13 profiles (skip interactive picker)
  --profiles LIST   Comma-separated profile names to install
  --skip-memory     Skip memory policy configuration
  --quiet           Minimal output
  -h, --help        Show this help

EOF
    exit 0
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --dry-run)     DRY_RUN=true; shift ;;
        --all)         ALL=true; shift ;;
        --profiles)    PROFILE_SELECTION="$2"; shift 2 ;;
        --skip-memory) SKIP_MEMORY=true; shift ;;
        --quiet)       QUIET=true; shift ;;
        -h|--help)     usage ;;
        *) echo "Unknown: $1"; usage ;;
    esac
done

# ── Helpers ─────────────────────────────────────────────────────────

say() {
    if ! $QUIET; then echo -e "$1"; fi
}

success() { say "${GREEN}✅${NC} $1"; }
warn()    { say "${YELLOW}⚠️${NC} $1"; }
error()   { say "${RED}❌${NC} $1"; }
info()    { say "${BLUE}ℹ️${NC} $1"; }
header()  { say "\n${BOLD}$1${NC}"; }
confirm() {
    local prompt="$1"
    local response
    read -rp "$(echo -e "${BLUE}→${NC} $prompt [y/N]: ")" response
    [[ "$response" =~ ^[Yy] ]]
}

# ── Prerequisites ───────────────────────────────────────────────────

check_prereqs() {
    header "📋 Checking Prerequisites"
    
    local ok=true
    
    # Hermes installed
    if command -v hermes &>/dev/null; then
        local version=$(hermes --version 2>/dev/null | head -1 || echo "unknown")
        success "Hermes Agent: $version"
    else
        error "Hermes Agent not installed"
        say "   → Install: curl -sSL https://get.hermesagent.com | bash"
        ok=false
    fi
    
    # Python 3
    if command -v python3 &>/dev/null; then
        success "Python 3: $(python3 --version 2>&1)"
    else
        error "Python 3 not found"
        ok=false
    fi
    
    # YAML support
    if python3 -c "import yaml" 2>/dev/null; then
        success "PyYAML: available"
    else
        warn "PyYAML not installed — some validation disabled"
    fi
    
    # Config directory
    if [ -d "$HERMES_HOME" ]; then
        success "Hermes home: $HERMES_HOME"
    else
        warn "Hermes home not found: $HERMES_HOME (will be created)"
    fi
    
    if ! $ok; then
        error "Prerequisites not met. Fix above and re-run."
        exit 1
    fi
    
    say ""
}

# ── Scaffold Profiles ───────────────────────────────────────────────

scaffold_profiles() {
    header "🏗️  Scaffolding Profiles"
    
    local scaffold_script="$SCRIPT_DIR/scripts/profile-scaffold.sh"
    local templates="$SCRIPT_DIR/templates/profiles"
    
    if [ ! -f "$scaffold_script" ]; then
        error "Scaffold script not found: $scaffold_script"
        exit 1
    fi
    
    local args=(
        --templates "$templates"
        --target "$HERMES_HOME/profiles"
    )
    
    if $DRY_RUN; then
        args+=(--dry-run)
    fi
    
    if $ALL; then
        args+=(--all)
    elif [ -n "$PROFILE_SELECTION" ]; then
        args+=(--profiles "$PROFILE_SELECTION")
    else
        args+=(--pick)
    fi
    
    bash "$scaffold_script" "${args[@]}"
    
    if [ $? -ne 0 ] && ! $DRY_RUN; then
        warn "Some profiles may not have been created. Check output above."
    fi
}

# ── Apply Domain Config ─────────────────────────────────────────────

apply_domain_configs() {
    header "🎯 Applying Domain Configurations"
    
    local config_script="$SCRIPT_DIR/scripts/config-apply-template.sh"
    
    if [ ! -f "$config_script" ]; then
        warn "Config-apply script not found — skipping domain config"
        return
    fi
    
    local adaptable_profiles=(
        "$HERMES_HOME/profiles/zeus-project-manager"
        "$HERMES_HOME/profiles/hera-business-ops"
    )
    
    local applied=0
    for profile_dir in "${adaptable_profiles[@]}"; do
        if [ ! -d "$profile_dir" ]; then
            continue
        fi
        
        local domain_file="$profile_dir/CUSTOMER_DOMAIN.md"
        if [ ! -f "$domain_file" ]; then
            info "No CUSTOMER_DOMAIN.md for $(basename "$profile_dir") — skipping"
            continue
        fi
        
        # Check if customer has customized it
        if grep -q 'YOUR_NAME' "$domain_file" 2>/dev/null; then
            info "$(basename "$profile_dir"): CUSTOMER_DOMAIN.md not yet customized — skipping"
            say "   → Edit $domain_file and re-run: $config_script --profile-dir $profile_dir"
            continue
        fi
        
        if $DRY_RUN; then
            say "  🔍 Would apply config to: $(basename "$profile_dir")"
        else
            bash "$config_script" --profile-dir "$profile_dir"
            applied=$((applied + 1))
        fi
    done
    
    if [ "$applied" -gt 0 ]; then
        success "$applied adaptable profile(s) configured"
    fi
}

# ── Memory Policy ────────────────────────────────────────────────────

apply_memory_policy() {
    if $SKIP_MEMORY; then
        info "Memory policy skipped (--skip-memory)"
        return
    fi
    
    header "🧠 Applying Memory Policy"
    
    local memory_script="$SCRIPT_DIR/scripts/memory-policy-apply.sh"
    
    if [ ! -f "$memory_script" ]; then
        warn "Memory policy script not found — skipping"
        return
    fi
    
    local args=()
    if $DRY_RUN; then
        args+=(--dry-run)
    fi
    args+=(--config "$HERMES_HOME/config.yaml")
    
    bash "$memory_script" "${args[@]}"
}

# ── Health Check ─────────────────────────────────────────────────────

run_health_check() {
    header "🏥 System Health Check"
    
    local health_script="$SCRIPT_DIR/health/system-health.sh"
    
    if [ ! -f "$health_script" ]; then
        warn "Health script not found — skipping"
        return
    fi
    
    bash "$health_script"
}

# ── Summary ──────────────────────────────────────────────────────────

print_summary() {
    header "🎉 Installation Complete!"
    
    say ""
    say "${BOLD}What's installed:${NC}"
    say ""
    
    local profile_count=0
    if [ -d "$HERMES_HOME/profiles" ]; then
        profile_count=$(find "$HERMES_HOME/profiles" -maxdepth 2 -name "SOUL.md" | wc -l)
    fi
    say "   Profiles: $profile_count"
    
    if [ -f "$HERMES_HOME/config.yaml" ]; then
        say "   Config:   $HERMES_HOME/config.yaml"
    fi
    
    say ""
    say "${BOLD}Next steps:${NC}"
    say ""
    say "   1. Configure your API keys:"
    say "      hermes config set model.provider <your-provider>"
    say "      hermes config set model.api_key <your-key>"
    say ""
    say "   2. Customize adaptable profiles:"
    say "      Edit CUSTOMER_DOMAIN.md in ~/.hermes/profiles/zeus-project-manager/"
    say "      Then run: ./scripts/config-apply-template.sh --profile-dir <dir>"
    say ""
    say "   3. Verify everything works:"
    say "      hermes profile list"
    say "      ./health/system-health.sh"
    say ""
    say "   4. Complete personalization so Hermes knows your business:"
    say "      ./scripts/personalization-interview.sh"
    say "      Then open: ~/.hermes/blueprint/SUCCESS_PATH.md"
    say ""
    say "   5. Start using your AI business partner:"
    say "      hermes profile switch zeus-project-manager"
    say ""
    if $DRY_RUN; then
        say "${YELLOW}⚠️  This was a dry run. Run without --dry-run to install.${NC}"
    fi
}

# ── Main ─────────────────────────────────────────────────────────────

main() {
    say ""
    say "${BOLD}╔══════════════════════════════════════╗${NC}"
    say "${BOLD}║     🔧 Hermes Blueprint Installer     ║${NC}"
    say "${BOLD}╚══════════════════════════════════════╝${NC}"
    
    if $DRY_RUN; then
        warn "DRY RUN — no changes will be made"
    fi
    
    # Phase 1: Prerequisites
    check_prereqs
    
    # Phase 2: Scaffold profiles
    scaffold_profiles
    
    # Phase 3: Apply domain configs (for adaptable profiles)
    apply_domain_configs
    
    # Phase 4: Memory policy
    apply_memory_policy
    
    # Phase 5: Health check
    if ! $DRY_RUN; then
        run_health_check
    fi
    
    # Phase 6: Proactive personalization path
    if ! $DRY_RUN; then
        local personalization_script="$SCRIPT_DIR/scripts/personalization-interview.sh"
        if [ -f "$personalization_script" ]; then
            header "🧭 Personalization Success Path"
            say "Installation is the engine. Personalization is what makes it worth paying for."
            say ""
            if confirm "Run the 10-minute personalization interview now?"; then
                bash "$personalization_script"
            else
                warn "Skipped for now. Run later: ./scripts/personalization-interview.sh"
            fi
        fi
    fi
    
    # Phase 7: Summary
    print_summary
}

main "$@"
