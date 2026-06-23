#!/bin/bash
# Hermes Blueprint — System Health Check
# Customer-facing health scorecard. Outputs a 0-100 composite score.
#
# Usage:
#   ./system-health.sh
#   ./system-health.sh --json    # machine-readable output

set -euo pipefail

JSON_OUTPUT=false
HERMES_HOME="${HERMES_HOME:-$HOME/.hermes}"

while [[ $# -gt 0 ]]; do
    case "$1" in
        --json) JSON_OUTPUT=true; shift ;;
        --hermes-home) HERMES_HOME="$2"; shift 2 ;;
        -h|--help)
            echo "Usage: $0 [--json] [--hermes-home PATH]"
            echo "Customer-facing Hermes system health check"
            exit 0
            ;;
        *) shift ;;
    esac
done

# ── Collect Metrics ──────────────────────────────────────────────────

# 1. Hermes installed
if command -v hermes &>/dev/null; then
    HERMES_INSTALLED=true
    HERMES_VERSION=$(hermes --version 2>/dev/null | head -1 || echo "unknown")
else
    HERMES_INSTALLED=false
    HERMES_VERSION="not installed"
fi

# 2. Config valid
CONFIG_FILE="$HERMES_HOME/config.yaml"
if [ -f "$CONFIG_FILE" ]; then
    if python3 -c "import yaml; yaml.safe_load(open('$CONFIG_FILE'))" 2>/dev/null; then
        CONFIG_VALID=true
        CONFIG_VERSION=$(python3 -c "import yaml; print(yaml.safe_load(open('$CONFIG_FILE')).get('config_version','unknown'))" 2>/dev/null || echo "?")
    else
        CONFIG_VALID=false
        CONFIG_VERSION="invalid YAML"
    fi
else
    CONFIG_VALID=false
    CONFIG_VERSION="missing"
fi

# 3. Profiles count
if [ -d "$HERMES_HOME/profiles" ]; then
    PROFILE_COUNT=$(find "$HERMES_HOME/profiles" -maxdepth 2 -name "SOUL.md" | wc -l)
else
    PROFILE_COUNT=0
fi

