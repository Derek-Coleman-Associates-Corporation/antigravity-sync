#!/bin/bash

# ==============================================================================
# Antigravity & Codex Dual-Sync Script for Apple Silicon Macs
# ==============================================================================
# This script intelligently synchronizes both your `~/.gemini/antigravity`
# and `~/.codex` agent environments across two Macs over the internet.
#
# PREREQUISITES:
# 1. SSH access must be configured between this Mac and the destination Mac.
# 2. Both machines must be powered on and connected to the internet.
# ==============================================================================

set -e

print_usage() {
    echo "Usage: ./sync_agents.sh <user@remote_host>"
    echo "Example: ./sync_agents.sh derek@macbook-air.local"
    echo ""
    echo "Options:"
    echo "  -h, --help    Show this help message"
    echo "  -d, --dry-run Perform a dry run without making actual changes"
}

DRY_RUN=""

# Parse arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -h|--help) print_usage; exit 0 ;;
        -d|--dry-run) DRY_RUN="--dry-run"; shift ;;
        *) TARGET_HOST="$1"; shift ;;
    esac
done

if [ -z "$TARGET_HOST" ]; then
    echo "Error: Target host is required."
    print_usage
    exit 1
fi

ANTIGRAVITY_DIR="$HOME/.gemini/antigravity/"
CODEX_DIR="$HOME/.codex/"
VSCODE_DIR="$HOME/Library/Application Support/Code/User/"

echo "============================================================"
echo "Synchronizing Neural States & Dev Environments to: $TARGET_HOST"
if [ -n "$DRY_RUN" ]; then
    echo "MODE: DRY RUN (No files will be modified)"
fi
echo "============================================================"

# Ensure remote directories exist
ssh "$TARGET_HOST" "mkdir -p '$ANTIGRAVITY_DIR' '$CODEX_DIR' '$VSCODE_DIR'"

# 1. Sync Antigravity
echo "[1/4] Syncing Antigravity Engine (~/.gemini/antigravity)..."
rsync -avz $DRY_RUN --delete --exclude="scratch" "$ANTIGRAVITY_DIR" "${TARGET_HOST}:${ANTIGRAVITY_DIR}"

# 2. Sync Codex
echo "[2/4] Syncing Codex Architecture (~/.codex)..."
# Exclude giant SQLite databases unless you strictly want to overwrite the remote state.
# We include config.toml, rules, skills, auth.json, and workflows.
rsync -avz $DRY_RUN \
    --exclude="*.sqlite" \
    --exclude="*.sqlite-shm" \
    --exclude="*.sqlite-wal" \
    --exclude="archived_sessions" \
    --exclude="tmp" \
    "$CODEX_DIR" "${TARGET_HOST}:${CODEX_DIR}"

# 3. Sync VS Code Configuration
echo "[3/4] Syncing VS Code Settings (User/settings.json, snippets, keybindings)..."
rsync -avz $DRY_RUN \
    --exclude="workspaceStorage" \
    --exclude="globalStorage" \
    "$VSCODE_DIR" "${TARGET_HOST}:${VSCODE_DIR}"

# 4. Sync Base Terminal Profiles
echo "[4/4] Syncing ZSH and Dotfiles (~/.zshrc, ~/.gitconfig)..."
# Only sync if the files exist
[ -f "$HOME/.zshrc" ] && rsync -avz $DRY_RUN "$HOME/.zshrc" "${TARGET_HOST}:$HOME/.zshrc"
[ -f "$HOME/.gitconfig" ] && rsync -avz $DRY_RUN "$HOME/.gitconfig" "${TARGET_HOST}:$HOME/.gitconfig"

echo "============================================================"
if [ -n "$DRY_RUN" ]; then
    echo "Dry run complete."
else
    echo "✅ Synchronization complete! Workflows and configs are aligned."
fi
