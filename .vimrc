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
	Plugin 'scrooloose/nerdtree'
	Plugin 'rodjek/vim-puppet'
	Plugin 'bling/vim-airline'
	Plugin 'xolox/vim-misc'
	Plugin 'altercation/vim-colors-solarized'
	Plugin 'xolox/vim-colorscheme-switcher'
	Plugin 'flazz/vim-colorschemes'
	Plugin 'scrooloose/syntastic'

call vundle#end()

"""""""""""""""""""""
" Setup vim-airline "
"""""""""""""""""""""
set laststatus=2
let g:airline_powerline_fonts = 1
let g:airline_theme='kalisi'

set guifont=Ubuntu\ Mono\ derivative\ Powerline:h14

""""""""""""""""""
" Theme Settings "
""""""""""""""""""
colorscheme corn
filetype plugin on
syntax on
set transparency=25

""""""""""""""""""
" Misc Settings "
""""""""""""""""""
set number
set ruler
set ignorecase
set hlsearch

""""""""""""""""""
" Cursor Settings "
""""""""""""""""""
set cursorline
set cursorcolumn
hi CursorLine term=underline guibg=#484848
hi CursorColumn term=reverse guibg=#484848
