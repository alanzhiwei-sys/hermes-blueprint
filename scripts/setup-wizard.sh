#!/bin/bash
# Hermes Blueprint — Interactive Setup Wizard
# Walks the customer through configuring their Hermes Blueprint.
# No YAML editing required — everything is conversational.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
HERMES_HOME="${HERMES_HOME:-$HOME/.hermes}"
PROFILES_DIR="$HERMES_HOME/profiles"
CONFIG_FILE="$HERMES_HOME/config.yaml"

BOLD='\033[1m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

DRY_RUN=false

# ── CLI ─────────────────────────────────────────────────────────────

while [[ $# -gt 0 ]]; do
    case "$1" in
        --dry-run) DRY_RUN=true; shift ;;
        -h|--help)
            echo "Usage: $0 [--dry-run]"
            echo "Interactive setup wizard for Hermes Blueprint"
            exit 0
            ;;
        *) shift ;;
    esac
done

# ── Helpers ─────────────────────────────────────────────────────────

say() { echo -e "$1"; }
ask() {
    local prompt="$1"
    local default="${2:-}"
    local response
    
    if [ -n "$default" ]; then
        read -rp "$(echo -e "${BLUE}→${NC} $prompt [$default]: ")" response
        echo "${response:-$default}"
    else
        read -rp "$(echo -e "${BLUE}→${NC} $prompt: ")" response
        echo "$response"
    fi
}

confirm() {
    local prompt="$1"
    local response
    read -rp "$(echo -e "${BLUE}→${NC} $prompt [y/N]: ")" response
    [[ "$response" =~ ^[Yy] ]]
}

section() {
    say ""
    say "${BOLD}━━━ $1 ━━━${NC}"
    say ""
}

# ── Intro ────────────────────────────────────────────────────────────

intro() {
    clear 2>/dev/null || true
    say ""
    say "${BOLD}╔══════════════════════════════════════════╗${NC}"
    say "${BOLD}║     🔧 Hermes Blueprint Setup Wizard      ║${NC}"
    say "${BOLD}╚══════════════════════════════════════════╝${NC}"
    say ""
    say "Welcome! This wizard will configure your AI business partner."
    say "No technical knowledge needed — just answer a few questions."
    say ""
    say "Your Hermes Blueprint includes 13 specialized AI profiles:"
    say ""
    say "  ${BOLD}Execution Profiles${NC}"
    say "    ⭐ Zeus — runs client delivery, quoting, projects"
    say "    ⭐ Hera  — runs strategy, packaging, growth"
    say ""
    say "  ${BOLD}Support Profiles${NC}"
    say "    Hephaestus — strategy & decisions"
    say "    Apollo — content & branding"
    say "    Artemis — coding & technical"
    say "    Athena — research & analysis"
    say "    Poseidon — automation & systems"
    say "    Ares — negotiation prep"
    say "    Themis — legal & compliance"
    say "    Hestia — finance & tax"
    say "    Aphrodite — wellness & balance"
    say ""
    
    if ! confirm "Ready to set up?"; then
        say "Come back anytime. Run: ./setup-wizard.sh"
        exit 0
    fi
}

# ── Provider Setup ───────────────────────────────────────────────────

setup_provider() {
    section "1. AI Provider"
    
    say "Which AI provider will you use?"
    say "  1) OpenRouter (recommended — access to 200+ models)"
    say "  2) Anthropic (Claude directly)"
    say "  3) DeepSeek"
    say "  4) OpenAI"
    say "  5) Other / Custom"
    say ""
    
    local choice=$(ask "Choose provider" "1")
    
    case "$choice" in
        1) PROVIDER="openrouter"; PROVIDER_NAME="OpenRouter" ;;
        2) PROVIDER="anthropic"; PROVIDER_NAME="Anthropic" ;;
        3) PROVIDER="deepseek"; PROVIDER_NAME="DeepSeek" ;;
        4) PROVIDER="openai"; PROVIDER_NAME="OpenAI" ;;
        5|*) 
            PROVIDER=$(ask "Provider name")
            PROVIDER_NAME="$PROVIDER"
            ;;
    esac
    
    say ""
    local api_key=$(ask "Your $PROVIDER_NAME API key")
    
    if [ -n "$api_key" ] && [ "$api_key" != "YOUR_KEY" ]; then
        PROVIDER_KEY="$api_key"
        say "  ${GREEN}✅${NC} API key saved"
    else
        PROVIDER_KEY=""
        say "  ${YELLOW}⚠️${NC} No API key provided — you'll need to add it manually"
    fi
}

