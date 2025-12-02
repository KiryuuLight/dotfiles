# Bob Nvim Manager
export PATH=$PATH:/home/light/.local/share/bob/nvim-bin

# Zoxide
eval "$(zoxide init zsh)"

# Editor
export EDITOR='nvim'
# Mise
eval "$(/home/light/.local/bin/mise activate zsh)"
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

source /usr/share/zsh-antidote/antidote.zsh

# Plugins
antidote load ~/.config/antidote/plugins.txt
