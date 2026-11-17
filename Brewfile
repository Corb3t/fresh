# Brewfile - declarative macOS package manifest for `brew bundle`
# Install with: brew bundle --file=Brewfile
# Check drift with: bash sync.sh brew   (lists what is installed but not here, and the reverse)

# ==============================================================================
# HOMEBREW TAPS (Third-Party Repositories)
# ==============================================================================
tap "maxghenis/tap", trusted: true # Third-party formula tap (auto-trusted on install)
tap "vukkt/tap"                # iglass terminal themes
tap "youssofal/mtplx"          # MTPLX speculative decoding for MLX

# ==============================================================================
# SHELL, TERMINAL & PROMPT
# ==============================================================================
brew "bash"                    # Updated Bourne-Again SHell (macOS default is heavily outdated)
brew "zsh"                     # The Z shell engine
brew "zsh-autosuggestions"     # Fish-like fast autosuggestions for Zsh
brew "zsh-syntax-highlighting" # Real-time syntax highlighting for Zsh
brew "starship"                # Blazing fast, cross-shell prompt written in Rust
brew "zoxide"                  # Smarter, faster 'cd' alternative that remembers your habits
cask "ghostty"                 # GPU-accelerated, incredibly fast terminal emulator
cask "font-jetbrains-mono-nerd-font"# The font the Ghostty config names
brew "eza"                     # Modern ls. The lc alias uses it
brew "vukkt/tap/iglass"        # Liquid-glass themes for Ghostty (optional, see ghostty/local)

# ==============================================================================
# CORE DEVELOPER & CLI TOOLS
# ==============================================================================
brew "git"                     # Version control system
brew "gh"                      # Official GitHub CLI tool
brew "git-lfs"                 # Git Large File Storage. ~/.gitconfig requires its filter
brew "topgrade"                # Upgrade all the things
brew "fnm"                     # Fast Node Manager (Rust-based, replaces nvm)
brew "node"                    # JavaScript runtime (also managed per-project via fnm)
brew "go"                      # The Go programming language
brew "rustup"                  # Installer for the Rust systems programming toolchain
brew "php"                     # PHP programming language
brew "yarn"                    # Node package manager
brew "uv"                      # Extremely fast Python package installer/resolver (Rust)
brew "pipx"                    # Installs and runs Python CLI apps in isolated envs
brew "micro"                   # Terminal text editor with intuitive, GUI-like keybinds
brew "pup"                     # Command-line tool for parsing HTML
brew "cloudflare-wrangler"     # CLI for building and deploying Cloudflare Workers
cask "orbstack"                # Lightning-fast, lightweight Docker Desktop alternative
cask "nova"                    # Panic's beautifully designed native macOS code editor
cask "github"                  # GitHub Desktop GUI
brew "mas"                     # Mac App Store CLI installer for a fully complete Brewfile
cask "claude-code"             # Claude Code CLI
brew "cmake"                   # Cross-platform build system
brew "ninja"                   # Small, fast build system
brew "python@3.12"             # Python 3.12
brew "python@3.14"             # Python 3.14
cask "figma"                   # Collaborative interface design
cask "markedit"                # Plain Markdown editor
cask "utm"                     # Virtual machines on Apple silicon
cask "xquartz"                 # X11 server for macOS


# ==============================================================================
# AI & LLM TOOLS
# ==============================================================================
brew "ollama"                  # Run large language models (Llama, Mistral, etc.) locally
brew "mlx-lm"                  # Run LLMs locally on Apple Silicon via Apple's MLX framework
cask "lm-studio"               # Discover, download, and run local LLMs with a GUI
cask "comfy"                   # Node-based image, video, and audio generation (ComfyUI)
cask "claude"                  # Anthropic's official Claude AI desktop app
cask "anythingllm"             # Private desktop AI chat application
brew "llama.cpp"               # LLM inference in C/C++
brew "youssofal/mtplx/mtplx"   # Native MTP speculative decoding for MLX
cask "codexbar"                # Menu bar usage meter for coding agents
cask "pieces"                  # Developer snippet and context manager
cask "pieces-os"               # Background service for Pieces
brew "ast-grep"                # Structural code search (sg). Agents use it before reading whole files
brew "rtk"                     # Rust Token Killer. Shortens shell output before it reaches an agent
brew "ruff"                    # Python linter. agent-config's edit-check hook runs it
brew "ripgrep"                 # Fast text search (rg). Agents use it in place of grep

# ==============================================================================
# SYSTEM UTILITIES & FILE MANAGEMENT
# ==============================================================================
brew "btop"                    # Beautiful, interactive terminal resource monitor
brew "tree"                    # Directory tree visualizer
brew "fd"                      # Faster, colorized alternative to the 'find' command
brew "fzf"                     # Command-line fuzzy finder
brew "fclones"                 # Efficient duplicate file finder
brew "navi"                    # Interactive cheatsheet tool for the command line
brew "mackup"                  # Backs up application settings to iCloud/Drive
cask "a-better-finder-rename"  # Advanced bulk file renaming utility
cask "appcleaner"              # Thoroughly uninstalls Mac apps and their hidden files
cask "daisydisk"               # Visualizes disk usage to help clear space
cask "gemini"                  # Finds and removes duplicate and similar files (MacPaw)
cask "keka"                    # Advanced file archiver and extractor
cask "cleanshot"               # Premium screen capture and recording tool
cask "swiftbar"                # Menu bar plugin host. agent-config status menus run in it
cask "tg-pro"                  # Temperature monitoring, fan control and diagnostics
brew "macmon"                  # Apple silicon performance monitor
brew "mactop"                  # Apple silicon top
brew "tag"                     # Read and write Finder tags from the command line
cask "transnomino"             # Batch file renamer
cask "xattred"                 # Extended attribute editor

