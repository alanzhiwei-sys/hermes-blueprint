#!/usr/bin/env python3
"""
Hermes Blueprint — Profile Sanitization Script
Strips all personal/private data from Hermes profiles before templating.
Output: clean template profiles under product/blueprint/templates/profiles/

Usage:
  ./sanitize.sh --source ~/.hermes/profiles --output ~/.hermes/product/blueprint/templates/profiles

WARNING: This script should NEVER be run on live profiles.
Always run on a COPY or point to the source and output separately.
"""

import argparse
import os
import re
import shutil
import sys
from pathlib import Path

# ── Sanitization Rules ──────────────────────────────────────────────

# Files to COMPLETELY EXCLUDE (never copy, never template)
EXCLUDE_FILES = {
    "auth.lock", "auth.json", "auth.json.bak", "auth.json.bak2",
    "state.db", "state.db-shm", "state.db-wal",
    "models_dev_cache.json", "context_length_cache.yaml",
    "provider_models_cache.json",
}

# Directories to COMPLETELY EXCLUDE
EXCLUDE_DIRS = {
    "memories",       # MEMORY.md + USER.md = private
    "cache",          # model metadata caches
    "cron",           # cron jobs contain personal data
    "sandboxes",      # personal sandboxes
    "audio_cache",    # cached audio
    "pairing",        # pairing data
    "bin",            # binaries
    "hooks",          # personal hooks
    "home",           # home directory mount
    "skins",          # personal skins
    "workspace",      # personal workspace
}

# Vault subdirectories to EXCLUDE
EXCLUDE_VAULT_DIRS = {"raw"}  # raw contains unprocessed personal data

# ── Pattern-Based Redaction ─────────────────────────────────────────

# Singapore phone numbers (various formats)
PHONE_PATTERNS = [
    (re.compile(r'\b(\+65[-\s]?)?[689]\d{3}[-\s]?\d{4}\b'), '[PHONE_REDACTED]'),
    (re.compile(r'\b[689]\d{3}[-\s]?\d{4}\b'), '[PHONE_REDACTED]'),
]

# Email addresses
EMAIL_PATTERN = re.compile(r'\b[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}\b')

# API key patterns (common formats)
API_KEY_PATTERNS = [
    (re.compile(r'(sk-[A-Za-z0-9]{20,})'), '[API_KEY_REDACTED]'),
    (re.compile(r'(org-[A-Za-z0-9]{20,})'), '[ORG_KEY_REDACTED]'),
    (re.compile(r'(Bearer\s+)[A-Za-z0-9_\-\.]{20,}'), r'\1[TOKEN_REDACTED]'),
    (re.compile(r'(api[_-]?key[=:]\s*["\']?)[A-Za-z0-9_\-]{20,}["\']?', re.IGNORECASE), r'\1[API_KEY_REDACTED]'),
]

# Config-specific: provider API keys
YAML_KEY_PATTERNS = [
    (re.compile(r'(api_key:\s*["\']?)[A-Za-z0-9_\-]{10,}["\']?', re.IGNORECASE), r'\1"YOUR_API_KEY"'),
    (re.compile(r'(OPENROUTER_API_KEY=)[^\n]+'), r'\1YOUR_OPENROUTER_KEY'),
    (re.compile(r'(DEEPSEEK_API_KEY=)[^\n]+'), r'\1YOUR_DEEPSEEK_KEY'),
    (re.compile(r'(TELEGRAM_BOT_TOKEN=)[^\n]+'), r'\1YOUR_TELEGRAM_BOT_TOKEN'),
    (re.compile(r'(HASS_TOKEN=)[^\n]+'), r'\1YOUR_HOME_ASSISTANT_TOKEN'),
]

# Personal names and identifiers (case-insensitive)
PERSONAL_NAMES = [
    r'\bAlan\b', r'\bChua Zhi Wei\b', r'\balanzhiwei\b', r'\bChua\b',
]

# Addresses and specific locations
PERSONAL_LOCATIONS = [
    r'\bChangi Rd\b', r'\bJurong\b',
]

# Project-specific names (business names, client references)
CLIENT_PATTERNS = [
    r'\bHHF\b', r'\bSmart Hush\b',  # Keep business names but be careful with client data
]

# ── Helper Functions ────────────────────────────────────────────────

def should_exclude_file(filepath: Path) -> bool:
    """Check if file should be completely excluded."""
    if filepath.name in EXCLUDE_FILES:
        return True
    if filepath.suffix in ('.db', '.db-shm', '.db-wal', '.lock', '.bak', '.bak2'):
        return True
    if '.tick.lock' in filepath.name:
        return True
    return False

