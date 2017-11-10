#!/data/data/com.termux/files/usr/bin/bash

function exists { hash "$1" 2>/dev/null; }

while [[ $# -gt 0 ]]; do
    case $1 in
        -t|--tmux)
            tmux=true;;
        -n| --nvim)
            nvimrc=true;;
        -z| --zsh)
            zsh=true;;
        *) echo "Unknown options:' $1"
    esac
    shift
done

function ask {
    # https://djm.me/ask
    local prompt default reply

    while true; do

        if [ "${2:-}" = "Y" ]; then
            prompt="Y/n"
            default=Y
        elif [ "${2:-}" = "N" ]; then
            prompt="y/N"
            default=N
        else
            prompt="y/n"
            default=
        fi

        echo -n "$1 [$prompt] "
        read reply </dev/tty

        if [ -z "$reply" ]; then
            reply=$default
        fi

        case "$reply" in
            Y*|y*) return 0 ;;
            N*|n*) return 1 ;;
        esac

    done
}

if ! [ exists git ];then
  apt install -y git
fi

if [ -d "$HOME/.termux" ]; then
  if ask "Termux configs exists already, do you want to overwrite?" Y; then
    rm -rf $HOME/.termux
    curl -fsLo $HOME/.termux/colors.properties --create-dirs https://cdn.rawgit.com/onlurking/termux/master/.termux/colors.properties
    curl -fsLo $HOME/.termux/font.ttf --create-dirs https://cdn.rawgit.com/onlurking/termux/master/.termux/font.ttf
  else
    return 1
  fi
else
  curl -fsLo $HOME/.termux/colors.properties --create-dirs https://cdn.rawgit.com/onlurking/termux/master/.termux/colors.properties
  curl -fsLo $HOME/.termux/font.ttf --create-dirs https://cdn.rawgit.com/onlurking/termux/master/.termux/font.ttf
fi

if [ $zsh ];then
    if ! [ exists zsh ]; then
      apt install -y zsh
    fi
    if [ ! -d "$HOME/.oh-my-zsh" ]; then # check if directory exists
        git clone git://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh --depth 1
    else
      if ask "oh-my-zsh is already installed, do you want to overwrite?" Y; then
          rm -rf $HOME/.oh-my-zsh
          git clone git://github.com/robbyrussell/oh-my-zsh.git $HOME/.oh-my-zsh --depth 1
      else
          return 1
      fi
    fi
    curl -fsLo $HOME/.oh-my-zsh/themes/lambda-mod.zsh-theme https://cdn.rawgit.com/onlurking/termux/master/.termux/lambda-mod.zsh-theme
    curl -fsLo $HOME/.zshrc https://cdn.rawgit.com/onlurking/termux/master/.termux/.zshrc
    curl -fsLo $HOME/.profile https://cdn.rawgit.com/onlurking/termux/master/.termux/.profile
    if ask "Do you want syntax highlighting on zsh?" Y; then
      git clone git://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting
    fi
    chsh -s zsh
fi

if ask "Do you want to close Termux to apply the settings?" Y; then
    pkill termux
else
    echo "The settings will only be applied the next time you open Termux."
fi

if ask "Do you want setup external storage?" Y; then
    termux-setup-storage
fi

exit
