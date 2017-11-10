#!/data/data/com.termux/files/usr/bin/bash

while [[ $# -gt 0 ]]; do
    case $1 in
        -e|--elixir)
            elixir=true;;
        -p|--python)
            python=true;;
        -n| --nvim)
            nvimrc=true;;
        -t| --tmux)
            tmux=true;;
        -z| --zsh)
            zsh=true;;
        *) echo -e "Unknown options:' $1"
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
  echo -e "\e[32m[ elixir ]\e[m downloading"
  curl -L https://github.com/elixir-lang/elixir/releases/download/v1.5.2/Precompiled.zip 2>/dev/null > Precompiled.zip
  unzip -qq  Precompiled.zip 1>/dev/null && rm Precompiled.zip && cd bin 
  echo -e "\e[32m[ elixir ]\e[m fixing binaries"
  termux-fix-shebang elixir elixirc iex mix
  echo 'export PATH="$PATH:$HOME/.elixir/bin"' >> "$HOME/.profile"
  cd "$HOME"
  echo -e "\e[32m[ elixir ]\e[m restart termux"
}

clear

if ! [ -x "$(command -v git)" ]; then
  echo -e "\e[32m[ git ]\e[m not found, installing"
  apt-get install -y git > /dev/null 2>&1
fi

if [ -d "$HOME/.termux" ]; then
  if ask "\e[32m[ termux ]\e[m configs found, overwrite?" Y; then
    rm -rf "$HOME/.termux"
    curl -fsLo "$HOME/.termux/colors.properties" --create-dirs https://cdn.rawgit.com/onlurking/termux/master/.termux/colors.properties
    curl -fsLo "$HOME/.termux/font.ttf" --create-dirs https://cdn.rawgit.com/onlurking/termux/master/.termux/font.ttf
  fi
else
  echo -e "\e[32m[ termux ]\e[m downloading configs"
  curl -fsLo "$HOME/.termux/colors.properties" --create-dirs https://cdn.rawgit.com/onlurking/termux/master/.termux/colors.properties
  curl -fsLo "$HOME/.termux/font.ttf" --create-dirs https://cdn.rawgit.com/onlurking/termux/master/.termux/font.ttf
fi

if [ $zsh ];then
    if ! [ -x "$(command -v zsh)" ]; then
      echo -e "\e[32m[ zsh ]\e[m not found, installing"
      apt-get install -y zsh > /dev/null 2>&1
    fi
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        echo -e "\e[32m[ oh-my-zsh ]\e[m clonning repository"
        git clone git://github.com/robbyrussell/oh-my-zsh.git "$HOME/.oh-my-zsh" --depth 1 --quiet > /dev/null
    else
      if ask "\e[32m[ oh-my-zsh ]\e[m configs found, overwrite?" Y; then
          rm -rf "$HOME/.oh-my-zsh"
          git clone git://github.com/robbyrussell/oh-my-zsh.git "$HOME/.oh-my-zsh" --depth 1 --quiet > /dev/null
      fi
    fi
    curl -fsLo "$HOME/.oh-my-zsh/themes/lambda-mod.zsh-theme" https://cdn.rawgit.com/onlurking/termux/master/.termux/lambda-mod.zsh-theme
    curl -fsLo "$HOME/.zshrc" https://cdn.rawgit.com/onlurking/termux/master/.termux/.zshrc
    curl -fsLo "$HOME/.profile" https://cdn.rawgit.com/onlurking/termux/master/.termux/.profile
    if [ ! -d "$HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting" ]; then
      if ask "\e[32m[ oh-my-zsh ]\e[m enable syntax highlighting?" Y; then
          echo -e "\e[32m[ oh-my-zsh ]\e[m downloading plugin"
          git clone git://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting" --quiet > /dev/null
    fi
    else
      sed -i '4s/.*/plugins=(git)/' "$HOME/.zshrc"
    fi
    chsh -s zsh
fi

if [ $elixir ];then
  if ! [ -x "$(command -v erl)" ]; then
    echo -e "\e[32m[ erlang ]\e[m not found, installing"
    apt-get install -y erlang > /dev/null 2>&1
  fi
  if [ ! -d "$HOME/.elixir" ]; then
    install_elixir
  else
    if ask "\e[32m[ elixir ]\e[m found, overwrite?" Y; then
      rm -rf "$HOME/.elixir"
      install_elixir
    fi
  fi
fi

if [ $python ];then
  if ! [ -x "$(command -v python)" ]; then
    echo -e "\e[32m[ python ]\e[m not found, installing"
    apt-get install -y python python-dev > /dev/null 2>&1
  fi
  curl -fsLo "$HOME/.pythonrc" https://cdn.rawgit.com/onlurking/termux/master/.termux/.pythonrc
fi

if [ $tmux ];then
  if ! [ -x "$(command -v tmux)" ]; then
    echo -e "\e[32m[ tmux ]\e[m not found, installing"
    apt-get install -y tmux > /dev/null 2>&1
  fi
  curl -fsLo "$HOME/.tmux.conf" https://raw.githubusercontent.com/onlurking/termux/master/.termux/.tmux.conf
fi

if ask "\e[32m[ storage ]\e[m setup external storage?" Y; then
    termux-setup-storage
fi

if ask "\e[32m[ termux ]\e[m hide welcome message?" Y; then
    touch "$HOME/.hushlogin"
fi

if ask "\e[32m[ finished ]\e[m close termux to apply settings?" Y; then
    pkill termux
else
    echo -e "\e[32m[ warning ]\e[m please restart termux to apply settings"
fi

exit