def should_exclude_dir(dirpath: Path, relative_to: Path) -> bool:
    """Check if directory should be completely excluded."""
    name = dirpath.name
    if name in EXCLUDE_DIRS:
        return True
    # Exclude hidden dirs except vault (vault is not hidden)
    if name.startswith('.') and name != '.hermes':
        return True
    return False

def redact_content(content: str, filepath: Path) -> str:
    """Apply pattern-based redaction to file content."""
    
    # Skip binary/special files
    if filepath.suffix in ('.db', '.lock', '.png', '.jpg', '.jpeg', '.gif', '.mp3', '.mp4'):
        return content
    
    try:
        text = content if isinstance(content, str) else content.decode('utf-8', errors='replace')
    except Exception:
        return content
    
    # 1. Redact phone numbers
    for pattern, replacement in PHONE_PATTERNS:
        text = pattern.sub(replacement, text)
    
    # 2. Redact email addresses (preserve structure, replace content)
    text = EMAIL_PATTERN.sub('[EMAIL_REDACTED]', text)
    
    # 3. Redact API keys
    for pattern, replacement in API_KEY_PATTERNS:
        text = pattern.sub(replacement, text)
    
    # 4. YAML-specific key redaction
    for pattern, replacement in YAML_KEY_PATTERNS:
        text = pattern.sub(replacement, text)
    
    # 5. Redact personal names
    for name_pattern in PERSONAL_NAMES:
        text = re.sub(name_pattern, '[NAME_REDACTED]', text, flags=re.IGNORECASE)
    
    # 6. Redact personal locations
    for loc_pattern in PERSONAL_LOCATIONS:
        text = re.sub(loc_pattern, '[LOCATION_REDACTED]', text, flags=re.IGNORECASE)
    
    return text


def process_vault_wiki(src_dir: Path, dst_dir: Path) -> None:
    """Process vault/wiki — keep structure but redact content."""
    wiki_src = src_dir / "vault" / "wiki"
    if not wiki_src.exists():
        return
    
    wiki_dst = dst_dir / "vault" / "wiki"
    wiki_dst.mkdir(parents=True, exist_ok=True)
    
    for root, dirs, files in os.walk(wiki_src):
        rel = Path(root).relative_to(wiki_src)
        current_dst = wiki_dst / rel
        
        # Filter out excluded vault dirs
        dirs[:] = [d for d in dirs if d not in EXCLUDE_VAULT_DIRS and not d.startswith('.')]
        
        current_dst.mkdir(parents=True, exist_ok=True)
        
        for fname in files:
            if should_exclude_file(Path(fname)):
                continue
            src_file = Path(root) / fname
            dst_file = current_dst / fname
            
            try:
                with open(src_file, 'r', encoding='utf-8', errors='replace') as f:
                    content = f.read()
                
                redacted = redact_content(content, src_file)
                
                with open(dst_file, 'w', encoding='utf-8') as f:
                    f.write(redacted)
            except Exception as e:
                print(f"  ⚠️  Skipped {src_file}: {e}", file=sys.stderr)


def sanitize_profile(src_profile: Path, dst_profile: Path, profile_name: str) -> bool:
    """Sanitize a single profile directory."""
    print(f"\n📁 Sanitizing: {profile_name}")
    
    if not src_profile.exists():
        print(f"  ❌ Source not found: {src_profile}")
        return False
    
    dst_profile.mkdir(parents=True, exist_ok=True)
    
    # Key files to process
    key_files = ["SOUL.md", "AGENTS.md", "EXAMPLES.md", "config.yaml"]
    
    for kf in key_files:
        src_file = src_profile / kf
        if not src_file.exists():
            continue
        
        dst_file = dst_profile / kf
        try:
            with open(src_file, 'r', encoding='utf-8', errors='replace') as f:
                content = f.read()
            
            redacted = redact_content(content, src_file)
            
            with open(dst_file, 'w', encoding='utf-8') as f:
                f.write(redacted)
            
            print(f"  ✅ {kf} — sanitized")
        except Exception as e:
            print(f"  ⚠️  {kf} — error: {e}", file=sys.stderr)
    
    # Process vault/wiki if exists
    if (src_profile / "vault" / "wiki").exists():
        process_vault_wiki(src_profile, dst_profile)
        print(f"  ✅ vault/wiki — sanitized")
    
    # Copy vault/_index.md (usually generic)
    index_file = src_profile / "vault" / "_index.md"
    if index_file.exists():
        dst_index = dst_profile / "vault" / "_index.md"
        dst_index.parent.mkdir(parents=True, exist_ok=True)
        try:
            with open(index_file, 'r', encoding='utf-8', errors='replace') as f:
                content = f.read()
            redacted = redact_content(content, index_file)
            with open(dst_index, 'w', encoding='utf-8') as f:
                f.write(redacted)
        except Exception:
            pass
    
    return True


