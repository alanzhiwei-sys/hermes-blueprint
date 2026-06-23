#!/bin/bash
# Hermes Blueprint — Restore Script
# Restores a backup created by backup.sh into HERMES_HOME.
#
# Usage:
#   ./restore.sh <backup-file.tar.gz>
#   ./restore.sh <backup-file.tar.gz> --dry-run
#   ./restore.sh <backup-file.tar.gz> --profiles-only
#
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HERMES_HOME="${HERMES_HOME:-$HOME/.hermes}"
DRY_RUN=false
PROFILES_ONLY=false
FORCE=false

# ── Usage ─────────────────────────────────────────────────────────────
usage() {
    cat <<EOF
🔄  Hermes Blueprint — Restore

Usage: ./restore.sh <backup-file.tar.gz> [options]

Options:
  --dry-run          List what would be restored without extracting
  --profiles-only    Only restore profiles, skip global config
  --force            Overwrite existing files without confirmation
  --output DIR       Restore to custom directory (default: \$HERMES_HOME)
  -h, --help         Show this help

Examples:
  ./restore.sh ~/.hermes/backups/hermes-backup-20260623-120000.tar.gz
  ./restore.sh backup.tar.gz --dry-run
  ./restore.sh backup.tar.gz --profiles-only --output /tmp/test-restore
EOF
    exit 0
}

# ── Parse Args ────────────────────────────────────────────────────────
RESTORE_DIR="$HERMES_HOME"

while [[ $# -gt 0 ]]; do
    case "$1" in
        --dry-run)       DRY_RUN=true; shift ;;
        --profiles-only) PROFILES_ONLY=true; shift ;;
        --force)         FORCE=true; shift ;;
        --output)        RESTORE_DIR="$2"; shift 2 ;;
        -h|--help)       usage ;;
        -*) echo "Unknown option: $1"; usage ;;
        *) BACKUP_FILE="$1"; shift ;;
    esac
done

# ── Validation ────────────────────────────────────────────────────────
if [ -z "${BACKUP_FILE:-}" ]; then
    echo "❌ No backup file specified."
    usage
fi

if [ ! -f "$BACKUP_FILE" ]; then
    echo "❌ Backup file not found: $BACKUP_FILE"
    exit 1
fi

# Handle .gpg encrypted backups
if [[ "$BACKUP_FILE" == *.gpg ]]; then
    echo "🔐 Encrypted backup detected — decrypting..."
    DECRYPTED="${BACKUP_FILE%.gpg}"
    gpg -d "$BACKUP_FILE" > "$DECRYPTED" 2>/dev/null || {
        echo "❌ Decryption failed. Wrong passphrase or corrupted file."
        exit 1
    }
    BACKUP_FILE="$DECRYPTED"
fi

# ── Info ──────────────────────────────────────────────────────────────
echo ""
echo "🔄  Hermes Blueprint — Restore"
echo "═══════════════════════════════════════"
echo "   Backup:  $(basename "$BACKUP_FILE")"
echo "   Target:  $RESTORE_DIR"
echo "   Size:    $(du -sh "$BACKUP_FILE" | awk '{print $1}')"
echo ""

# ── Dry Run ───────────────────────────────────────────────────────────
if $DRY_RUN; then
    echo "🏁 Dry run — contents:"
    echo ""
    tar tzf "$BACKUP_FILE" 2>/dev/null | head -50
    TOTAL=$(tar tzf "$BACKUP_FILE" 2>/dev/null | wc -l)
    if [ "$TOTAL" -gt 50 ]; then
        echo "   ... and $((TOTAL - 50)) more files"
    fi
    echo ""
    echo "   Total files: $TOTAL"
    exit 0
fi

# ── Safety check ──────────────────────────────────────────────────────
if [ -d "$RESTORE_DIR" ] && [ "$(ls -A "$RESTORE_DIR" 2>/dev/null)" ] && ! $FORCE; then
    echo "⚠️  Target directory is not empty: $RESTORE_DIR"
    echo ""
    echo "   Restoring will overwrite existing files."
    echo "   Use --force to skip this prompt, or --output for a different directory."
    echo ""
    read -rp "   Continue? [y/N] " confirm
    if [ "$confirm" != "y" ] && [ "$confirm" != "Y" ]; then
        echo "   Cancelled."
        exit 0
    fi
fi

# ── Restore ───────────────────────────────────────────────────────────
echo "   Extracting..."

mkdir -p "$RESTORE_DIR"
tar xzf "$BACKUP_FILE" -C "$RESTORE_DIR" 2>/dev/null

FILE_COUNT=$(tar tzf "$BACKUP_FILE" 2>/dev/null | wc -l)

echo ""
echo "═══════════════════════════════════════"
echo "✅ Restore complete"
echo ""
echo "   📁 Destination: $RESTORE_DIR"
echo "   📦 Files restored: $FILE_COUNT"
echo ""
echo "   Next steps:"
echo "   1. Verify config: hermes config check"
echo "   2. Check profiles: hermes profile list"
echo "   3. Run: ./system-health.sh"
echo "═══════════════════════════════════════"
