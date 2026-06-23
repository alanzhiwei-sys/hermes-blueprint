# Hermes Blueprint — Community Edition

**Your own AI operating system for business.** Pre-configured, self-hosted, and guided by a 30-day personalization path.

[![Beta](https://img.shields.io/badge/status-beta-yellow)](https://github.com/alanzhiwei-sys/hermes-blueprint)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue)](LICENSE)
[![Hermes Agent](https://img.shields.io/badge/powered%20by-Hermes%20Agent-purple)](https://github.com/nousresearch/hermes-agent)

---

## What is Hermes Blueprint?

A **pre-configured AI operating system** for small businesses. Install it on any Linux machine and get 13 AI specialists that handle your projects, clients, research, content, finances, legal, and operations — without hiring a team.

Unlike a generic chatbot or a folder of prompts, Blueprint includes a **30-day personalization path**. It captures your business context, creates first prompts, builds your first workflow, runs a Day 7 review, and helps you measure ROI at Day 30.

Built on [Hermes Agent](https://github.com/nousresearch/hermes-agent) (57K+ stars), the open-source AI agent framework.

---

## What You Get

| Profile | What it does |
|---|---|
| **Zeus** | Project management — quotes, timelines, subcontractors, client communication |
| **Hera** | Business operations — service packages, pricing, installer briefing |
| **Hephaestus** | Strategic advisor — "should I" decisions, investments, tools, strategy |
| **Aphrodite** | Relationship coach — work-life balance, communication, wellness |
| **Apollo** | Content & branding — social media, marketing copy, brand voice |
| **Artemis** | Coder & architect — code review, debugging, tool evaluation |
| **Athena** | Researcher — market research, competitor analysis, deep dives |
| **Poseidon** | Operations — automation, backups, system health, cron jobs |
| **Hestia** | Finance — tax (SG), CPF, cash flow, profit margins |
| **Themis** | Legal — contracts, PDPA compliance, disputes |
| **Ares** | Adversary sim — negotiation practice, pitch stress-testing |

**13 profiles. One install. Your business runs smarter.**

---

## Quick Start

### Prerequisites

- Linux machine (Ubuntu 22.04+ recommended, 16GB+ RAM)
- OpenRouter or Anthropic API key ([free signup](https://openrouter.ai/keys))
- Basic terminal comfort (you can copy-paste commands)

### Install

```bash
curl -fsSL https://raw.githubusercontent.com/alanzhiwei-sys/hermes-blueprint/main/install.sh | bash
```

This installs Hermes Agent + all 13 profile templates + setup wizard + scripts.

After installation, Blueprint does **not** stop at "done." It runs a proactive personalization path that teaches Hermes your business and creates your 30-day success roadmap.

### First Run

```bash
# Set your API key
hermes config set model.api_key "sk-or-your-key-here"

# Ask your first question
hermes chat -q "What's on my calendar today?"

# Meet your team
hermes --profile hephaestus-assistant chat -q "Should I invest in marketing or tools first?"
```

---

## What's in the Box

```
blueprint/
├── install.sh                    # One-command installer
├── setup-wizard.sh               # Interactive onboarding
├── USER_GUIDE.md                 # Full documentation
├── PRICING.md                    # Commercial tiers
├── DOMAIN_INTERVIEW.md           # Customization questions
├── BETA_INVITE.md                # Private beta invite + qualification script
├── POSITIONING.md                # Product messaging and beta positioning
├── PROACTIVE_ONBOARDING.md        # 30-day personalization path
├── scripts/
│   ├── personalization-interview.sh # Customer context + success roadmap
│   ├── first-win-wizard.sh       # First useful business artifact plan
│   ├── backup.sh                 # Portable backup
│   ├── restore.sh                # Full restore
│   ├── update.sh                 # Safe updates (preserves your configs)
│   └── troubleshoot.sh           # Health diagnostics
└── templates/profiles/           # 13 AI profile templates
    ├── zeus-renovation/          # Project manager
    ├── hera-smarthush/           # Business operations
    ├── hephaestus-assistant/     # Strategic advisor
    ├── aphrodite-relationship/   # Relationship coach
    ├── apollo-content/           # Content & branding
    ├── artemis-coder/            # Coder & architect
    ├── athena-researcher/        # Researcher
    ├── poseidon-operations/      # Operations
    ├── hestia-finance/           # Finance (Singapore)
    ├── themis-legal/             # Legal advisor
    ├── ares-adversary/           # Adversary simulator
    ├── zeus-project-manager/     # Adaptable PM (any industry)
    └── hera-business-ops/        # Adaptable business ops (any industry)
```

---

## Proactive Personalization Path

Blueprint is designed to avoid the "that's it?" problem after installation.

After setup, run:

```bash
./scripts/personalization-interview.sh
```

This creates:

| File | What it does |
|---|---|
| `~/.hermes/blueprint/CUSTOMER_CONTEXT.md` | Captures your business, customers, workflow, tone, tools, and approval boundaries |
| `~/.hermes/blueprint/SUCCESS_PATH.md` | Day 0 / Day 1 / Day 3 / Day 7 / Day 14 / Day 30 roadmap |
| `~/.hermes/blueprint/PROACTIVE_QUESTIONS.md` | Questions Hermes should gradually ask so it keeps learning your business |
| `~/.hermes/blueprint/FIRST_PROMPTS.md` | Copy-paste prompts for strategy, ops, content, research, and finance |

**The goal:** Hermes should keep asking useful questions, building playbooks, and reviewing progress after installation — not just sit there waiting for perfect prompts.

See [PROACTIVE_ONBOARDING.md](PROACTIVE_ONBOARDING.md) for the full 30-day path.

---

## Who This Is For

✅ **Solo business owners** who do everything themselves — PM, sales, ops, finance  
✅ **Small teams (2-10 people)** who need AI support but can't hire engineers  
✅ **Technical founders** who want an AI OS, not a SaaS subscription  
✅ **Singapore SMEs** — profiles include Singapore-specific tax, CPF, HDB, PDPA context  

❌ **Not for:** People who've never used a terminal. You need basic Linux comfort.

---

## Pricing

**This repo is free and open-source (MIT).** You can install everything and use it forever at no cost beyond your LLM API fees (~$25-50 SGD/mo).

**Commercial tiers** (for businesses who want more):

| Tier | Price (SGD) | What's extra |
|---|---:|---|
| **Blueprint Kit** | $149 | Self-install + 13 profiles + scripts + personalization interview + 30-day success path |
| **Blueprint Pro** | $599 | Kit + Alan-guided Day 0 setup + Day 7 review + 30-day support |
| **Blueprint Foundry** | $999 | Pro + 3 custom industry profiles + Day 30 ROI review + 90-day support |

See [PRICING.md](PRICING.md) for details.

---

## Customizing for Your Business

Two profiles are **adaptable** to any industry:

- `zeus-project-manager` → rename to whatever you do (e.g., "construction-pm", "event-planner")
- `hera-business-ops` → rename to your service business

Edit `CUSTOMER_DOMAIN.md` in each profile to tell the AI about YOUR business, YOUR tools, and YOUR workflow.

See [DOMAIN_INTERVIEW.md](DOMAIN_INTERVIEW.md) for the guided questionnaire.

---

## Beta Program

**Status:** 🟡 Beta — seeking 5-10 early users for feedback

If you install this and use it for 2+ weeks, I want to hear from you:
- What worked immediately?
- What was confusing?
- What's missing?

→ [Request Beta Access](https://github.com/alanzhiwei-sys/hermes-blueprint/discussions) (GitHub Discussions)
→ Or DM me on Telegram

---

## FAQ

**Q: Do I need to be technical?**
A: You need basic terminal comfort (copy-paste commands, edit a text file). If you've ever followed a Linux tutorial, you're fine. If you've never opened a terminal, the Kit tier might be a better fit than DIY.

**Q: What does it cost to run?**
A: The software is free. You pay for LLM API usage — typically $25-50 SGD/month for a solo business owner using it daily. This goes to OpenRouter/Anthropic directly, not to us.

**Q: Can I run this on macOS/Windows?**
A: Linux only for now. macOS via Docker (instructions coming). Windows via WSL (untested).

**Q: Is my data private?**
A: Everything runs on YOUR machine. Your emails, client data, project files — none of it goes to us. The only external call is to the LLM API (OpenRouter/Anthropic) for AI responses.

**Q: Who built this?**
A: Alan — a renovation project manager in Singapore who built this for himself, used it daily for 6+ months, and is now sharing it. Not a VC-backed startup. Not a SaaS company. One person who built the tool he wished existed.

---

## Contributing

Found a bug? Have a feature idea? [Open an issue](https://github.com/alanzhiwei-sys/hermes-blueprint/issues).

Want to add a profile for your industry? PRs welcome.

---

## License

MIT — free for personal and commercial use. Built on [Hermes Agent](https://github.com/nousresearch/hermes-agent) (also open-source).

---

*Built with ❤️ in Singapore by someone who just wanted AI to handle the boring stuff.*
