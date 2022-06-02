" or """  is comment

" vim-plug
call plug#begin('~/.vim/plugged')
        Plug 'vim-airline/vim-airline'
        Plug 'vim-airline/vim-airline-themes'

        Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
        Plug 'junegunn/fzf.vim'
        
        Plug 'tpope/vim-eunuch'

        Plug 'mg979/vim-visual-multi', {'branch': 'master'}

call plug#end()

" vim-plug-theme config
""" airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_tabs = 0

:map  <S-j> <Plug>AirlineSelectPrevTab
:imap <A-S-j> <RIGHT><ESC><Plug>AirlineSelectPrevTab
:cmap <A-S-j> <ESC><Plug>AirlineSelectPrevTab

:map  <S-k> <Plug>AirlineSelectNextTab
:imap <A-S-k> <RIGHT><ESC><Plug>AirlineSelectNextTab
:cmap <A-S-k> <ESC><Plug>AirlineSelectNextTab


""" fzf
let g:fzf_preview_window = [] 

:map  <silent> <S-r> :Rg<CR>
:imap <silent> <A-S-r> <C-\><C-o>:Rg<CR>

:map  <silent> <C-f> :BLines<CR>
:imap <silent> <C-f> <C-\><C-o>:BLines<CR>

:map  <silent> <S-f> :Lines<CR>
:imap <silent> <A-S-f> <C-\><C-o>:Lines<CR>

:map  <silent> <s-l> :Files<CR>  
:imap <silent> <A-S-l> <C-\><C-o>:Files<CR>  


""" vim-eunuch             
"""""" Save All Modified Buffer Files
:map  <F1> :wall<CR>
:imap <F1> <RIGHT><ESC>:wall<CR>
:cmap <F1> <ESC>:wall<CR>

"""""" Rename File (Must Had Name)
:map  <F2> :Rename<SPACE>
:imap <F2> <RIGHT><ESC>:Rename<SPACE>
:cmap <F2> <ESC>:Rename<SPACE>

"""""" Chmod +x (Right Now)
:map  <F3> :w<CR>:Chmod +x<CR>
:imap <F3> <RIGHT><ESC>:w<CR>:Chmod +x<CR>
:cmap <F3> <ESC>:w<CR>:Chmod +x<CR>

"""""" Quit All Buffer And No Save
:map  <F4> :qall!<CR>
:imap <F4> <ESC>:qall!<CR>
:cmap <F4> <ESC>:qall!<CR>

"""""" Close Single Buffer
:map  <F6> :bd<CR>
:imap <F6> <ESC>:bd<CR>
:cmap <F6> <ESC>:bd<CR>

"""""" New Tab With Name
:map  <C-t> :tabe<SPACE>
:imap <C-t> <RIGHT><ESC>:tabe<SPACE>
:cmap <C-t> <ESC>:tabe<SPACE>

:map  <A-t> :tabe<SPACE>
:imap <A-t> <RIGHT><ESC>:tabe<SPACE>
:cmap <A-t> <ESC>:tabe<SPACE>


""" vim-visual-multi
let g:VM_maps = {}
let g:VM_maps['Find Under']         = '<C-d>'   " replace C-n
let g:VM_maps['Find Subword Under'] = '<C-d>'   " replace visual C-n

" set mouse=a
" let g:VM_mouse_mappings = 1
" nmap   <C-LeftMouse>      <Plug>(VM-Mouse-Cursor)
" nmap   <A-LeftMouse>      <Plug>(VM-Mouse-Column)




" Compatible Alt Key
let c='a'
while c <= 'z'
  exec "set <A-".c.">=\e".c
  exec "imap \e".c." <A-".c.">"
  let c = nr2char(1+char2nr(c))
endw
set timeout ttimeoutlen=50


" Simple
syntax on
set nu

set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

set backspace=indent,eol,start

set scrolloff=4

""" set mouse=a
set encoding=utf-8

set wildmenu

""" Close Match HighLight and Ignore Case
set nohlsearch
set ignorecase


" KeyMap
""" Esc
:map  <A-q> <ESC>
:imap <A-q> <ESC>
:cmap <A-q> <ESC>


""" :wq
:map  <A-w> <ESC>:wq<CR>
:imap <A-w> <ESC>:wq<CR>
:cmap <A-w> <ESC>:wq<CR>

""" TAB / Shift+TAB
""" 5 + TAB / 5 + Shift+TAB
:map  <TAB> >>
"""(No Config)""":imap <TAB> <C-\><C-o>>> 
:vmap <TAB> >>i

