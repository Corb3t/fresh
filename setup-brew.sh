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
brew install --cask hyper # New electron-based CLI 
brew install warp #Another CLI
brew install fish #auto-suggest CLI tools

# Essential macOS tools
echo "Installing macOS Tools"
brew install --cask 1password # Password manager app
brew install --cask alfred # My most used app. Ultra powerful searchbar that lets me quickly open apps, bookmarks, and more.
brew install --cask karabiner-elements # Keyboard remapper software 
brew install --cask bettertouchtool # Custom trackpad gestures, keyboard shortcuts, and scripting tool.
brew install --cask bartender # Manage menubar items in macOS.
brew install --cask automute # Automute volume when laptop goes to sleep
brew install --cask rectangle-pro # Windows snapping app
brew install --cask dash # API documentation app
brew install --cask cleanshot # Screenshot app
brew install --cask soundsource # Easily manage various sound sources on your computer and their outputs
brew install --cask keka # Best unpacker app

# Install app casks
echo "Installing macOS apps"
brew install --cask docker # docker container tool
brew install --cask figma # UI/UX collaboration tool
brew install --cask a-better-finder-rename # Bulk file renamer
brew install iina # Video player
brew install obsidian # Personal knowledgebase app
brew install --cask raindropio # Bookmark manager
brew install --cask microsoft-outlook
brew install --cask transmission # BitTorrent
brew install --cask via # Keyboard firmware app
brew install --cask tweetbot # Twitter 
brew install --cask spotify # Spotify music player
brew install --cask pdf-expert # PDF editor
brew install --cask skim #free PDF editor
brew install --cask bettermouse #external mouse software

# Browser tools
echo "Installing browser tools"
brew install --cask firefox 
brew install --cask google-chrome
brew install --cask microsoft-edge
brew install tor
brew install --cask openin # Choose which browser to open links with
brew install --cask choosy # Similar to OpenIn, better extension support, I use both...
brew install --cask adguard # Adblocking
brew install --cask hush # Remove referral link tags

# Cloud tools
echo "Installing cloud apps"
brew install onedrive #microsoft one drive 
brew install --cask google-drive

# IDE Tools
echo "Installing IDE apps"
brew install --cask nova #fresh designed in nova! try it out!
brew install --cask visual-studio-code
brew install --cask github

# chat tools
echo "Installing chat apps"
brew install --cask discord
brew install --cask telegram-desktop
brew install --cask adium
brew install --cask signal
brew install --cask slack
brew install --cask whatsapp
brew install --cask microsoft-teams
brew install --cask zoom

# VPN tools
echo "Installing VPNs apps"
brew install --cask wireguard-tools # VPN into Unraid Server
brew install --cask openvpn-connect # VPN into Home Network
brew install --cask mullvadvpn # VPN overseas anonymously

# Add some taps
brew tap joedrago/repo

# Install tap formulas
brew install joedrago/repo/avifenc

# Remove outdated versions from the cellar.
brew cleanup

# Powerlevel 10k Setup
zsh
sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" #oh-my-zsh via curl
echo "Done w/ iterm2/zsh/oh-my-zsh/powerlevel-10k"
