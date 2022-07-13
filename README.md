# Fresh
Starting a fresh install of macOS and linux can be such a pain - all of your apps are gone and none of your settings are configured. Here's a collection of scripts, applications, CLI tools, extensions, config files, and dotfiles that make re-installing a breeze.

## Warning 
If you are interested in setting up dotfiles, you should fork this repository, review the code, and remove and edit any things you don’t want or need. Use at your own risk!

## Start Here
Clone this repo to the hidden ~/.config directory in your home directory to restore your app's configuration files.

Run this:
```
git clone https://github.com/corb3t/fresh.git ~/.config
cd ~/.config
```

## Install Fonts
Navigate to /fresh/fonts and manually open all of the fonts in the folder. This will install them system-wide on your OS. MesloLGS NF provides really nice glyphs for your terminals:

[![Image of iTerm 2 with Oh My Zsh + MesloLGS NF + Powerlevel 10k Installed](https://i.postimg.cc/J0kLpCQ9/Clean-Shot-2022-07-13-at-12-53-19-2x.png)](https://postimg.cc/PvT9qc94)

## Install Brew
[Brew](https://brew.sh/) lets macOS and Linux users install applications from the command line. This lets users easily script and automate their app installation and configuration process using my fresh repo.

Enter the following in terminal:

``` 
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" 
```

## Install Apps
To install off your apps outlined in setup-brew.sh, enter the following in terminal to run a script that will download as many app as possible using homebrew.

``` 
source ~/.config/setup-brew.sh
```

## Setup macOS Settings

``` 
source ~/.config/setup-macos.sh
```

## Setup symlinks

``` 
source ~/.config/setup-symlinks.sh
```

## Install Other Apps
Download my favorite apps from the App store or independent websites:

* [Tot](https://tot.rocks/) - Tiny Quick Note-taking app
* [Meeter](https://www.trymeeter.com/) - Show upcoming meetings in your menubar and easily launch the appropriate app
* [Gestimer](http://maddin.io/gestimer/) - Easily set a reminder from your menubar
* [ColorSlurp](https://colorslurp.com/) - Color picker for macOS
* [Reeder 5](https://reederapp.com/) - RSS Reader, which uses a self-hosted instance of [FreshRSS](https://www.freshrss.org/) on my Unraid server
* [Scrobbles for Last.fm](https://apps.apple.com/us/app/scrobbles-for-last-fm/id1344679160?mt=12) - Tracks my music listening history

## Keyboard
Shortcuts: Disable Spotlight in preparation for enabling Alfred as default shortcut using cmd + space.

## Configure iTerm2
Create a new profile in Preferences > Profile named corbet
Colors > Color presets > Tango Light

Session > Status bar enabled and Configure Status Bar. Add git state, CPU utilization, Memory utilization. Click Auto-Rainbow.

Repeat the settings for the Dark profile
Mark dark profile and select Other Actions > Set as default.

Download the font files for https://github.com/romkatv/powerlevel10k#manual-font-installation from fonts/ and double-click to open them all to follow "Install Font".

Navigate to the iterm2 Preferences > Profiles > Text > Font and search for https://github.com/romkatv/powerlevel10k#manual-font-installation to select the font. Save and restart iTerm2.

## Upgrading Apps
You can enforce a reinstall by running the two commands below, the second command
only reinstalls all application casks.

``` 
brew reinstall $(brew list)

brew reinstall $(brew list --cask)
```

## Hire Me

Do you think I would be a valuable asset to your software development team? I am currently open to employment - e-mail me at me@corbet.dev! 

## Special Thanks

[Unofficial Guide to Github Dotfile](https://dotfiles.github.io/) - Great resource.

[dotfiles](https://github.com/pawelgrzybek/dotfiles) - Original inspiration for my dotfile creation
[Backing up VS Code with dotfiles and symlinks](https://pawelgrzybek.com/sync-vscode-settings-and-snippets-via-dotfiles-on-github/) - Backup up VS Code, a great app.

[Oh My Zsh + Powerlevel 10k Terminal](https://dev.to/abdfnx/oh-my-zsh-powerlevel10k-cool-terminal-1no0) - While Terminal is great, there are many great plugins for iterm 2 that make it great

[More dotfiles templates](https://gitlab.com/dnsmichi/dotfiles) - More dotfile inspos

[Another amazing dotfile guide](https://github.com/holman/dotfiles) - Helped me simplify this process.