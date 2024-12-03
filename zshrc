bindkey -e

fpath=(~/.zsh/plugins/zsh-completions/src $fpath)

autoload -Uz compinit
typeset -i updated_at=$(date +'%j' -r ~/.zcompdump 2>/dev/null || stat -f '%Sm' -t '%j' ~/.zcompdump 2>/dev/null)
if [ $(date +'%j') != $updated_at ]; then
  compinit -i
else
  compinit -C -i
fi

source ~/.keys.zsh

# load omz plugins
source ~/.zsh/plugins/zsh-syntax-highlighting/themes/catppuccin_macchiato-zsh-syntax-highlighting.zsh
source ~/.zsh/tmux.plugin.zsh
source ~/.zsh/git.plugin.zsh
source ~/.zsh/git-flow.plugin.zsh

# history setup
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups
setopt SHARE_HISTORY

setopt auto_cd # cd by typing directory name if it's not a command

setopt auto_list # automatically list choices on ambiguous completion
setopt auto_menu # automatically use menu completion
setopt always_to_end # move cursor to end if word had one match

zstyle ':completion:*' menu select # select completions with arrow keys
zstyle ':completion:*' group-name '' # group results by category
zstyle ':completion:::::' completer _expand _complete _ignored _approximate # enable approximate matches for completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' # case-insensitive completion
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS} # use LS_COLORS for completion colors

source ~/.zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

export EDITOR='nvim'
alias vi='nvim'

alias ls='lsd'
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
alias bfg="java -jar /Users/benjamin/Developer/apps/bfg.jar"
alias bundletool="java -jar /Users/benjamin/bin/bundletool.jar"

alias lg='lazygit'

#export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

# pnpm
export PNPM_HOME="/Users/benjamin/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

declare -A tools
tools[n]=npm 
tools[p]=pnpm 
tools[y]=yarn 
tools[b]=bun

declare -A actions
actions[i]=install
actions[u]=update
actions[b]="run build"
actions[d]="run dev"
actions[w]="run watch"

# create aliases for tools and actions
# like pi -> pnpm install or bw -> bun watch
for key value in "${(@kv)tools}"; do
    # echo "$key -> $value"
    alias $key=$value

    for k v in "${(@kv)actions}"; do
        # echo "  $key$k -> $value $v"
        alias "$key$k"="$value $v"
    done
done

###-begin-pnpm-completion-###
if type compdef &>/dev/null; then
  _pnpm_completion () {
    local reply
    local si=$IFS

    IFS=$'\n' reply=($(COMP_CWORD="$((CURRENT-1))" COMP_LINE="$BUFFER" COMP_POINT="$CURSOR" SHELL=zsh pnpm completion-server -- "${words[@]}"))
    IFS=$si

    if [ "$reply" = "__tabtab_complete_files__" ]; then
      _files
    else
      _describe 'values' reply
    fi
  }
  compdef _pnpm_completion pnpm
fi
###-end-pnpm-completion-###

#export JAVA_HOME=/Library/Java/JavaVirtualMachines/adoptopenjdk-8.jdk/Contents/Home
#export JAVA_HOME=/Library/Java/JavaVirtualMachines/temurin-17.jdk/Contents/Home
#export JAVA_HOME=/Library/Java/JavaVirtualMachines/zulu-11.jdk/Contents/Home
export JAVA_HOME=/Library/Java/JavaVirtualMachines/openjdk17-zulu/Contents/Home

export FLUTTER_HOME=/Users/benjamin/Developer/flutter/2.2.3
export ANDROID_HOME=$HOME/Library/Android/sdk
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools

export PATH="$HOME/go/bin:$PATH"
export PATH="$HOME/.symfony5/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
export PATH="$HOME/.cargo/bin:$PATH"
export PATH=$PATH:$ANDROID_HOME/emulator
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$JAVA_HOME/bin:$HOME/Developer/apps/nvim-macos/bin:$PATH
export PATH=$FLUTTER_HOME/bin:$PATH
export PATH="$PATH:/Applications/WezTerm.app/Contents/MacOS"
export PATH="/usr/local/sbin:$PATH"
export PATH="/Applications/Sublime Text.app/Contents/SharedSupport/bin:$PATH"

alias s=subl

# tabtab source for packages
# uninstall by removing these lines
[[ -f ~/.config/tabtab/zsh/__tabtab.zsh ]] && . ~/.config/tabtab/zsh/__tabtab.zsh || true

[[ -f /usr/local/bin/trash ]] && alias rm="/usr/local/bin/trash"
[[ -f /opt/local/bin/trash ]] && alias rm="/opt/local/bin/trash"

# bun completions
[ -s "/Users/benjamin/.bun/_bun" ] && source "/Users/benjamin/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# case sensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

eval "$(starship init zsh)"
#eval "$(zoxide init zsh --cmd cd)"

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

