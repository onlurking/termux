"
"              ███████████████████████████
"              ███████▀▀▀░░░░░░░▀▀▀███████
"              ████▀░░░░░░░░░░░░░░░░░▀████
"              ███│░░░░░░░░░░░░░░░░░░░│███
"              ██▌│░░░░░░░░░░░░░░░░░░░│▐██
"              ██░└┐░░░░░░░░░░░░░░░░░┌┘░██
"              ██░░└┐░░░░░░░░░░░░░░░┌┘░░██
"              ██░░┌┘▄▄▄▄▄░░░░░▄▄▄▄▄└┐░░██
"              ██▌░│██████▌░░░▐██████│░▐██
"              ███░│▐███▀▀░░▄░░▀▀███▌│░███
"              ██▀─┘░░░░░░░▐█▌░░░░░░░└─▀██
"              ██▄░░░▄▄▄▓░░▀█▀░░▓▄▄▄░░░▄██
"              ████▄─┘██▌░░░░░░░▐██└─▄████
"              █████░░▐█─┬┬┬┬┬┬┬─█▌░░█████
"              ████▌░░░▀┬┼┼┼┼┼┼┼┬▀░░░▐████
"              █████▄░░░└┴┴┴┴┴┴┴┘░░░▄█████
"              ███████▄░░░░░░░░░░░▄███████
"              ██████████▄▄▄▄▄▄▄██████████
"              ███████████████████████████
"
"         You are about to experience a potent
"           dosage of Vim. Watch your steps.
"
"     ╔══════════════════════════════════════════╗
"     ║             HERE BE VIMPIRES             ║
"     ╚══════════════════════════════════════════╝


syntax on
colorscheme Tomorrow-Night-Eighties
set expandtab
set shiftwidth=2
set laststatus=0
set tabstop=2
set shortmess+=afilmnrxoOtT
set hidden
imap jj <Esc>
set number
let mapleader=","
set listchars=eol:¬,tab:»\ ,trail:~,extends:»,precedes:«
hi Normal ctermbg=none

call plug#begin('~/.vim/plugged')

" Autocomplete
Plug 'ervandew/supertab'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

if executable('python')
  Plug 'zchee/deoplete-jedi'
endif

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './intall --all' }

" Snippets
Plug 'Shougo/neosnippet.vim' | Plug 'Shougo/neosnippet-snippets'
Plug 'honza/vim-snippets'

" Plug 'w0rp/ale'
Plug 'scrooloose/nerdcommenter'
Plug 'editorconfig/editorconfig-vim'
Plug 'ntpeters/vim-better-whitespace'

" Distraction Free
Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }
Plug 'amix/vim-zenroom2'

" Syntax Highlight
Plug 'mitsuhiko/vim-python-combined'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'vim-jp/vim-cpp'
Plug 'othree/html5.vim'
Plug 'JulesWang/css.vim'
Plug 'hail2u/vim-css3-syntax'
Plug 'pangloss/vim-javascript'
Plug 'elzr/vim-json'
Plug 'elixir-lang/vim-elixir'
Plug 'cespare/vim-toml'
Plug 'wavded/vim-stylus'
Plug 'digitaltoad/vim-pug'
Plug 'uarun/vim-protobuf'
Plug 'exu/pgsql.vim'
Plug 'othree/nginx-contrib-vim'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'neovimhaskell/haskell-vim'
Plug 'fatih/vim-go'
Plug 'ElmCast/elm-vim'
Plug 'guns/vim-clojure-static'
Plug 'guns/vim-clojure-highlight'
Plug 'luochen1990/rainbow'
Plug 'StanAngeloff/php.vim'
Plug 'hylang/vim-hy'

call plug#end()

" Neosnippet
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <C-k> <Plug>(neosnippet_expand_or_jump)
xmap <C-k> <Plug>(neosnippet_expand_target)
imap <C-k> <Plug>(neosnippet_expand_or_jump)
smap <expr><TAB> neosnippet#expandable_or_jumpable() ? \ "\<Plug>(neosnippet_expand_or_jump)" : "\<TAB>"

if has('conceal')
  set conceallevel=2 concealcursor=niv
endif

let g:neosnippet#enable_snipmate_compatibility = 1

let g:neosnippet#snippets_directory='~/.vim/plugged/vim-snippets/snippets'

" Deoplete
let g:deoplete#enable_at_startup = 1
