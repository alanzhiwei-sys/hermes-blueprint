#!/bin/bash
# Hermes Blueprint — Backup Script
# Creates a timestamped backup of profiles, configs, skills, cron, vault.
# Excludes: hermes-agent binary, venv, caches, logs, node_modules, mnemosyne DB
#
# Usage:
#   ./backup.sh                           # Full backup
#   ./backup.sh --output /mnt/backups     # Custom output dir
#   ./backup.sh --profile zeus-renovation # Single profile only
#   ./backup.sh --profiles-only           # All profiles (no global config)
#
set -euo pipefail

# ── Defaults ──────────────────────────────────────────────────────────
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="${BACKUP_DIR:-$HOME/.hermes/backups}"
HERMES_HOME="${HERMES_HOME:-$HOME/.hermes}"
TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
PROFILE_FILTER=""
PROFILES_ONLY=false
DRY_RUN=false
VERBOSE=false

# ── Usage ─────────────────────────────────────────────────────────────
usage() {
    cat <<EOF
🛡️  Hermes Blueprint — Backup

Usage: ./backup.sh [options]

Options:
  --output DIR         Backup directory (default: \$HERMES_HOME/backups)
  --profile NAME       Backup a single profile only
  --profiles-only      Backup all profiles, skip global config
  --dry-run            Show what would be backed up without creating archive
  -v, --verbose        Show detailed file list
  -h, --help           Show this help

Examples:
  ./backup.sh                                      # Full backup
  ./backup.sh --profile zeus-renovation             # One profile
  ./backup.sh --output /mnt/nas/backups             # External drive
EOF
    exit 0
}

# ── Parse Args ────────────────────────────────────────────────────────
while [[ $# -gt 0 ]]; do
    case "$1" in
        --output)        BACKUP_DIR="$2"; shift 2 ;;
        --profile)       PROFILE_FILTER="$2"; shift 2 ;;
        --profiles-only) PROFILES_ONLY=true; shift ;;
        --dry-run)       DRY_RUN=true; shift ;;
        -v|--verbose)    VERBOSE=true; shift ;;
        -h|--help)       usage ;;
        *) echo "Unknown option: $1"; usage ;;
    esac
done

# ── Preflight ─────────────────────────────────────────────────────────
if [ ! -d "$HERMES_HOME" ]; then
    echo "❌ Hermes home not found: $HERMES_HOME"
    echo "   Set HERMES_HOME or run from a Hermes installation."
    exit 1
fi

mkdir -p "$BACKUP_DIR"
BACKUP_FILE="$BACKUP_DIR/hermes-backup-${TIMESTAMP}.tar.gz.gpg"

# ── Build File List ───────────────────────────────────────────────────
say() { echo "   $*"; }

echo ""
echo "🛡️  Hermes Blueprint — Backup"
echo "═══════════════════════════════════════"
echo "   Hermes home: $HERMES_HOME"
echo "   Output dir:  $BACKUP_DIR"
echo "   Timestamp:   $TIMESTAMP"
echo ""

TMP_LIST=$(mktemp)

# ── Always include: root config files ─────────────────────────────────
if ! $PROFILES_ONLY && [ -z "$PROFILE_FILTER" ]; then
    # Global configs
    for f in config.yaml .env SOUL.md AGENTS.md auth.json channel_directory.json; do
        if [ -f "$HERMES_HOME/$f" ]; then
            echo "$HERMES_HOME/$f" >> "$TMP_LIST"
            $VERBOSE && say "✅ $f"
        fi
    done

    # Global skills
    if [ -d "$HERMES_HOME/skills" ]; then
        find "$HERMES_HOME/skills" -type f \
            ! -path '*/.git/*' \
            ! -path '*/__pycache__/*' \
            ! -path '*/.curator_backups/*' \
            >> "$TMP_LIST" 2>/dev/null || true
        $VERBOSE && say "✅ skills/"
    fi

    # Cron jobs + scheduler
    if [ -d "$HERMES_HOME/cron" ]; then
        find "$HERMES_HOME/cron" -type f \
            ! -name 'ticker_heartbeat' \
            ! -name 'ticker_last_success' \
            ! -path '*/output/*' \
            ! -path '*/output-archive/*' \
            >> "$TMP_LIST" 2>/dev/null || true
        $VERBOSE && say "✅ cron/"
    fi

    # Plugins
    if [ -d "$HERMES_HOME/plugins" ]; then
        find "$HERMES_HOME/plugins" -type f \
            ! -path '*/.git/*' \
            ! -path '*/__pycache__/*' \
            >> "$TMP_LIST" 2>/dev/null || true
        $VERBOSE && say "✅ plugins/"
    fi

    $VERBOSE || say "✅ Root config + skills + cron + plugins"
