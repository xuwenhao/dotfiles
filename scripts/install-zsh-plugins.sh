#!/usr/bin/env bash

set -euo pipefail

if ! command -v brew >/dev/null 2>&1; then
  echo "Homebrew is required for this script." >&2
  exit 1
fi

brew_prefix="$(brew --prefix)"
zsh_root="${ZSH:-$HOME/.oh-my-zsh}"
zsh_custom="${ZSH_CUSTOM:-$zsh_root/custom}"
plugins_dir="$zsh_custom/plugins"

mkdir -p "$plugins_dir"
for formula in zsh-autosuggestions zsh-syntax-highlighting; do
  if ! brew list --versions "$formula" >/dev/null 2>&1; then
    brew install "$formula"
  fi
done

mkdir -p "$plugins_dir/zsh-autosuggestions" "$plugins_dir/zsh-syntax-highlighting"

ln -sfn \
  "$brew_prefix/share/zsh-autosuggestions/zsh-autosuggestions.zsh" \
  "$plugins_dir/zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"
ln -sfn \
  "$brew_prefix/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" \
  "$plugins_dir/zsh-syntax-highlighting/zsh-syntax-highlighting.plugin.zsh"

echo "Installed and linked zsh plugins into $plugins_dir"
