# CLAUDE.md

## Project overview

Personal dotfiles repo using GNU Stow. Each top-level directory (e.g. `kitty/`) is a stow package mirroring `$HOME`.

## Key files

- `kitty/.config/kitty/kitty.conf` — main kitty config (layout, tabs, colors, keybindings)
- `kitty/.config/kitty/sidebar.py` — sidebar kitten TUI (runs inside kitty via `kitty +runpy`). Uses the `kittens.tui.handler.Handler` base class with an asyncio event loop.
- `kitty/.config/kitty/sidebar_ctl.py` — standalone controller for toggle/new-tab. Runs as a background process, talks to kitty via `kitty @` remote control over a unix socket.

## Architecture notes

### Sidebar dual-mode design

`sidebar.py` operates in two modes:
- **Kitten mode** (`main()` / `handle_result()`): invoked via `kitty +kitten`, actions return to boss via `result_handler`
- **Standalone mode** (`run_standalone()`): invoked via `kitty +runpy`, executes actions directly via `kitty @` remote control. This is the primary mode used by the keybindings.

### Socket discovery

Background processes (launched with `--type=background`) don't inherit `KITTY_LISTEN_ON`. The controller (`sidebar_ctl.py`) uses glob-based socket discovery (`/tmp/kitty.sock-*`) as fallback.

### Width clamping

The sidebar uses `--bias=20` for initial split, then queries actual geometry via `kitty @ ls` and resizes to `total_cols * 0.20` clamped to `[SIDEBAR_MIN_COLS, SIDEBAR_MAX_COLS]`.

## Conventions

- Catppuccin Mocha color palette throughout
- Chinese comments in kitty.conf are intentional — keep them
- Tab titles use a `p:` prefix convention for custom names; otherwise fall back to working directory basename
