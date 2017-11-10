#!/data/data/com.termux/files/usr/bin/bash

while [[ $# -gt 0 ]]; do
    case $1 in
        -e|--elixir)
            elixir=true;;
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
        read -r reply </dev/tty

        if [ -z "$reply" ]; then
            reply=$default
        fi

        case "$reply" in
            Y*|y*) return 0 ;;
            N*|n*) return 1 ;;
        esac

    done
}

function install_elixir {
  mkdir "$HOME/.elixir" && cd "$HOME/.elixir"
  echo "[ elixir ] downloading"
  curl -L https://github.com/elixir-lang/elixir/releases/download/v1.5.2/Precompiled.zip > Precompiled.zip > /dev/null 2>&1
  unzip Precompiled.zip && rm Precompiled.zip && cd bin
  echo "[ elixir ] fixing binaries"
  termux-fix-shebang elixir elixirc iex mix
  echo 'export PATH="$PATH:$HOME/.elixir/bin"' >> "$HOME/.profile"
  cd "$HOME"
  echo "[ elixir ] restart termux"
}

clear

if ! [ -x "$(command -v git)" ]; then
  echo "[ git ] not found, installing"
  apt-get install -y git > /dev/null 2>&1
fi

if [ -d "$HOME/.termux" ]; then
  if ask "[ termux ] configs found, overwrite?" Y; then
    rm -rf "$HOME/.termux"
    curl -fsLo "$HOME/.termux/colors.properties" --create-dirs https://cdn.rawgit.com/onlurking/termux/master/.termux/colors.properties
    curl -fsLo "$HOME/.termux/font.ttf" --create-dirs https://cdn.rawgit.com/onlurking/termux/master/.termux/font.ttf
  fi
else
  echo "[ termux ] downloading configs"
  curl -fsLo "$HOME/.termux/colors.properties" --create-dirs https://cdn.rawgit.com/onlurking/termux/master/.termux/colors.properties
  curl -fsLo "$HOME/.termux/font.ttf" --create-dirs https://cdn.rawgit.com/onlurking/termux/master/.termux/font.ttf
fi

if [ $zsh ];then
    if ! [ -x "$(command -v zsh)" ]; then
      echo "[ zsh ] not found, installing"
      apt-get install -y zsh > /dev/null 2>&1
    fi
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo "[ oh-my-zsh ] clonning repository"
        git clone git://github.com/robbyrussell/oh-my-zsh.git "$HOME/.oh-my-zsh" --depth 1 --quiet > /dev/null
    else
      if ask "[ oh-my-zsh ] configs found, overwrite?" Y; then
          rm -rf "$HOME/.oh-my-zsh"
          git clone git://github.com/robbyrussell/oh-my-zsh.git "$HOME/.oh-my-zsh" --depth 1 --quiet > /dev/null
      fi
    fi
    curl -fsLo "$HOME/.oh-my-zsh/themes/lambda-mod.zsh-theme" https://cdn.rawgit.com/onlurking/termux/master/.termux/lambda-mod.zsh-theme
    curl -fsLo "$HOME/.zshrc" https://cdn.rawgit.com/onlurking/termux/master/.termux/.zshrc
    curl -fsLo "$HOME/.profile" https://cdn.rawgit.com/onlurking/termux/master/.termux/.profile
    if ask "[ oh-my-zsh ] enable syntax highlighting?" Y; then
      echo "[ oh-my-zsh ] downloading plugin"
      git clone git://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting" --quiet > /dev/null
    else
      sed -i '4s/.*/plugins=(git)/' "$HOME/.zshrc"
    fi
    chsh -s zsh
fi

if [ $elixir ];then
  if ! [ -x "$(command -v erl)" ]; then
    echo "[ erlang ] not found, installing"
    apt-get install -y erlang > /dev/null 2>&1
  fi
  if [ ! -d "$HOME/.elixir" ]; then
    install_elixir
  else
    if ask "[ elixir ] found, overwrite?" Y; then
      rm -rf "$HOME/.elixir"
      install_elixir
    fi
  fi
fi

if ask "[ storage ] setup external storage?" Y; then
    termux-setup-storage
fi

if ask "[ termux ] hide welcome message?" Y; then
    touch "$HOME/.hushlogin"
fi

if ask "[ finished ] close termux to apply settings?" Y; then
    pkill termux
else
    echo "[ warning ] please restart termux to apply settings"
fi

exit
