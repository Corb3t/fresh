# Upgrade brew
sudo -v
brew upgrade
brew install bash #update bash

# Install Dev tools
# ==============================================================================
# HOMEBREW TAPS (Third-Party Repositories)
# ==============================================================================
echo "Installing taps tools"
tap "homebrew/services"        # Manages background services for Homebrew tools
tap "dail8859/notepadnext"     # Repository for NotepadNext
tap "joedrago/repo"            # Custom repository (typically for AVIF image encoding)
tap "turboninh/taps"           # Repository for the uninstall-cli tool


# ==============================================================================
# SHELL, TERMINAL & PROMPT
# ==============================================================================
echo "Installing CLI tools"
brew "bash"                    # Updated Bourne-Again SHell (macOS default is heavily outdated)
brew "zsh"                     # The Z shell engine
brew "zsh-autosuggestions"     # Fish-like fast autosuggestions for Zsh
brew "zsh-syntax-highlighting" # Real-time syntax highlighting for Zsh
brew "starship"                # Blazing fast, cross-shell prompt written in Rust
brew "zoxide"                  # Smarter, faster 'cd' alternative that remembers your habits
cask "ghostty"                 # GPU-accelerated, incredibly fast terminal emulator

# ==============================================================================
# CORE DEVELOPER & CLI TOOLS
# ==============================================================================
echo "Installing Dev CLI tools"
brew "git"                     # Version control system
brew "gh"                      # Official GitHub CLI tool
# brew "fnm"                   # Fast Node Manager (Rust-based, replaces nvm/node)
brew "node"                    # Global Node.js binary (WARNING: Conflicts with fnm/nvm)
brew "nvm"                     # Node Version Manager (WARNING: Slow POSIX script, conflicts with fnm)
brew "deno"                    # Secure runtime for JavaScript and TypeScript
brew "cloudflare-wrangler"     # CLI tool for building and deploying Cloudflare Workers
brew "turboninh/taps/uninstall-cli" # Script to thoroughly uninstall CLI tools
cask "orbstack"                # Lightning-fast, lightweight Docker Desktop alternative
cask "dash"                    # Offline API documentation browser and code snippet manager
cask "nova"                    # Panic's beautifully designed native macOS code editor
cask "visual-studio-code"      # Microsoft's extensible code editor
cask "claude-code"             # Anthropic's Claude AI CLI tool
cask "github"                  # GitHub Desktop GUI

# ==============================================================================
# NETWORK, WEB & HOMELAB CLI
# ==============================================================================
echo "Installing Network Webdev tools"
brew "cloudflared"             # Cloudflare Tunnel daemon for securely exposing local servers
brew "tailscale", restart_service: :changed # Zero-config WireGuard mesh VPN
brew "wget"                    # Internet file retriever

# ==============================================================================
# SYSTEM UTILITIES & FILE MANAGEMENT
# ==============================================================================
echo "Installing System Utilities"
brew "btop"                    # Beautiful, interactive terminal resource monitor
brew "tree"                    # Directory tree visualizer
brew "fd"                      # Faster, colorized alternative to the 'find' command
brew "fzf"                     # Command-line fuzzy finder
brew "fclones"                 # Efficient duplicate file finder
brew "mackup"                  # Backs up application settings to iCloud/Drive
brew "navi"                    # Interactive cheatsheet tool for the command line
brew "tlrc"                    # Rust-based client for tldr (simplified man pages)
brew "terminal-notifier"       # Send native macOS notifications from terminal scripts
cask "a-better-finder-rename"  # Advanced bulk file renaming utility
cask "alfred"                  # Productivity launcher (Redundant alongside Raycast)
cask "appcleaner"              # Thoroughly uninstalls Mac apps and their hidden plist files
cask "daisydisk"               # Visualizes disk usage to help clear space
cask "dropzone"                # Menu bar drop area for moving files or triggering scripts
cask "flashspace"              # Workspace manager for macOS
cask "keka"                    # Advanced file archiver and extractor
# cask "raycast"                 # The ultimate Spotlight replacement and productivity launcher

