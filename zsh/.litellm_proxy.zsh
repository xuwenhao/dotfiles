# LiteLLM Proxy Configuration
# 凭证从 ~/.litellm_credentials 加载（不入版本控制）
# Usage: llm_proxy on / llm_proxy off / llm_proxy status

_LITELLM_CRED_FILE="$HOME/.litellm_credentials"

if [[ ! -f "$_LITELLM_CRED_FILE" ]]; then
  echo "[litellm_proxy] 凭证文件不存在: $_LITELLM_CRED_FILE"
  return 0
fi

source "$_LITELLM_CRED_FILE"

# 始终 export LiteLLM 凭证
export LITELLM_API_URL="$LITELLM_URL"
export LITELLM_API_KEY="$LITELLM_KEY"

# 模型名映射（无敏感信息，可入 git）
_PROXY_ANTHROPIC_MODEL="claude-opus-4-6-subscription"
_PROXY_SONNET_MODEL="claude-sonnet-4-6-subscription"
_PROXY_HAIKU_MODEL="claude-haiku-4-5-subscription"
_PROXY_OPUS_MODEL="claude-opus-4-6-subscription"
_PROXY_SUBAGENT_MODEL="claude-haiku-4-5-subscription"

llm_proxy() {
  case "$1" in
    on)
      export ANTHROPIC_BASE_URL="$LITELLM_URL"
      export ANTHROPIC_CUSTOM_HEADERS="x-litellm-api-key: Bearer $LITELLM_KEY"
      export ANTHROPIC_MODEL="$_PROXY_ANTHROPIC_MODEL"
      export ANTHROPIC_DEFAULT_SONNET_MODEL="$_PROXY_SONNET_MODEL"
      export ANTHROPIC_DEFAULT_HAIKU_MODEL="$_PROXY_HAIKU_MODEL"
      export ANTHROPIC_DEFAULT_OPUS_MODEL="$_PROXY_OPUS_MODEL"
      export CLAUDE_CODE_SUBAGENT_MODEL="$_PROXY_SUBAGENT_MODEL"
      echo "LiteLLM proxy: ON"
      ;;
    off)
      unset ANTHROPIC_BASE_URL ANTHROPIC_CUSTOM_HEADERS
      unset ANTHROPIC_MODEL ANTHROPIC_DEFAULT_SONNET_MODEL
      unset ANTHROPIC_DEFAULT_HAIKU_MODEL ANTHROPIC_DEFAULT_OPUS_MODEL
      unset CLAUDE_CODE_SUBAGENT_MODEL
      echo "LiteLLM proxy: OFF"
      ;;
    status)
      if [[ -n "$ANTHROPIC_BASE_URL" ]]; then
        echo "LiteLLM proxy: ON → $ANTHROPIC_BASE_URL"
      else
        echo "LiteLLM proxy: OFF"
      fi
      ;;
    *) echo "Usage: llm_proxy {on|off|status}"; return 1 ;;
  esac
}

# 默认开启代理
llm_proxy on
