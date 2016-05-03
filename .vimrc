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

""""""""""""""""""
" Theme Settings "
""""""""""""""""""
colorscheme candycode
filetype plugin on
syntax on

""""""""""""""""""""""""""""""
"" files, backups and undo
""""""""""""""""""""""""""""""

" Turn backup off, since most stuff is in source control
set nobackup
set noswapfile

""""""""""""""""""""""""""""""
"" mouse
""""""""""""""""""""""""""""""
set mouse=a
set ttym=xterm2

""""""""""""""""""""""""""""""
"" clipboard
""""""""""""""""""""""""""""""
set clipboard=unnamedplus

"""""""""""""""""""""
" Setup vim-airline "
"""""""""""""""""""""
set laststatus=2
let g:airline_powerline_fonts = 1
let g:airline_theme='kalisi'

"set guifont=Meslo\ LG\ S\ for\ Powerline
set guifont=Ubuntu\ Mono\ derivative\ Powerline:h14

filetype plugin indent on 
:
set number
set ruler
set ignorecase
set hlsearch

set cursorline
set cursorcolumn
"hi CursorLine   cterm=NONE ctermbg=darkred ctermfg=white guibg=Grey guifg=black
"hi CursorColumn cterm=NONE ctermbg=darkred ctermfg=white guibg=Grey guifg=black

cd /Users/asolanki/trp/logs