# ── Profile Selection ────────────────────────────────────────────────

select_profiles() {
    section "2. Your Business Setup"
    
    say "Which profiles do you need?"
    say ""
    say "  ${BOLD}Execution Engine — Zeus${NC}"
    say "    Runs your client delivery, quoting, scope, and project management"
    say ""
    
    local want_zeus=false
    if confirm "Do you want Zeus (client delivery & quoting)?"; then
        want_zeus=true
    fi
    
    say ""
    say "  ${BOLD}Growth Engine — Hera${NC}"
    say "    Runs your strategy, packaging, competitor analysis, and growth"
    say ""
    
    local want_hera=false
    if confirm "Do you want Hera (strategy & business growth)?"; then
        want_hera=true
    fi
    
    say ""
    say "  ${BOLD}Support Profiles${NC}"
    say ""
    local want_all_support=false
    if confirm "Do you want ALL support profiles (recommended)? Say No to pick individually."; then
        want_all_support=true
    fi
    
    # Build profile selection list
    PROFILES=""
    if $want_zeus; then PROFILES="${PROFILES},zeus-project-manager"; fi
    if $want_hera; then PROFILES="${PROFILES},hera-business-ops"; fi
    if $want_all_support; then
        PROFILES="${PROFILES},hephaestus-assistant,aphrodite-relationship,apollo-content,artemis-coder,athena-researcher,poseidon-operations,ares-adversary,themis-legal,hestia-finance"
    fi
    
    PROFILES="${PROFILES#,}"  # Remove leading comma
    
    if [ -z "$PROFILES" ]; then
        say "  ${YELLOW}⚠️${NC} No profiles selected. At minimum, pick Zeus or Hera."
        select_profiles
        return
    fi
    
    say ""
    say "  Selected: ${GREEN}$PROFILES${NC}"
}

# ── Zeus Domain Config ───────────────────────────────────────────────

configure_zeus() {
    section "3a. Configure Zeus — Your Execution Engine"
    
    say "Zeus handles your client delivery — quoting, scope, project management."
    say "Tell me about your business."
    say ""
    
    ZEUS_NAME=$(ask "Your name")
    ZEUS_ROLE=$(ask "Your role" "Founder")
    ZEUS_COMPANY=$(ask "Company name")
    ZEUS_INDUSTRY=$(ask "Your industry" "Consulting")
    ZEUS_SLUG=$(echo "$ZEUS_INDUSTRY" | tr '[:upper:]' '[:lower:]' | tr ' &' '--' | tr -cd 'a-z0-9-')
    ZEUS_MARKET=$(ask "Your target market" "Singapore — Small & Medium Businesses")
    ZEUS_TOOLS=$(ask "Tools you use" "Email, WhatsApp, Excel")
    
    say ""
    say "  ${BOLD}Summary:${NC}"
    say "  Name:     $ZEUS_NAME"
    say "  Role:     $ZEUS_ROLE"
    say "  Company:  $ZEUS_COMPANY"
    say "  Industry: $ZEUS_INDUSTRY"
    say "  Market:   $ZEUS_MARKET"
    say "  Tools:    $ZEUS_TOOLS"
    say ""
    
    if ! confirm "Does this look correct?"; then
        configure_zeus
        return
    fi
    
    # Write CUSTOMER_DOMAIN.md
    local domain_file="$PROFILES_DIR/zeus-project-manager/CUSTOMER_DOMAIN.md"
    if [ "$DRY_RUN" != true ] && [ -f "$domain_file" ]; then
        cat > "$domain_file" << EOF
CUSTOMER_NAME="$ZEUS_NAME"
CUSTOMER_ROLE="$ZEUS_ROLE"
CUSTOMER_COMPANY="$ZEUS_COMPANY"
CUSTOMER_INDUSTRY="$ZEUS_INDUSTRY"
CUSTOMER_INDUSTRY_SLUG="$ZEUS_SLUG"
CUSTOMER_MARKET="$ZEUS_MARKET"
CUSTOMER_TOOLS="$ZEUS_TOOLS"
EOF
        say "  ${GREEN}✅${NC} Zeus configured"
        
        # Apply config
        bash "$SCRIPT_DIR/scripts/config-apply-template.sh" --profile-dir "$PROFILES_DIR/zeus-project-manager" 2>&1 | grep -v "^$" || true
    fi
}

