#!/bin/bash
# Hermes Blueprint — Memory Policy Apply Script
# Installs Mnemosyne ignore_patterns and memory governance for customer.
#
# Usage:
#   ./memory-policy-apply.sh [--dry-run]

set -euo pipefail

DRY_RUN=false
CONFIG_FILE="$HOME/.hermes/config.yaml"

while [[ $# -gt 0 ]]; do
    case "$1" in
        --dry-run) DRY_RUN=true; shift ;;
        --config)  CONFIG_FILE="$2"; shift 2 ;;
        -h|--help)
            echo "Usage: $0 [--dry-run] [--config PATH]"
            echo "Applies Hermes Blueprint memory policy to config.yaml"
            exit 0
            ;;
        *) echo "Unknown: $1"; exit 1 ;;
    esac
done

if [ ! -f "$CONFIG_FILE" ]; then
    echo "❌ Config file not found: $CONFIG_FILE"
    echo "   Run Hermes setup first."
    exit 1
fi

echo "🧠 Hermes Blueprint — Memory Policy"
echo "======================================"
echo "Config: $CONFIG_FILE"
echo ""

# Check if memory.mnemosyne block exists
if ! python3 -c "
import yaml, sys
cfg = yaml.safe_load(open('$CONFIG_FILE'))
mem = cfg.get('memory', {}).get('mnemosyne')
if mem is None:
    print('MISSING')
    sys.exit(1)
print('EXISTS')
" 2>/dev/null; then
    echo "⚠️  memory.mnemosyne block not found in config."
    echo "   Creating it now..."
fi

# Define the memory policy patterns
POLICY='
ignore_patterns:
  - '"'"'^\[?1 image\]? '"'"'
  - '"'"'Classify this renovation photo'"'"'
  - '"'"'sorting renovation project media into folders'"'"'
  - '"'"'Return ONLY a JSON object'"'"'
  - '"'"'JSON-only: Score this benchmark output'"'"'
  - '"'"'^Reply (exactly|with exactly):? (OK|ok)$'"'"'
  - '"'"'^respond with just the word OK$'"'"'
  - '"'"'^ASYNC DELEGATION BATCH COMPLETE'"'"'
  - '"'"'background fan-out of [0-9]+ subagent'"'"'
  - '"'"'^Progress Report$'"'"'
  - '"'"'^Progress — [0-9]+ of [0-9]+ batches complete$'"'"'
  - '"'"'skill buildout complete'"'"'
'

if $DRY_RUN; then
    echo "🔍 DRY RUN — would apply these patterns:"
    echo "$POLICY"
    echo ""
    echo "Run without --dry-run to apply."
    exit 0
fi

# Apply using hermes config set for each pattern as a JSON list
python3 - <<PY
import json, subprocess, sys

patterns = [
    r'^\\[?1 image\\]? ',
    r'Classify this renovation photo',
    r'sorting renovation project media into folders',
    r'Return ONLY a JSON object',
    r'JSON-only: Score this benchmark output',
    r'^Reply (exactly|with exactly):? (OK|ok)\$',
    r'^respond with just the word OK\$',
    r'^ASYNC DELEGATION BATCH COMPLETE',
    r'background fan-out of [0-9]+ subagent',
    r'^Progress Report\$',
    r'^Progress — [0-9]+ of [0-9]+ batches complete\$',
    r'skill buildout complete',
]

value = json.dumps(patterns)
cmd = ['hermes', 'config', 'set', 'memory.mnemosyne.ignore_patterns', value]
print(f'Running: hermes config set memory.mnemosyne.ignore_patterns ...')
res = subprocess.run(cmd, capture_output=True, text=True, timeout=30)

if res.returncode != 0:
    print(f'❌ Failed: {res.stderr}')
    sys.exit(1)

print(f'✅ {res.stdout.strip()}')
PY

echo ""
echo "✅ Memory policy applied."
echo ""
echo "📋 Verify with:"
echo "   python3 -c \"import yaml; print(yaml.safe_load(open('$CONFIG_FILE'))['memory']['mnemosyne']['ignore_patterns'])\""
echo "   mnemosyne_stats"
