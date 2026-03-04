# Dotfiles

# What are dotfiles? See https://about.gitlab.com/blog/2020/04/17/dotfiles-document-and-automate-your-macbook-setup/
sudo -v

# Core CLI Tools
ln -s ~/.config/.zshrc ~/.zshrc
ln -s ~/.config/.gitconfig ~/.gitconfig
ln -s ~/.config/.zprofile ~/.zprofile

# Initialize new settings
source ~/.zshrc