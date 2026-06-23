# Alerting Policy

## Overview

An alerting policy defines what deserves attention, who gets notified, through which channels, and how quickly. The goal is to maximize signal and minimize noise — every alert should demand action, and every page should be actionable.

## Severity Tiers

Classify all alerts into five severity levels. This is the foundation of your alerting policy — every alert must have an assigned severity.

### Severity Definitions

| Severity | Name | Definition | Response SLA | Notification |
|----------|------|-----------|-------------|-------------|
| **SEV0** | Critical Outage | Complete service unavailability. Revenue-impacting. Data loss in progress. | 5 min acknowledge, 30 min resolve | Page + Phone Call |
| **SEV1** | Major Incident | Core feature broken for majority of users. Significant degradation. | 15 min acknowledge, 2 hr resolve | Page |
| **SEV2** | Partial Outage | Feature broken for subset of users. Non-critical service down. | 1 hr acknowledge, 8 hr resolve | High-priority message |
| **SEV3** | Warning | Degraded performance, approaching thresholds. Non-blocking issue. | End of business day | Message / ticket |
| **SEV4** | Informational | Routine notifications, system events, trend data. | Next business day | Log / dashboard |

### Severity Assignment Rules

When creating an alert, verify:
- [ ] Does this actually require human intervention? (If automation can fix it, automate — don't alert)
- [ ] Is the severity appropriate? (Tendency is to over-severity; err toward lower tiers)
- [ ] Is there a clear runbook for this alert? (No runbook → demote to SEV4 until one exists)
- [ ] Would this wake someone up at 3 AM for a valid reason? (If no, it's not SEV0 or SEV1)

## Notification Channels

Match channel to severity. Don't send low-severity alerts to high-urgency channels.

### Channel Catalog

| Channel | Best For | Latency | Avoid For |
|---------|----------|---------|-----------|
| **PagerDuty / Opsgenie** | SEV0, SEV1 (on-call rotation, escalation) | <1 min | SEV3, SEV4 (alert fatigue) |
| **Push notification** (Slack, Teams DM) | SEV2 during business hours | <2 min | Off-hours unless on-call |
| **Group chat channel** (#alerts, #ops) | SEV2, SEV3 (team visibility) | <5 min | SEV0 (may be missed) |
| **Email** | SEV3, daily digests, trend reports | <30 min | SEV0, SEV1 (too slow) |
| **Dashboard** (Grafana, Datadog) | SEV4, trend monitoring | N/A (passive) | Anything requiring action |
| **Ticket system** (Jira, Linear) | SEV2-SEV4 follow-up tasks | Hours-days | SEV0, SEV1 (needs immediate action) |

### Channel Selection Checklist
- [ ] SEV0/SEV1 always routed to on-call rotation with escalation
- [ ] No single point of failure: at least 2 people in rotation for each critical service
- [ ] Off-hours alerts only for SEV0 and SEV1 (respect sleep and work-life boundaries)
- [ ] All SEV0/SEV1 alerts also logged to a persistent channel for post-mortem review

## Escalation Matrix

Define who gets alerted and when, with automatic escalation if an alert goes unacknowledged.

### Standard Escalation Path

```
Time Elapsed        Action
────────────────────────────────────────
Alert fires    →    Primary on-call notified
+5 min (no ack) →  Secondary on-call notified
+15 min (no ack) → Team lead / manager notified
+30 min (no ack) → Engineering director notified
+60 min (no ack) → VP / CTO notified
```

### Escalation Configuration Rules

- **Primary on-call:** Rotated weekly. Goes to first responder.
- **Secondary on-call:** Rotated weekly, offset from primary. Acts as backup.
- **Manager escalation:** Only for SEV0 and unresolved SEV1. Don't escalate SEV2 to management.
- **Weekend/holiday:** Same rotation applies. If the service matters, 24/7 coverage matters.
- **Handoff:** Document who was on-call, what happened, and any open issues at rotation change.

### Escalation Policy Document

Maintain a current document containing:
- On-call rotation schedule (published 4 weeks in advance)
- Primary and secondary contact details (phone, email, preferred channel)
- Service ownership map (who owns which alerts)
- External dependencies and their support contacts
- Escalation contacts at each level

## False Positive Reduction

The single biggest threat to an effective alerting system is alert fatigue. When people get too many false alarms, they start ignoring all alerts — including real ones.

### Root Cause Analysis for False Alarms

For every false positive, investigate:

1. **Threshold too tight:** Is the alert threshold realistic? (e.g., CPU >80% for 1 minute vs. sustained >90% for 10 minutes)
2. **Flapping:** Is the condition rapidly toggling on/off? Add hysteresis or minimum duration requirements.
3. **Wrong metric:** Are we alerting on a proxy metric instead of the actual user-facing symptom?
4. **Environment variance:** Does the threshold account for normal patterns (deployments, batch jobs, traffic spikes)?
5. **Stale alert:** Was this alert created for a past incident that's no longer relevant?

### False Positive Reduction Checklist

- [ ] Every alert has a documented alerting threshold with justification
- [ ] Alerts require sustained condition (minimum 5 minutes) before firing — prevents flapping
- [ ] Alert volume reviewed monthly: top 5 noisy alerts targeted for tuning or removal
- [ ] Automatically suppress alerts during known maintenance windows
- [ ] Correlation rules: don't fire 50 alerts for a single root cause (group related alerts)
- [ ] "Alert on symptoms, not causes" — alert on "users getting 500 errors", not "CPU >90%". The latter may be normal under load.

### Monthly Alert Hygiene Ritual

1. Pull all alerts from the past 30 days
2. Categorize: Actionable vs. Ignored vs. False Positive
3. Calculate signal-to-noise ratio: Actionable / Total alerts
4. Target: >70% actionable rate. Below 50% requires systematic review.
5. For each alert below 50% actionable rate: tune threshold, change metric, or delete
6. Archive alerts for services/components that no longer exist
7. Document changes and share with the team

### Alert Design Principles

**Good alerts:**
- Indicate a user-visible problem or an imminent one
- Are specific about what's wrong and where
- Link directly to a runbook with remediation steps
- Fire once per incident, not once per affected component

**Bad alerts (avoid):**
- "CPU is high" — normal under load. Alert on error rates or latency instead.
- "Disk is 80% full" — not actionable until it's an actual problem. Alert at 90% and 95% with trend data.
- "Something might be wrong" — vague. Be specific or don't alert.
- Alerts on metrics you can't control or don't have a runbook for.
