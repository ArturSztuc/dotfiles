"########################################
"SECTION:  PLUGINS' SETUP
"########################################

" SNIPPETS:
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
" Trigger snippet
let g:UltiSnipsExpandTrigger="<C-Space>"
" Next entry within the snippet
let g:UltiSnipsJumpForwardTrigger="<C-b>"
" Past entry within the snippet
let g:UltiSnipsJumpBackwardTrigger="<C-z>"

""" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"
let g:vimtex_view_method = 'zathura'
let g:tex_flavor='latex'
let g:vimtex_quickfix_mode=0
let g:tex_conceal='abdmg'

set runtimepath+=~/.vim/mysnippets/UltiSnips
"let g:UltiSnipsSnippetsDir='~/.vim/mysnippets/'
"let g:UltiSnipsSnippetDirectories=["snippets"]

" INDENT GUIDES:
" Indent guides on startup
let g:indent_guides_enable_on_vim_startup = 1
"let g:indentguides_ignorelist = ['text']
"let g:indentguides_spacechar = '┆'
let g:indentguides_tabchar = '|'
"let g:indentLine_concealcursor = 'inc'
"let g:indentLine_conceallevel = 2
"let g:indentLine_setColors = 0
"let g:indentLine_char = '┊'
""let g:indentLine_setConceal = 0
"let g:indentLine_enabled = 0
set conceallevel=2



" YOUCOMPLETEME:
" Fallback file, if there's no local one
let g:ycm_global_ycm_extra_conf = "~/.vim/.ycm_extra_conf.py"

" Do not ask for confirmation of the extra config load
let g:ycm_confirm_extra_conf = 0 
"
" map <C-]> :YcmCompleter GoToImprecise<CR>
" " Go to definition
" map <leader>g  :YcmCompleter GoToDefinitionElseDeclaration<CR>
" " close autocomplete window after use
" let g:ycm_autoclose_preview_window_after_completion=1
"
"let g:snipMate = get(g:, 'snipMate', {}) " Allow for vimrc re-sourcing
"let g:snipMate.scope_aliases = {}
"let g:snipMate.scope_aliases['ruby'] = 'ruby,rails'

" STATUSBAR:
"
" Otherwise status bar doesn't display
set laststatus=2

" No more -- INSERT -- etc. since we have a status bar
set noshowmode

" Set the status bar itself
let g:lightline = {
      \ 'colorscheme': 'solarized',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified'] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'fileformat', 'fileencoding', 'filetype', 'charvaluehex' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'gitbranch#name'
      \ },
      \ }

" TMUXCOMPLETE:
" Set the tmux completion
let g:tmuxcomplete#asyncomplete_source_options = {
            \ 'name':      'tmux',
            \ 'whitelist': ['*'],
            \ 'config': {
            \     'splitmode':      'words',
            \     'filter_prefix':   1,
            \     'show_incomplete': 1,
            \     'sort_candidates': 0,
            \     'scrollback':      0,
            \     'truncate':        0
            \     }
            \ }

" Dunno
" TODO XXX FIXME What does it do?
let g:tmuxcomplete#trigger = 'omnifunc'

" NERT COMMETNER:
"
" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1

" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'

" Set a language to use its alternate delimiters by default
let g:NERDAltDelims_java = 1

" Add your own custom formats or override the defaults
let g:NERDCustomDelimiters = { 'c': { 'left': '/**','right': '*/' } }

" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1

" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1

" Enable NERDCommenterToggle to check all selected lines is commented or not 
let g:NERDToggleCheckAllLines = 1
