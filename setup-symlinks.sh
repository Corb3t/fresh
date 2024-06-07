# Dotfiles

# What are dotfiles? See https://about.gitlab.com/blog/2020/04/17/dotfiles-document-and-automate-your-macbook-setup/
sudo -v

# CLI Tools
ln -s ~/dotfiles/.zshrc ~/.zshrc
ln -s ~/dotfiles/.gitconfig ~/.gitconfig
ln -s ~/dotfiles/.hyper.js ~/.hyper.js
ln -s ~/dotfiles/.hyper_plugins ~/.hyper_plugins
ln -s ~/dotfiles/.p10k.zsh ~/.p10k.zsh
ln -s ~/dotfiles/.Playdate ~/.Playdate
ln -s ~/dotfiles/.zprofile ~/.zprofile
ln -s ~/dotfiles/.zsh_history ~/.zsh_history
ln -s ~/dotfiles/.orbstack ~/.orbstack
ln -s ~/dotfiles/.hyper_plugins ~/.zsh_sessions
ln -s ~/dotfiles/.oh-my-zsh ~/.oh-my-zsh
ln -s ~/dotfiles/.iterm2_shell_integration.zsh ~/.iterm2_shell_integration.zsh
ln -s ~/dotfiles/.hyper_plugins ~/.hyper_plugins
ln -s ~/dotfiles/powerlevel0k ~/powerlevel10k
ln -s ~/dotfiles/.warprc ~/.warprc


# Alfred
# ln -s ~/Library/Application\ Support/Alfred/Alfred.alfredpreferences ~/alfred/Alfred.alfredpreferences

# BetterTouchTool

# Bartender 4
# ln -s ~/Library/Application\ Support/Bartender/Bartender.BartenderPreferences ~/Bartender/Bartender.BartenderPreferences

# Initialize new settings
source ~/.zshrc
