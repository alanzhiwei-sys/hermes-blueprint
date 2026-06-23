#!/bin/bash
# Hermes Blueprint — Template Variable Substitution
# Reads CUSTOMER_DOMAIN.md from a profile template directory,
# substitutes {{VARIABLES}} in all .md and .yaml files.
#
# Usage:
#   ./config-apply-template.sh --profile-dir templates/profiles/zeus-project-manager
#   ./config-apply-template.sh --profile-dir templates/profiles/hera-business-ops

set -euo pipefail

PROFILE_DIR=""
DRY_RUN=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        --profile-dir) PROFILE_DIR="$2"; shift 2 ;;
        --dry-run)     DRY_RUN=true; shift ;;
        -h|--help)
            echo "Usage: $0 --profile-dir PATH [--dry-run]"
            echo "Substitutes {{CUSTOMER_*}} variables from CUSTOMER_DOMAIN.md into all profile files"
            exit 0
            ;;
        *) echo "Unknown: $1"; exit 1 ;;
    esac
done

if [ -z "$PROFILE_DIR" ]; then
    echo "❌ --profile-dir is required"
    exit 1
fi

DOMAIN_FILE="$PROFILE_DIR/CUSTOMER_DOMAIN.md"
if [ ! -f "$DOMAIN_FILE" ]; then
    echo "❌ CUSTOMER_DOMAIN.md not found in $PROFILE_DIR"
    echo "   This profile may not be adaptable — only zeus-project-manager and hera-business-ops support this."
    exit 1
fi

echo "🔄 Hermes Blueprint — Template Config Apply"
echo "=============================================="
echo "Profile: $(basename "$PROFILE_DIR")"
echo ""

# Source the domain file to load variables
# (CUSTOMER_DOMAIN.md uses KEY="VALUE" format compatible with bash sourcing)
set -a
# shellcheck disable=SC1090
source "$DOMAIN_FILE"
set +a

# Check if variables are still at defaults
UNSET_COUNT=0
for var in CUSTOMER_NAME CUSTOMER_COMPANY CUSTOMER_INDUSTRY CUSTOMER_INDUSTRY_SLUG CUSTOMER_MARKET; do
    val="${!var:-}"
    if [ -z "$val" ] || [[ "$val" == YOUR_* ]]; then
        echo "  ⚠️  $var is not set (or still at YOUR_* default)"
        UNSET_COUNT=$((UNSET_COUNT + 1))
    else
        echo "  ✅ $var = $val"
    fi
done

if [ "$UNSET_COUNT" -gt 0 ]; then
    echo ""
    echo "⚠️  $UNSET_COUNT variable(s) still at default values."
    echo "   Edit $DOMAIN_FILE and re-run."
    if ! $DRY_RUN; then
        echo "   Proceeding anyway — {{VARIABLES}} will remain as-is in output."
    fi
fi

echo ""

# Find all .md and .yaml files in profile dir
FILES=$(find "$PROFILE_DIR" -maxdepth 1 \( -name "*.md" -o -name "*.yaml" \) ! -name "CUSTOMER_DOMAIN.md" | sort)
FILE_COUNT=$(echo "$FILES" | grep -c . || echo 0)

if [ "$FILE_COUNT" -eq 0 ]; then
    echo "❌ No .md/.yaml files found to substitute."
    exit 1
fi

# Perform substitution using Python (handles &, spaces, special chars correctly)
python3 - "$FILES" "$DOMAIN_FILE" "$DRY_RUN" << 'PYEOF'
import sys, os, re

files = sys.argv[1].strip().split('\n') if sys.argv[1].strip() else []
domain_file = sys.argv[2]
dry_run = sys.argv[3] == 'true'

# Parse CUSTOMER_DOMAIN.md
vars = {}
with open(domain_file) as f:
    for line in f:
        line = line.strip()
        if not line or line.startswith('#'):
            continue
        m = re.match(r'^(\w+)="(.*)"$', line)
        if m:
            vars[m.group(1)] = m.group(2)

updated = 0
for filepath in files:
    filepath = filepath.strip()
    if not filepath:
        continue
    fname = os.path.basename(filepath)
    
    with open(filepath) as f:
        content = f.read()
    
    original = content
    for var, val in vars.items():
        placeholder = '{{' + var + '}}'
        content = content.replace(placeholder, val)
    
    if content != original:
        if dry_run:
            print(f"  🔍 Would update: {fname}")
        else:
            with open(filepath, 'w') as f:
                f.write(content)
            print(f"  ✅ Updated: {fname}")
        updated += 1
    else:
        print(f"  ⏭️  No changes: {fname}")

# Check for unresolved placeholders
unresolved = 0
for filepath in files:
    filepath = filepath.strip()
    if not filepath:
        continue
    with open(filepath) as f:
        for i, line in enumerate(f, 1):
            for m in re.finditer(r'\{\{\w+\}\}', line):
                if not dry_run:
                    print(f"  ⚠️  Unresolved: {os.path.basename(filepath)}:{i}: {m.group()}", file=sys.stderr)
                unresolved += 1

if unresolved > 0 and not dry_run:
    print(f"  ⚠️  {unresolved} unresolved placeholder(s) remaining", file=sys.stderr)
elif updated > 0 and not dry_run:
    print(f"  ✅ All {updated} file(s) updated with no remaining placeholders")

PYEOF

echo ""
echo "=============================================="
if $DRY_RUN; then
    echo "🔍 DRY RUN — no files modified"
else
    echo "✅ Template variables applied"
fi
echo ""
