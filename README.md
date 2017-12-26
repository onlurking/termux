# Termux Dotfiles

# Requirements
- curl
```bash
apt update && apt -y upgrade && apt install -y curl
```

# Installation
```bash
curl -fsSL https://git.io/vHIKx | bash -s -- --zsh --python --neovim
```

# Installation Flags

**-pg** or **--postgres** setup a postgres installation (optional **pgcli** install)<br>
**-p** or **--python** setup a python installation<br>
**-r** or **--ruby** setup a ruby installation<br>
**-t** or **--tmux** setups tmux<br>
**-n** or **--neovim** setups neovim<br>
**-z** or **--zsh** setups zsh<br>
**-e** or **--elixir** setup a erlang, and elixir installation<br>
