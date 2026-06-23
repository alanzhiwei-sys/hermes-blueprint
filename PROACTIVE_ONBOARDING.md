# Proactive Onboarding Path

Hermes Blueprint should not feel like "installation complete, good luck." The product promise is a guided AI operating system that keeps learning the customer's business after install.

## Product Principle

**Installation gives the customer an engine. Onboarding gives them a path. Personalization gives them value.**

Every paid customer should leave setup with:

1. A clear business context file Hermes can reference
2. A selected first business win
3. A concrete 48-hour artifact plan
4. A 30-day success path
5. First prompts for each major profile
6. A backlog of questions Hermes should ask over time
7. A Week 1 and Day 30 review loop

## What the Installer Now Creates

Running `./scripts/personalization-interview.sh` and `./scripts/first-win-wizard.sh` creates:

| File | Purpose |
|---|---|
| `~/.hermes/blueprint/CUSTOMER_CONTEXT.md` | Customer's business identity, services, workflow, tools, tone, boundaries |
| `~/.hermes/blueprint/SUCCESS_PATH.md` | Day 0 / Day 1 / Day 3 / Day 7 / Day 14 / Day 30 roadmap |
| `~/.hermes/blueprint/FIRST_WIN_PLAN.md` | One concrete business artifact to create within 48 hours |
| `~/.hermes/blueprint/PROACTIVE_QUESTIONS.md` | Questions Hermes should gradually ask to become more personalized |
| `~/.hermes/blueprint/FIRST_PROMPTS.md` | Copy-paste prompts for strategy, ops, content, research, finance |
| `~/.hermes/profiles/*/vault/wiki/customer-context.md` | Shared customer context copied into each installed profile vault |

## Customer Experience

### Bad Experience

> "Install done. Here are 13 profiles. Go figure it out."

This makes customers feel the product is just files and scripts.

### Good Experience

> "Install done. Now let's teach Hermes your business. Today we capture your context. Tomorrow we build your first workflow. In 7 days we review what worked. In 30 days we measure ROI."

This makes the customer feel they bought a system, not a ZIP file.

## First-Win Standard

The first 48 hours decide whether the customer believes the product has value.

A beta user must create at least one usable artifact, such as:

- Sales follow-up sequence
- Customer FAQ / response library
- Weekly owner command briefing
- SOP / delivery checklist
- Competitor / pricing research brief
- Proposal / quote assistant

If they cannot name or use one artifact within 7 days, onboarding failed — even if installation succeeded.

## 30-Day Success Path

### Day 0 — Install + First Context

Goal: prove Hermes works and give it basic customer context.

Customer completes:
- Health check
- Personalization interview
- First 48-hour win selection

### Day 1 — Workflow Interview

Goal: make Hermes ask the customer about their real workflow.

Recommended prompt:

```bash
hermes chat -q "Interview me about my sales workflow. Ask one question at a time. At the end, create a sales workflow playbook for my business."
```

### Day 3 — First Playbook

Goal: create one reusable SOP from the customer's actual work.

Examples:
- Quote follow-up process
- Client onboarding process
- Weekly reporting process
- Content publishing process
- Supplier comparison process

### Day 7 — Business Review

Goal: show early value and identify gaps.

Recommended prompt:

```bash
hermes chat -q "Review my first week using Hermes. Ask me what I tried, what failed, and what to improve. Then create my Week 2 action plan."
```

### Day 14 — Automation Audit

Goal: identify safe automation opportunities without rushing into risky actions.

Recommended prompt:

```bash
hermes --profile poseidon-operations chat -q "Based on my workflow and approval boundaries, identify 3 safe automations and 3 automations I should avoid for now."
```

### Day 30 — ROI Review

Goal: make value visible.

Recommended prompt:

```bash
hermes chat -q "Run a 30-day ROI review. Compare my time saved, decisions improved, workflows created, and gaps remaining. Recommend whether to deepen, simplify, or stop using any profiles."
```

## Boundaries

Hermes should be proactive in **asking, drafting, organizing, and reviewing**.

Hermes should not be proactive in:

- Sending customer messages
- Deleting files
- Spending money
- Publishing public content
- Changing production systems
- Making legal/financial commitments

Those actions require explicit user approval.

## Commercial Implication

This path strengthens paid perceived value:

| Tier | Onboarding Promise |
|---|---|
| Blueprint Kit | Self-guided 30-day success path + First Business Win wizard |
| Blueprint Pro | Alan walks them through Day 0, verifies install, and helps choose the first business artifact |
| Blueprint Foundry | Alan builds custom profiles + runs Day 30 ROI review around real business workflows |

The buyer should feel there is a planned implementation journey, not just an installer.
