# Fresh [![Thanks](https://bit.ly/saythankss)](https://github.com/sponsors/corb3t)
Starting a fresh install of macOS and linux can be such a pain - all of your apps are gone and none of your settings are configured. Here's a collection of scripts, applications, CLI tools, extensions, config files, and dotfiles that make re-installing a breeze.

## Warning
If you are interested in setting up dotfiles, you should fork this repository, review the code, and remove and edit any things you don’t want or need. Use at your own risk!

## Start Here
Clone this repo to the hidden ~/.config directory in your home directory to restore your app's configuration files!

Run this:
```
git clone https://github.com/corb3t/fresh.git ~/.config
cd ~/.config
```

## Install Brew
[Brew](https://brew.sh/) lets macOS and Linux users install applications from the command line. This lets users easily script and automate their app installation and configuration process using my fresh repo.

Enter the following in terminal:

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Install Brew Apps
To install off your apps outlined in the Brewfile, enter the following in terminal to run a script that will download as many app as possible using homebrew.

```
brew bundle --file ~/.config/Brewfile
```

## Setup macOS Settings

```
source ~/.config/setup-macos.sh
```

## Setup symlinks

```
source ~/.config/setup-symlinks.sh
```

## Developer and AI Agent Setup

`fresh` sets up the machine. Everything about how AI coding agents work on my projects lives in a separate private repo, `agent-config`: shared `AGENTS.md` instructions for Claude Code, Codex and Gemini, skills, a project scaffold, a git pre-commit guard, background git sync between my Macs, and a manifest of every project repo. It's private because it holds my profile and machine names. The pattern works for anyone. Keep the public machine layer here and the personal agent layer in a private repo.

After the steps above:

```
gh auth login
gh repo clone Corb3t/agent-config ~/Developer/agent-config
bash ~/Developer/agent-config/bootstrap.sh --apply
```

That links the agent instructions into each tool, installs the git guard and sync jobs, and clones every project into the same path it has on my other Macs. Every project is a private GitHub repo. Agents work on branches and open pull requests, and merging to `main` deploys through GitHub Actions.

The `Claude/` folder in this repo is the earlier version of the scaffold, kept for reference. The current one is in `agent-config`. The write-up of the original is at [corbet.app/writing/scaffold-sh](https://corbet.app/writing/scaffold-sh).

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

## Upgrading Apps
Enter the following command to update and remove any leftover brew files

```
brew update && brew upgrade && brew autoremove && brew cleanup
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