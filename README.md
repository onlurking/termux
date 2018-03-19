# Termux Dotfiles

Installation | Screenshot
:-------------------------:|:-------------------------:
<img src="https://i.imgur.com/VDDEXh1.png" width="70%" height="70%" /> | <img src="https://i.imgur.com/5thIWFf.png" width="70%" height="70%" />


# Requirements
Install curl first:
```bash
apt update && apt -y upgrade && apt install -y curl
```

# Installation
Just paste the following code into Termux and adjust the parameters to customize what the script will install:
```bash
curl -fsSL https://git.io/termux | bash -s -- --zsh --python --neovim
```

# Script parameters

**-pg** or **--postgres** setup a postgres installation (optional **pgcli** install)<br>
**-p** or **--python** setup a python installation<br>
**-r** or **--ruby** setup a ruby installation (includes pry)<br>
**-g**, **--go** or *--golang* setup a golang installation<br>
**-js** or **--nodejs** setups nodejs (optional yarn install)<br>
**-t** or **--tmux** setups tmux<br>
**-n** or **--neovim** setups neovim<br>
**--php** setups php<br>
**-z** or **--zsh** setups zsh (optional syntax-highlight and auto-sugestions)<br>
**-e** or **--elixir** setup a erlang, and elixir installation<br>

# Security
`https://git.io/termux` is a short url which resolves to <br>`https://raw.githubusercontent.com/onlurking/termux/master/termux.sh`

Piping commands from internet to shell is considered bad practice, <br>and there is lot of discussion on the internet: 
- [Hacker News Discussion](https://news.ycombinator.com/item?id=12766049)
- [Don't Pipe to your Shell](https://www.seancassidy.me/dont-pipe-to-your-shell.html)
- [The Truth About Curl and Installing Software Securely on Linux](https://medium.com/@esotericmeans/the-truth-about-curl-and-installing-software-securely-on-linux-63cd12e7befd)

<br>but I did this anyway because of the convenience factor (there is no way to be more straightforward than this),<br>
please, feel free to review the [installer code](https://git.io/termux) and open an Issue.
