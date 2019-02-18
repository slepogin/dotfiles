" vim: set foldmethod=marker foldlevel=99 nomodeline:
" Author: Nikita Slepogin
" Date: 01.04.2017

" Load vim defaults {{{
" Where is a bug in Windows.
" If you change encoding to UTF8 you should repopulate runtimepath.
" I prefer using .vim directory in both windows and linux.
language C
set encoding=UTF-8
set runtimepath=$HOME/.vim,$VIMRUNTIME

unlet! skip_defaults_vim
silent! source $VIMRUNTIME/defaults.vim
" }}}

" Utility functions {{{
fun! s:DownloadFileUnix(uri, dest)
    silent let l:output = system("curl -fLo ".a:dest." --create-dirs ".a:uri)
    return v:shell_error
endfun

fun! s:DownloadFileWindows(uri, dest)
    silent let l:output = system('powershell -command "md '.fnamemodify(a:dest, ':p:h').'; iwr -Uri \"'.a:uri.'\" -OutFile \"'.fnamemodify(a:dest, ':p').'\""')
    return v:shell_error
endfun

fun! DownloadFile(uri, dest)
    if has('unix')
        let l:result = s:DownloadFileUnix(a:uri, a:dest)
    elseif has('win32')
        let l:result = s:DownloadFileWindows(a:uri, a:dest)
    endif
    if l:result != 0
        echoerr 'Failed to download "'.a:uri.'"'
    endif
    return l:result
endfun

" TODO: Rewrite it with just git clone plug.vim! It's crossplatform anyway!

fun! s:CheckInstallVimPlug(dest)
    unlet! s:vim_plug_install
    let l:uri = "https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim"
    if empty(glob(a:dest, ':p'))
        if DownloadFile(l:uri, a:dest) == 0
            autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
            let s:vim_plug_install=1
        endif
    endif
endfun
" }}}

" VIM-PLUG Plugins {{{
call s:CheckInstallVimPlug('~/.vim/autoload/plug.vim')

silent! if plug#begin('~/.vim/plugged')
" Step 0 : Awesome file navigation [in progress]
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/goyo.vim'
Plug 'mhinz/vim-signify'

Plug 'vimwiki/vimwiki', { 'branch': 'dev' }
Plug 'wsdjeg/FlyGrep.vim'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'octol/vim-cpp-enhanced-highlight'

" Colors
Plug 'morhetz/gruvbox'

" Basically IDE
Plug 'ludovicchabant/vim-gutentags'
Plug 'w0rp/ale'
Plug 'maralla/completor.vim'
Plug 'ervandew/supertab'
Plug 'tpope/vim-fugitive'

" Python IDE
Plug 'vim-python/python-syntax'
Plug 'dccmx/google-style.vim'
Plug 'davidhalter/jedi-vim'
Plug 'python-mode/python-mode', { 'branch': 'develop' }

" Cpp IDE -> Install clang!
call plug#end()
endif

" This is needed to avoid error messages at first start
if exists('s:vim_plug_install')
    finish
endif
" }}}


" Basic settings {{{

" FIXME:Cool colors but doesn't work with Terminal.app
" Which is faster then iTerm :(
" if has('termguicolors')
"   set termguicolors
"   let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
"   let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
" endif

nnoremap <Space> <nop>
let mapleader      = "\<Space>"
let maplocalleader = "\<Space>"

let g:signify_vcs_list = ['git']
let g:signify_skip_filetype = { 'journal': 1 }

" Plugin's settings {{{
augroup vimrc
  autocmd!
augroup END

set statusline+=%{gutentags#statusline()}
set statusline+=%{fugitive#statusline()}
" let g:airline_powerline_fonts=1
let g:airline_theme='gruvbox'
let g:gutentags_cache_dir='~/.cache/tags'

let g:netrw_banner = 0
let g:netrw_liststyle = 0
let g:netrw_browse_split = 0
let g:netrw_altv = 1
let g:netrw_winsize = -25
let g:netrw_keepdir = 0
let g:netrw_sort_sequence = '[\/]$,*'

let g:ale_sign_column_always = 1
let g:airline#extensions#ale#enabled = 1
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

" Use completor.vim instead
let g:jedi#completions_enabled = 0
let g:python_highlight_all = 1
let g:SuperTabDefaultCompletionType = "<c-n>"
let g:vimwiki_list = [{'path': '~/Documents/Notes',
                       \ 'syntax': 'markdown', 'ext': '.md'}]

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

" Highlight diff language input cursor with other color
highlight lCursor guifg=NONE guibg=Cyan

syntax on
colorscheme gruvbox
set background=dark
" }}}

" Basic settings {{{

set nostartofline

set foldenable
set foldlevelstart=10
set foldnestmax=10
set foldmethod=syntax

set keymap=russian-jcukenwin
set spelllang=ru_ru,en_us

set fileformats=unix,dos,mac
set modeline

set number
set ruler
set relativenumber

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
set iminsert=0
set imsearch=0

set list listchars=tab:→…,trail:•

set wildmenu wildmode=full

set shortmess=aIT

set ttyfast ttymouse=xterm2 lazyredraw ttyscroll=3

set mouse=a
set autoread
set hidden

set splitright
set splitbelow

set modelines=2
set synmaxcol=1000

" For MacVim
set noimd
set imi=1
set ims=-1

set noerrorbells visualbell t_vb=

hi! link cppStructure cppStatement
" }}}

" Autocmd {{{
augroup vimrc
    autocmd!
    autocmd FileType python,rst,c,cpp highlight Excess ctermbg=DarkGrey guibg=Black
    autocmd FileType python,rst,c,cpp match Excess /\%81v.*/
    autocmd FileType python,rst,c,cpp set nowrap
    autocmd FileType python,rst,c,cpp set colorcolumn=80
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

fun! s:projectgrep(pattern)
    execute 'noautocmd vimgrep /' . a:pattern . '/j ./**/*'
    execute 'copen'
endfun
command! -nargs=1 Pgrep call s:projectgrep(<f-args>)
nmap <silent> g/ :Pgrep 
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


fun! s:BetterExplore()
    if exists(':Rexplore')
        execute 'Rexplore'
    else
        execute 'Explore'
    endif
endfun
command! BetterExplore call s:BetterExplore()

nnoremap <leader><leader> :Files<CR>

nnoremap <F2> :BetterExplore<CR>
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

" }}}

