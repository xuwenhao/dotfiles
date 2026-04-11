# dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/). Each top-level directory is a stow package that mirrors the home directory structure.

## Structure

```
dotfiles/
  kitty/                    # kitty terminal emulator
    .config/kitty/
      kitty.conf            # main config (tabs, layout, colors)
  zsh/                      # zsh configuration
    .zshrc                  # oh-my-zsh + conda/nvm (cross-platform)
    .litellm_proxy.zsh      # LiteLLM proxy helper
```

## Installation

```bash
cd ~/Codebase/personal/dotfiles
stow --no-folding -t "$HOME" kitty zsh
```

### Zsh plugin dependencies

`zsh/.zshrc` enables `zsh-autosuggestions` and
`zsh-syntax-highlighting` through oh-my-zsh, so install them before
starting a new shell.

On macOS with Homebrew, run:

```bash
./scripts/install-zsh-plugins.sh
```

The script installs both formulas and symlinks them into
`${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins`, which is where
oh-my-zsh expects external plugins.

Manual equivalent:

```bash
brew install zsh-autosuggestions zsh-syntax-highlighting
mkdir -p "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"
mkdir -p "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
mkdir -p "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
ln -sfn "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh" \
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"
ln -sfn "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" \
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh"
```

Or clone them into oh-my-zsh's custom plugin directory:

```bash
git clone https://github.com/zsh-users/zsh-autosuggestions \
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-autosuggestions"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
  "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting"
```

### SSH terminfo setup

When SSHing from a terminal with a custom TERM value (Ghostty, Kitty, etc.), the remote machine may lack the terminfo entry, causing display artifacts. Export it from the local machine:

```bash
infocmp xterm-ghostty | ssh <host> 'tic -x -'   # Ghostty
infocmp xterm-kitty   | ssh <host> 'tic -x -'   # Kitty
```

## Kitty

### Tab bar

Powerline-style tab bar (Catppuccin Mocha theme) at the bottom. Tab titles show the index and working directory name.

### Sidebar

The sidebar kitten lives in its own repo at `~/Codebase/personal/kitty-sidebar`. `kitty.conf` does `include sidebar.conf`, so stowing the kitty-sidebar package alongside these dotfiles activates it automatically:

```bash
cd ~/Codebase/personal/kitty-sidebar
stow --no-folding -t "$HOME" kitty
```

If the package is not stowed, kitty will print a warning about the missing `sidebar.conf` at startup and continue loading the rest of the config.
