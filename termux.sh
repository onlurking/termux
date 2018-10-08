#!/data/data/com.termux/files/usr/bin/bash

function install_zsh() {
	if ! [ -x "$(command -v zsh)" ]; then
		echo -e "\\e[32m[ zsh ]\\e[m not found, installing"
		apt-get install -y zsh >/dev/null 2>&1
	fi
	if [ ! -d "$HOME/.oh-my-zsh" ]; then
		echo -e "\\e[32m[ oh-my-zsh ]\\e[m clonning repository"
		git clone git://github.com/robbyrussell/oh-my-zsh.git "$HOME/.oh-my-zsh" --depth 1 --quiet >/dev/null
	else
		if ask "\\e[32m[ oh-my-zsh ]\\e[m configs found, overwrite?" Y; then
			rm -rf "$HOME/.oh-my-zsh"
			git clone git://github.com/robbyrussell/oh-my-zsh.git "$HOME/.oh-my-zsh" --depth 1 --quiet >/dev/null
		fi
	fi
	curl -fsLo "$HOME/.oh-my-zsh/themes/lambda-mod.zsh-theme" https://cdn.rawgit.com/onlurking/termux/master/.termux/lambda-mod.zsh-theme
	curl -fsLo "$HOME/.zshrc" https://cdn.rawgit.com/onlurking/termux/master/.termux/.zshrc
	curl -fsLo "$HOME/.profile" https://cdn.rawgit.com/onlurking/termux/master/.termux/.profile
	if [ ! -d "$HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting" ]; then
		if ask "\\e[32m[ oh-my-zsh ]\\e[m enable syntax highlighting?" Y; then
			echo -e "\\e[32m[ oh-my-zsh ]\\e[m downloading plugin"
			git clone git://github.com/zsh-users/zsh-syntax-highlighting.git "$HOME/.oh-my-zsh/plugins/zsh-syntax-highlighting" --quiet >/dev/null
		fi
	else
		sed -i '4s/.*/plugins=(git)/' "$HOME/.zshrc"
	fi

	if [ ! -d "$HOME/.oh-my-zsh/plugins/zsh-autosuggestions" ]; then
		if ask "\\e[32m[ oh-my-zsh ]\\e[m enable autosuggestions?" Y; then
			echo -e "\\e[32m[ oh-my-zsh ]\\e[m downloading plugin"
			git clone git://github.com/zsh-users/zsh-autosuggestions.git "$HOME/.oh-my-zsh/plugins/zsh-autosuggestions" --quiet >/dev/null
			sed -i '4s/git/git zsh-autosuggestions/' "$HOME/.zshrc"
		fi
	fi

	chsh -s zsh

}

function install_elixir() {
	mkdir "$HOME/.elixir" && cd "$HOME/.elixir" || exit
	echo -e "\\e[32m[ elixir ]\\e[m downloading"
	curl -L https://github.com/elixir-lang/elixir/releases/download/v1.7.3/Precompiled.zip 2>/dev/null >Precompiled.zip
	unzip -qq Precompiled.zip 1>/dev/null && rm Precompiled.zip && cd bin || exit
	echo -e "\\e[32m[ elixir ]\\e[m fixing binaries"
	termux-fix-shebang elixir elixirc iex mix
	echo 'export PATH="$PATH:$HOME/.elixir/bin"' >>"$HOME/.profile"
	cd "$HOME" || exit
	if ask "\\e[32m[ yarn ]\\e[m install rebar? (recommended)" Y; then
    curl -fsLo "$HOME/.local/bin/rebar" https://github.com/rebar/rebar/releases/download/2.6.2/rebar
    curl -fsLo "$HOME/.local/bin/rebar3" https://github.com/erlang/rebar3/releases/download/3.6.2/rebar3
    chmod +x $HOME/.local/bin/rebar && chmod +x $HOME/.local/bin/rebar3
  fi
}

function install_node() {
	if ! [ -x "$(command -v node)" ]; then
		echo -e "\\e[32m[ nodejs ]\\e[m not found, installing"
		apt-get install -y nodejs >/dev/null 2>&1
	fi
	echo -e "\\e[32m[ npm ]\\e[m configuring prefix"
	mkdir -p "$HOME/.npm-packages"
	npm set prefix "$HOME/.npm-packages"

	if ask "\\e[32m[ yarn ]\\e[m install yarn? (recommended)" Y; then
		if [ -d "$HOME/.yarn" ]; then
			echo -e "\\e[32m[ yarn ]\\e[m removing existing yarn"
			rm -rf "$HOME/.yarn"
		fi
		echo -e "\\e[32m[ yarn ]\\e[m downloading nightly"
		curl -s -o- -L https://yarnpkg.com/install.sh | bash -s -- --nightly >/dev/null 2>&1
		export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"
		echo -e "\\e[32m[ yarn ]\\e[m configuring prefix"
		$HOME/.yarn/bin/yarn config set prefix "$HOME/.npm-packages" >/dev/null 2>&1
	fi
}

