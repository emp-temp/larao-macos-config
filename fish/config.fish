if status is-interactive
    eval "$(/opt/homebrew/bin/brew shellenv)"
end

set --universal nvm_default_version v22.12.0

set -x XDG_CONFIG_HOME $HOME/.config
