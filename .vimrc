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
	Plugin 'scrooloose/syntastic'
    Plugin 'SearchComplete'
    Plugin 'belluzj/fantasque-sans'
    Plugin 'morhetz/gruvbox'
    Plugin 'python-mode/python-mode'
    Plugin 'rodjek/vim-puppet'
    Plugin 'tpope/vim-fugitive'
    Plugin 'shumphrey/fugitive-gitlab.vim'
    Plugin 'tpope/vim-git'
    Plugin 'tpope/vim-rhubarb'
    Plugin 'vim-airline/vim-airline'
    Plugin 'vim-airline/vim-airline-themes'
    Plugin 'kien/ctrlp.vim' 

call vundle#end()

"""""""""""""""""""""
" Setup vim-airline "
"""""""""""""""""""""
set laststatus=2
let g:airline_powerline_fonts=1
let g:airline_theme='cool'
set guifont=Fantasque\ Sans\ Mono:h14
set statusline=%<%F\ %h%m%r%{fugitive#statusline()}%=%-14.(%l,%c%V%)\ %P


""""""""""""""""""
" Theme Settings "
""""""""""""""""""
syntax enable
set encoding=utf-8
set background=dark
"colorscheme molokai
colorscheme gruvbox
filetype plugin on

"""""""""""""""""
" Misc Settings "
"""""""""""""""""
set number
set relativenumber 
set ruler
set ignorecase
set hlsearch
set noswapfile
set nopaste

" show existing tab with 4 spaces width
set tabstop=4
" when indenting with '>', use 4 spaces width
set shiftwidth=4
" On pressing tab, insert 4 spaces
set expandtab

"""""""""""""""""""""
" Auto Reload .vimrc"
"""""""""""""""""""""
augroup reload_vimrc " {
    autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END " }

""""""""""""""""""
" Cursor Settings "
""""""""""""""""""
set cursorline
set cursorcolumn
hi CursorLine term=underline guibg=#484840
hi CursorColumn term=reverse guibg=#484840

"""""""""""""""""""
" Highliht Spaces "
"""""""""""""""""""
highlight LiteralTabs ctermbg=darkyellow guibg=darkyellow
match LiteralTabs /\s\  /
highlight ExtraWhitespace ctermbg=darkyellow guibg=darkyellow
match ExtraWhitespace /\s\+$/ 

""""""""""""""""""""""""""""""""""""""""
" Ctrl-j move to the split below
" Ctrl-k move to the split above
" Ctrl-l move to the split to the right
" Ctrl-h move to the split to the left
""""""""""""""""""""""""""""""""""""""""
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

"""""""""""""""""""""""""
" invoke CtrlP with  dir
"""""""""""""""""""""""""
noremap <C-p> :CtrlP /trp/git/puppet/<CR>

"""""""""""""""""""""""""
" Fix for Gbrowse
"""""""""""""""""""""""""
let g:fugitive_gitlab_domains = ['http://github.rp-core.com']
