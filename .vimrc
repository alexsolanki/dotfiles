" Vundle Configuration

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim

set switchbuf=usetab
call vundle#begin()

       	" Brief help
       	" :PluginList       - lists configured plugins
       	" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
       	" :PluginSearch foo - searches for foo; append `!` to refresh local cache
       	" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal

       	Plugin 'gmarik/Vundle.vim'
    Plugin 'vim-airline/vim-airline'
    Plugin 'vim-airline/vim-airline-themes'
       	Plugin 'scrooloose/syntastic'
    Plugin 'valloric/youcompleteme'
    Plugin 'SearchComplete'
    Plugin 'morhetz/gruvbox'
    Plugin 'belluzj/fantasque-sans'
    Plugin 'klen/python-mode'
    Plugin 'rodjek/vim-puppet'

call vundle#end()

"""""""""""""""""""""
" Setup vim-airline "
"""""""""""""""""""""
set laststatus=2
let g:airline_powerline_fonts=1
set guifont=Fantasque\ Sans\ Mono:h13

""""""""""""""""""
" Theme Settings "
""""""""""""""""""
syntax enable
set encoding=utf-8
set background=dark
"colorscheme molokai
colorscheme gruvbox
filetype plugin on
set transparency=10

""""""""""""""""""
" Misc Settings "
""""""""""""""""""
set number
set ruler
set ignorecase
set hlsearch
set noswapfile

filetype plugin indent on
" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab

""""""""""""""""""
" Cursor Settings "
""""""""""""""""""
set cursorline
set cursorcolumn
hi CursorLine term=underline guibg=#484840
hi CursorColumn term=reverse guibg=#484840
