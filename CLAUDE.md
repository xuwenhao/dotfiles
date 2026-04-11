# CLAUDE.md

## Project overview

Personal dotfiles repo using GNU Stow. Each top-level directory (e.g. `kitty/`) is a stow package mirroring `$HOME`.

## Key files

- `kitty/.config/kitty/kitty.conf` — main kitty config (layout, tabs, colors). Ends with `include sidebar.conf`, which pulls in keybindings + remote control config from the separate [kitty-sidebar](../kitty-sidebar) repo when that package is stowed.

## Related repos

The sidebar kitten (`sidebar.py`, `sidebar_ctl.py`, `sidebar.conf`) lives in a separate repo at `~/Codebase/personal/kitty-sidebar`. See that repo's CLAUDE.md for its architecture notes (dual-mode design, socket discovery, width clamping).

## Stow usage

This repo lives at `~/Codebase/personal/dotfiles`, not `~/dotfiles`, so stow's default parent-directory target won't work. Always specify `$HOME` explicitly:

```bash
stow --no-folding -t "$HOME" <package>
```

## Conventions

- Catppuccin Mocha color palette throughout
- Chinese comments in kitty.conf are intentional — keep them
- Tab titles use a `p:` prefix convention for custom names; otherwise fall back to working directory basename
