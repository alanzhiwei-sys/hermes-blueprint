# Backup Strategy

## Overview

A comprehensive backup strategy is your last line of defense against data loss from hardware failure, human error, ransomware, and disasters. A backup that hasn't been tested is not a backup — it's a hope.

## The 3-2-1 Backup Rule

The gold standard for data resilience. Every piece of critical data must have:

1. **Three (3) total copies** of your data — the production copy plus two backups
2. **Two (2) different storage media** — don't put all backups on the same type of hardware
3. **One (1) offsite copy** — physically separated from the primary location

### Modern Interpretation (3-2-1-1-0)

Extend the classic rule for modern threats:

- **3** copies total
- **2** different media types (e.g., local disk + cloud object storage)
- **1** offsite copy
- **1** immutable or air-gapped copy (ransomware protection)
- **0** errors — verified by automated restore testing

### Practical Implementation

```
Primary data: Production server (SSD)
├── Local backup 1: NAS or external drive (different physical device, same location)
├── Offsite backup 2: Cloud object storage (S3, B2, GCS) with object lock / versioning
└── Air-gapped backup 3: Periodic snapshot to cold storage, not network-accessible
```

## What to Back Up

### Backup Priority Tiers

| Priority | Data Type | Examples | RPO | RTO |
|----------|-----------|----------|-----|-----|
| **Critical** | Business-continuity data | Databases, customer records, financial data, source code | <1 hour | <4 hours |
| **High** | Operational data | Configuration files, cron jobs, Docker Compose files, documentation | <24 hours | <24 hours |
| **Medium** | Productivity data | Email archives, project files, analytics data | <7 days | <48 hours |
| **Low** | Recreatable data | Build artifacts, caches, logs older than retention period | N/A | Recreate on demand |

**RPO (Recovery Point Objective):** Maximum acceptable data loss, measured in time.
**RTO (Recovery Time Objective):** Maximum acceptable time to restore service.

### Backup Exclusion List

Don't back up what you don't need:
- `/tmp`, `/var/tmp` — temporary files
- `/proc`, `/sys`, `/dev` — virtual filesystems
- Build artifacts and caches that can be regenerated
- Docker images that can be pulled from registries
- Package manager caches (`/var/cache/apt/`)

**Rule:** If you can regenerate it deterministically from source, back up the source, not the artifact.

## Encryption

Backups contain all your sensitive data. Encrypt them — both in transit and at rest.

### Encryption Checklist

- [ ] **At rest:** All backup files encrypted (AES-256-GCM recommended)
- [ ] **In transit:** TLS 1.3 for all network transfers, or encrypted before transmission
- [ ] **Key management:** Encryption keys stored separately from backups — never in the same location
- [ ] **Key rotation:** Rotate keys annually or after any suspected compromise
- [ ] **Key recovery:** Documented key recovery procedure accessible to at least two authorized people

### Tool Recommendations

| Tool | Use Case | Notes |
|------|----------|-------|
| `gpg` / `age` | File-level encryption before transfer | Simple, well-audited. `age` is simpler for automation |
| `rclone crypt` | Transparent encryption for cloud backups | Encrypts before upload, decrypts on download |
| `restic` | Encrypted deduplicated snapshots | Built-in encryption, supports S3/B2/SFTP backends |
| `borgbackup` | Encrypted local + remote backups | Strong deduplication, append-only mode for immutability |

### Restore Testing

**Untested backups are not backups.** Schedule regular restore drills.

### Restore Test Cadence

| Test Type | Frequency | Scope |
|-----------|-----------|-------|
| **File-level spot check** | Weekly (automated) | Restore 3 random files, verify checksums |
| **Database restore** | Monthly | Restore latest backup to staging, run integrity checks |
| **Full disaster recovery** | Quarterly | Restore entire stack from scratch, verify all services healthy |
| **Ransomware scenario** | Annually | Restore from immutable backup only, verify no data loss |

### Restore Test Documentation

After each test, record:
- Date, time, and operator
- Backup set restored
- Time to restore (compare against RTO)
- Data integrity: checksums matched? Application opened data correctly?
- Issues encountered and fixes applied

### Automated Verification Script Template

```bash
#!/bin/bash
# Weekly automated restore spot-check

BACKUP_PATH="/mnt/backups/daily"
RESTORE_PATH="/tmp/restore-test-$(date +%Y%m%d)"
SAMPLE_FILES=("db.sql.gz" "config.yml" "data/users.json")

mkdir -p "$RESTORE_PATH"

for file in "${SAMPLE_FILES[@]}"; do
    if [ ! -f "$BACKUP_PATH/$file" ]; then
        echo "ERROR: $file not found in backup" >&2
        exit 1
    fi
    cp "$BACKUP_PATH/$file" "$RESTORE_PATH/"
    ORIGINAL_MD5=$(md5sum "$BACKUP_PATH/$file" | cut -d' ' -f1)
    RESTORED_MD5=$(md5sum "$RESTORE_PATH/$file" | cut -d' ' -f1)
    if [ "$ORIGINAL_MD5" != "$RESTORED_MD5" ]; then
        echo "ERROR: Checksum mismatch for $file" >&2
        exit 1
    fi
    echo "OK: $file"
done

rm -rf "$RESTORE_PATH"
echo "All spot checks passed."
```

## Offsite Replication

Moving backups offsite is non-negotiable. A fire, flood, or theft that takes your primary system will also take any local-only backups.

### Replication Methods

1. **Push to cloud storage:** `rclone sync /backups remote:bucket/backups` — simplest, most common
2. **Pull from backup server:** Dedicated backup server pulls from production — better security isolation (production has no cloud credentials)
3. **Peer-to-peer replication:** Sync between geographically distributed nodes — complex, only for advanced setups

### Offsite Checklist

- [ ] Offsite copy in a different geographic region (≥300km from primary)
- [ ] Different cloud provider or physical location than primary infrastructure
- [ ] Offsite credentials are NOT stored on the primary system (for push models, use restricted keys)
- [ ] Bandwidth adequate for backup window (calculate: backup size ÷ available upload speed)
- [ ] Offsite retention policy matches or exceeds local retention
- [ ] Immutable storage enabled (S3 Object Lock, B2 Object Lock, WORM storage) — protects against ransomware deleting backups