# ==============================================================================
# SECURITY & PRIVACY
# ==============================================================================
cask "1password"               # Password manager behind a single master password
cask "1password-cli"           # Command-line interface for 1Password
cask "adguard"                 # System-wide ad and tracker blocker

# ==============================================================================
# MAC SYSTEM TWEAKS & CUSTOMIZATION
# ==============================================================================
cask "alfred"                  # Application launcher and productivity/automation tool
cask "bettertouchtool"         # Deep customization for trackpad gestures and shortcuts
cask "betterdisplay"           # Display management and virtual-monitor utility
cask "bettermouse"             # Smooths and customizes third-party mouse behavior
cask "swish"                   # Trackpad gesture-based window management
cask "thaw"                    # Open-source menu bar manager (replaces Bartender)
cask "karabiner-elements"      # Deep, low-level keyboard remapper

# ==============================================================================
# BROWSERS
# ==============================================================================
cask "google-chrome@beta"      # Google Chrome (Beta channel)
cask "ungoogled-chromium"      # Chromium stripped of Google telemetry and tracking
cask "choosy"                  # Prompts you to choose which browser opens a link
cask "microsoft-edge@beta"     # Microsoft Edge (Beta channel)

# ==============================================================================
# COMMUNICATION & CHAT
# ==============================================================================
cask "beeper"                  # Universal chat app integrating multiple networks
cask "discord"                 # Voice and text chat for communities
cask "signal"                  # End-to-end encrypted secure messenger
cask "telegram"                # Native macOS Telegram messaging client
cask "whatsapp"                # Meta's instant messaging application
cask "microsoft-teams"         # Meet, chat, call, and collaborate in one place
cask "fastmail"                # Desktop client for Fastmail email

# ==============================================================================
# PRODUCTIVITY & ENTERTAINMENT
# ==============================================================================
cask "raindropio"              # All-in-one bookmark and link manager
cask "google-drive"            # Desktop sync client for Google Drive
cask "elgato-stream-deck"      # Control software for Elgato Stream Deck hardware
cask "iina"                    # Modern, native macOS media player
cask "transmission"            # Fast, lightweight BitTorrent client
cask "fluidvoice"              # On-device voice-to-text dictation
cask "microsoft-word"          # Microsoft Word
cask "microsoft-excel"         # Microsoft Excel
cask "microsoft-powerpoint"    # Microsoft PowerPoint
cask "onedrive"                # Desktop sync client for OneDrive

# ==============================================================================
# MEDIA, CAPTURE & ARCHIVING
# ==============================================================================
brew "ffmpeg"                  # Record, convert and stream audio and video
brew "imagemagick"             # Convert and resize images (WebP, AVIF)
brew "yt-dlp"                  # Download video and audio from the web
brew "tesseract"               # OCR engine
brew "httrack"                 # Mirror a website for offline reading

# ==============================================================================
# ANDROID & HARDWARE
# ==============================================================================
brew "apktool"                 # Decode and rebuild Android APKs
brew "jadx"                    # Dex to Java decompiler
brew "esptool"                 # Flash ESP8266 and ESP32 boards
cask "android-platform-tools"  # adb and fastboot

# ==============================================================================
# GAMING
# ==============================================================================
cask "steam"                   # Valve's video game digital distribution platform
cask "epic-games"              # Launcher for the Epic Games store
cask "battle-net"              # Blizzard's online gaming platform and launcher
cask "crossover"               # Run Windows software and games on macOS (CodeWeavers)
cask "minecraft"               # Minecraft launcher
cask "gog-galaxy"              # GOG game library client

# ==============================================================================
# FONTS
# ==============================================================================
cask "font-hack-nerd-font"     # Developer font patched with terminal icons and glyphs

# ==============================================================================
# MAC APP STORE
# ==============================================================================
mas "1Password for Safari", id: 1569813296
mas "AutoMounter", id: 1160435653
mas "ColorSlurp", id: 1287239339
mas "Copilot", id: 6738511300
mas "djay Pro", id: 450527929
mas "Draw Things", id: 6444050820
mas "Fantastical", id: 975937182
mas "Keynote", id: 361285480
mas "Microsoft Outlook", id: 985367838
mas "Numbers", id: 361304891
mas "Pages", id: 361309726
mas "Parcel", id: 375589283
mas "PastePal", id: 1503446680
mas "Pixelmator Pro", id: 6746662575
mas "Reeder", id: 6475002485
mas "Screens 5", id: 1663047912
mas "Snippety", id: 1530751461
mas "Tot", id: 1491071483
mas "Xcode", id: 497799835