""""""""""""""""""""""""""""""""""""""""""""""""""
" Vundle
set nocompatible              " be iMproved
filetype off                  " required!
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

Bundle 'Blackrush/vim-gocode'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'Shougo/unite.vim'
Bundle 'Shougo/vimproc.vim'
Bundle 'Valloric/YouCompleteMe'
Bundle 'airblade/vim-gitgutter'
Bundle 'altercation/vim-colors-solarized'
Bundle 'bling/vim-airline'
Bundle 'dag/vim2hs'
Bundle 'eagletmt/ghcmod-vim'
Bundle 'eagletmt/neco-ghc'
Bundle 'groenewege/vim-less'
Bundle 'guns/vim-clojure-static'
Bundle 'hail2u/vim-css3-syntax'
Bundle 'jistr/vim-nerdtree-tabs'
Bundle 'kien/ctrlp.vim'
Bundle 'kien/rainbow_parentheses.vim'
Bundle 'majutsushi/tagbar'
Bundle 'oplatek/Conque-Shell'
Bundle 'scrooloose/nerdtree'
Bundle 'scrooloose/syntastic'
Bundle 'tarruda/vim-conque-repl'
Bundle 'tfnico/vim-gradle'
Bundle 'tpope/vim-classpath'
Bundle 'tpope/vim-fireplace'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-surround'
Bundle 'xolox/vim-misc'
Bundle 'xolox/vim-session'

""""""""""""""""""""""""""""""""""""""""""""""""""
" Key Bindings

" Press jj fast to get back to normal mode from typing
inoremap jj <ESC>

"set up an easy to reach leader
let mapleader = ";"

" press ; to issue commands in normal mode (no more shift holding)
"nnoremap ; :

"nnoremap <silent><Leader><C-]> <C-w><C-]><C-w>T
nnoremap <f12> :!ctags -R --c-kinds=+degmnstvf --c++-kinds=+cdefgmnstuv --java-kinds=+cefgimp<cr>
nnoremap <f8> :!make<cr>
nnoremap <f7> :!pdflatex "%"<cr>

" Tagbar
nnoremap <leader>t :TagbarToggle<cr>

" NERDTree
nnoremap <leader>f :NERDTreeTabsToggle<cr>
let g:NERDTreeWinSize = 35

" Split movement
nnoremap <C-h> :<C-w>h<cr>
nnoremap <C-j> :<C-w>j<cr>
nnoremap <C-k> :<C-w>k<cr>
nnoremap <C-l> :<C-w>l<cr>

" Easy motion
nmap s <Plug>(easymotion-s2)
nmap t <Plug>(easymotion-t2)

" Conque repl
let g:conque_repl_send_key = '<leader>rl'
let g:conque_repl_send_buffer_key = '<leader>rr'

" Press control-U to capitalize the last word when editing.
inoremap <c-u> <esc>viwUea

" Pull up the vimrc
nnoremap <leader>ev :split $MYVIMRC<cr>

" Sort a block of text
nnoremap <leader>rt vip:sort<cr>
vnoremap <leader>rt :sort<cr>

" Sort a block of text
nnoremap <leader>ml :tabmove -1<cr>
nnoremap <leader>mr :tabmove +1<cr>

au FileType haskell nnoremap <buffer> <leader>cs O<esc>o<esc>80i-<esc>o<space>

""""""""""""""""""""""""""""""""""""""""""""""""""
" Misc

" Do not syntax highlight over 100 columns. Makes vim not suck with really long
" lines.
set synmaxcol=100

set nofoldenable " Folds suck

set spell
set spelllang=en

set cursorcolumn
set cursorline
set nu "line numbers

" Let me backspace properly?
set backspace=indent,eol,start

set completeopt=menu

" Get propper tabs and syntax highlighting
syntax on
filetype on
filetype indent on
filetype plugin on
filetype plugin indent on

set cindent
set copyindent
set smartindent
set autoindent
set expandtab
set tabstop=2
set shiftwidth=2
set textwidth=80

" Color all columns over the current max
let &cc="+1,+".join(range(1,999),",+")

" Reuse open tabs when switching buffers
set switchbuf=usetab,newtab

" Fuck swap files
set noswapfile
set nobackup
set nowb

" Strip whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" auto cd to the current dir as the file
"set autochdir

let g:clipbrdDefaultReg = '+'

" toggle paste mode (to paste properly indented text)
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

set showcmd   " Show (partial) command in status line.
set showmatch   " Show matching brackets.
set ignorecase    " Do case insensitive matching
set smartcase   " Do smart case matching

""""""""""""""""""""""""""""""""""""""""""""""""""
" Conque / conque-repl

function! HsReplStart()
  " Determine whether to call ghci or cabal repl
  let command = "ghci"
  if !empty(glob("*.cabal"))
    let command = "cabal repl"
  endif

  if !exists("t:hs_term_buffer")
    let t:hs_code_buffer = bufnr("%")
    let t:hs_term = conque_term#open(command, ['split'], 1)
    let t:hs_term_buffer = bufnr("$")
  call t:hs_term.writeln(":set +m\n")
  endif

  execute "normal! :sb " . t:hs_code_buffer . "\<cr>"
  call t:hs_term.writeln("\n:reload\n")
  ConqueTermSendBufferNormal