:map  <S-TAB> <<
:imap <S-TAB> <C-\><C-o><<
:vmap <S-TAB> <<i



""" Save
:map  <A-s> :w!<CR>
:imap <A-s> <ESC>:w!<CR>a
:cmap <A-s> <ESC>:w!<CR>
"""""" Note: Can not Bind by Ctrl+s (Lock)



""" Copy & Paste (Line)
:map  <A-c> y<END>
:imap <A-c> <C-\><C-o>y<END>

:map  <A-v> p
:imap <A-v> <C-\><C-o>p

:map  <A-d> yyp
:imap <A-d> <C-\><C-o>Y<ESC>P<DOWN>i


""" Source ~/.vimrc
:map  <F5> <ESC>:source ~/.vimrc<CR>
:imap <F5> <ESC>:source ~/.vimrc<CR>
:cmap <F5> <ESC>:source ~/.vimrc<CR>



""" Move
:map  <A-j> <LEFT>
:map  j     <LEFT>
:map! <A-j> <LEFT>

:map  <A-k> <RIGHT>
:map  k     <RIGHT>
:map! <A-k> <RIGHT>


"""""" Home/End such as Sublime Text
function! MoveHome()
    let currentLine=col('.')

    normal! 0
    let withSpaceHomeLine=col('.')

    normal! g^
    let noSpaceHomeLine=col('.')

    if currentLine != noSpaceHomeLine
        normal g^
    else 
        normal 0
    endif
endfunction


function! MoveEnd()
    let currentLine=col('.')

    normal! $
    let withSpaceEndLine=col('.')

    normal! g_
    let noSpaceEndLine=col('.')

    if currentLine != noSpaceEndLine
        normal g_
    else 
        normal $
    endif
endfunction


:map  <silent> <A-h> :call MoveHome()<CR>
:imap <silent> <A-h> <RIGHT><ESC>:call MoveHome()<CR>i

:map  <silent> <A-l> :call MoveEnd()<CR>
:imap <A-l> <ESC>:call MoveEnd()<CR>a




:map  <A-n> <DOWN>
"""" No Set(Due match next) :map n <DOWN>
:imap <A-n> <DOWN>
:cmap <A-n> <C-n>

:map  <A-p> <UP>
"""" No Set(Due paste     ) :map p <UP>
:imap <A-p> <UP>
:cmap <A-p> <C-p>


:map  <A-b> <C-LEFT>
:imap <A-b> <C-LEFT>
:cmap <A-b> <C-LEFT>

:map  <A-f> <C-RIGHT>
:imap <A-f> <C-RIGHT>
:cmap <A-f> <C-RIGHT>

:map  <C-n> 5<Down>
:imap <C-n> <C-\><C-o>5<Down>
:map  <C-p> 5<UP>
:imap <C-p> <C-\><C-o>5<UP>



""" Select (backward/forward all) ('d' can delete)
:map  <A-a> vgg<HOME>
:imap <A-a> <C-\><C-o>vgg<HOME>

:map  <A-e> vG<END>
:imap <A-e> <C-\><C-o>vG<END>


:map  <C-a> ggVG
:imap <C-a> <ESC>G<ESC>Vgg


:map  <C-S-v> <C-v>
:imap <C-S-v> <C-v>


""" Delete / Cut
:map  <A-o> i<BS>
:imap <A-o> <BS>
:cmap <A-o> <BS>

:map  <A-i> dbi
:imap <A-i> <C-\><C-o>db


:map  <S-o> xi
:imap <A-S-o> <C-\><C-o>x


:map  <S-i> dwi
:imap <A-S-i> <C-\><C-o>dw




:map  <C-u> d<HOME>
:imap <C-u> <C-\><C-o>d<HOME>


:map  <C-k> D
:imap <C-k> <C-\><C-o>D


""" UnDo / Redo
:map  <A-u> u
:imap <A-u> <C-\><C-o>u


:map  <A-r> <C-r>
:imap <A-r> <C-\><C-o><C-r>


""" Jump () [] {}
:map  <S-m> %
:imap <A-S-m> %


""" Enter
:map  <A-m> <CR>
:imap <A-m> <CR>

""" python
:map  <buffer> <C-b> :w<CR>:exec '!python3' shellescape(@%, 1)<c    r>
:imap <buffer> <C-b> <ESC>:w<CR>:<ESC>:exec '!python3' shellesca    pe(@%, 1)<cr>
:cmap <buffer> <C-b> <ESC>:w<CR>:<ESC>:exec '!python3' shellesca    pe(@%, 1)<cr>
