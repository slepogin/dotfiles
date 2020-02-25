" vim: set foldmethod=marker foldlevel=99 nomodeline:
" Author: Nikita Slepogin
" Date: 01.04.2017

" Where is a bug in Windows.
" If you change encoding to UTF8 you should repopulate runtimepath.
language C
set encoding=utf-8
set runtimepath=$HOME/.vim,$VIMRUNTIME
set nocompatible

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

let mapleader      = "\<Space>"
let maplocalleader = "\<Space>"

" VIM-PLUG Plugins {{{

silent! if plug#begin('~/.vim/plugged')
" Colors
Plug 'morhetz/gruvbox'
Plug 'chriskempson/base16-vim'
Plug 'arcticicestudio/nord-vim'

" Git
Plug 'mhinz/vim-signify'
  let g:signify_vcs_list = ['git']
  let g:signify_skip_filetype = { 'journal': 1 }
  let g:signify_sign_add          = '│'
  let g:signify_sign_change       = '│'
  let g:signify_sign_changedelete = '│'
Plug 'tpope/vim-fugitive'
  nmap     <Leader>g :Gstatus<CR>gg<c-n>
  nnoremap <Leader>d :Gdiff<CR>

" Edit
Plug 'tpope/vim-commentary'
  map  <Leader>c  <Plug>Commentary
  nmap <Leader>cc <Plug>CommentaryLine
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
  let g:undotree_WindowLayout = 2
  nnoremap U :UndotreeToggle<CR>
Plug 'vim-scripts/ReplaceWithRegister'
Plug 'junegunn/goyo.vim'

" Navigate
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'justinmk/vim-gtfo'
Plug 'wsdjeg/FlyGrep.vim', { 'on': 'FlyGrep'}
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
  augroup nerd_loader
    autocmd!
    autocmd VimEnter * silent! autocmd! FileExplorer
    autocmd BufEnter,BufNew *
          \  if isdirectory(expand('<amatch>'))
          \|   call plug#load('nerdtree')
          \|   execute 'autocmd! nerd_loader'
          \| endif
  augroup END
Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
  let g:tagbar_sort = 0
  nnoremap T :TagbarToggle<CR>
Plug 'Yggdroot/indentLine', { 'on': 'IndentLinesEnable' }
  autocmd! User indentLine doautocmd indentLine Syntax
  let g:indentLine_color_term = 239
  let g:indentLine_color_gui = '#616161'
Plug 'junegunn/vim-slash'
Plug 'christoomey/vim-tmux-navigator'

" Python
Plug 'vim-python/python-syntax'
Plug 'dccmx/google-style.vim'
" FIXME: Kinda slow...
" Plug 'python-mode/python-mode', { 'branch': 'develop' }

" Golang
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }

" C/C++
Plug 'octol/vim-cpp-enhanced-highlight'


" NOTE: Figure out how to lazy load
" Plug 'vimwiki/vimwiki', { 'branch': 'dev'}
Plug 'mrk21/yaml-vim'
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }
" Basically IDE
Plug 'ludovicchabant/vim-gutentags'
Plug 'ervandew/supertab'