function install_requirements() {
	if ! [ -x "$(command -v git)" ]; then
		echo -e "\\e[32m[ git ]\\e[m not found, installing"
		apt-get install -y git >/dev/null 2>&1
	fi

	if [ ! -d "$HOME/.local/bin" ]; then
		mkdir -p "$HOME/.local/bin"
		echo 'export PATH="$PATH:$HOME/.local/bin"' >> $HOME/.profile
	fi

	if [ -d "$HOME/.termux" ]; then
		if ask "\\e[32m[ termux ]\\e[m configs found, overwrite?" Y; then
			rm -rf "$HOME/.termux"
			curl -fsLo "$HOME/.termux/colors.properties" --create-dirs https://cdn.rawgit.com/onlurking/termux/master/.termux/colors.properties
			curl -fsLo "$HOME/.termux/font.ttf" --create-dirs https://cdn.rawgit.com/onlurking/termux/master/.termux/font.ttf
		fi
	else
		curl -fsLo "$HOME/.termux/colors.properties" --create-dirs https://cdn.rawgit.com/onlurking/termux/master/.termux/colors.properties
		curl -fsLo "$HOME/.termux/font.ttf" --create-dirs https://cdn.rawgit.com/onlurking/termux/master/.termux/font.ttf
	fi
}

function install_postgres() {
	if ! [ -x "$(command -v pg_ctl)" ]; then
		echo -e "\\e[32m[ postgres ]\\e[m not found, installing"
		apt-get install -y postgresql postgresql-dev >/dev/null 2>&1

		echo -e "\\e[32m[ postgres ]\\e[m creating configs"
		initdb ~/.pg >/dev/null 2>&1
		pg_ctl -D ~/.pg start >/dev/null 2>&1

		echo 'alias pgstart="pg_ctl -D ~/.pg start" > /dev/null 2>&1' >>"$HOME/.profile"
		echo -e "\\e[32m[ postgres ]\\e[m type pgstart to start postgresql"

		if ask "\\e[32m[ postgres ]\\e[m install pgcli? (optional)" Y; then
			if ! [ -x "$(command -v python)" ]; then
				echo -e "\\e[32m[ postgres ]\\e[m python not found, installing"
				apt-get install -y python python-dev >/dev/null 2>&1
			fi
			pip install pgcli >/dev/null 2>&1
			echo -e "\\e[32m[ pgcli ]\\e[m creating configs"
			createdb "$(whoami)"
		fi
	fi
}

function install_neovim() {
	if ! [ -x "$(command -v nvim)" ]; then
		echo -e "\\e[32m[ neovim ]\\e[m not found, installing"
		apt-get install -y neovim>/dev/null 2>&1
	fi
	if ask "\\e[32m[ termux ]\\e[m install python module? (highly recommended)" Y; then
		if ! [ -x "$(command -v clang)" ]; then
			echo -e "\\e[32m[ neovim ]\\e[m clang not found, installing"
			apt-get install -y clang libcrypt-dev>/dev/null 2>&1
		fi
		if ! [ -x "$(command -v python)" ]; then
			echo -e "\\e[32m[ neovim ]\\e[m python not found, installing"
			apt-get install -y python python-dev >/dev/null 2>&1
		fi
		pip install neovim >/dev/null 2>&1
	fi
	if ask "\\e[32m[ neovim ]\\e[m install ruby module? (optional)" Y; then
		if ! [ -x "$(command -v clang)" ]; then
			echo -e "\\e[32m[ neovim ]\\e[m clang not found, installing"
			apt-get install -y clang make >/dev/null 2>&1
		fi
		if ! [ -x "$(command -v ruby)" ]; then
			echo -e "\\e[32m[ neovim ]\\e[m ruby not found, installing"
			apt-get install -y ruby ruby-dev make>/dev/null 2>&1
		fi
		gem install neovim >/dev/null 2>&1
	fi
	curl -fsLo "$HOME/.config/nvim/autoload/plug.vim" --create-dirs https://cdn.rawgit.com/onlurking/termux/master/.termux/nvim/autoload/plug.vim
	curl -fsLo "$HOME/.config/nvim/colors/Tomorrow-Night-Eighties.vim" --create-dirs https://cdn.rawgit.com/onlurking/termux/master/.termux/nvim/colors/Tomorrow-Night-Eighties.vim
	curl -fsLo "$HOME/.config/nvim/init.vim" --create-dirs https://cdn.rawgit.com/onlurking/termux/master/.termux/nvim/init.vim
}