endfunction

function! HsReplStop()
  if exists("t:hs_term")
    call t:hs_term.close()
  endif
  if exists("t:hs_term_buffer")
    execute "bdel " . t:hs_term_buffer
  endif

  unlet! t:hs_term
  unlet! t:hs_term_buffer
  unlet! t:hs_code_buffer
endfunction

function! HsReplGo()
  if exists("t:hs_term_buffer")
    execute "normal! :sb " . t:hs_term_buffer . "\<cr>"
    startinsert
  endif
endfunction

nnoremap <leader>hh :call HsReplStart()<cr>
nnoremap <leader>hq :call HsReplStop()<cr>
nnoremap <leader>hg :call HsReplGo()<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""
" Easy motion

hi link EasyMotionTarget WarningMsg
hi link EasyMotionShade Comment
let g:EasyMotion_smartcase = 1

""""""""""""""""""""""""""""""""""""""""""""""""""
" Tagbar

let g:tagbar_autofocus = 1
let g:tagbar_autoclose = 1
let g:tagbar_autoshowtag = 1
let g:tagbar_type_haskell = {
    \ 'ctagsbin'  : 'hasktags',
    \ 'ctagsargs' : '-x -c -o-',
    \ 'kinds'     : [
        \  'm:modules:0:1',
        \  'd:data: 0:1',
        \  'd_gadt: data gadt:0:1',
        \  't:type names:0:1',
        \  'nt:new types:0:1',
        \  'c:classes:0:1',
        \  'cons:constructors:1:1',
        \  'c_gadt:constructor gadt:1:1',
        \  'c_a:constructor accessors:1:1',
        \  'ft:function types:1:1',
        \  'fi:function implementations:0:1',
        \  'o:others:0:1'
    \ ],
    \ 'sro'        : '.',
    \ 'kind2scope' : {
        \ 'm' : 'module',
        \ 'c' : 'class',
        \ 'd' : 'data',
        \ 't' : 'type'
    \ },
    \ 'scope2kind' : {
        \ 'module' : 'm',
        \ 'class'  : 'c',
        \ 'data'   : 'd',
        \ 'type'   : 't'
    \ }
\}

""""""""""""""""""""""""""""""""""""""""""""""""""
" Solarized

let g:solarized_termtrans = 1
set t_Co=256
set background=dark
let g:solarized_contrast="medium"
colorscheme solarized

""""""""""""""""""""""""""""""""""""""""""""""""""
" YCM

"au FileType haskell set omnifunc=necoghc#omnifunc
let g:ycm_always_populate_location_list = 1
let g:ycm_semantic_triggers =  {
  \   'c' : ['->', '.'],
  \   'cpp,objcpp' : ['->', '.', '::'],
  \   'cs,java,javascript,d,vim,python,perl6,scala,vb,elixir,go' : ['.'],
  \   'erlang' : [':'],
  \   'haskell' : ['.'],
  \   'lua' : ['.', ':'],
  \   'objc' : ['->', '.'],
  \   'ocaml' : ['.', '#'],
  \   'perl' : ['->'],
  \   'php' : ['->', '::'],
  \   'ruby' : ['.', '::'],
  \ }

""""""""""""""""""""""""""""""""""""""""""""""""""
" gitgutter

let g:gitgutter_realtime = 0

""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-airline

set laststatus=2
let g:airline_powerline_fonts = 1

""""""""""""""""""""""""""""""""""""""""""""""""""
" Syntastic

"let g:syntastic_check_on_open=1
let g:syntastic_quiet_messages = {'level': 'warnings'}

""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-session

let g:session_autosave = 'no'


""""""""""""""""""""""""""""""""""""""""""""""""""
" vim-gocode

let g:go_fmt_autofmt = 0

""""""""""""""""""""""""""""""""""""""""""""""""""
" Unite

"call unite#filters#matcher_default#use(['matcher_fuzzy'])
"nnoremap <leader>r :<C-u>Unite -start-insert -tab -auto-preview file_rec<CR>
"
""Most recently used
"nnoremap <leader>m :<C-u>Unite -start-insert -tab -auto-preview file_mru<CR>
"
""Search through yank history!
"let g:unite_source_history_yank_enable = 1
"nnoremap <leader>y :<C-u>Unite -start-insert history/yank<CR>

"Search through tabs
"nnoremap <leader>t :<C-u>Unite -start-insert tab<CR>

"search lines
"nnoremap <silent> /  :<C-u>Unite -buffer-name=search line/fast -start-insert<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""
" Auto load ~/.vimrc

augroup reload_vimrc " {
  autocmd!
  autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END " }

""""""""""""""""""""""""""""""""""""""""""""""""""
" FileTypes

" Golang
autocmd FileType go setlocal noexpandtab shiftwidth=2 tabstop=2 softtabstop=2

" Haskell

au FileType haskell nnoremap <buffer> <F1> :HdevtoolsType<CR>
au FileType haskell nnoremap <buffer> <silent> <F2> :HdevtoolsClear<CR>
au FileType haskell setlocal textwidth=80
au FileType haskell setlocal shiftwidth=2 tabstop=2
au FileType haskell setlocal iskeyword-=.

" Markdown
autocmd BufNewFile,BufReadPost *.md set filetype=markdown
