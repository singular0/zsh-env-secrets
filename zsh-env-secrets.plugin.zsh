_env_secrets_load() {
  [[ -z "$ENV_SECRETS" ]] && return

  local backends=(pass security)
  local backend
  if [[ -n "$ENV_SECRETS_BACKEND" ]]; then
    # Check that requesting backend is supported
    if [[ " ${arr[@]} " != *" $ENV_SECRETS_BACKEND "* ]]; then
      echo "zsh-env-secrets: unsupported backend: '$ENV_SECRETS_BACKEND'" >&2
      return
    fi
  else
    # Detect available backend
    for backend in "${backends[@]}"; do
      if (( ${+commands[$backend]} )); then
        ENV_SECRETS_BACKEND=$backend
        break
      fi
    done
  fi

  [[ -z "$ENV_SECRETS_BACKEND" ]] && return

  local secret env_var secret_path value
  for secret in "${ENV_SECRETS[@]}"; do
    env_var="${secret%%:*}"
    secret_path="${secret#*:}"
    [[ "$secret" == "$env_var" ]] && secret_path="$env_var"

    case "$ENV_SECRETS_BACKEND" in
      pass)
        value=$(pass show "$secret_path" 2>/dev/null) ;;
      security)
        value=$(security find-generic-password -w -l "$secret_path" 2>/dev/null) ;;
    esac
    if [[ -n "$value" ]]; then
      export "$env_var"="$value"
    else
      echo "zsh-env-secrets: failed to load secret: '$secret_path'" >&2
    fi
  done
}

[[ -n "$ENV_SECRETS" ]] && _env_secrets_load

