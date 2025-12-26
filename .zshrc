export PATH="$HOME/.local/bin:$PATH"
# FZF
source <(fzf --zsh)
# Bob Nvim Manager
export PATH=$PATH:/home/light/.local/share/bob/nvim-bin
# Zoxide
eval "$(zoxide init zsh)"
# Editor
export EDITOR='nvim'
# Mise
eval "$(mise activate zsh)"
# Starship
export STARSHIP_CONFIG=/home/light/.config/starship/starship.toml
eval "$(starship init zsh)"

# Aliases
alias vim='ESLINT_USE_FLAT_CONFIG=false nvim'
alias nvim='ESLINT_USE_FLAT_CONFIG=false nvim'
alias cd='z'
alias c='clear'
alias cat='bat' 
alias l='eza -lh --icons=auto'
alias ls='eza -1 --icons=auto'
alias ll='eza -lha --icons=auto --sort=name --group-directories-first'
alias ld='eza -lhD --icons=auto'
alias lt='eza --icons=auto --tree'
alias p='pnpm'
alias mkdir='mkdir -p'
alias config='cd ~/dotfiles-v2/'

# History
HISTFILE=~/.zsh_history

# Style
zstyle ':zsh-utils:plugins:history' use-xdg-basedirs no
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Plugins
source /usr/share/zsh-antidote/antidote.zsh
antidote load ~/.config/antidote/plugins.txt

# Autosuggestion keybindings
bindkey '^E' end-of-line              # Ctrl+E: accept full suggestion
bindkey '^F' forward-word             # Ctrl+F: accept next word

# Worktree picker
source ~/dotfiles-v2/scripts/wt.zsh

# Yazi wrapper (proper image cleanup and cd on exit)
function y() {
  local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
  # Force Überzug++ in Zellij, native Kitty otherwise
  if [[ -n "$ZELLIJ" ]]; then
    TERM=xterm-kitty yazi "$@" --cwd-file="$tmp"
  else
    yazi "$@" --cwd-file="$tmp"
  fi
  if cwd="$(cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}
