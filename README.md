# zsh-env-secrets

`zsh-env-secrets` automatically retrieves secrets from secure storage backends and exports them as
environment variables during shell initialization. This eliminates the need to store sensitive
information in plain text configuration files.

## Installation

### Oh My Zsh

1. Clone the repository to your Oh My Zsh custom plugins directory:
   ```bash
   git clone https://github.com/singular0/zsh-env-secrets.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-env-secrets
   ```

2. Add the plugin to your `.zshrc`:
   ```bash
   plugins=(... zsh-env-secrets)
   ```

### Zplug

```bash
zplug "singular0/zsh-env-secrets"
```

## Configuration

Add the configuration to your `.zshrc` before the plugin loads:

```bash
# Define secrets to load
ENV_SECRETS=(
  "DATABASE_URL"
  "API_KEY:my-app/api-key"
  "SECRET_TOKEN:tokens/secret"
)

# Optional: specify backend (auto-detected if omitted)
ENV_SECRETS_BACKEND="pass"
```

### `ENV_SECRETS`

**Required.** An array of secrets to load. Each entry can be in one of two formats:

- `ENV_VAR_NAME:secret_path` - Maps environment variable to a specific secret path
- `ENV_VAR_NAME` - Uses the same name for both environment variable and secret path

### `ENV_SECRETS_BACKEND`

**Optional.** Explicitly specify which backend to use. If not set, the plugin will automatically
detect the first available backend from the supported list.

Supported values:
- `pass` - The standard Unix password manager
- `security` - macOS Keychain

## License

GNU GPLv3 - see [LICENSE](LICENSE) file for details.

