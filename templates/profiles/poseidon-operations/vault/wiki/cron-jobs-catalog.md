# Cron Jobs Catalog

## Overview

A systematic approach to inventorying, scheduling, and monitoring cron jobs. Every cron job must be documented, justified, and monitored — cron jobs without owners are operational debt.

## Job Inventory Template

Maintain a living inventory of every cron job in your infrastructure. Use this template:

### Inventory Record

```
**Job ID:** unique-identifier (e.g., daily-backup-db-prod)
**Purpose:** What business need does this serve? (One sentence justification)
**Schedule:** Cron expression + human-readable (e.g., `0 2 * * *` — Daily at 2:00 AM UTC)
**Command:** Full command with arguments
**Owner:** Person/team responsible for this job
**Expected Duration:** Normal runtime range (e.g., 2-5 minutes)
**Success Criteria:** How do we know it worked? (exit code 0, specific log message, file created)
**Dependencies:** What must succeed before this runs? (other jobs, services, data sources)
**Alerting:** Who gets notified on failure? What channel?
**Last Review:** Date of last audit for continued relevance
**Documentation:** Link to detailed runbook
```

### Master Inventory Table

| Job ID | Schedule | Owner | Last Success | Status | Dependencies |
|--------|----------|-------|-------------|--------|-------------|
| daily-backup-db | 0 2 * * * | ops | 2026-06-10 | ✅ | postgres-up |
| weekly-report | 0 8 * * 1 | analytics | 2026-06-08 | ✅ | daily-rollup |

## Scheduling Best Practices

### Time Distribution
- **Avoid the "top of the hour" problem:** Stagger jobs by 5-15 minute offsets. Don't schedule everything at `0 * * * *`.
- **Off-peak execution:** Schedule resource-intensive jobs during low-traffic hours (typically 2-5 AM local). Know your traffic patterns.
- **Randomized offsets:** For jobs running across many servers, add a random sleep (`sleep $((RANDOM % 300))`) to avoid thundering herds.

### Cron Expression Reference

```
┌────────── minute (0-59)
│ ┌───────── hour (0-23)
│ │ ┌──────── day of month (1-31)
│ │ │ ┌─────── month (1-12)
│ │ │ │ ┌────── day of week (0-7, 0=Sunday)
│ │ │ │ │
* * * * * command
```

**Common pitfalls:**
- `0 0 * * *` runs at midnight, not "every hour"
- `*/5 * * * *` runs every 5 minutes — the correct syntax for "every N"
- Remember timezone: cron uses system timezone unless overridden

### Environment Hygiene
- Always set `SHELL=/bin/bash` and `PATH` explicitly at the top of crontabs
- Use absolute paths for all commands and files
- Redirect output: `>> /var/log/jobname.log 2>&1` — capture both stdout and stderr
- Wrap commands in a shell script rather than complex one-liners in crontab

## Dependency Chains

Many cron jobs form implicit dependency chains. Make them explicit.

### Dependency Patterns

1. **Sequential (Chain):** Job B must run after Job A succeeds.
   - **Implementation:** `job-a && job-b` in a wrapper script, or use a workflow tool (n8n)
   - **Risk:** If Job A fails, entire chain stalls

2. **Fan-out (Parallel):** Multiple independent jobs can run simultaneously after a gate job.
   - **Implementation:** Gate job writes a sentinel file; downstream jobs wait for it
   - **Risk:** Resource contention if many jobs fire simultaneously

3. **DAG (Directed Acyclic Graph):** Complex dependencies.
   - **Implementation:** Use a workflow orchestrator (Airflow, Prefect, Dagster), not raw cron
   - **Signal:** When you have >5 interdependent jobs, graduated from cron to an orchestrator

### Dependency Documentation

For each dependency, document:
- **Upstream job ID** and expected completion time
- **What to do if upstream fails:** Skip, wait, run with stale data, escalate?
- **Maximum acceptable staleness:** How old can the upstream output be before downstream job should abort?

## Failure Alerting

A cron job that silently fails is dangerous. Build a layered alerting strategy.

### Alert Levels

| Level | Condition | Action |
|-------|-----------|--------|
| **INFO** | Job completed with warnings | Log only, include in daily digest |
| **WARN** | Job failed but retry succeeded | Notify in daily summary |
| **ERROR** | Job failed, retry exhausted | Immediate notification to owner + ops channel |
| **CRITICAL** | Job failed + downstream jobs blocked | Page on-call, escalate |

### Monitoring Checklist

- [ ] Every cron job has a health check (did it run when expected?)
- [ ] Success/failure tracked with timestamps (not just "last ran")
- [ ] Dead man's switch for critical jobs: alert if job HASN'T run in expected window
- [ ] Alert fatigue prevention: group related failures, don't spam on retries
- [ ] Monthly audit: review job inventory for stale jobs, update owners
- [ ] Runbook exists for each ERROR/CRITICAL job with recovery steps

### Heartbeat Monitoring Pattern

For truly critical jobs, implement a heartbeat:

1. Job writes a timestamp to a known location (file, DB row, monitoring API)
2. Separate monitor checks "has the heartbeat been updated in the last N minutes?"
3. If heartbeat is stale → alert. This catches jobs that hang or the cron daemon stops.
