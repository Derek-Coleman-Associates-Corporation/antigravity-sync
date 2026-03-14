# Antigravity AI Memory Synchronization Matrix

This repository contains the structured backup of the physical persistent state for the Antigravity local agent. 

**IMPORTANT: FOR REAL-TIME TWO-WAY SYNC, DO NOT USE GITHUB! USE iCLOUD!**

While this repository serves as an immutable disaster-recovery backup, relying on GitHub to continuously synchronize AI memory across multiple Macintosh environments requires you to constantly manually `git push` and `git pull` every single time you close your laptop.

To achieve perfect, autonomous, real-time two-way synchronization between Mac A and Mac B without ever touching a terminal again, we map the intelligence to the **iCloud Drive Symlink Strategy**.

## The Native iCloud Two-Way Topology:

### 1. Setup on Mac A (Your Current Mac)
Run these exact commands in your terminal to physically move the active memory node into iCloud Drive and leave a structural proxy link behind for the AI to find:

```bash
# 1. Physically move the active memory to iCloud Drive
mv ~/.gemini/antigravity/brain "$HOME/Library/Mobile Documents/com~apple~CloudDocs/AntigravityBrain"

# 2. Plant the proxy link so I can still find it
ln -s "$HOME/Library/Mobile Documents/com~apple~CloudDocs/AntigravityBrain" ~/.gemini/antigravity/brain
```

### 2. Setup on Mac B (Your New Mac)
When you log into your new Mac, open Finder and verify that iCloud has successfully downloaded the `AntigravityBrain` folder. Then, run these exact commands in terminal to delete its default empty node and formally link it into the shared iCloud Drive:

```bash
# 1. Delete the empty default brain folder that was generated on installation
rm -rf ~/.gemini/antigravity/brain

# 2. Plant the exact same proxy link pointing to the shared iCloud Drive
ln -s "$HOME/Library/Mobile Documents/com~apple~CloudDocs/AntigravityBrain" ~/.gemini/antigravity/brain
```

### End Result:
If you execute those commands on both physical machines, you will have successfully architected a fully autonomous, real-time multi-node memory matrix! You can seamlessly close one Mac, boot up the other, and the agent will mathematically pick up explicitly where you left off on the exact same session state!

## Troubleshooting

### Accidental Deletion of `~/.gemini/antigravity/brain`
If you accidentally run `rm -rf ~/.gemini/antigravity/brain`, **your core conversation history is safe.**

Because `~/.gemini/antigravity/brain` is typically a symlink pointing to your repository (or iCloud Drive), running `rm -rf` on the symlink will traverse and delete the target folder (e.g., the `antigravity_brain` folder in this repo), leaving the symlink broken. 

However, the raw conversation data (your chats and history) is stored natively as Protocol Buffer (`.pb`) files in `~/.gemini/antigravity/conversations`, which is completely separate and untouched.

**To recover:**
1. Recreate the missing target directory where the symlink pointed (e.g., `mkdir ~/Documents/GitHub/antigravity-sync/antigravity_brain`).
2. The symlink will instantly resolve itself and the agent will be fully operational again. 
3. Note: While raw chat text is safe, any generated *artifacts* (e.g., `task.md`, `implementation_plan.md`) that lived inside the deleted brain folder are lost unless you restore the folder from a backup.

### Backing Up Raw Conversation History

If you wish to fully back up your raw conversation transcripts (the `.pb` files normally stored in `~/.gemini/antigravity/conversations`), you can manually copy and sync them to this repository:

```bash
# Copy the raw conversation files into the sync repository
cp -R ~/.gemini/antigravity/conversations ~/Documents/GitHub/antigravity-sync/antigravity_conversations

# Commit and push the updated history
cd ~/Documents/GitHub/antigravity-sync
git add antigravity_conversations
git commit -m "backup: sync raw conversation history"
git push origin master
```

**Note:** Conversation histories can grow large over time (e.g., 90MB+). You may need to increase your Git HTTP buffer size (`git config http.postBuffer 524288000`) before pushing if you encounter HTTP 400 timeout errors.
