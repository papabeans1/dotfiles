if [ -f "$HOME/.local/bin/env" ]; then
  . "$HOME/.local/bin/env"
fi

path_prepend() {
  case ":$PATH:" in
    *":$1:"*) ;;
    *) PATH="$1:$PATH" ;;
  esac
}

if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

path_prepend "/opt/homebrew/opt/dotnet@9/bin"
path_prepend "$HOME/.pixi/bin"

export DOTNET_ROOT="/opt/homebrew/opt/dotnet@9/libexec"
export NVM_DIR="${NVM_DIR:-$HOME/.nvm}"
