# dotfiles

Personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/). Each top-level directory is a stow package that mirrors the home directory structure.

## Structure

```
dotfiles/
  kitty/                    # kitty terminal emulator
    .config/kitty/
      kitty.conf            # main config (tabs, layout, colors, keybindings)
      sidebar.py            # sidebar kitten — tab navigation TUI
      sidebar_ctl.py        # sidebar controller — toggle & new-tab helpers
  zsh/                      # zsh configuration
    .zshrc                  # oh-my-zsh + conda/nvm (cross-platform)
    .litellm_proxy.zsh      # LiteLLM proxy helper
```

## Installation

```bash
cd ~/Codebase/personal/dotfiles
stow --no-folding -t "$HOME" kitty zsh
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

A custom kitten that provides a side panel for tab management.

**Keybindings:**

| Key | Action |
|-----|--------|
| `ctrl+shift+s` | Toggle sidebar |
| `cmd+t` / `ctrl+shift+t` | New tab with sidebar |

**Inside the sidebar:**

| Key | Action |
|-----|--------|
| `j` / `k` / arrows | Navigate tabs |
| `1`–`9` | Jump to tab by number |
| `enter` | Switch to selected tab |
| `n` | New tab |
| `x` | Close selected tab |
| `q` / `esc` | Close sidebar |

**Width behavior:** The sidebar targets 20% of the terminal width, clamped between 40 and 60 columns. On a normal-sized window it stays at ~40 columns; on a wide or fullscreen monitor it scales up to 60.

**Auto-refresh:** The tab list refreshes every 2 seconds, so new tabs appear without any keypress.

**Tab switching:** When you switch tabs via the sidebar, it automatically spawns a new sidebar in the target tab (if one doesn't already exist) so navigation stays persistent.

### Security note

This config enables kitty's remote control via unix socket (`allow_remote_control yes` + `listen_on unix:/tmp/kitty.sock`). This allows any local process to send commands to kitty (read terminal content, resize windows, launch processes, etc.). The socket is PID-suffixed (`/tmp/kitty.sock-<PID>`) and protected by filesystem permissions, but if you run untrusted code locally, consider using `allow_remote_control socket-only` or reviewing your socket file permissions.

### Requirements

- [kitty](https://sw.kovidgoyal.net/kitty/) with remote control enabled (`allow_remote_control yes`)
- Socket configured via `listen_on unix:/tmp/kitty.sock`
- Layouts: `horizontal,splits,stack`
