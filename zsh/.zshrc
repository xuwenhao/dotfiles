# --- oh-my-zsh ---
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
DISABLE_AUTO_TITLE="true"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting)
source $ZSH/oh-my-zsh.sh

# --- Kitty tab title: git repo name or directory name ---
if [[ "$TERM" == "xterm-kitty" || -n "$KITTY_WINDOW_ID" ]]; then
  function _set_kitty_tab_title() {
    local git_root
    git_root=$(git rev-parse --show-toplevel 2>/dev/null)
    local title="${git_root:+${git_root:t}}"
    title="${title:-${PWD:t}}"
    [[ "$title" == "$USER" ]] && title="~"
    printf '\e]2;p:%s\a' "$title"
  }
  precmd_functions+=(_set_kitty_tab_title)
fi

# --- Conda ---
if [[ "$(uname)" == "Darwin" ]]; then
    _conda_base="/opt/homebrew/Caskroom/miniconda/base"
else
    _conda_base="$HOME/miniconda3"
fi
__conda_setup="$("$_conda_base/bin/conda" 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "$_conda_base/etc/profile.d/conda.sh" ]; then
        . "$_conda_base/etc/profile.d/conda.sh"
    else
        export PATH="$_conda_base/bin:$PATH"
    fi
fi
unset __conda_setup _conda_base

# --- PATH ---
export PATH="$HOME/.local/bin:$PATH"

# --- nvm ---
export NVM_DIR="$HOME/.nvm"
if [[ "$(uname)" == "Darwin" ]]; then
    [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"
else
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
fi

# --- External sources (credentials & tools) ---
[[ -f ~/.zsh_credentials ]] && source ~/.zsh_credentials
[[ -f ~/.litellm_proxy.zsh ]] && source ~/.litellm_proxy.zsh

# --- Claude Code ---
alias ccd='claude --dangerously-skip-permissions'
