# Hermes Blueprint — User Guide

**Welcome.** You just installed an AI operating system for your business. Here's what you have, how to use it, and what to do in your first 15 minutes.

---

## What You Just Installed

You now have **13 AI profiles** — each is a specialist agent with its own personality, knowledge base, and set of skills. Think of them as employees who never sleep, never forget, and work at the speed of thought.

| Profile | Role | Who needs this |
|---|---|---|
| **Zeus** | Project Manager | Anyone managing projects, clients, quotes, subcontractors |
| **Hera** | Business Operations | Anyone running a service business with packages, pricing, installers |
| **Hephaestus** | Strategic Advisor | Everyone — helps with "should I" decisions, investments, tool choices |
| **Aphrodite** | Relationship Coach | Anyone who wants better communication, work-life balance, wellness |
| **Apollo** | Content & Branding | Anyone creating social media, marketing copy, branding |
| **Artemis** | Coder & Architect | Anyone writing code, debugging, or evaluating tech tools |
| **Athena** | Researcher | Anyone doing market research, competitor analysis, deep dives |
| **Poseidon** | Operations | Anyone automating workflows, backups, system maintenance |
| **Hestia** | Finance | Anyone managing money, taxes (Singapore), CPF, cash flow |
| **Themis** | Legal | Anyone reviewing contracts, checking compliance, handling disputes |
| **Ares** | Adversary Sim | Anyone preparing for negotiations, difficult conversations, pitch reviews |
| **Hermes** | Central Hub | Everyone — routes your questions to the right specialist |

Plus two adaptable profiles:
| **Execution Engine** | Generic PM | Can be customized for any industry project management |
| **Growth Engine** | Generic Business Ops | Can be customized for any service business |

---

## Your First 15 Minutes

### 1. Set Up Your API Key (3 min)

Your profiles need an AI provider. The easiest is OpenRouter — one key, many models.

```bash
# Set your OpenRouter API key
hermes config set model.api_key "sk-or-v1-your-key-here"

# Or use Anthropic directly
hermes config set model.provider anthropic
hermes config set model.api_key "sk-ant-your-key-here"
```

**Don't have a key?** 
- OpenRouter: https://openrouter.ai/keys (free signup, pay-per-use)
- Anthropic: https://console.anthropic.com/ (requires account)

### 2. Run Your First Command (1 min)

Open a terminal and ask something simple:

```bash
hermes chat -q "What's the weather in Singapore today?"
```

If you get an answer, your API key works. ✅

### 3. Meet Your Team (5 min)

Try each core profile once:

```bash
# Ask Zeus a PM question
hermes --profile zeus-renovation chat -q "What are the top 3 things to check on a site visit?"

# Ask Hephaestus a strategy question
hermes --profile hephaestus-assistant chat -q "Should I invest in better tools or hire help first?"

# Ask Apollo to write something
hermes --profile apollo-content chat -q "Write a LinkedIn post about using AI in small business"

# Ask Athena to research
hermes --profile athena-researcher chat -q "What are the top 3 trends in Singapore SME digitalization in 2026?"
```

### 4. Customize Your Domain (3 min)

The Execution Engine and Growth Engine have a `CUSTOMER_DOMAIN.md` file. This is where you tell the AI about YOUR business.

```bash
# Edit the domain file
nano ~/.hermes/profiles/zeus-project-manager/CUSTOMER_DOMAIN.md
```

Replace the placeholders with your actual business details:

```markdown
# My Business
- **Industry:** [YOUR_INDUSTRY]
- **Company:** [YOUR_COMPANY_NAME]
- **Role:** [YOUR_ROLE]
- **Location:** [YOUR_CITY], Singapore
- **Tools I use:** [YOUR_TOOLS — e.g., Xero, Slack, WhatsApp]
- **My workflow:** [BRIEF_DESCRIPTION]
```

### 5. Set Up Backups (3 min)

Test that backup works, then schedule it:

```bash
# Run a manual backup
~/.hermes/product/blueprint/scripts/backup.sh

# Schedule automatic backups (daily at 2am)
hermes cron create \
  --name "Daily Backup" \
  --schedule "0 2 * * *" \
  --script "~/.hermes/product/blueprint/scripts/backup.sh"
```

---

## How to Use Each Profile

### Zeus — Your Project Manager

**Best for:** Quotes, pricing, site visits, subcontractor management, project timelines, client communication

**Example prompts:**
```
"Review this quote and flag anything missing or underpriced"
"What should I check before a final handover for a condo renovation?"
"Draft a WhatsApp message to a client about a 2-week delay — keep it reassuring"
"Compare these 3 supplier quotes for kitchen carpentry"
```

### Hera — Your Business Operations

**Best for:** Service packages, pricing strategy, smart home installs, subcontractor network, ecosystem compatibility

**Example prompts:**
"Design a 3-tier service package for my business"
"Compare Zigbee vs Z-Wave for a new smart home installation"
"What should I include in an electrician briefing document?"

### Hephaestus — Your Strategic Advisor

**Best for:** Investment decisions, tool adoption, business strategy, passive income ideas, "should I" questions

**Example prompts:**
"Should I invest $5K in marketing or new equipment?"
"Is it worth paying for [software] at $50/month?"
"Evaluate this passive income opportunity"
"Help me decide between hiring a VA or automating with AI"

### Aphrodite — Your Relationship Coach

