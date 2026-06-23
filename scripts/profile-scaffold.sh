#!/bin/bash
# Hermes Blueprint — Profile Scaffold Script
# Generates customer Hermes profile structure from sanitized templates.
#
# Usage:
#   ./profile-scaffold.sh --templates ~/.hermes/product/blueprint/templates/profiles \
#                         --target ~/.hermes/profiles \
#                         --profiles zeus,hera,artemis,athena
#
#   ./profile-scaffold.sh --all     # scaffold all 11 profiles
#   ./profile-scaffold.sh --pick    # interactive picker

set -euo pipefail

# ── Config ──────────────────────────────────────────────────────────

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PRODUCT_DIR="$(dirname "$SCRIPT_DIR")"
TEMPLATES_DIR="$PRODUCT_DIR/templates/profiles"
TARGET_DIR=""
PROFILES=""
INTERACTIVE=false
ALL=false
DRY_RUN=false

# Profile metadata for descriptions
declare -A PROFILE_DESC
PROFILE_DESC[zeus-project-manager]="⭐ Execution Engine — client delivery, quoting, scope, project management. Adaptable to any service industry via CUSTOMER_DOMAIN.md"
PROFILE_DESC[hera-business-ops]="⭐ Growth Engine — strategy, packaging, competitor analysis, business expansion. Adaptable to any product/service business via CUSTOMER_DOMAIN.md"
PROFILE_DESC[hephaestus-assistant]="Cross-domain strategy — investments, tool adoption, business decisions, passive income"
PROFILE_DESC[aphrodite-relationship]="Relationship & wellness — marriage, family, personal growth, health advice"
PROFILE_DESC[apollo-content]="Content & branding — social media, writing, design, media production"
PROFILE_DESC[artemis-coder]="Code & architecture — software development, debugging, tool evaluation"
PROFILE_DESC[athena-researcher]="Research & analysis — deep research, competitive intel, market analysis"
PROFILE_DESC[poseidon-operations]="Operations & systems — workflows, automation, cron jobs, system maintenance"
PROFILE_DESC[ares-adversary]="Adversary simulation — negotiation prep, objection handling, stress-testing"
PROFILE_DESC[themis-legal]="Legal & compliance — contract audit, PDPA, SCT prep, variation orders"
PROFILE_DESC[hestia-finance]="Finance & tax — CPF, IRAS, margin analysis, financial health"

ALL_PROFILES=(
    zeus-renovation
    zeus-project-manager
    hera-smarthush
    hera-business-ops
    hephaestus-assistant
    aphrodite-relationship
    apollo-content
    artemis-coder
    athena-researcher
    poseidon-operations
    ares-adversary
    themis-legal
    hestia-finance
)

# ── CLI Parsing ─────────────────────────────────────────────────────

usage() {
    cat <<EOF
Usage: $0 [OPTIONS]

Options:
  --templates DIR     Template profiles directory (default: ../templates/profiles)
  --target DIR        Target Hermes profiles directory (default: ~/.hermes/profiles)
  --profiles LIST     Comma-separated profile names to scaffold
  --all               Scaffold all 11 profiles
  --pick              Interactive profile picker
  --dry-run           Show what would be created without creating anything
  -h, --help          Show this help

Profile names:
  zeus-renovation, hera-smarthush, hephaestus-assistant,
  aphrodite-relationship, apollo-content, artemis-coder,
  athena-researcher, poseidon-operations, ares-adversary,
  themis-legal, hestia-finance

EOF
    exit 0
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --templates) TEMPLATES_DIR="$2"; shift 2 ;;
        --target)    TARGET_DIR="$2"; shift 2 ;;
        --profiles)  PROFILES="$2"; shift 2 ;;
        --all)       ALL=true; shift ;;
        --pick)      INTERACTIVE=true; shift ;;
        --dry-run)   DRY_RUN=true; shift ;;
        -h|--help)   usage ;;
        *) echo "Unknown option: $1"; usage ;;
    esac
done

# ── Resolve defaults ─────────────────────────────────────────────────

if [ -z "$TARGET_DIR" ]; then
    TARGET_DIR="$HOME/.hermes/profiles"
fi

if [ ! -d "$TEMPLATES_DIR" ]; then
    echo "❌ Templates directory not found: $TEMPLATES_DIR"
    echo "   Run sanitize.sh first to generate templates."
    exit 1
fi

# ── Interactive picker ───────────────────────────────────────────────

