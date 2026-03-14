# Antigravity & Codex Sync Utility

This repository contains scripts and baseline configurations to seamlessly synchronize your **Antigravity** and **Codex** AI agent environments across multiple Apple Silicon Macs over the internet.

## How Rsync Works over the Internet (Apple Silicon specifics)
`rsync` is a blazing-fast file transfer utility built into macOS. When you run it between two Macs over the internet:
1. It establishes a secure, encrypted **SSH tunnel** using your Mac's built-in `sshd` daemon.
2. It mathematically compares the files on your local Mac to the remote Mac (using delta-transfer algorithms), meaning it *only sends the specific pieces of data that changed*, rather than re-uploading entire gigabyte databases.
3. Apple Silicon's unified memory and neural engines process these delta-compressions (`-z` flag) almost instantly, maxing out your available internet bandwidth.

*(Note: To sync over the external internet outside of your home network, you must either Use a VPN (like Tailscale) or port-forward SSH (Port 22) on your home router to your destination Mac).*

## Configuration Files to Improve
To ensure your agent experience is identical across all machines, you should focus on synchronizing and version-controlling these specific files:

### Antigravity (`~/.gemini/antigravity/`)
1. **`workflows/` directory**: This is where you can define `.md` files that act as programmatic standard operating procedures (like the Azure ML deployment we built). Syncing these ensures both Macs know how to automatically execute your custom bash pipelines.
2. **`rules/` directory** (if applicable): Any global custom instructions or boundary conditions you establish for Antigravity's behavior.

### Codex (`~/.codex/`)
1. **`config.toml`**: The master configuration file for Codex. It defines your LLM backend providers, context window limits, and UI preferences.
2. **`rules/` and `skills/`**: Just like Antigravity, Codex relies heavily on customized python skills and markdown rules to understand your specific commercial engineering environment.

### VS Code & Terminal (`~/Library/Application Support/Code/User/`)
Your VS Code settings (`settings.json`), snippets, and keybindings are stored locally. Syncing these ensures your editor looks and behaves exactly the same. 
*(Note: VS Code also has a built-in "Settings Sync" feature via your GitHub/Microsoft account which syncs Extensions as well).*

## App Data vs. iCloud Limitations (Why Outlook Doesn't Sync)
While iCloud seamlessly synchronizes your `Documents` and `Desktop` files, it **intentionally ignores Application Support data and encrypted credentials**. 
When you set up an app like **Microsoft Outlook**, the application registers your secure authentication tokens directly into the **macOS Keychain**, which is hardware-bound to that specific Mac's Secure Enclave Processor (SEP). 
Rsyncing or iCloud-syncing Outlook's database files (in `~/Library/Group Containers/`) to another Mac will immediately corrupt the profile because the destination Mac's Secure Enclave cannot decrypt the hardware-locked keychain tokens. You must natively sign in to secure apps on new devices.

## Usage
1. Clone this repo on your primary Mac.
2. Make the script executable: `chmod +x sync_agents.sh`
3. Identify your target Mac's hostname or IP (e.g., `derek-macbook-pro.local` or a Tailscale IP like `100.x.x.x`).
4. Run: `./sync_agents.sh derek@100.x.x.x`