# ── Hera Domain Config ───────────────────────────────────────────────

configure_hera() {
    section "3b. Configure Hera — Your Growth Engine"
    
    say "Hera handles your business growth — strategy, packaging, competitor analysis."
    say ""
    
    HERA_NAME=$(ask "Your name")
    HERA_COMPANY=$(ask "Company name")
    HERA_INDUSTRY=$(ask "Your industry" "Technology Services")
    HERA_SLUG=$(echo "$HERA_INDUSTRY" | tr '[:upper:]' '[:lower:]' | tr ' &' '--' | tr -cd 'a-z0-9-')
    HERA_MARKET=$(ask "Your target market" "Singapore — Residential & SME")
    HERA_SERVICES=$(ask "Services you offer" "Consulting, Implementation, Support")
    HERA_COMPETITORS=$(ask "Main competitors" "Local providers, DIY solutions")
    HERA_SCOPE=$(ask "How do you scope projects?" "discovery call")
    
    say ""
    say "  ${BOLD}Summary:${NC}"
    say "  Name:        $HERA_NAME"
    say "  Company:     $HERA_COMPANY"
    say "  Industry:    $HERA_INDUSTRY"
    say "  Market:      $HERA_MARKET"
    say "  Services:    $HERA_SERVICES"
    say "  Competitors: $HERA_COMPETITORS"
    say "  Scope step:  $HERA_SCOPE"
    say ""
    
    if ! confirm "Does this look correct?"; then
        configure_hera
        return
    fi
    
    # Write CUSTOMER_DOMAIN.md
    local domain_file="$PROFILES_DIR/hera-business-ops/CUSTOMER_DOMAIN.md"
    if [ "$DRY_RUN" != true ] && [ -f "$domain_file" ]; then
        cat > "$domain_file" << EOF
CUSTOMER_NAME="$HERA_NAME"
CUSTOMER_COMPANY="$HERA_COMPANY"
CUSTOMER_INDUSTRY="$HERA_INDUSTRY"
CUSTOMER_INDUSTRY_SLUG="$HERA_SLUG"
CUSTOMER_MARKET="$HERA_MARKET"
CUSTOMER_SERVICES="$HERA_SERVICES"
CUSTOMER_COMPETITORS="$HERA_COMPETITORS"
CUSTOMER_SCOPE_STEP="$HERA_SCOPE"
EOF
        say "  ${GREEN}✅${NC} Hera configured"
        
        # Apply config
        bash "$SCRIPT_DIR/scripts/config-apply-template.sh" --profile-dir "$PROFILES_DIR/hera-business-ops" 2>&1 | grep -v "^$" || true
    fi
}

# ── Apply Provider Config ────────────────────────────────────────────