fi

# ── Profiles ──────────────────────────────────────────────────────────
PROFILES_DIR="$HERMES_HOME/profiles"
if [ ! -d "$PROFILES_DIR" ]; then
    echo "⚠️  No profiles directory found at $PROFILES_DIR"
else
    if [ -n "$PROFILE_FILTER" ]; then
        # Single profile
        if [ -d "$PROFILES_DIR/$PROFILE_FILTER" ]; then
            find "$PROFILES_DIR/$PROFILE_FILTER" -type f \
                ! -path '*/audio_cache/*' \
                ! -path '*/cache/*' \
                ! -path '*/image_cache/*' \
                ! -path '*/logs/*' \
                ! -path '*/sandboxes/*' \
                ! -path '*/sessions/*' \
                ! -path '*/pairing/*' \
                ! -path '*/bin/*' \
                ! -path '*/home/*' \
                ! -path '*/.git/*' \
                ! -path '*/__pycache__/*' \
                ! -path '*/.curator_backups/*' \
                >> "$TMP_LIST" 2>/dev/null || true
            say "✅ 1 profile: $PROFILE_FILTER"
        else
            echo "❌ Profile not found: $PROFILE_FILTER"
            exit 1
        fi
    else
        # All profiles
        count=0
        for profile_dir in "$PROFILES_DIR"/*/; do
            profile_name=$(basename "$profile_dir")
            [ "$profile_name" = "*" ] && continue
            find "$profile_dir" -type f \
                ! -path '*/audio_cache/*' \
                ! -path '*/cache/*' \
                ! -path '*/image_cache/*' \
                ! -path '*/logs/*' \
                ! -path '*/sandboxes/*' \
                ! -path '*/sessions/*' \
                ! -path '*/pairing/*' \
                ! -path '*/bin/*' \
                ! -path '*/home/*' \
                ! -path '*/.git/*' \
                ! -path '*/__pycache__/*' \
                ! -path '*/.curator_backups/*' \
                >> "$TMP_LIST" 2>/dev/null || true
            count=$((count + 1))
        done
        say "✅ $count profiles"
    fi
fi

# ── Sessions (optional, small) ────────────────────────────────────────
if ! $PROFILES_ONLY && [ -z "$PROFILE_FILTER" ]; then
    if [ -d "$HERMES_HOME/sessions" ]; then
        find "$HERMES_HOME/sessions" -type f -name '*.db' 2>/dev/null >> "$TMP_LIST" || true
        $VERBOSE && say "✅ sessions/"
    fi
fi

# ── Vault (if at root level) ──────────────────────────────────────────
if ! $PROFILES_ONLY && [ -z "$PROFILE_FILTER" ]; then
    if [ -d "$HERMES_HOME/vault" ]; then
        find "$HERMES_HOME/vault" -type f \
            ! -path '*/raw/*' \
            >> "$TMP_LIST" 2>/dev/null || true
        $VERBOSE && say "✅ vault/"
    fi
fi

# ── Summary ───────────────────────────────────────────────────────────
FILE_COUNT=$(wc -l < "$TMP_LIST")
SIZE_EST=$(du -sch $(cat "$TMP_LIST") 2>/dev/null | tail -1 | awk '{print $1}')

echo ""
echo "   📦 Files: $FILE_COUNT"
echo "   💾 Est. size: ${SIZE_EST:-unknown}"
echo ""

if $DRY_RUN; then
    echo "🏁 Dry run — no archive created."
    if $VERBOSE; then
        echo ""
        echo "── File list ────────────────────────"
        cat "$TMP_LIST"
    fi
    rm "$TMP_LIST"
    exit 0
fi

# ── Create Archive ────────────────────────────────────────────────────
echo "   Compressing..."

# Convert absolute paths to paths relative to HERMES_HOME for portable archives
REL_LIST=$(mktemp)
sed "s|^$HERMES_HOME/||" "$TMP_LIST" > "$REL_LIST"
rm "$TMP_LIST"

tar czf "${BACKUP_FILE%.gpg}" -C "$HERMES_HOME" -T "$REL_LIST" 2>/dev/null
rm "$REL_LIST"

ARCHIVE_SIZE=$(du -sh "${BACKUP_FILE%.gpg}" | awk '{print $1}')

echo ""
echo "═══════════════════════════════════════"
echo "✅ Backup created"
echo ""
echo "   📁 ${BACKUP_FILE%.gpg}"
echo "   💾 Size: $ARCHIVE_SIZE"
echo ""
echo "   To encrypt (recommended):"
echo "   gpg -c ${BACKUP_FILE%.gpg}"
echo ""
echo "   To restore:"
echo "   ./restore.sh ${BACKUP_FILE%.gpg}"
echo "═══════════════════════════════════════"
