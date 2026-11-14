# Fresh [![Thanks](https://bit.ly/saythankss)](https://github.com/sponsors/corb3t)
Starting a fresh install of macOS and linux can be such a pain - all of your apps are gone and none of your settings are configured. Here's a collection of scripts, applications, CLI tools, extensions, config files, and dotfiles that make re-installing a breeze.

## Warning
If you are interested in setting up dotfiles, you should fork this repository, review the code, and remove and edit any things you don’t want or need. Use at your own risk!

## Start Here
Clone this repo, then let `sync.sh` link the config files into place.

```
git clone https://github.com/corb3t/fresh.git ~/Developer/Github/fresh
cd ~/Developer/Github/fresh
```

## Install Brew
[Brew](https://brew.sh/) lets macOS and Linux users install applications from the command line. This lets users easily script and automate their app installation and configuration process using my fresh repo.

```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

## Install Brew Apps

```
brew bundle --file Brewfile
```

## Setup macOS Settings

```
source setup-macos.sh
```

## Link the terminal config
`sync.sh` is a dry run until you pass `--apply`. It creates `~/.fresh`, a link to this clone, and links the shell, prompt, Ghostty and Topgrade config through it. Anything it replaces is moved to a backup folder first.

```
bash sync.sh link            # show what would change
bash sync.sh link --apply    # do it
bash sync.sh check           # links, syntax, secret scan, Brewfile drift
```

| Linked path | Source in this repo |
|---|---|
| `~/.zshenv`, `~/.zprofile`, `~/.zshrc` | `dot-config/zsh/` |
| `~/.config/starship.toml` | `dot-config/starship.toml` |
| `~/.config/ghostty/config` | `dot-config/ghostty/config` |
| `~/.config/topgrade.toml` | `dot-config/topgrade.toml` |

Machine-specific settings stay out of this repo. Each tool reads one optional local file: `~/.zshrc.local`, `~/.config/ghostty/local` and `~/.config/topgrade.d/local.toml`. Starting points are in `examples/`. I keep mine in my private `agent-config` repo, one folder per machine.

Other commands: `sync.sh brew` reports Brewfile drift in both directions, `sync.sh parity <host>` compares two Macs over SSH, and `sync.sh rollback <stamp> --apply` undoes a link run.

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
`topgrade` updates Homebrew, casks, App Store apps and more in one run. The shared config is `dot-config/topgrade.toml`.

```
topgrade
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