" Testing
" Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Lint
Plug 'w0rp/ale'
  let g:ale_lint_delay = 1000
  nmap ]a <Plug>(ale_next_wrap)
  nmap [a <Plug>(ale_previous_wrap)
Plug 'maralla/completor.vim' " NOTE: Uses JEDI already
" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }

call plug#end()
endif
" }}}

" syntax on " NOTE: Already in defaults
" set background=dark
" NOTE: Setting background or syntax after color results in twice sourcing
silent! colorscheme nord

" Basic settings {{{

" Don't use termguicolors with Terminal.app
if has('termguicolors') && $TERM_PROGRAM != "Apple_Terminal"
  set termguicolors
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
endif


" Plugin's settings {{{
let g:gruvbox_contrast_dark = 'soft'

let g:gutentags_cache_dir='~/.cache/tags'

let g:netrw_banner = 0
let g:netrw_liststyle = 0
let g:netrw_browse_split = 0
let g:netrw_altv = 1
let g:netrw_winsize = -25
let g:netrw_keepdir = 0
let g:netrw_sort_sequence = '[\/]$,*'

" let g:ale_set_highlights = 0
" let g:ale_sign_column_always = 1
" let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
" let g:ale_sign_error = '•'
" let g:ale_sign_warning = '•'
" let g:ale_echo_msg_error_str =  '✹ Error'
" let g:ale_echo_msg_warning_str = '⚠ Warning'

let g:python_highlight_all = 1

let g:SuperTabDefaultCompletionType = "<c-n>"

let g:vimwiki_list = [{'path': '~/Documents/Notes',
                      \'syntax': 'markdown', 'ext': '.md'}]

let g:fzf_colors = {
    \ 'fg':      ['fg', 'GruvboxGray'],
    \ 'bg':      ['bg', 'Normal'],
    \ 'hl':      ['fg', 'GruvboxRed'],
    \ 'fg+':     ['fg', 'GruvboxGreen'],
    \ 'bg+':     ['bg', 'GruvboxBg1'],
    \ 'hl+':     ['fg', 'GruvboxRed'],
    \ 'info':    ['fg', 'GruvboxOrange'],
    \ 'prompt':  ['fg', 'GruvboxBlue'],
    \ 'header':  ['fg', 'GruvboxBlue'],
    \ 'pointer': ['fg', 'Error'],
    \ 'marker':  ['fg', 'Error'],
    \ 'spinner': ['fg', 'Statement'],
\ }
" }}}

" Interface settings {{{
if has('gui_running')
    set guioptions=a
    if has('win32')
        set guifont=Input_Mono:h14,Consolas:h14
    else
        set guifont=Input\ Mono\ 12,Monospace\ 12
    endif
endif

" Settings for ConEmu (Windows Term Emulator)
if !empty($CONEMUBUILD)
    set term=pcansi
    set t_Co=256
    let &t_AB="\e[48;5;%dm"
    let &t_AF="\e[38;5;%dm"
endif


function! s:statusline_expr()
  let mod = "%{&modified ? '[+] ' : !&modifiable ? '[x] ' : ''}"
  let ro  = "%{&readonly ? '[RO] ' : ''}"
  let ft  = "%{len(&filetype) ? '['.&filetype.'] ' : ''}"
  let fug = "%{exists('g:loaded_fugitive') ? fugitive#statusline() : ''}"
  let sep = ' %= '
  let pos = ' %-12(%l : %c%V%) '
  let pct = ' %P'

  return '[%n] %F %<'.mod.ro.ft.fug.sep.pos.'%*'.pct
endfunction
let &statusline = s:statusline_expr()


" syntax on " NOTE: Already in defaults
" set background=dark
" NOTE: Setting background or syntax after color results in twice sourcing
" silent! colorscheme nord

" Highlight diff language input cursor with other color
highlight lCursor guifg=NONE guibg=Cyan
" }}}

" Basic settings {{{

set nostartofline

set foldenable
set foldlevelstart=10
set foldnestmax=10
set foldmethod=syntax

set keymap=russian-jcukenwin
set langmap=ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz
set iminsert=0
set imsearch=-1
set spelllang=ru_ru,en_us

set fileformats=unix,dos,mac
set modeline
set number
set ruler

set timeoutlen=500
set tabstop=8
set softtabstop=4
set shiftwidth=4
set smarttab expandtab
set autoindent smartindent
set showcmd
set virtualedit=block

set cursorline
set showmatch

" Enable backups and swap just in case..
set backupdir=/tmp//,.
set directory=/tmp//,.
set undodir=/tmp//,.

set clipboard=unnamed
set completeopt=menuone,preview
" No need in Import when tags completion used
set complete-=i

set textwidth=0
" This is a good half screen limit for any file
set colorcolumn=80

" Don't break a line after one-letter word.
" Remove comment leader when joining lines
set formatoptions+=1j

let &showbreak = '↳ '
set breakindent
set breakindentopt=sbr

set exrc

set laststatus=2

set ignorecase smartcase
set gdefault
set incsearch
set showmatch
set hlsearch

set backspace=indent,eol,start
set list listchars=tab:→…,trail:•

set wildmenu wildmode=full

set shortmess=aIT

set ttyfast
set lazyredraw
if !has('nvim')
  set ttymouse=xterm2
  set ttyscroll=3
endif

set mouse=a
set autoread
set hidden

set splitright
set splitbelow

set modelines=2
set synmaxcol=1000

set noerrorbells visualbell t_vb=

hi! link cppStructure cppStatement
" }}}

" Autocmd {{{
augroup vimrc
    autocmd!
    autocmd FileType python,rst,c,cpp highlight Excess ctermbg=DarkGrey guibg=Black
    autocmd FileType python,rst,c,cpp match Excess /\%81v.*/
    autocmd GUIEnter * set visualbell t_vb=
    autocmd FocusLost * if expand('%') != '' | update | endif
    autocmd BufWritePost _vimrc,.vimrc source %
augroup END

augroup pythonrc
    autocmd!
    autocmd FileType python setlocal indentexpr=GetGooglePythonIndent(v:lnum)
augroup END

fun! s:pysearch(pattern)
    execute 'vimgrep ' . a:pattern . ' ./**/*.py'
endfun
command! -nargs=1 Pysearch call s:pysearch(<f-args>)

nmap <silent> g/ :FlyGrep<CR>
nmap <silent> <leader>* :noautocmd vimgrep <cword> ./**/*<CR>

" }}}

" Mappings {{{
nnoremap Q @q

nmap <silent> <leader>/ :nohlsearch<CR>
map Y y$

nnoremap <leader>ev :e $MYVIMRC<cr>
nnoremap <leader>s :set spell! <ENTER>
nnoremap <leader>v V`]

nnoremap <C-p> :GFiles<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader><leader> :Buffers<CR>
nnoremap <tab> <C-W><C-W>

" ----------------------------------------------------------------------------
" Markdown headings
" ----------------------------------------------------------------------------
nnoremap <leader>1 m`yypVr=``
nnoremap <leader>2 m`yypVr-``
nnoremap <leader>3 m`^i### <esc>``4l
nnoremap <leader>4 m`^i#### <esc>``5l
nnoremap <leader>5 m`^i##### <esc>``6l

nnoremap <leader><leader> :Files<CR>

nnoremap <F3> :50Vex!<CR>
vnoremap <F4> :<C-U>1,'<-1:delete<CR>:'>+1,$:delete<CR>
nnoremap <F10> :Goyo<CR>

" Open new line below and above current line
nnoremap <leader>o o<esc>
nnoremap <leader>O O<esc>

" Save
inoremap <C-s>     <C-O>:update<cr>
nnoremap <C-s>     :update<cr>
nnoremap <leader>s :update<cr>
nnoremap <leader>w :update<cr>
" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %

" Quit
inoremap <C-Q>     <esc>:q<cr>
nnoremap <C-Q>     :q<cr>
vnoremap <C-Q>     <esc>
nnoremap <Leader>q :q<cr>
nnoremap <Leader>Q :qa!<cr>

nnoremap [e :ALEPrevious<cr>
nnoremap ]e :ALENext<cr>

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
inoremap <C-U> <C-G>u<C-U>

function! s:colors(...)
  return filter(map(filter(split(globpath(&rtp, 'colors/*.vim'), "\n"),
        \                  'v:val !~ "^/usr/"'),
        \           'fnamemodify(v:val, ":t:r")'),
        \       '!a:0 || stridx(v:val, a:1) >= 0')
endfunction

function! s:rotate_colors()
  if !exists('s:colors')
    let s:colors = s:colors()
  endif
  let name = remove(s:colors, 0)
  call add(s:colors, name)
  execute 'colorscheme' name
  redraw
  echo name
endfunction

nnoremap <silent> <F8> :call <SID>rotate_colors()<cr>

fun! s:ctoogle()
    if empty(filter(getwininfo(), 'v:val.quickfix && !v:val.loclist'))
        copen
    else
        cclose
    endif
endfun
command! Ctoogle call s:ctoogle()

fun! s:ltoogle()
    if empty(filter(getwininfo(), 'v:val.quickfix && v:val.loclist'))
        lopen
    else
        lclose
    endif
endfun
command! Ltoogle call s:ltoogle()

function! s:profile(bang)
  if a:bang
    profile pause
    noautocmd qall
  else
    profile start /tmp/profile.log
    profile func *
    profile file *
  endif
endfunction
command! -bang Profile call s:profile(<bang>0)

" Likewise, Files command with preview window
command! -bang -nargs=? -complete=dir Files
  \ call fzf#vim#files(<q-args>, fzf#vim#with_preview(), <bang>0)

" ----------------------------------------------------------------------------
" AutoSave
" ----------------------------------------------------------------------------
function! s:autosave(enable)
  augroup autosave
    autocmd!
    if a:enable
      autocmd TextChanged,InsertLeave <buffer>
            \  if empty(&buftype) && !empty(bufname(''))
            \|   silent! update
            \| endif
    endif
  augroup END
endfunction

command! -bang AutoSave call s:autosave(<bang>1)

" Convenient command to see the difference between the current buffer and the
" file it was loaded from, thus the changes you made.
" Only define it when not defined already.
" Revert with: ":delcommand DiffOrig".
if !exists(":DiffOrig")
  command DiffOrig vert new | set bt=nofile | r ++edit # | 0d_ | diffthis
    \ | wincmd p | diffthis
endif
" }}}

