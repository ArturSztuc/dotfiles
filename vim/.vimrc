" PLUGIN SECTION, MESS {{{
" Vundle vimrc
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
" call vundle#begin('~/some/path/here')
"
let g:ycm_confirm_extra_conf = 0 
"
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'Valloric/YouCompleteMe'
"
" End configuration, makes the plugins available
call vundle#end()
filetype plugin indent on

map <C-]> :YcmCompleter GoToImprecise<CR>
" }}}
" SPACES, TABS, COLOURS {{{
syntax enable           "Syntax processing
set tabstop=2           "Spaces per tab
set shiftwidth=2        "Spaces
set softtabstop=2       "Spaces in tab when editing
set expandtab           "Tabs ARE spaces
" }}}
" UI CONFIG {{{
set number	" shows number lines
set cursorline	" highlights line
set showcmd " shows last command used at the bottom
filetype indent on      "Load filetype-specific indent files eg. .vim/indent/python.vim
set wildmenu            "visual autocomplete for command menu
set lazyredraw          "Redraw only when we need to.
set showmatch           "Highlight matching [{()}]
" }}}
"SEARCHING {{{
set incsearch           "Search as characters are entered
set hlsearch            "Highlight matches
"Run leader and space instead :noh 
nnoremap <leader><space> :nohlsearch<CR>
" }}}
" FOLDING {{{
set foldenable          " enable folding
set foldlevelstart=10   " opens most folds by default
set foldnestmax=10      " 10 nested fold max
set foldlevel=0
nnoremap <space> za     " space open/closes folds
set foldmethod=indent   " fold based on indent level
" }}}
" LEADER SHORTCUTS {{{
let mapleader=","       "Coma is the leader!
" }}}
" HIGHLIGHTS LAST INSERTED TEXT {{{
nnoremap gV `[v`]
" }}}
" allows cursor change in tmux mode {{{
if exists('$TMUX')
  let &t_SI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=1\x7\<Esc>\\"
  let &t_EI = "\<Esc>Ptmux;\<Esc>\<Esc>]50;CursorShape=0\x7\<Esc>\\"
else
  let &t_SI = "\<Esc>]50;CursorShape=1\x7"
  let &t_EI = "\<Esc>]50;CursorShape=0\x7"
endif
" }}}

set modeline
set modelines=1
" vim:set foldmethod=marker foldlevel=0:
