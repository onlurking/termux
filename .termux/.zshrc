export ZSH=$HOME/.oh-my-zsh
ZSH_THEME="lambda-mod"
VISUAL="nvim"
plugins=(git zsh-syntax-highlighting)

alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

alias cp="cp -rv"
alias rm="rm -rv"
alias mv="mv -v"

alias g="git"
alias gh="hub"

alias ka="kiall"
alias cl="clear"
alias h="history"
alias q="exit"

source $HOME/.profile
source $ZSH/oh-my-zsh.sh
