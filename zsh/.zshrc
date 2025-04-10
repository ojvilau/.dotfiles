zmodload -F zsh/parameter p:aliases

cd
export COLORTERM=truecolor
export PATH=$PATH:/usr/local/go/bin
export NODE_OPTIONS=--max_old_space_size=8192

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
# ZSH_THEME="random"

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
plugins=(git ssh-agent zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
# Set up fzf key bindings and fuzzy completion
eval "$(fzf --zsh)"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
alias v="$HOME/.appimages/nvim.appimage"
alias t="tmux -f $HOME/.config/tmux/tmux.conf"
alias gprunelist="git fetch -p && git branch -vv | grep ': gone]' | grep -v \"\\*\" | awk '{ print \$1; }'"
alias gprune="$aliases[gprunelist] | xargs -r git branch -D"

export VOLTA_HOME="$HOME/.volta"
export PATH="$VOLTA_HOME/bin:$PATH"

# bun completions
[ -s "/home/ojvilau/.bun/_bun" ] && source "/home/ojvilau/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

eval "$(starship init zsh)"

vf() {
  local selection
  selection=$(fzf --walker-root="$HOME" --walker=dir)
  if [ -n "$selection" ]; then
    cd "$selection"
    $aliases[v] .
  else
    echo "No directory selected."
  fi
}

vfw() {
  local selection
  selection=$(fzf --walker-root="$HOME/projects" --walker=dir)
  if [ -n "$selection" ]; then
    cd "$selection"
    $aliases[v] .
  else
    echo "No directory selected."
  fi
}

cdf() {
  local selection
  selection=$(fzf --walker-root="$HOME" --walker=dir,hidden)
  if [ -n "$selection" ]; then
    cd "$selection"
  else
    echo "No directory selected."
  fi
}

cdw() {
  local selection
  selection=$(fzf --walker-root="$HOME/projects" --walker=dir)
  if [ -n "$selection" ]; then
    cd "$selection"
  else
    echo "No directory selected."
  fi
}