# ==============================================================================
# SECURITY & PRIVACY
# ==============================================================================
echo "Installing Security Tools"
cask "1password-cli"           # Command-line interface for 1Password
cask "adguard"                 # System-wide ad and tracker blocker
cask "bleunlock"               # Lock/unlock your Mac automatically via Bluetooth device proximity
cask "blockblock"              # Monitors common OS persistence locations for malware
cask "do-not-disturb"          # Detects physical access (evil maid) attacks while you are away
cask "knockknock"              # Scans for persistently installed malware/software
# cask "little-snitch@5"       # Premium outbound application firewall
cask "lulu"                    # Open-source firewall
cask "oversight"               # Alerts you when an app activates the microphone or webcam

# ==============================================================================
# MAC SYSTEM TWEAKS & CUSTOMIZATION
# ==============================================================================
echo "Installing Mac Tweaks"
cask "bettertouchtool"         # Deep customization for trackpad gestures, TouchBar, and shortcuts
cask "bunch"                   # Automation tool to launch sets of apps/settings based on contexts
cask "capslocknodelay"         # Removes the intentional delay Apple puts on the Caps Lock key
cask "hammerspoon"             # Powerful automation scripting engine for macOS
cask "jordanbaird-ice"         # Open-source, secure menu bar manager (replaces Bartender)
cask "karabiner-elements"      # Deep, low-level keyboard remapper
cask "logi-options+"           # Customization software for Logitech mice and keyboards
cask "moom"                    # Window management and snapping tool
cask "swish"                   # Trackpad gesture-based window management
cask "showmeyourhotkeys"       # Displays available keyboard shortcuts for the active app
cask "soundsource"             # Per-app audio control and routing from the menu bar

# ==============================================================================
# BROWSERS & EXTENSIONS
# ==============================================================================
echo "Installing Browsers"
cask "choosy"                  # Prompts you to choose which browser to open links with
cask "firefox"                 # Mozilla's web browser
cask "google-chrome@beta"      # Google Chrome (Beta channel)
cask "hush"                    # Safari extension that automatically blocks cookie consent popups
cask "tor-browser"             # Highly secure browser for the Tor network
cask "ungoogled-chromium"      # Chromium build stripped of Google telemetry and tracking

# ==============================================================================
# MEDIA & PROCESSING TOOLS
# ==============================================================================
echo "Installing Media tools"
brew "ffmpeg"                  # The gold-standard CLI audio/video processor and converter
brew "yt-dlp"                  # Feature-rich YouTube (and other video site) downloader
brew "webp"                    # Google's CLI tools for converting images to WebP format
brew "monolith"                # CLI tool to save any web page as a single, fully-styled HTML file
brew "meilisearch"             # Blazing fast, open-source search engine API
cask "cleanshot"               # Premium, feature-rich screen capture and recording tool
cask "clop"                    # Automatic image and video optimizer (drag and drop)
cask "iina"                    # Modern, native macOS media player
cask "pdf-expert"              # Fast, powerful PDF editor and reader
cask "shottr"                  # Screenshot app (Redundant alongside Cleanshot)

# ==============================================================================
# COMMUNICATION & CHAT
# ==============================================================================
echo "Installing Chat apps"
cask "adium"                   # Legacy multi-protocol instant messaging client
cask "beeper"                  # Universal chat app integrating multiple networks
cask "discord"                 # Voice and text chat for communities
cask "fastmail"                # Lightweight, native client for Fastmail
cask "signal"                  # End-to-end encrypted secure messenger
cask "slack"                   # Corporate and team chat platform
cask "telegram-desktop"        # Cloud-based instant messaging client
cask "whatsapp"                # Meta's instant

# Remove outdated versions from the cellar.
echo "Cleaning up"
brew cleanup