**Best for:** Work-life balance, marriage communication, stress management, wellness habits

**Example prompts:**
"How do I set boundaries with clients who message at 10pm?"
"I'm feeling burned out — help me create a recovery plan"
"Draft a difficult but kind message to a family member"

### Apollo — Your Content & Branding

**Best for:** Social media posts, brand voice, marketing copy, content calendars, design direction

**Example prompts:**
"Write 3 LinkedIn posts about running a small business in Singapore"
"Create a 30-day content calendar for my business Instagram"
"Rewrite this marketing copy in a more professional tone"
"Suggest a brand color palette for a renovation company"

### Artemis — Your Coder & Architect

**Best for:** Code review, debugging, API integration, tool evaluation, system architecture

**Example prompts:**
"Review this Python script for errors"
"How do I connect my website to a payment API?"
"Compare these 3 tools for task automation"

### Athena — Your Researcher

**Best for:** Market research, competitor analysis, trend reports, source evaluation

**Example prompts:**
"Research the top 5 competitors in [industry] in Singapore"
"What are the latest HDB renovation regulations?"
"Compare 3 accounting software options for a small Singapore business"

### Poseidon — Your Operations Engine

**Best for:** Workflow automation, cron jobs, system health, backup verification, alerting

**Example prompts:**
"Set up a daily health check for my system"
"Automate my invoice generation workflow"
"Audit all my scheduled tasks and flag anything broken"

### Hestia — Your Finance Advisor

**Best for:** Tax planning (Singapore), CPF optimization, cash flow analysis, profit margins, IRAS estimation

**Example prompts:**
"Calculate my estimated income tax for YA 2026"
"How should I optimize my CPF contributions as a self-employed person?"
"Analyze my business cash flow and flag risks"

### Themis — Your Legal Advisor

**Best for:** Contract review, PDPA compliance, warranty terms, dispute preparation, variation orders

**Example prompts:**
"Review this contract for unfair terms"
"Generate a PDPA compliance checklist for my business"
"What should I do if a client refuses to pay a variation order?"

### Ares — Your Adversary Simulator

**Best for:** Negotiation practice, difficult client roleplay, pitch stress-testing, objection handling

**Example prompts:**
"Simulate a difficult client who is unhappy with the final delivery"
"Stress-test my sales pitch — where are the weak points?"
"Roleplay a supplier negotiation where they're pushing for higher rates"

---

## How to Switch Profiles

### Method 1: One-shot query (recommended)

```bash
hermes --profile <profile-name> chat -q "your question"
```

### Method 2: Interactive session

```bash
hermes profile use <profile-name>
# Now every message goes to this profile
# Type 'exit' to return to Hermes
```

### Method 3: In the same chat (Telegram/CLI)

Just ask naturally. Hermes detects what you need and routes automatically. When you say "review this quote," Hermes routes to Zeus. When you say "should I invest in...," Hermes routes to Hephaestus.

---

## Daily Workflow Examples

### Morning (5 min)
```
"Good morning. What's on my calendar today? Are there any urgent emails?"
"Any tasks in ClickUp due today?"
"Run the daily system health check"
```

### During work
```
"Review this quote before I send it to the client"
"Draft a reply to this client email — they're asking about a delay"
"Research the best materials for [specific project requirement]"
```

### End of day (3 min)
```
"Summarize what I accomplished today and what's pending for tomorrow"
"Log today's key decisions and lessons learned"
"Run backup and verify it completed"
```

---

## Troubleshooting

### "Command not found: hermes"
Your PATH isn't set. Run:
```bash
export PATH="$HOME/.hermes:$HOME/.local/bin:$PATH"
```
Add this line to your `~/.bashrc` to make it permanent.

### "API key not configured"
```bash
hermes config set model.api_key "your-key-here"
```

### "Model not found" or "Provider error"
Check your available models:
```bash
hermes models list
```
Then set a working model:
```bash
hermes config set model.name "anthropic/claude-sonnet-4"
```

### "Permission denied" when running scripts
```bash
chmod +x ~/.hermes/product/blueprint/scripts/*.sh
```

### Full diagnostic scan
```bash
~/.hermes/product/blueprint/scripts/troubleshoot.sh --issue all
```

---

## Backup & Restore

### Manual backup
```bash
~/.hermes/product/blueprint/scripts/backup.sh
```
Creates a timestamped `.tar.gz` in `~/.hermes/backups/`.

### Restore from backup
```bash
~/.hermes/product/blueprint/scripts/restore.sh ~/.hermes/backups/hermes-backup-YYYYMMDD-HHMMSS.tar.gz
```

### Encrypt backups (recommended)
```bash
gpg -c ~/.hermes/backups/hermes-backup-*.tar.gz
# Enter a passphrase — don't lose it
```

---

## Getting Help

- **Documentation:** This guide lives at `~/.hermes/product/blueprint/USER_GUIDE.md`
- **Troubleshooting:** Run `~/.hermes/product/blueprint/scripts/troubleshoot.sh --quick`
- **Community:** [GitHub Discussions](https://github.com/alanzhiwei-sys/hermes-blueprint/discussions) (coming soon)
- **Pro/Foundry support:** Email alan@[your-domain].com or WhatsApp during Singapore business hours

---

*Welcome to your AI operating system. Start small — ask Hermes one thing today. Let the profiles earn your trust one interaction at a time.*
