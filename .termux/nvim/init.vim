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
filetype plugin on
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

" Snippets
Plug 'Shougo/neosnippet.vim' | Plug 'Shougo/neosnippet-snippets'
Plug 'honza/vim-snippets'

" Plug 'w0rp/ale'
Plug 'scrooloose/nerdcommenter'
Plug 'editorconfig/editorconfig-vim'
Plug 'ntpeters/vim-better-whitespace'

" Distraction Free
Plug 'junegunn/goyo.vim', { 'on': 'Goyo' }

" Syntax Highlight
Plug 'sheerun/vim-polyglot'

Plug 'vimwiki/vimwiki'
Plug 'suan/vim-instant-markdown'


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

" Disable python 2
let g:loaded_python_provider = 1

let g:vimwiki_list=[{'path': '~/.wiki', 'syntax': 'markdown', 'ext': '.md'}]

" vimwiki with markdown support
let g:vimwiki_ext2syntax = {'.md': 'markdown', '.markdown': 'markdown', '.mdown': 'markdown'}
let g:instant_markdown_slow = 1
let g:instant_markdown_autostart = 0	" disable autostart
map <leader>md :InstantMarkdownPreview<CR>

