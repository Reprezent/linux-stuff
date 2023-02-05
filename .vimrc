:syntax on
set laststatus=2 " Vim-AirLine support
let g:airline#extensions#tabline#enabled = 1

set t_kb=
set nocompatible
set backspace=eol,indent,start
set autoindent
set smartindent

" don't highlight the last search upon startup
set viminfo="h"

" Do C-style auto indentation on C/C++/Perl files only :)
:filetype on
:autocmd FileType c,cpp,perl :set cindent

" stop Vim from beeping all the time
set vb

set tabstop=4
set shiftwidth=4
set softtabstop=4
set smarttab
set list
set listchars=tab:>-

" uncomment to insert spaces instead of a tab when tab is pressed
set expandtab

set ruler
set background=dark

"Tell you if you are in insert mode
set showmode

"match parenthesis, i.e. ) with (  and } with {
set showmatch

"ignore case when doing searches
set ignorecase
set smartcase

"tell you how many lines have been changed
set report=0

set scrolloff=5
set wildmode=longest,list
set incsearch
set hlsearch

:colorscheme elflord

set showtabline=2
"sets max column to be 80 characters
set colorcolumn=+80
" Show highlighting groups for current word
nmap <C-S-P> :call <SID>SynStack()<CR>
function! <SID>SynStack()
    if !exists("*synstack")
        return
    endif
    echo map(synstack(line('.'), col('.')),
    \       'synIDattr(v:val, "name")')
endfunc

" air-line
let g:airline_powerline_fonts = 0

"""""""""""""""""""""""""""""""""""""""""
"--------- Personal Vim stuff ----------"
"""""""""""""""""""""""""""""""""""""""""

" Auto Load Vim Folds
augroup AutoSaveFolds
    autocmd!
    autocmd BufWinLeave * mkview
    autocmd BufWinEnter * silent loadview
augroup END

" Completion above the line, not inline
set wildmenu

" Saves file open state
augroup ReloadFile
    au!

    autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") && &ft !~# 'commit'
    \ |   exe "normal! g`\""
    \ | endif
augroup END




