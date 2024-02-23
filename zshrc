# Init completion
autoload -Uz compinit && compinit

source ~/Developer/apps/zsh-syntax-highlighting/themes/catppuccin_macchiato-zsh-syntax-highlighting.zsh
source ~/.keys.zsh

# load omz plugins
source ~/.oh-my-zsh/plugins/tmux/tmux.plugin.zsh
source ~/.oh-my-zsh/plugins/git/git.plugin.zsh
source ~/.oh-my-zsh/plugins/git-flow/git-flow.plugin.zsh

# history setup
setopt SHARE_HISTORY
HISTFILE=$HOME/.zhistory
SAVEHIST=1000
HISTSIZE=999
setopt HIST_EXPIRE_DUPS_FIRST

export EDITOR='nvim'
alias vi='nvim'

alias ls=lsd
[[ -n "$TMUX" ]] && alias clear="clear && tmux clear-history"
alias o='/usr/bin/open .'

# autocompletion for ssh hosts
h=()
if [[ -r ~/.ssh/config ]]; then
  h=($h ${${${(@M)${(f)"$(cat ~/.ssh/config)"}:#Host *}#Host }:#*[*?]*})
fi
if [[ -r ~/.ssh/known_hosts ]]; then
  h=($h ${${${(f)"$(cat ~/.ssh/known_hosts{,2} || true)"}%%\ *}%%,*}) 2>/dev/null
fi
if [[ $#h -gt 0 ]]; then
  zstyle ':completion:*:ssh:*' hosts $h
  zstyle ':completion:*:slogin:*' hosts $h
fi

# yarn
alias y='yarn'
alias yi='yarn install'
alias yu='yarn upgrade'
alias yd='yarn run dev'
alias yw='yarn run watch'

# git
alias nah="git reset --hard; git clean -df"
alias gl="git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"
#alias gresolve='s $(git diff --name-only --diff-filter=U)'

# postgresql
alias pg_start="pg_ctl -D /usr/local/var/postgres -l /usr/local/var/postgres/server.log start"
alias pg_stop="pg_ctl -D /usr/local/var/postgres stop -s -m fast"

# clear cache
alias dns_clear="sudo killall -HUP mDNSResponder;sudo killall mDNSResponderHelper;sudo dscacheutil -flushcache"

#
alias bfg="java -jar /Users/benjamin/bin/bfg.jar"
alias bundletool="java -jar /Users/benjamin/bin/bundletool.jar"

alias lg='lazygit'

alias vpharma="sudo openfortivpn -c ~/.openfortivpn"

#export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# pnpm
export PNPM_HOME="/Users/benjamin/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
alias p='pnpm'
alias pi='pnpm install'
alias pu='pnpm upgrade'
alias pd='pnpm dev'
alias pw='pnpm watch'
# pnpm end

#export JAVA_HOME=/Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home
#export JAVA_HOME=/Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Home
#export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-11.jdk/Contents/Home
export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-17.jdk/Contents/Home

export FLUTTER_HOME=/Users/benjamin/Developer/flutter/2.2.3
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$JAVA_HOME/bin:$HOME/Developer/apps/nvim-macos/bin:$HOME/.yarn/bin:$PATH
export PATH=$FLUTTER_HOME/bin:$PATH
export PATH="/usr/local/sbin:$PATH"

# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/zsh/__tabtab.zsh ]] && . ~/.config/tabtab/zsh/__tabtab.zsh || true

[[ -f /usr/local/bin/trash ]] && alias rm="/usr/local/bin/trash"

# bun completions
[ -s "/Users/benjamin/.bun/_bun" ] && source "/Users/benjamin/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# case sensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

eval "$(starship init zsh)"
eval "$(zoxide init zsh --cmd cd)"
