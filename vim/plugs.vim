"########################################
"SECTION:  PLUGIN SECTION, MESS         #
"########################################
"
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Autocomplete, works with all languages, ctags for C++
Plugin 'Valloric/YouCompleteMe'

" Needed to generate a fileproject for YCM ctags to work properly
Plugin 'rdnetto/YCM-Generator'

" Nerd tree, CTRL+n 
Plugin 'The-NERD-tree'

" Shows marks, mapped to F6 F7 DoShowMarks! DoShowMarks NoShowMarks(!)
" TODO: Could probably remove this, not using
Plugin 'jacquesbh/vim-showmarks'

" No distractions, just text! Perfect for latex/md writing
" Just do :Goyo, :Goyo 120/80%/x120/x60%
Plugin 'junegunn/goyo.vim'


" A nice toolbox for edditing .tex files
Plugin 'lervag/vimtex'

" Awesome status bar at the bottom
Plugin 'itchyny/lightline.vim'

" Read git branch
Plugin 'itchyny/vim-gitbranch'

" Switch quickly between .h and .cpp etc.
Plugin 'a.vim'

" Shows a (splitscreen) bar with all the "tags" This means classes, class
" functions etc.
Plugin 'Tagbar'

" Surrounds word/sentence/line/lines with "*{[( or anything else you want
" TODO: Not using much, either delete or start using it!
" example usage: cs'" ds"
Plugin 'tpope/vim-surround' 

" Commenting the code in a nice/automated way
Plugin 'scrooloose/nerdcommenter'

" Not to confuse with the tagbar. This toggles bools between True/False, ints
" between 0 and 1 etc.
"Bundle 'https://github.com/sagarrakshe/toggle-bool'

" Completion by doing fuzzy search in all the TMUX windows. Needs some
" prerequisites :/ 
Plugin 'prabirshrestha/async.vim'
Plugin 'prabirshrestha/asyncomplete.vim'
Plugin 'wellle/tmux-complete.vim'

" Allows snippets whilst writing the code. This is just the snippet engine
" without snippets!
Plugin 'SirVer/ultisnips'

" Snippets are separated from the engine. Add this if you want them:
Plugin 'honza/vim-snippets'
" And latex-specific
Plugin 'rbonvall/snipmate-snippets-bib'

" Indent guides
Plugin 'nathanaelkane/vim-indent-guides'
"Plugin 'Yggdroot/indentLine'

" Move along a long line with <leader><leader>w / b 
" TODO: Need to change the colours, they are blending into the background
Plugin 'easymotion/vim-easymotion'


" Plugin that allows for editting .gpg files
Plugin 'gnupg.vim'

" End configuration, makes the plugins available
call vundle#end()
filetype plugin indent on
filetype plugin on
