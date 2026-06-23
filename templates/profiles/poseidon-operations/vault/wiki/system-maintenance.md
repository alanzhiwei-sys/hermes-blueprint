# System Maintenance

## Overview

A proactive maintenance regimen to keep servers healthy, secure, and performant. Unmaintained systems drift into failure silently — scheduled maintenance prevents emergency firefighting.

## Health Check Schedule

Define and execute health checks on a fixed cadence. Automate what you can; manually verify what you can't.

### Daily Checks (Automated)

| Check | Command / Method | Expected Result | Alert On |
|-------|-----------------|-----------------|----------|
| Disk usage | `df -h` | <80% on all partitions | >85% — WARN, >95% — CRITICAL |
| Memory usage | `free -m` | <90% used | >95% — WARN, swap usage >50% |
| CPU load | `uptime` | Load < CPU cores | Load > 2× CPU cores sustained |
| Service status | `systemctl is-active <service>` | active | inactive or failed |
| Docker containers | `docker ps -a --filter "status=exited"` | No unexpected exited | Any exited container not marked as completed task |
| SSL cert expiry | `openssl s_client -connect host:443 -servername host </dev/null 2>/dev/null \| openssl x509 -noout -enddate` | >30 days remaining | <14 days — WARN, <7 days — CRITICAL |

### Weekly Checks

- [ ] Review system logs for anomalies (`journalctl --since "1 week ago" -p err`)
- [ ] Verify backups completed successfully (check backup logs, test restore a sample)
- [ ] Review security updates available (`apt list --upgradable` / `yum check-update`)
- [ ] Check monitoring dashboards for trends (disk growth rate, memory leak patterns)

### Monthly Checks

- [ ] Full backup integrity test (restore a random backup to staging and verify)
- [ ] User account audit: remove inactive accounts, rotate access keys
- [ ] Review and update firewall rules
- [ ] Performance baseline comparison (is the system slower than last month?)

## Update Policy

A structured approach to applying system and package updates without destabilizing production.

### Prioritization Tiers

| Tier | Type | Window | Testing Requirement |
|------|------|--------|-------------------|
| **Critical** | Security patches with known exploits (CVE score ≥9.0) | Within 24 hours | Smoke test only if available |
| **High** | Security patches (CVE 7.0-8.9), critical bug fixes | Within 7 days | Deploy to staging first |
| **Medium** | Non-critical security, minor version bumps | Next maintenance window | Full staging verification |
| **Low** | Feature updates, cosmetic fixes | Next scheduled release cycle | Standard QA process |

### Update Execution Checklist

- [ ] Announce maintenance window (if applicable) to stakeholders
- [ ] Take system snapshot / backup before starting
- [ ] Apply updates to staging environment first
- [ ] Run test suite / smoke tests on staging
- [ ] Apply updates to production during low-traffic window
- [ ] Monitor system metrics for 30 minutes post-update
- [ ] Verify all services are healthy
- [ ] Document what was updated and any issues encountered

### Rollback Readiness

Always have a rollback plan before updating:
- **Package manager rollback:** `apt install <package>=<previous-version>` or `yum downgrade`
- **Snapshot restore:** VM snapshot or filesystem snapshot (ZFS, LVM)
- **Docker:** Keep previous image tag. `docker service rollback` or `docker-compose up -d` with pinned old version

## Log Rotation

Unmanaged logs consume disk space and make debugging harder.

### Rotation Policy

```
# /etc/logrotate.d/custom-app
/var/log/myapp/*.log {
    daily
    rotate 30          # Keep 30 days
    compress           # gzip old logs
    delaycompress      # Keep yesterday's log uncompressed for 1 day
    missingok          # Don't error if log file is missing
    notifempty         # Don't rotate empty files
    create 640 appuser appgroup
    postrotate
        systemctl reload myapp  # Signal app to reopen log files
    endscript
}
```

**Default rotation rules:**
- Application logs: 30 days retention, daily rotation
- Web server access logs: 90 days (for analytics), then archive to cold storage
- System logs (syslog, auth.log): 30 days
- Debug/trace logs: 7 days maximum — these grow fastest

### Pre-Rotation Health Check

Before enabling log rotation, verify:
- [ ] Application supports log file reopening (SIGHUP, USR1, or built-in)
- [ ] No critical audit requirement mandates longer retention
- [ ] Compression doesn't break log analysis tools (test first)
- [ ] Disk has headroom for compressed archive storage

## Disk Monitoring

### Thresholds and Actions

| Usage | Status | Action |
|-------|--------|--------|
| <70% | Healthy | No action |
| 70-80% | Watch | Review growth rate, plan cleanup or expansion |
| 80-90% | Warning | Execute cleanup runbook, alert ops |
| 90-95% | Critical | Immediate cleanup, page on-call |
| >95% | Emergency | Emergency cleanup, services at risk of failure |

### Quick Cleanup Commands

```bash
# Docker cleanup
docker system prune -a --volumes --force

# Find largest directories
du -h --max-depth=1 / | sort -hr | head -20

# Find files >100MB modified >30 days ago
find / -type f -size +100M -mtime +30 2>/dev/null

# Clear systemd journal older than 7 days
journalctl --vacuum-time=7d

# Clear apt cache
apt clean && apt autoremove
```

## Docker Cleanup

Docker accumulates unused images, containers, volumes, and networks over time.

### Scheduled Cleanup

Add to weekly cron:

```bash
#!/bin/bash
# Weekly Docker cleanup — safe for running services

# Remove stopped containers
docker container prune -f

# Remove dangling images (untagged, no container references)
docker image prune -f

# Remove unused images (not used by any container)
# Use with caution — only if you don't need rollback capability
docker image prune -a -f --filter "until=168h"  # Older than 7 days

# Remove unused volumes (DANGER: data loss if misconfigured)
# Only enable if you're certain no named volumes are in use
# docker volume prune -f

# Remove unused networks
docker network prune -f

# Show space recovered
docker system df
```

**Safety rules:**
- Never run `docker volume prune` unattended — it can destroy persistent data
- Keep at least the last 2 image versions for rollback capability
- Test cleanup script in staging before deploying to production cron
- Monitor `docker system df` output weekly to catch build-up early
