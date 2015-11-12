set transparency=10
set lines=70
set columns=115

"""""""""""""""""""
" Setup nerd-tree "
"""""""""""""""""""
"Start NerdTree on start-up.
"autocmd VimEnter * NERDTree
"autocmd VimEnter * wincmd p

map <C-n> :NERDTreeToggle<CR>



" open Nerd Tree in folder of file in active buffer
cd /Users/asolanki/trp/git/puppet_production/modules
map <Leader>nt :NERDTree %:p:h<CR>

" Close all open buffers on entering a window if the only
" buffer that's left is the NERDTree buffer

autocmd WinEnter * call s:CloseIfOnlyNerdTreeLeft()
function! s:CloseIfOnlyNerdTreeLeft()
  if exists("t:NERDTreeBufName")
    if bufwinnr(t:NERDTreeBufName) != -1
      if winnr("$") == 1
        q
      endif
    endif
  endif
endfunction