# 4. Mnemosyne health
MNEMOSYNE_PATH="$HERMES_HOME/mnemosyne/data/mnemosyne.db"
if [ -f "$MNEMOSYNE_PATH" ]; then
    MNEMOSYNE_EXISTS=true
    MNEMOSYNE_SIZE=$(du -sh "$MNEMOSYNE_PATH" 2>/dev/null | cut -f1 || echo "?")
    MNEMOSYNE_STATS=$(python3 -c "
import sqlite3, os
try:
    db=sqlite3.connect('file:$MNEMOSYNE_PATH?mode=ro', uri=True)
    wc=db.execute('SELECT COUNT(*) FROM working_memory').fetchone()[0]
    ec=db.execute('SELECT COUNT(*) FROM episodic_memory').fetchone()[0]
    print(f'{wc}|{ec}')
except: print('?|?')
" 2>/dev/null || echo "?|?")
    WORKING_COUNT=$(echo "$MNEMOSYNE_STATS" | cut -d'|' -f1)
    EPISODIC_COUNT=$(echo "$MNEMOSYNE_STATS" | cut -d'|' -f2)
else
    MNEMOSYNE_EXISTS=false
    MNEMOSYNE_SIZE="N/A"
    WORKING_COUNT="?"
    EPISODIC_COUNT="?"
fi

# 5. Backup freshness
BACKUP_DIR="$HERMES_HOME/backups"
if [ -d "$BACKUP_DIR" ]; then
    NOW=$(date +%s)
    LAST_BACKUP=$(stat -c '%Y' "$BACKUP_DIR" 2>/dev/null || echo 0)
    BACKUP_AGE_HOURS=$(( (NOW - LAST_BACKUP) / 3600 ))
else
    BACKUP_AGE_HOURS=999
fi

# 6. Disk usage
DISK_PCT=$(df -h "$HERMES_HOME" --output=pcent 2>/dev/null | tail -1 | tr -d ' %' || echo "?")
DISK_FREE=$(df -h "$HERMES_HOME" --output=avail 2>/dev/null | tail -1 | xargs || echo "?")

# 7. Memory
MEM_PCT=$(free | awk 'NR==2{printf "%.0f", $3/$2*100}' 2>/dev/null || echo "?")
MEM_USED=$(free -h | awk 'NR==2{print $3}' 2>/dev/null || echo "?")
MEM_TOTAL=$(free -h | awk 'NR==2{print $2}' 2>/dev/null || echo "?")

# 8. Uptime
UPTIME_STR=$(uptime -p 2>/dev/null | sed 's/up //' || echo "?")

# ── Scoring ──────────────────────────────────────────────────────────

score_hermes() {
    if $HERMES_INSTALLED && $CONFIG_VALID; then echo 100; else echo 0; fi
}

score_profiles() {
    if [ "$PROFILE_COUNT" -ge 8 ]; then echo 100
    elif [ "$PROFILE_COUNT" -ge 4 ]; then echo 70
    elif [ "$PROFILE_COUNT" -ge 1 ]; then echo 40
    else echo 0; fi
}

score_mnemosyne() {
    if $MNEMOSYNE_EXISTS && [ "$WORKING_COUNT" != "?" ] && [ "$WORKING_COUNT" -gt 0 ]; then echo 100
    elif $MNEMOSYNE_EXISTS; then echo 50
    else echo 0; fi
}

score_backup() {
    if [ "$BACKUP_AGE_HOURS" -lt 24 ]; then echo 100
    elif [ "$BACKUP_AGE_HOURS" -lt 72 ]; then echo 60
    elif [ "$BACKUP_AGE_HOURS" -lt 168 ]; then echo 30
    else echo 0; fi
}

score_disk() {
    if [ "$DISK_PCT" = "?" ]; then echo 50
    elif [ "$DISK_PCT" -le 70 ]; then echo 100
    elif [ "$DISK_PCT" -le 85 ]; then echo 60
    elif [ "$DISK_PCT" -le 95 ]; then echo 20
    else echo 0; fi
}

score_memory() {
    if [ "$MEM_PCT" = "?" ]; then echo 50
    elif [ "$MEM_PCT" -le 60 ]; then echo 100
    elif [ "$MEM_PCT" -le 85 ]; then echo 60
    else echo 20; fi
}

S1=$(score_hermes)
S2=$(score_profiles)
S3=$(score_mnemosyne)
S4=$(score_backup)
S5=$(score_disk)
S6=$(score_memory)

# Weights: Hermes(25) Profiles(15) Mnemosyne(20) Backup(15) Disk(15) Memory(10)
COMPOSITE=$(python3 -c "print(int($S1*0.25 + $S2*0.15 + $S3*0.20 + $S4*0.15 + $S5*0.15 + $S6*0.10))")

# ── Output ───────────────────────────────────────────────────────────

if $JSON_OUTPUT; then
    python3 -c "
import json
print(json.dumps({
    'composite_score': $COMPOSITE,
    'subsystems': {
        'hermes_installed': {'score': $S1, 'detail': '$HERMES_VERSION'},
        'profiles': {'score': $S2, 'detail': '$PROFILE_COUNT profiles'},
        'mnemosyne': {'score': $S3, 'detail': '${WORKING_COUNT}W/${EPISODIC_COUNT}E, $MNEMOSYNE_SIZE'},
        'backup': {'score': $S4, 'detail': '${BACKUP_AGE_HOURS}h ago'},
        'disk': {'score': $S5, 'detail': '${DISK_PCT}% used, ${DISK_FREE} free'},
        'memory': {'score': $S6, 'detail': '${MEM_USED}/${MEM_TOTAL} (${MEM_PCT}%)'}
    },
    'uptime': '$UPTIME_STR',
    'hermes_home': '$HERMES_HOME'
}, indent=2))
"
else

# Determine verdict
if [ "$COMPOSITE" -ge 90 ]; then
    VERDICT="✅ Excellent"
elif [ "$COMPOSITE" -ge 75 ]; then
    VERDICT="🟡 Good"
elif [ "$COMPOSITE" -ge 50 ]; then
    VERDICT="🟠 Needs attention"
else
    VERDICT="🔴 Setup incomplete"
fi

cat <<REPORT

═══════════════════════════════════════
  🏠 YOUR HERMES STATUS
═══════════════════════════════════════

 Overall Health: $VERDICT ($COMPOSITE/100)

 ── Core ────────────────────────────
 $(if $HERMES_INSTALLED; then echo "✅"; else echo "❌"; fi) Hermes installed      $HERMES_VERSION
 $(if $CONFIG_VALID; then echo "✅"; else echo "❌"; fi) Config valid          v$CONFIG_VERSION

 ── Profiles ─────────────────────────
 $(if [ "$PROFILE_COUNT" -ge 8 ]; then echo "✅"; elif [ "$PROFILE_COUNT" -ge 1 ]; then echo "⚠️"; else echo "❌"; fi) $PROFILE_COUNT profiles active

 ── Memory ──────────────────────────
 $(if $MNEMOSYNE_EXISTS && [ "$WORKING_COUNT" != "?" ] && [ "$WORKING_COUNT" -gt 0 ]; then echo "✅"; else echo "⚠️"; fi) Mnemosyne            ${WORKING_COUNT} working / ${EPISODIC_COUNT} episodic

 ── Safety ──────────────────────────
 $(if [ "$BACKUP_AGE_HOURS" -lt 24 ]; then echo "✅"; elif [ "$BACKUP_AGE_HOURS" -lt 72 ]; then echo "⚠️"; else echo "❌"; fi) Backup               ${BACKUP_AGE_HOURS}h old

 ── System ──────────────────────────
 $(if [ "$DISK_PCT" != "?" ] && [ "$DISK_PCT" -le 85 ]; then echo "✅"; else echo "⚠️"; fi) Disk                 ${DISK_PCT}% used, ${DISK_FREE} free
 $(if [ "$MEM_PCT" != "?" ] && [ "$MEM_PCT" -le 85 ]; then echo "✅"; else echo "⚠️"; fi) Memory               ${MEM_USED}/${MEM_TOTAL} (${MEM_PCT}%)
 ⏱️  Uptime               $UPTIME_STR

═══════════════════════════════════════

REPORT

# Quick actions
if [ "$COMPOSITE" -lt 75 ]; then
    echo "📋 Recommended actions:"
    echo ""
    if ! $HERMES_INSTALLED; then
        echo "   → Install Hermes: curl -sSL https://get.hermesagent.com | bash"
    fi
    if ! $CONFIG_VALID; then
        echo "   → Fix config: hermes config check"
    fi
    if [ "$PROFILE_COUNT" -eq 0 ]; then
        echo "   → Scaffold profiles: ./profile-scaffold.sh --pick"
    fi
    if ! $MNEMOSYNE_EXISTS; then
        echo "   → Setup Mnemosyne: hermes memory setup"
    fi
    if [ "$BACKUP_AGE_HOURS" -ge 72 ]; then
        echo "   → Create backup: ./backup.sh"
    fi
    echo ""
fi

fi