function install_ruby() {
	if ! [ -x "$(command -v ruby)" ]; then
		echo -e "\\e[32m[ ruby ]\\e[m not found, installing"
		apt-get install -y ruby ruby-dev >/dev/null 2>&1
	fi
	echo -e "\\e[32m[ ruby ]\\e[m installing pry"
	gem install pry >/dev/null 2>&1
}

function install_tmux() {
	if ! [ -x "$(command -v tmux)" ]; then
		echo -e "\\e[32m[ tmux ]\\e[m not found, installing"
		apt-get install -y tmux >/dev/null 2>&1
	fi
	curl -fsLo "$HOME/.tmux.conf" https://raw.githubusercontent.com/onlurking/termux/master/.termux/.tmux.conf
}

function install_python() {
	if ! [ -x "$(command -v python)" ]; then
		echo -e "\\e[32m[ python ]\\e[m not found, installing"
		apt-get install -y python python-dev >/dev/null 2>&1
	fi
	curl -fsLo "$HOME/.pythonrc" https://cdn.rawgit.com/onlurking/termux/master/.termux/.pythonrc
}

function install_php() {
	echo -e "\\e[32m[ php ]\\e[m not found, installing"
	apt-get install -y nginx php php-fpm >/dev/null 2>&1
}

function install_golang() {
  echo -e "\\e[32m[ go ]\\e[m not found, installing"
	apt-get install -y golang >/dev/null 2>&1
  mkdir $HOME/.go
  echo 'export GOPATH="$PATH:$HOME/.go"' >> $HOME/.profile
  echo 'export PATH="$PATH:$HOME/.go/bin"' >> $HOME/.profile
}

function ask() {
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

		echo -e -n "$1 [$prompt] "
		read -r reply </dev/tty

		if [ -z "$reply" ]; then
			reply=$default
		fi

		case "$reply" in
		Y* | y*) return 0 ;;
		N* | n*) return 1 ;;
		esac

	done
}

function start() {
	clear
	echo -e "\\n  ▓▓▓▓▓▓▓▓▓▓▓▓"
	echo -e " ░▓    about ▓ custom termux config files"
	echo -e " ░▓   author ▓ onlurking <diogofelix@acm.org>"
	echo -e " ░▓     code ▓ https://git.io/termux"
	echo -e " ░▓▓▓▓▓▓▓▓▓▓▓▓"
	echo -e " ░░░░░░░░░░░░\\n"
}

function finish() {
	if ask "\\e[32m[ storage ]\\e[m setup external storage?" Y; then
		termux-setup-storage
	fi

	if ask "\\e[32m[ termux ]\\e[m hide welcome message?" Y; then
		touch "$HOME/.hushlogin"
	fi

	if ! grep -q "source ~/.profile" $HOME/.bash_profile >/dev/null 2>&1; then
		echo -e "\nif [ -f ~/.profile ]; then\n  source ~/.profile\nfi" >> $HOME/.bash_profile
	fi

	if ask "\\e[32m[ finished ]\\e[m close termux to apply settings?" Y; then
		pkill termux
	else
		echo -e "\\e[32m[ warning ]\\e[m please restart termux to apply settings"
	fi
}

while [[ $# -gt 0 ]]; do
	case $1 in
	-e | --elixir)
		elixir=true
		;;
  -g | --go | --golang)
		golang=true
		;;
	-p | --python)
		python=true
		;;
	-n | --nvim | --neovim)
		nvimrc=true
		;;
	-js | --nodejs)
		nodejs=true
		;;
	-t | --tmux)
		tmux=true
		;;
	-r | --ruby)
		ruby=true
		;;
	--php)
		php=true
		;;
	-pg | --postgres)
		postgres=true
		;;
	-z | --zsh)
		zsh=true
		;;
	*) echo -e "Unknown options:' $1" ;;
	esac
	shift
done

start
install_requirements

if [ $python ]; then
	install_python
fi

if [ $zsh ]; then
	install_zsh
fi

if [ $nodejs ]; then
	install_node
fi

if [ $postgres ]; then
	install_postgres
fi

if [ $nvimrc ]; then
	install_neovim
fi

if [ $tmux ]; then
	install_tmux
fi

if [ $ruby ]; then
	install_ruby
fi

if [ $golang ]; then
  install_golang
fi

if [ $php ]; then
	install_php
fi

if [ $elixir ]; then
	if ! [ -x "$(command -v erl)" ]; then
		echo -e "\\e[32m[ erlang ]\\e[m not found, installing"
		apt-get install -y erlang >/dev/null 2>&1
	fi
	if [ ! -d "$HOME/.elixir" ]; then
		install_elixir
	else
		if ask "\\e[32m[ elixir ]\\e[m found, overwrite?" Y; then
			rm -rf "$HOME/.elixir"
			install_elixir
		fi
	fi
fi

source $HOME/.profile

finish

exit
