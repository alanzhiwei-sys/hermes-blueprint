#!/bin/bash
# Hermes Blueprint — First Business Win Wizard
# Converts post-install energy into one concrete business artifact plan.

set -euo pipefail

HERMES_HOME="${HERMES_HOME:-$HOME/.hermes}"
BLUEPRINT_HOME="$HERMES_HOME/blueprint"
OUTPUT="$BLUEPRINT_HOME/FIRST_WIN_PLAN.md"
DRY_RUN=false

BOLD='\033[1m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run) DRY_RUN=true; shift ;;
    -h|--help)
      echo "Usage: $0 [--dry-run]"
      echo "Creates a first-business-win plan so setup ends with a concrete outcome."
      exit 0 ;;
    *) shift ;;
  esac
done

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

intro() {
  say ""
  say "${BOLD}╔══════════════════════════════════════════════╗${NC}"
  say "${BOLD}║      🎯 Hermes First Business Win Wizard     ║${NC}"
  say "${BOLD}╚══════════════════════════════════════════════╝${NC}"
  say ""
  say "Do not end setup with 'what now?'"
  say "Pick ONE useful business artifact Hermes should help you create first."
  say ""
}

choose_win() {
  say "Choose your first business win:"
  say ""
  say "  1) Sales follow-up system"
  say "  2) Customer FAQ / response library"
  say "  3) Weekly owner command briefing"
  say "  4) SOP / checklist builder"
  say "  5) Competitor / pricing research desk"
  say "  6) Proposal / quote assistant"
  say "  7) Custom"
  say ""
  WIN_CHOICE=$(ask "Enter choice number" "1")

  case "$WIN_CHOICE" in
    1) WIN_NAME="Sales follow-up system"; PROFILE_HINT="hephaestus-assistant or hermes central"; ARTIFACT="A 7-day lead follow-up sequence with WhatsApp/email drafts, timing, and qualification notes" ;;
    2) WIN_NAME="Customer FAQ / response library"; PROFILE_HINT="apollo-content or hermes central"; ARTIFACT="A reusable answer bank for common customer questions, objections, and next-step replies" ;;
    3) WIN_NAME="Weekly owner command briefing"; PROFILE_HINT="poseidon-operations or hermes central"; ARTIFACT="A weekly review template covering tasks, risks, money, follow-ups, and decisions" ;;
    4) WIN_NAME="SOP / checklist builder"; PROFILE_HINT="poseidon-operations"; ARTIFACT="A step-by-step SOP with checklist, owner, approval points, and mistakes to avoid" ;;
    5) WIN_NAME="Competitor / pricing research desk"; PROFILE_HINT="athena-researcher"; ARTIFACT="A competitor/pricing research brief with source links, gaps, and recommended next actions" ;;
    6) WIN_NAME="Proposal / quote assistant"; PROFILE_HINT="zeus-renovation or zeus-project-manager"; ARTIFACT="A proposal/quote improvement checklist plus client-facing explanation drafts" ;;
    7) WIN_NAME=$(ask "Name your custom first win"); PROFILE_HINT="hermes central"; ARTIFACT=$(ask "What artifact should be produced?") ;;
    *) WIN_NAME="Sales follow-up system"; PROFILE_HINT="hephaestus-assistant or hermes central"; ARTIFACT="A 7-day lead follow-up sequence with WhatsApp/email drafts, timing, and qualification notes" ;;
  esac

  BUSINESS_CONTEXT=$(ask "What specific business/workflow should this apply to?" "my current business")
  SOURCE_MATERIAL=$(ask "What source material should Hermes use?" "customer context, recent examples, notes, spreadsheet, or pasted text")
  SUCCESS_MEASURE=$(ask "How will you know this first win is useful?" "I can use the artifact within 48 hours")
  APPROVAL_BOUNDARY=$(ask "What must Hermes NOT do without approval?" "send messages, delete files, spend money, publish content")
}

write_plan() {
  local now
  now=$(date '+%Y-%m-%d %H:%M:%S')

  if $DRY_RUN; then
    say "${YELLOW}DRY RUN:${NC} would write $OUTPUT"
    return
  fi

  mkdir -p "$BLUEPRINT_HOME"
  cat > "$OUTPUT" << EOF
# First Business Win Plan

Generated: $now

## Chosen Win

**$WIN_NAME**

## Target Workflow / Business Context

$BUSINESS_CONTEXT

## Artifact Hermes Should Produce

$ARTIFACT

## Source Material

$SOURCE_MATERIAL

## Success Measure

$SUCCESS_MEASURE

## Approval Boundary

Hermes must not do this without explicit approval:

$APPROVAL_BOUNDARY

## Recommended Profile

Use: **$PROFILE_HINT**

## Copy-Paste Prompt

\`\`\`text
Read my customer context at ~/.hermes/blueprint/CUSTOMER_CONTEXT.md and my first-win plan at ~/.hermes/blueprint/FIRST_WIN_PLAN.md.

Help me create this first business win: $WIN_NAME.

Context: $BUSINESS_CONTEXT
Artifact needed: $ARTIFACT
Source material: $SOURCE_MATERIAL
Success measure: $SUCCESS_MEASURE
Approval boundary: $APPROVAL_BOUNDARY

Ask me only the missing questions needed to produce a usable first draft. Then create the artifact in a practical, copy-paste-ready format.
\`\`\`

## 48-Hour Checklist

- [ ] Run the copy-paste prompt above
- [ ] Answer Hermes' missing-context questions
- [ ] Generate first draft
- [ ] Edit and approve manually
- [ ] Save final artifact into your vault/wiki
- [ ] Record whether it saved time or improved quality

## Beta Validation Question

Did this first win make Hermes feel immediately useful after installation?

- [ ] Yes
- [ ] No
- [ ] Partly — explain what was missing
EOF

  say "${GREEN}✅ Created $OUTPUT${NC}"
}

main() {
  intro
  choose_win
  write_plan
  say ""
  say "Next: open $OUTPUT and run the copy-paste prompt."
}

main "$@"
