# Workflow Automation

## Overview

A practical framework for deciding what to automate, choosing the right tools, and building reliable automated workflows. Focus on operational resilience — automation that breaks silently is worse than no automation.

## Automation Decision Framework

Not everything should be automated. Use this four-question filter before investing time:

1. **Frequency:** Does this task occur at least weekly? (Daily/monthly is the sweet spot. One-off tasks rarely justify automation.)
2. **Volume:** Does it involve significant data volume or repetitive steps? (Manual processing of >10 items = automation candidate.)
3. **Error Cost:** What is the cost of a human mistake vs. an automation failure? (If automation failure is catastrophic, build manual approval gates.)
4. **Maintenance Burden:** Will the automation itself require more maintenance than the manual task? (If the data format changes monthly, automation may be net-negative.)

**Decision Matrix:**

| Frequency | High Volume | Low Volume |
|-----------|-------------|------------|
| **Daily/Weekly** | Automate | Evaluate case-by-case |
| **Monthly** | Automate with alerts | Document the process instead |
| **Rare/One-off** | Script it, don't automate | Do it manually |

## Trigger-Event Catalog

Automations are initiated by triggers. Understand the options:

### Scheduled Triggers (Time-Based)
- **Cron:** Standard Unix scheduler. Best for simple, predictable schedules. Use for: daily reports, nightly backups, cache warming.
- **External scheduler:** n8n/Make built-in scheduler. Best when integrated with workflow tooling.

### Event Triggers (Action-Based)
- **Webhook:** Inbound HTTP request from a third-party service. Use for: GitHub push → deploy, Stripe payment → invoice, form submission → CRM update.
- **Email:** Inbound email parsing. Use for: invoice processing, support ticket creation.
- **Database change:** Row insert/update. Use for: data pipeline triggers, audit logging.
- **File system watch:** New file in directory. Use for: upload processing, log analysis.
- **Message queue:** New message on RabbitMQ, Kafka, SQS. Use for: high-throughput event processing.

### Hybrid Triggers
- **Polling:** Periodic check of an external system state. Use when webhooks aren't available. Set polling intervals based on urgency (1 min for critical, 15+ min for informational).

## n8n vs Make — Selection Guide

| Criterion | n8n | Make (formerly Integromat) |
|-----------|-----|---------------------------|
| **Self-hosting** | Yes (open source, Docker) | No (SaaS only) |
| **Pricing** | Free for self-hosted | Subscription tiers by operations |
| **Complexity ceiling** | High (code nodes, custom JS/Python) | Medium (visual only, limited scripting) |
| **Community** | Active GitHub, growing | Large existing community |
| **Data sovereignty** | Full control with self-hosting | Data passes through Make servers |
| **Best for** | Developer-heavy teams, sensitive data, complex logic | Business users, quick integrations, non-technical teams |

**Recommendation:** Self-host n8n via Docker for operational workflows where data sensitivity, cost control, and custom logic matter. Use Make for rapid prototyping and non-sensitive marketing/sales automations.

## Error Handling

Every automated workflow must handle failures explicitly. The worst failure mode is silent.

### Error Handling Pattern

```
1. Execute task
2. IF success → log result, continue
3. IF failure → classify error type:
   a. Transient (timeout, rate limit) → retry with exponential backoff (3 attempts, 2^n seconds)
   b. Permanent (invalid data, auth failure) → halt, alert, preserve input for debugging
   c. Partial (batch, some items failed) → log failures, continue with successful items
4. All errors → send alert with: workflow name, error message, input data snapshot, timestamp
```

**Checklist: Error Handling Quality**
- [ ] Every workflow has an explicit error path (no "happy path only" workflows)
- [ ] Retry logic with max attempts and backoff for transient errors
- [ ] Dead-letter queue or error log for failed executions
- [ ] Alert triggers on: first failure, N consecutive failures, error rate spike
- [ ] Input data preserved for debugging (mind data retention policies)

## Idempotency

Idempotency ensures that running the same automation multiple times with the same input produces the same result — critical for retries and replay.

### Idempotency Patterns

1. **Deduplication Key:** Assign a unique ID to each input event. Before processing, check if the ID has already been processed. Store processed IDs in a simple database or KV store.
2. **State Check Before Write:** Read current state → compute desired state → only write if different. Prevents duplicate updates.
3. **Upsert Operations:** Use INSERT...ON CONFLICT (PostgreSQL), REPLACE (MySQL), or PUT (REST APIs) instead of INSERT+separate check. The database handles deduplication.
4. **At-Least-Once + Idempotent Consumer:** Accept that triggers may fire more than once. Design consumers (the automation logic) to handle duplicates gracefully.

**Implementation Checklist:**
- [ ] Every workflow that creates or updates data uses a deduplication mechanism
- [ ] Webhook endpoints validate idempotency keys from the sender
- [ ] Retried executions don't create duplicate records
- [ ] Tested by running the same input through the workflow twice and verifying no duplicates
