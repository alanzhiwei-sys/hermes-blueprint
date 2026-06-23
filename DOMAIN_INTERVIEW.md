# Domain Interview — Setup Wizard Questions

These questions are asked during `setup-wizard.sh` after profile installation. They populate `CUSTOMER_DOMAIN.md` for the Execution Engine and Growth Engine profiles, and set the tone for all adaptable profiles.

---

## Question Set (6 Core + 2 Optional)

### 1. "What industry are you in?"

**Why:** Determines which profiles get loaded by default and what terminology the AI uses.

**Options (select one):**
- Renovation / Construction
- Food & Beverage
- Retail / E-commerce
- Professional Services (accounting, legal, consulting)
- Logistics / Distribution
- Technology / SaaS
- Healthcare / Wellness
- Education / Training
- Other (type your own)

**What it sets:**
- `INDUSTRY` variable in CUSTOMER_DOMAIN.md
- Recommended profile subset
- Industry-specific fallback terminology

---

### 2. "What's your company name?"

**Why:** The AI uses your company name in client-facing communications, quotes, and branding. Without it, the AI sounds generic.

**Input:** Free text. Example: "Hoong Fatt Heng" or "Smith & Co Consulting"

**What it sets:**
- `COMPANY_NAME` in CUSTOMER_DOMAIN.md
- Appears in all client-facing templates

---

### 3. "What's your role?"

**Why:** Affects tone, authority level, and what kinds of decisions the AI helps with. A CEO needs different support than a project manager.

**Options (select one):**
- Owner / Founder (I make all decisions)
- Manager (I manage a team)
- Solo operator (I do everything myself)
- Team lead (I manage projects but not people)
- Other (type your own)

**What it sets:**
- `ROLE` in CUSTOMER_DOMAIN.md
- Adjusts Apollo's content tone (founder voice vs professional voice)

---

### 4. "What tools do you use daily?"

**Why:** The AI needs to know your stack to give actionable advice. If you use Xero, it'll reference Xero. If you use WhatsApp, it'll draft WhatsApp messages.

**Checkboxes (select all that apply):**
- WhatsApp (client communication)
- Gmail / Google Workspace
- Microsoft 365 / Outlook
- Xero (accounting)
- QuickBooks
- ClickUp (project management)
- Notion
- Trello / Asana
- Slack
- Telegram
- Excel / Google Sheets
- Other (type)

**What it sets:**
- `TOOLS` array in CUSTOMER_DOMAIN.md
- Enables tool-specific advice (e.g., "Export this quote as a ClickUp task")

---

### 5. "What's your biggest time-waster right now?"

**Why:** The AI profiles you — Apollo writes content, Athena researches, Zeus manages projects. Knowing your pain point tells the AI which profile to prioritize and what to proactively help with.

**Options (select up to 2):**
- Writing emails / client messages (→ Apollo, Zeus)
- Research / finding information (→ Athena)
- Scheduling / calendar management (→ Poseidon, Hermes)
- Quotes / pricing / proposals (→ Zeus, Hestia)
- Invoicing / follow-ups (→ Hestia)
- Social media / marketing (→ Apollo)
- Contract review / legal (→ Themis)
- Decision-making / "should I" questions (→ Hephaestus)
- Managing subcontractors / vendors (→ Zeus, Hera)
- Other (type)

**What it sets:**
- `PAIN_POINTS` in CUSTOMER_DOMAIN.md
- Primes the AI to proactively offer help in this area

---

### 6. "How do you want the AI to communicate with you?"

**Why:** Sets the default tone for all profiles. A renovation contractor and a lawyer need different communication styles.

**Options (select one):**
- Direct & practical (bullet points, clear actions)
- Professional & detailed (full context, thorough)
- Casual & friendly (like a colleague)
- Formal & precise (for legal/finance professionals)

**What it sets:**
- `COMMUNICATION_STYLE` in CUSTOMER_DOMAIN.md
- Applied across all profile AGENTS.md tone sections

---

### Optional 7: "What's your monthly AI budget?"

**Why:** Helps configure model routing. A $25/mo budget means using cheaper models for simple queries. A $100/mo budget means premium models everywhere.

**Options:**
- $10-25/mo (budget-conscious)
- $25-50/mo (standard)
- $50-100/mo (power user)
- $100+/mo (all premium, all the time)

**What it sets:**
- `AI_BUDGET` in CUSTOMER_DOMAIN.md
- Configures model routing in config.yaml

---

### Optional 8: "Who's your main competitor?"

**Why:** Athena and Ares can use this to benchmark, research, and simulate competitive scenarios.

**Input:** Free text. Example: "ABC Renovation" or "Deloitte"

**What it sets:**
- `COMPETITOR` in CUSTOMER_DOMAIN.md
- Primes Athena for competitive research
- Gives Ares a named adversary to simulate

---

## Output: CUSTOMER_DOMAIN.md Template

After the interview, the wizard generates:

```markdown
# My Business

- **Industry:** [from Q1]
- **Company:** [from Q2]
- **Role:** [from Q3]
- **Location:** Singapore
- **Tools:** [from Q4]
- **Biggest time-waster:** [from Q5]
- **Communication style:** [from Q6]
- **AI budget:** [from Q7]
- **Main competitor:** [from Q8]

## My Workflow

[Auto-generated from Q4 + Q5]:
"I spend most of my day [from role context]. My main tools are [tools]. 
The thing that wastes the most time is [pain points]."

## What I Need from This AI

[Auto-generated from Q5 + Q6]:
"Help me with [pain points]. Communicate in a [communication style] way. 
My budget for AI is [budget] per month."
```

---

## Profile Recommendations (Auto-Generated from Q1)

Based on industry, the wizard recommends which profiles to load:

| Industry | Core profiles | Optional |
|---|---|---|
| Renovation / Construction | Zeus, Hera, Hephaestus, Ares, Themis | Hestia, Poseidon |
| F&B | Hera, Apollo, Athena, Hestia | Zeus, Poseidon |
| Retail / E-commerce | Apollo, Athena, Hestia, Poseidon | Hera, Ares |
| Professional Services | Zeus, Themis, Hestia, Hephaestus | Athena, Ares |
| Technology / SaaS | Artemis, Athena, Poseidon, Hephaestus | Apollo, Ares |

**All customers always get:** Hermes (hub) + Aphrodite (wellness) — these are universal.
