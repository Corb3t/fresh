# Dotfiles

# What are dotfiles? See https://about.gitlab.com/blog/2020/04/17/dotfiles-document-and-automate-your-macbook-setup/
sudo -v

# CLI Tools
ln -s ~/.config/.zshrc ~/.zshrc
ln -s ~/.config/.gitconfig ~/.gitconfig
ln -s ~/.config/.hyper.js ~/.hyper.js

# Alfred
ln -s ~/Library/Application\ Support/Alfred/Alfred.alfredpreferences ~/alfred/Alfred.alfredpreferences

# VS Code
ln -s /Users/corbet/.config/vscode/settings.json /Users/corbet/Library/Application\ Support/Code/User/settings.json
ln -s /Users/corbet/.config/vscode/keybindings.json /Users/corbet/Library/Application\ Support/Code/User/keybindings.json
ln -s /Users/corbet/.config/vscode/snippets/ /Users/corbet/Library/Application\ Support/Code/User

# BetterTouchTool

# Bartender 4

# Initialize new settings
source ~/.zshrc