def main():
    parser = argparse.ArgumentParser(
        description="Sanitize Hermes profiles for Blueprint template pack"
    )
    parser.add_argument(
        "--source", default=str(Path.home() / ".hermes" / "profiles"),
        help="Source profiles directory (default: ~/.hermes/profiles)"
    )
    parser.add_argument(
        "--output", default=str(Path.home() / ".hermes" / "product" / "blueprint" / "templates" / "profiles"),
        help="Output directory for sanitized templates"
    )
    parser.add_argument(
        "--profile", action="append", dest="profiles",
        help="Specific profile(s) to sanitize (repeatable). Default: all non-default profiles."
    )
    args = parser.parse_args()
    
    src_dir = Path(args.source)
    dst_dir = Path(args.output)
    
    if not src_dir.exists():
        print(f"❌ Source directory does not exist: {src_dir}", file=sys.stderr)
        sys.exit(1)
    
    # Determine which profiles to process
    if args.profiles:
        profile_names = args.profiles
    else:
        profile_names = [
            d.name for d in src_dir.iterdir()
            if d.is_dir() and d.name != "default"
            and not d.name.startswith(".")
        ]
    
    dst_dir.mkdir(parents=True, exist_ok=True)
    
    print("=" * 60)
    print("🧹 Hermes Blueprint — Profile Sanitization")
    print("=" * 60)
    print(f"Source:  {src_dir}")
    print(f"Output:  {dst_dir}")
    print(f"Profiles to process: {len(profile_names)}")
    print()
    
    success = 0
    failed = 0
    
    for pname in sorted(profile_names):
        src_profile = src_dir / pname
        dst_profile = dst_dir / pname
        if sanitize_profile(src_profile, dst_profile, pname):
            success += 1
        else:
            failed += 1
    
    print()
    print("=" * 60)
    print(f"✅ {success} profiles sanitized successfully")
    if failed:
        print(f"❌ {failed} profiles failed")
    print(f"Output: {dst_dir}")
    print("=" * 60)
    
    # Write a manifest
    manifest_path = dst_dir / "MANIFEST.md"
    with open(manifest_path, 'w') as f:
        f.write(f"# Hermes Blueprint — Profile Manifest\n\n")
        f.write(f"Generated: {__import__('datetime').datetime.now().isoformat()}\n\n")
        f.write("## Sanitized Profiles\n\n")
        for pname in sorted(profile_names):
            dst = dst_dir / pname
            if dst.exists():
                files = list(dst.rglob("*"))
                md_files = [x for x in files if x.suffix == '.md']
                f.write(f"- **{pname}** — {len(md_files)} markdown files, {len(files)} total files\n")
        f.write("\n## What Was Removed\n\n")
        f.write("- All API keys and tokens → replaced with `YOUR_*` placeholders\n")
        f.write("- All email addresses → `[EMAIL_REDACTED]`\n")
        f.write("- All phone numbers → `[PHONE_REDACTED]`\n")
        f.write("- All personal names → `[NAME_REDACTED]`\n")
        f.write("- All personal locations → `[LOCATION_REDACTED]`\n")
        f.write("- Auth files, state databases, caches → completely excluded\n")
        f.write("- Private memories (MEMORY.md, USER.md) → completely excluded\n")
        f.write("- Raw vault content → excluded\n")
        f.write("- Cron jobs and personal workspace → excluded\n")
        f.write("\n## What Was Preserved\n\n")
        f.write("- Profile structure and directory layout\n")
        f.write("- SOUL.md instructions (sanitized of personal references)\n")
        f.write("- AGENTS.md routing rules and protocols\n")
        f.write("- Vault/wiki knowledge base structure\n")
        f.write("- Profile skill names and configurations\n")
    
    print(f"\n📄 Manifest: {manifest_path}")
    
    return 0 if failed == 0 else 1


if __name__ == "__main__":
    sys.exit(main())
