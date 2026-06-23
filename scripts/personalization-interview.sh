#!/bin/bash
# Hermes Blueprint — Proactive Personalization Interview
# Creates customer context, day-by-day success path, and profile-specific starter prompts.

set -euo pipefail

HERMES_HOME="${HERMES_HOME:-$HOME/.hermes}"
BLUEPRINT_HOME="$HERMES_HOME/blueprint"
PROFILES_DIR="$HERMES_HOME/profiles"
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
      echo "Runs a guided business interview and generates customer context + success path."
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

section() {
  say ""
  say "${BOLD}━━━ $1 ━━━${NC}"
  say ""
}

confirm() {
  local prompt="$1"
  local response
  read -rp "$(echo -e "${BLUE}→${NC} $prompt [y/N]: ")" response
  [[ "$response" =~ ^[Yy] ]]
}

intro() {
  say ""
  say "${BOLD}╔══════════════════════════════════════════════╗${NC}"
  say "${BOLD}║   🧭 Hermes Blueprint Personalization Path   ║${NC}"
  say "${BOLD}╚══════════════════════════════════════════════╝${NC}"
  say ""
  say "Installation gives you the engine. This step teaches it YOUR business."
  say ""
  say "You will receive:"
  say "  ✅ A customer context file your profiles can reference"
  say "  ✅ A Day 0 / Day 1 / Day 7 / Day 14 / Day 30 success path"
  say "  ✅ First prompts for each profile so you never feel 'that's it?'"
  say "  ✅ A question backlog Hermes should proactively ask you over time"
  say ""
}

collect_answers() {
  section "1. Business Identity"
  OWNER_NAME=$(ask "Your name")
  COMPANY_NAME=$(ask "Company / brand name")
  ROLE=$(ask "Your role" "Founder / Owner")
  INDUSTRY=$(ask "Industry" "Service business")
  MARKET=$(ask "Primary market" "Singapore")

  section "2. What You Sell"
  SERVICES=$(ask "Main services / products" "Consulting, implementation, support")
  BEST_CUSTOMERS=$(ask "Best customers / ideal client profile")
  BAD_FIT=$(ask "Bad-fit customers to avoid")
  PRICING_MODEL=$(ask "Pricing model" "Project-based / package-based")

  section "3. How Work Flows"
  LEAD_SOURCE=$(ask "Where leads come from" "Referrals, WhatsApp, website")
  SALES_FLOW=$(ask "Your sales flow from enquiry to close" "Enquiry → call → quote → follow-up → deposit")
  DELIVERY_FLOW=$(ask "Your delivery flow after payment" "Kickoff → execution → updates → handover")
  TOOLS=$(ask "Tools you use daily" "WhatsApp, Gmail, Calendar, Sheets")

  section "4. What Hermes Should Learn First"
  PAIN_POINTS=$(ask "Top 3 things that waste your time")
  RECURRING_DECISIONS=$(ask "Recurring decisions Hermes should help with")
  KNOWLEDGE_SOURCES=$(ask "Where your business knowledge lives" "Google Drive, Notion/Obsidian, Gmail, spreadsheets")
  TONE=$(ask "Preferred communication tone" "Direct, warm, professional")

  section "5. Success Definition"
  FIRST_WIN=$(ask "What would make this feel valuable in the first 48 hours?")
  THIRTY_DAY_OUTCOME=$(ask "What should Hermes help you improve within 30 days?")
  RISK_OR_BOUNDARY=$(ask "What should Hermes avoid doing without approval?" "Sending messages, deleting files, making purchases")
}

