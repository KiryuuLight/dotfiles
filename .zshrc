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

# Worktree picker
source ~/dotfiles-v2/scripts/wt.zsh
