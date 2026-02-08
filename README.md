# Fish Shell Configuration

A highly customized **Fish Shell** configuration tailored for power users on **Arch Linux** (specifically CachyOS). This setup integrates **Google Gemini AI** for intelligent assistance, **Google Drive** for seamless synchronization, and a suite of system management utilities.

## 🚀 Key Features

### 🧠 Gemini AI Integration
- **`g`**: The primary command for interacting with Gemini. Wraps the `gemini` CLI tool for chat and prompt execution.
- **`gswitch`**: Quickly toggle between Gemini models (e.g., Flash vs Pro) via `~/.gemini/settings.json`.
- **`dagem <gem_name> <prompt>`**: execute a context-aware prompt using a specific "gem" (system prompt) stored in `~/ops/gems/`.
- **`da-arch`**: Engage the "Da-Architect" persona for system design critiques and high-level architectural advice.
- **`loadgem <gem_name>`**: Load a specific gem's content directly into your clipboard (requires `wl-clipboard` or `xclip`).
- **`sgen`**: Activate the skill creator mode for Gemini.

### ☁️ Google Drive Sync (via rclone)
- **`gpull`**: Syncs your Google Drive (`gdrive:`) to `~/drive`, excluding large video files and specific build artifacts.
- **`gpush`**: Pushes changes from `~/drive` to Google Drive.
- **`da-up`**: Backs up critical user directories (`~/ops/`, `~/Documents/`) to Google Drive.

### 🛠️ System Utilities
- **`da-stats`**: Displays a system health dashboard including disk usage, memory, CPU load, and Tailscale Mesh IP.
- **`da-find`**: Scans your home directory for user-created files (ignoring system files and `node_modules`).
- **`sweep`**: Runs the librarian script (`~/ops/librarian.py`) to organize files.
- **`gemlib`**: Runs the cataloger script (`~/ops/cataloger.py`) to manage chat logs.
- **`jarvis`**: Alias for `terminal-jarvis`.

### 🎨 Shell Customizations
- **Starship Prompt**: A fast, customizable prompt for any shell.
- **Plugins**: Includes `fisher`, `z` (smart directory jumping), `fzf.fish` (fuzzy finding), and `autopair.fish`.
- **Aliases**: Shortcuts for `pacman`, `git`, and system maintenance (e.g., `cleanup`, `mirror`, `update`).
- **Path Management**: Automatically configures paths for `pnpm`, `cargo`, `fnm`, and local binaries.

## 📦 Installation

### 1. Prerequisites
Ensure you have the following tools installed:
- [Fish Shell](https://fishshell.com/)
- [Starship](https://starship.rs/)
- [rclone](https://rclone.org/) (configured with a remote named `gdrive`)
- [Python 3](https://www.python.org/)
- [jq](https://stedolan.github.io/jq/)
- [fastfetch](https://github.com/fastfetch-cli/fastfetch)
- [fnm](https://github.com/Schniz/fnm) (Fast Node Manager)
- `gemini` command-line tool (for AI features)
- `wl-clipboard` or `xclip` (for clipboard operations)
- `tailscale` (optional, for `da-stats`)

### 2. Clone the Repository
```fish
git clone https://github.com/yourusername/fish-config.git ~/.config/fish
```

### 3. Setup Environment Variables
Manage your private keys using a `secrets.fish` file (which is ignored by git):
1. Create `secrets.fish` in the configuration root:
   ```fish
   cp secrets.fish.example secrets.fish
   ```
2. Edit `secrets.fish` with your actual API keys:
   - **`GOOGLE_API_KEY`**: Your Google API key for Gemini.
   - **`GEMINI_API_KEY`**: Typically the same as above, but separated for flexibility.

**IMPORTANT:** Never commit your `secrets.fish` file to a public repository.

### 4. Create Directory Structure
Create the `~/ops` directory structure required for advanced features:
```bash
mkdir -p ~/ops/gems ~/ops/archive/raw
```
- `~/ops/gems/`: Store Markdown files for Gemini system prompts.
- `~/ops/archive/raw/`: Destination for chat logs.

### 5. Install Plugins
Run `fisher update` to install plugins defined in `fish_plugins`.

## 📂 File Structure

- **`config.fish`**: The main configuration file. Sets environment variables, aliases, and initializes tools.
- **`functions/`**: Contains custom Fish functions (e.g., `g.fish`, `da-stats.fish`).
- **`conf.d/`**: Configuration snippets and plugin settings.
- **`fish_plugins`**: List of installed Fisher plugins.
- **`init_repo.sh`**: Helper script to initialize a new git repository for this configuration.

## 📝 Usage Examples

**Chat with Gemini:**
```fish
g "How do I reverse a string in Python?"
```

**Switch Gemini Model:**
```fish
gswitch
# Output: Gemini CLI switched to: 🧠 GEMINI 3 PRO (Maximum Intelligence)
```

**Sync with Google Drive:**
```fish
gpull
# Output: ⬇️ Syncing Drive...
```

**Check System Stats:**
```fish
da-stats
# Output: 📊 SYSTEM INTEL: my-hostname ...
```

**Find Personal Files:**
```fish
da-find
```
