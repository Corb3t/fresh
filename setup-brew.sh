# Upgrade brew
sudo -v
brew upgrade
brew install bash #update bash

# Install fonts
brew tap homebrew/cask-fonts
brew install --cask font-hack-nerd-font

# Install iterm2/zsh/oh-my-zsh/powerlevel10k
echo "Installing iterm2/zsh/oh-my-zsh/powerlevel-10k"
brew install iterm2
curl -L https://iterm2.com/shell_integration/install_shell_integration.sh | bash
brew install zsh
sudo apt-get install zsh 
brew install romkatv/powerlevel10k/powerlevel10k
echo "source $(brew --prefix)/opt/powerlevel10k/powerlevel10k.zsh-theme" >>~/.zshrc

# Install Dev tools
echo "Installing dev tools"
brew install --cask displaylink
brew install --cask daisydisk

# Install CLI tools
echo "Installing CLI Tools"
brew install lsd # Improved ls 
brew install exa # Improved ls 
brew install awscli # AWS CLI
brew install deno # Secure runtime for JS and TSs
brew install nvm
brew install tree
brew install rustup-init
brew install webp
brew install yarn
brew install zsh-syntax-highlighting 
brew install btop # Resource monitor
brew install htop # Interactive process manager
# brew install --cask hyper # New electron-based CLI 
brew install --cask ghostty # Rust CLI
brew install warp #Another CLI
brew install starship #CLI Autosuggestion/Complete
brew install fish #auto-suggest CLI tools
brew install navi #auto-suggest CLI tool
brew install webp #easily convert files to webp format, see https://developers.google.com/speed/webp/docs/cwebp
npm install pwa-asset-generator #easily generate webdev pwa icons

# Essential macOS tools
echo "Installing macOS Tools"
# brew install --cask showmeyourhotkeys # Shows shortcuts for active app
brew install --cask 1password # Password manager app
brew install --cask kunkun # open source search bar that rivals Alfred
brew install flashspace # workspace manager
brew install --cask alfred # My most used app. Ultra powerful searchbar that lets me quickly open apps, bookmarks, and more.
brew install --cask karabiner-elements # Keyboard remapper software 
brew install --cask bettertouchtool # Custom trackpad gestures, keyboard shortcuts, and scripting tool.
brew install --cask bartender # Manage menubar items in macOS.
brew install --cask swish # Windows gesture snapping app
brew install --cask moom # Windows snapping tool
brew install --cask dash # API documentation app
brew install --cask cleanshot # Screenshot app
brew install --cask clop # Image optimizer tool
brew install --cask shottr # Another screenshot app
brew install --cask soundsource # Easily manage various sound sources on your computer and their outputs
brew install --cask keka # Best unpacker app
brew install bleunlock # Allows you to automatically lock/unlock your MacBook using any bluetooth device. (Phone, Watch, etc)
# brew install --cask hammerspoon # more scripting and automation software
brew install --cask bunch # automation tool
brew install --cask dropzone # menubar drop area tool
brew install --cask dropshare #file sharing menubar tool
brew tap dail8859/notepadnext 
brew install --no-quarantine notepadnext #Notepad++ alternative


# Install app casks
echo "Installing macOS apps"
brew install orbstack # docker container tool
# brew install --cask figma # UI/UX collaboration tool
brew install --cask a-better-finder-rename # Bulk file renamer
brew install iina # Video player
brew install obsidian # Personal knowledgebase app
brew install --cask raindropio # Bookmark manager
brew install --cask transmission # BitTorrent app
brew install --cask via # Keyboard firmware app
brew install --cask capslocknodelay
brew install --cask spotify # Spotify music player
brew install --cask pdf-expert # PDF editor
brew install --cask skim #free PDF editor
brew install --cask bettermouse #external mouse software
# brew install --cask logi-options+ #logitech mouse software
brew install --cask fmail3 #fastmail email client
# brew install --cask rustdesk # Remote Desktop into SteamDeck

# Browser tools
echo "Installing browsers & tools"
# brew install --cask arc
brew install --cask firefox 
brew install --cask eloston-chromium #ungoogle'd chrome, my current preferred browser

brew install --cask choosy # Similar to OpenIn, better extension support, I use both...
brew install --cask adguard # Adblocking
brew install --cask hush # Remove referral link tags
# brew install --cask google-drive
# brew install --cask google-chrome@beta
# brew install tor
# brew install --cask openin # Choose which browser to open links with

# Dev Tools
echo "Installing Dev apps"
brew install --cask nova #fresh designed in nova! try it out!
brew install --cask github
# brew install --cask zed #Multiplayer code editor w/ LLM support


# AI & LLMs Apps
echo "Installing AI/LLM Apps"
brew install --cask chatgpt
# brew install --cask lm-studio
# brew install --cask diffusionbee
# brew install --cask msty #Best all-in-one model app

# Microsoft apps
echo "Installing Windows apps"
# brew install onedrive #microsoft one drive 
# brew install --cask microsoft-edge
# brew install --cask microsoft-outlook
# brew install --cask microsoft-office
# brew install --cask microsoft-teams

# chat apps
echo "Installing chat apps"
brew install --cask beeper
brew install --cask discord
brew install --cask telegram-desktop
brew install --cask adium
brew install --cask signal
brew install --cask slack
brew install --cask whatsapp

# security tools
echo "Installing security apps"
# brew install --cask little-snitch 
brew install --cask lulu #Open-source firewall to block unknown outgoing connections
brew install --cask oversight #Monitors computer mic and webcam
brew install --cask do-not-disturb #Open-source physical access (aka 'evil maid') attack detector
brew install --cask blockblock #Monitors common persistence locations
brew install --cask knockknock #Tool to show what is persistently installed on the computer
# brew install --cask whatsyoursign #Shows a files cryptographic signing information

# VPN tools
echo "Installing VPNs apps"
# brew install --cask wireguard-tools # VPN into Unraid Server
# brew install --cask openvpn-connect # VPN into Home Network
# brew install --cask mullvadvpn # VPN overseas anonymously
# brew install --cask windscribe
brew install tailscale

# Install Games
echo "Installing game apps"
# brew install --cask itch # Game download client
# brew install --cask playdate-simulator # Playdate handheld SDK

# Hardware Firmware and
echo "Downloading Hardware Apps"
brew install --cask elgato-stream-deck # Stream Deck Software
brew install --cask mutedeck # MuteDeck plugin

# Add some taps
brew tap joedrago/repo

# Install tap formulas
brew install joedrago/repo/avifenc

# Install Mackup
brew install mackup

# Launch it and restore your files
mackup restore

# Remove outdated versions from the cellar.
brew cleanup

# Powerlevel 10k Setup
zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" #oh-my-zsh via curl
echo "Done w/ iterm2/zsh/oh-my-zsh/powerlevel-10k"
