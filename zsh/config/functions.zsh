# =============================================================================
# ZSH FUNCTIONS CONFIGURATION
# =============================================================================
# This file contains all functions used in the Zsh shell configuration.
# It is sourced by the main .zshrc file.

# -----------------------------------------------------------------------------
# Utility Functions
# -----------------------------------------------------------------------------

# Create a new directory and enter it
mkcd() {
  mkdir -p "$1" && cd "$1"
}

# Extract various compressed file formats
extract() {
  if [ -f $1 ] ; then
    case $1 in
      *.tar.bz2)   tar xjf $1     ;;
      *.tar.gz)    tar xzf $1     ;;
      *.bz2)       bunzip2 $1     ;;
      *.rar)       unrar e $1     ;;
      *.gz)        gunzip $1      ;;
      *.tar)       tar xf $1      ;;
      *.tbz2)      tar xjf $1     ;;
      *.tgz)       tar xzf $1     ;;
      *.zip)       unzip $1       ;;
      *.Z)         uncompress $1  ;;
      *.7z)        7z x $1        ;;
      *)           echo "'$1' cannot be extracted via extract()" ;;
    esac
  else
    echo "'$1' is not a valid file"
  fi
}

# Find a file with a pattern in name
findfile() {
  find . -type f -name "*$1*"
}

# -----------------------------------------------------------------------------
# Development Functions
# -----------------------------------------------------------------------------

# Create a new git branch and switch to it
gitbr() {
  git checkout -b "$1"
}

# -----------------------------------------------------------------------------
# System Functions
# -----------------------------------------------------------------------------

# Show system information
sysinfo() {
  echo "OS: $(uname -s)"
  echo "Kernel: $(uname -r)"
  echo "Hostname: $(hostname)"
  echo "Uptime: $(uptime | cut -d ',' -f1)"
  echo "Shell: $SHELL"
  echo "Terminal: $TERM"
}

# -----------------------------------------------------------------------------
# WSL: auto-start the Docker daemon
# -----------------------------------------------------------------------------
# On WSL without systemd the Docker daemon does not start automatically. This
# starts it via the service command on the first interactive shell if it is
# installed but not yet running. Safe to source elsewhere: it no-ops when not
# on WSL, when docker is absent, or when the daemon is already up.
if [[ -o interactive ]] && grep -qi microsoft /proc/version 2>/dev/null; then
  if command -v docker >/dev/null 2>&1; then
    # Only act if the daemon is not already responding
    if ! docker info >/dev/null 2>&1; then
      # Prefer systemd if it is managing docker; otherwise use the service
      if command -v systemctl >/dev/null 2>&1 && systemctl is-enabled docker >/dev/null 2>&1; then
        sudo systemctl start docker 2>/dev/null
      else
        sudo service docker start >/dev/null 2>&1
      fi
    fi
  fi
fi

# -----------------------------------------------------------------------------
# Homebrew "source-first" helper commands (macOS only)
# -----------------------------------------------------------------------------
if [[ "$(uname -s)" == "Darwin" ]]; then

# Install formula from source (no bottle)
brewi() {
  if [[ -z "$1" ]]; then
    echo "usage: brewi <formula> [extra brew args]" >&2
    return 2
  fi
  brew install --build-from-source "$@"
}

# Reinstall formula from source
brewr() {
  if [[ -z "$1" ]]; then
    echo "usage: brewr <formula> [extra brew args]" >&2
    return 2
  fi
  brew reinstall --build-from-source "$@"
}

# Upgrade everything from source
brewu() {
  brew upgrade --build-from-source "$@"
}

# Upgrade only the outdated formulas, one-by-one, from source (more explicit logs)
brewupd() {
  # Update metadata first
  brew update || return $?

  # List outdated formulae (ignore casks here)
  local pkgs
  pkgs=($(brew outdated --formula --quiet))

  if (( ${#pkgs[@]} == 0 )); then
    echo "No outdated formulae."
    return 0
  fi

  echo "Upgrading from source (${#pkgs[@]}): ${pkgs[*]}"
  local p
  for p in "${pkgs[@]}"; do
    echo "==> brew upgrade --build-from-source $p"
    brew upgrade --build-from-source "$p" || return $?
  done
}

# Optional: show which formulae are outdated
brewout() {
  brew outdated --formula
}

fi
