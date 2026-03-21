# --- oh-my-zsh ---
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
DISABLE_AUTO_TITLE="true"
plugins=(git)
source $ZSH/oh-my-zsh.sh

# --- Kitty tab title: git repo name or directory name ---
function _set_kitty_tab_title() {
  local git_root
  git_root=$(git rev-parse --show-toplevel 2>/dev/null)
  local title="${git_root:+${git_root:t}}"
  title="${title:-${PWD:t}}"
  [[ "$title" == "$USER" ]] && title="~"
  printf '\e]2;p:%s\a' "$title"
}
precmd_functions+=(_set_kitty_tab_title)

# --- Conda ---
__conda_setup="$('/opt/homebrew/Caskroom/miniconda/base/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/Caskroom/miniconda/base/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/Caskroom/miniconda/base/bin:$PATH"
    fi
fi
unset __conda_setup

# --- PATH ---
export PATH="$HOME/.local/bin:$PATH"

# --- nvm ---
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"

# --- External sources (credentials & tools) ---
[[ -f ~/.zsh_credentials ]] && source ~/.zsh_credentials
[[ -f ~/.litellm_proxy.zsh ]] && source ~/.litellm_proxy.zsh

# --- Claude Code ---
alias ccd='claude --dangerously-skip-permissions --sandbox'