write_outputs() {
  local now
  now=$(date '+%Y-%m-%d %H:%M:%S')

  if $DRY_RUN; then
    say "${YELLOW}DRY RUN:${NC} would write files under $BLUEPRINT_HOME"
    return
  fi

  mkdir -p "$BLUEPRINT_HOME"

  cat > "$BLUEPRINT_HOME/CUSTOMER_CONTEXT.md" << EOF
# Customer Context

Generated: $now

## Identity
- Name: $OWNER_NAME
- Company: $COMPANY_NAME
- Role: $ROLE
- Industry: $INDUSTRY
- Market: $MARKET

## Offer
- Services / products: $SERVICES
- Best customers: $BEST_CUSTOMERS
- Bad-fit customers: $BAD_FIT
- Pricing model: $PRICING_MODEL

## Workflow
- Lead sources: $LEAD_SOURCE
- Sales flow: $SALES_FLOW
- Delivery flow: $DELIVERY_FLOW
- Daily tools: $TOOLS

## Personalization Priorities
- Time-wasters: $PAIN_POINTS
- Recurring decisions: $RECURRING_DECISIONS
- Knowledge sources: $KNOWLEDGE_SOURCES
- Preferred tone: $TONE

## Success Criteria
- First 48-hour win: $FIRST_WIN
- 30-day outcome: $THIRTY_DAY_OUTCOME
- Approval boundaries: $RISK_OR_BOUNDARY

## Standing Instruction for Hermes Profiles
When helping this customer, start by checking this context. Ask proactive questions when context is missing. End each response with one practical next step unless the user asks for exploration.
EOF

  cat > "$BLUEPRINT_HOME/SUCCESS_PATH.md" << EOF
# Hermes Blueprint Success Path

This is your planned path after installation. Follow this and your Hermes will get more personalized every week.

## Day 0 — Install + First Context
Goal: prove Hermes works and give it the first business context.

- [ ] Run health check: \`./health/system-health.sh\`
- [ ] Read \`$BLUEPRINT_HOME/CUSTOMER_CONTEXT.md\`
- [ ] Ask Hermes: "Based on my customer context, what are the 5 highest-value things you can help me with this week?"
- [ ] Pick ONE first win: $FIRST_WIN

## Day 1 — Teach Hermes Your Real Workflow
Goal: turn generic profiles into your business assistant.

Ask:
\`hermes chat -q "Interview me about my sales workflow. Ask one question at a time. At the end, create a sales workflow playbook for my business."\`

Then save the answer into your vault/wiki.

## Day 3 — Build Your First Playbook
Goal: create one reusable workflow that saves time.

Recommended playbook from your pain points:
- $PAIN_POINTS

Ask:
\`hermes chat -q "Create a repeatable SOP for this workflow in my business: [paste workflow]. Include checklist, approval points, and mistakes to avoid."\`

## Day 7 — Business Review
Goal: show value within the first week.

Ask:
\`hermes chat -q "Review my first week using Hermes. Ask me what I tried, what failed, and what to improve. Then create my Week 2 action plan."\`

## Day 14 — Automation Audit
Goal: identify safe automations, without rushing into risky ones.

Ask Poseidon:
\`hermes --profile poseidon-operations chat -q "Based on my workflow and approval boundaries, identify 3 safe automations and 3 automations I should avoid for now."\`

Boundary reminder: $RISK_OR_BOUNDARY

## Day 30 — ROI Review
Goal: confirm whether Hermes is paying for itself.

Ask:
\`hermes chat -q "Run a 30-day ROI review. Compare my time saved, decisions improved, workflows created, and gaps remaining. Recommend whether to deepen, simplify, or stop using any profiles."\`

Target outcome: $THIRTY_DAY_OUTCOME
EOF

  cat > "$BLUEPRINT_HOME/PROACTIVE_QUESTIONS.md" << EOF
# Proactive Questions Backlog

Hermes should gradually ask these questions over the first 30 days. Do not ask all at once.

## Business Model
- Which service has the highest margin?
- Which service causes the most support burden?
- What job/customer type should you avoid?
- What does a "good client" look like in your business?

## Sales
- What objections do prospects repeat?
- Which quote sections cause confusion?
- What follow-up message has worked best before?
- What is your ideal sales response time?

## Operations
- Which recurring task happens weekly?
- Which task requires your approval before anyone acts?
- Which files or tools contain your source-of-truth data?
- What should never be automated without approval?

## Communication Style
- Do you prefer direct, warm, premium, technical, or casual language?
- What words or tone should Hermes avoid?
- Should Hermes draft in WhatsApp style, email style, or both?

## 30-Day ROI
- What did Hermes save you from doing manually?
- What did Hermes misunderstand?
- What information did Hermes keep missing?
- Which profile gave the most value?
EOF

  cat > "$BLUEPRINT_HOME/FIRST_PROMPTS.md" << EOF
# First Prompts

Use these after installation so Hermes feels active, guided, and valuable.

## Main Hermes
\`hermes chat -q "Read my customer context at ~/.hermes/blueprint/CUSTOMER_CONTEXT.md. Ask me 5 high-value personalization questions, one at a time."\`

## Strategy
\`hermes --profile hephaestus-assistant chat -q "Based on my customer context, what should I improve first: sales, delivery, pricing, operations, or content? Give me a scorecard and one recommendation."\`

## Operations
\`hermes --profile poseidon-operations chat -q "Create my first 7-day operating rhythm. Include what I should review daily, weekly, and what not to automate yet."\`

## Content
\`hermes --profile apollo-content chat -q "Based on my customer context, create 10 content ideas that attract my ideal customer and filter out bad-fit customers."\`

## Research
\`hermes --profile athena-researcher chat -q "Create a competitor research plan for my industry and market. Ask me for competitor names if needed."\`

## Finance
\`hermes --profile hestia-finance chat -q "Based on my pricing model and services, ask me for missing numbers then create a simple margin review template."\`
EOF

  # Copy customer context into every installed profile's vault/wiki if present.
  if [ -d "$PROFILES_DIR" ]; then
    while IFS= read -r profile; do
      local wiki_dir="$profile/vault/wiki"
      if [ -d "$wiki_dir" ]; then
        cp "$BLUEPRINT_HOME/CUSTOMER_CONTEXT.md" "$wiki_dir/customer-context.md"
      fi
    done < <(find "$PROFILES_DIR" -mindepth 1 -maxdepth 1 -type d)
  fi

  say "${GREEN}✅${NC} Created $BLUEPRINT_HOME/CUSTOMER_CONTEXT.md"
  say "${GREEN}✅${NC} Created $BLUEPRINT_HOME/SUCCESS_PATH.md"
  say "${GREEN}✅${NC} Created $BLUEPRINT_HOME/PROACTIVE_QUESTIONS.md"
  say "${GREEN}✅${NC} Created $BLUEPRINT_HOME/FIRST_PROMPTS.md"
  say "${GREEN}✅${NC} Copied customer context into installed profile vaults where available"
}

finish() {
  section "Your Planned Path"
  say "${BOLD}Do this next:${NC}"
  say ""
  say "1. Open your success path:"
  say "   ${BLUE}$BLUEPRINT_HOME/SUCCESS_PATH.md${NC}"
  say ""
  say "2. Run your first personalization prompt:"
  say "   ${BLUE}hermes chat -q \"Read my customer context at ~/.hermes/blueprint/CUSTOMER_CONTEXT.md. Ask me 5 high-value personalization questions, one at a time.\"${NC}"
  say ""
  say "3. In 7 days, run the Week 1 review from SUCCESS_PATH.md"
  say ""
  say "This is not the end of installation — this is Day 0 of personalization."
}

main() {
  intro
  if ! confirm "Start the personalization interview now?"; then
    say "You can run it later: ./scripts/personalization-interview.sh"
    exit 0
  fi
  collect_answers
  write_outputs
  finish
}

main "$@"