apply_provider_config() {
    section "4. Apply Provider Configuration"
    
    if [ -z "${PROVIDER_KEY:-}" ]; then
        say "  ${YELLOW}⚠️${NC} No API key — skipping. Add it manually:"
        say "     hermes config set model.api_key YOUR_KEY"
        return
    fi
    
    if [ "$DRY_RUN" = true ]; then
        say "  🔍 Would set provider: $PROVIDER"
        say "  🔍 Would set API key:  ****${PROVIDER_KEY: -4}"
        return
    fi
    
    hermes config set model.provider "$PROVIDER" 2>/dev/null && \
        say "  ${GREEN}✅${NC} Provider set to $PROVIDER" || \
        say "  ${YELLOW}⚠️${NC} Couldn't set provider — add manually"
    
    # API key — handle safely
    if python3 -c "
import yaml, sys
cfg = yaml.safe_load(open('$CONFIG_FILE'))
if 'model' not in cfg: cfg['model'] = {}
cfg['model']['api_key'] = '$PROVIDER_KEY'
yaml.dump(cfg, open('$CONFIG_FILE', 'w'), default_flow_style=False)
" 2>/dev/null; then
        say "  ${GREEN}✅${NC} API key saved"
    else
        say "  ${YELLOW}⚠️${NC} Couldn't save API key — add manually"
    fi
}

# ── Proactive Personalization ────────────────────────────────────────

run_personalization_path() {
    section "5. Personalization Success Path"

    local personalization_script="$SCRIPT_DIR/personalization-interview.sh"

    say "Installation gives you profiles. Personalization makes them feel like YOUR AI team."
    say "This creates your customer context, 30-day roadmap, and first prompts."
    say ""

    if [ ! -f "$personalization_script" ]; then
        say "  ${YELLOW}⚠️${NC} Personalization script not found — skipping"
        return
    fi

    if confirm "Run the 10-minute personalization interview now?"; then
        if [ "$DRY_RUN" = true ]; then
            bash "$personalization_script" --dry-run
        else
            bash "$personalization_script"
        fi
    else
        say "  ${YELLOW}⚠️${NC} Skipped. Run later: ./scripts/personalization-interview.sh"
    fi
}

# ── Finish ────────────────────────────────────────────────────────────

finish() {
    section "6. All Done!"
    
    say ""
    say "${BOLD}🎉 Your Hermes Blueprint is ready!${NC}"
    say ""
    say "${BOLD}What's next:${NC}"
    say ""
    say "  1. Verify your profiles:"
    say "     ${BLUE}hermes profile list${NC}"
    say ""
    say "  2. Run the health check:"
    say "     ${BLUE}./health/system-health.sh${NC}"
    say ""
    say "  3. Start using Zeus:"
    say "     ${BLUE}hermes profile switch zeus-project-manager${NC}"
    say ""
    say "  4. Complete personalization / review your success path:"
    say "     ${BLUE}./scripts/personalization-interview.sh${NC}"
    say "     ${BLUE}./scripts/first-win-wizard.sh${NC}"
    say "     ${BLUE}~/.hermes/blueprint/SUCCESS_PATH.md${NC}"
    say "     ${BLUE}~/.hermes/blueprint/FIRST_WIN_PLAN.md${NC}"
    say ""
    
    if $DRY_RUN; then
        say "${YELLOW}⚠️  Dry run — nothing was actually changed.${NC}"
    else
        say "${GREEN}✅ Setup complete!${NC}"
    fi
    say ""
}

# ── Main ─────────────────────────────────────────────────────────────

main() {
    intro
    
    if $DRY_RUN; then
        say "${YELLOW}⚠️  DRY RUN MODE — no files will be modified${NC}"
        say ""
    fi
    
    setup_provider
    select_profiles
    
    # Scaffold profiles first
    if [ -n "$PROFILES" ] && [ "$DRY_RUN" != true ]; then
        section "Scaffolding profiles..."
        bash "$SCRIPT_DIR/scripts/profile-scaffold.sh" --profiles "$PROFILES" 2>&1 | tail -5
    elif [ -n "$PROFILES" ]; then
        say "  🔍 Would scaffold: $PROFILES"
    fi
    
    # Configure Zeus if selected
    if [[ "$PROFILES" == *"zeus-project-manager"* ]]; then
        configure_zeus
    fi
    
    # Configure Hera if selected
    if [[ "$PROFILES" == *"hera-business-ops"* ]]; then
        configure_hera
    fi
    
    apply_provider_config
    run_personalization_path
    finish
}

main "$@"
