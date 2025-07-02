_env_secrets_load() {
  [[ -z "$ENV_SECRETS" ]] && return

  local backends=(pass security)
  local backend
  if [[ -n "$ENV_SECRETS_BACKEND" ]]; then
    # Check that requesting backend is supported
    if (( ! ${backends[(Ie)$ENV_SECRETS_BACKEND]} )); then
      [[ -z "$ENV_SECRETS_QUIET" ]] && echo "zsh-env-secrets: unsupported backend: '$ENV_SECRETS_BACKEND'" >&2
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

  if [[ -z "$ENV_SECRETS_BACKEND" ]]; then
    [[ -z "$ENV_SECRETS_QUIET" ]] && echo "zsh-env-secrets: no supported backends found" >&2
    return
  fi

  local secret env_var secret_path value
  for secret in "${ENV_SECRETS[@]}"; do
    env_var="${secret%%:*}"
    if [[ "$secret" == "$env_var" ]]; then
      secret_path="$env_var"
    else
      secret_path="${secret#*:}"
    fi

    case "$ENV_SECRETS_BACKEND" in
      pass)
        value=$(pass show "$secret_path" 2>/dev/null) ;;
      security)
        value=$(security find-generic-password -w -l "$secret_path" 2>/dev/null) ;;
    esac

    if [[ -n "$value" ]]; then
      export "$env_var=$value"
    else
      [[ -z "$ENV_SECRETS_QUIET" ]] && echo "zsh-env-secrets: failed to load secret: '$secret_path'" >&2
    fi
  done
}

_env_secrets_load