if $INTERACTIVE; then
    echo "🧭 Hermes Blueprint — Profile Picker"
    echo "====================================="
    echo ""
    echo "Select profiles to scaffold (enter numbers, comma-separated):"
    echo ""
    for i in "${!ALL_PROFILES[@]}"; do
        p="${ALL_PROFILES[$i]}"
        printf "  %2d) %-28s — %s\n" "$((i+1))" "$p" "${PROFILE_DESC[$p]:-}"
    done
    echo ""
    read -rp "Your selection (e.g., 1,4,8,11 or 'all'): " selection
    
    if [ "$selection" = "all" ]; then
        ALL=true
    else
        IFS=',' read -ra nums <<< "$selection"
        chosen=()
        for n in "${nums[@]}"; do
            n=$(echo "$n" | xargs)
            if [[ "$n" =~ ^[0-9]+$ ]] && [ "$n" -ge 1 ] && [ "$n" -le "${#ALL_PROFILES[@]}" ]; then
                chosen+=("${ALL_PROFILES[$((n-1))]}")
            fi
        done
        if [ ${#chosen[@]} -eq 0 ]; then
            echo "❌ No valid profiles selected."
            exit 1
        fi
        PROFILES=$(IFS=,; echo "${chosen[*]}")
    fi
fi

# ── Resolve profile list ─────────────────────────────────────────────

if $ALL; then
    PROFILE_LIST=("${ALL_PROFILES[@]}")
elif [ -n "$PROFILES" ]; then
    IFS=',' read -ra PROFILE_LIST <<< "$PROFILES"
else
    echo "❌ No profiles specified. Use --profiles, --all, or --pick."
    usage
fi

# ── Scaffold ─────────────────────────────────────────────────────────

scaffold_profile() {
    local name="$1"
    local template="$TEMPLATES_DIR/$name"
    local target="$TARGET_DIR/$name"
    
    if [ ! -d "$template" ]; then
        echo "  ⚠️  Template not found: $name — skipping"
        return 1
    fi
    
    if [ -d "$target" ] && [ "$DRY_RUN" != true ]; then
        echo "  ⚠️  Profile already exists: $target — skipping (use --force to overwrite)"
        return 0
    fi
    
    if $DRY_RUN; then
        echo "  🔍 Would create: $target"
        return 0
    fi
    
    mkdir -p "$target"/{memories,vault/wiki,vault/raw,cron/output,home,audio_cache,sandboxes/singularity}
    
    # Copy sanitized files
    for f in SOUL.md AGENTS.md EXAMPLES.md CUSTOMER_DOMAIN.md; do
        if [ -f "$template/$f" ]; then
            cp "$template/$f" "$target/$f"
        fi
    done
    
    # Copy vault structure
    if [ -d "$template/vault" ]; then
        cp -r "$template/vault/"* "$target/vault/" 2>/dev/null || true
    fi
    
    # Create config.yaml from template (if exists) or minimal
    if [ -f "$template/config.yaml" ]; then
        cp "$template/config.yaml" "$target/config.yaml"
    else
        cat > "$target/config.yaml" <<'YAML'
# $NAME_PLACEHOLDER — Hermes Blueprint profile config
# Configure your AI provider below

model:
  provider: openrouter
  model: anthropic/claude-sonnet-4

memory:
  memory_enabled: true
  user_profile_enabled: true
  write_approval: false
  provider: mnemosyne
  mnemosyne:
    profile_isolation: true

delegation:
  max_concurrent_children: 3

context:
  engine: lcm

terminal:
  backend: local
YAML
        # Substitute the profile name
        sed -i "s/\$NAME_PLACEHOLDER/$name/" "$target/config.yaml"
    fi
    
    # Create placeholder memories
    echo "# $name — Agent Memory" > "$target/memories/MEMORY.md"
    echo "# $name — User Profile" > "$target/memories/USER.md"
    
    echo "  ✅ Created: $target"
    return 0
}

# ── Main ─────────────────────────────────────────────────────────────

echo ""
echo "🏗️  Hermes Blueprint — Profile Scaffold"
echo "=========================================="
echo "Templates: $TEMPLATES_DIR"
echo "Target:    $TARGET_DIR"
echo "Profiles:  ${#PROFILE_LIST[@]}"
echo ""
if $DRY_RUN; then
    echo "⚠️  DRY RUN — no files will be created"
    echo ""
fi

created=0
skipped=0
for p in "${PROFILE_LIST[@]}"; do
    p=$(echo "$p" | xargs)
    if scaffold_profile "$p"; then
        created=$((created + 1))
    else
        skipped=$((skipped + 1))
    fi
done

echo ""
echo "=========================================="
echo "✅ $created profiles created"
if [ "$skipped" -gt 0 ]; then
    echo "⚠️  $skipped profiles skipped"
fi
echo ""

if ! $DRY_RUN && [ "$created" -gt 0 ]; then
    echo "📋 Next steps:"
    echo "   1. Configure API keys in each profile's config.yaml"
    echo "   2. Review and customize SOUL.md for each profile"
    echo ""
    echo "   ⭐ For adaptable profiles (zeus-project-manager, hera-business-ops):"
    echo "      → Edit CUSTOMER_DOMAIN.md in the profile directory"
    echo "      → Run: ./config-apply-template.sh --profile-dir <profile-dir>"
    echo ""
    echo "   3. Run: hermes profile list  (to verify profiles are detected)"
    echo "   4. Run: ./system-health.sh  (to check system health)"
    echo ""
fi
