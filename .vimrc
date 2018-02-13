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

let s:vim_plug_url='https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

unlet! skip_defaults_vim
silent! source $VIMRUNTIME/defaults.vim

function! _download_file_linux()
    silent let l:output = system('curl -fLo ~/test.file --create-dirs http://googleom')
    return v:shell_error
endfunction
" }}}

" VIM-PLUG Install {{{
unlet! vim_plug_installed
if empty(glob('$HOME/.vim/autoload/plug.vim'))
    if has('unix')
        silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    elseif has('win32')
        silent !powershell -command "md ~/.vim/autoload;
        \ (New-Object Net.WebClient).DownloadFile(
        \ \"https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim\",
        \ $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath(
        \ \"~\.vim\autoload\plug.vim\"))"
    endif
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
    let vim_plug_installed=1
endif
" }}}

" TODO: Add checks for shell commands : fzf, ctags, clang..

" VIM-PLUG Plugins {{{
silent! if plug#begin()
" Step 0 : Awesome file navigation [in progress]
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
" end.
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'dccmx/google-style.vim'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'junegunn/goyo.vim'

" Basically IDE
Plug 'ludovicchabant/vim-gutentags'
Plug 'w0rp/ale'
Plug 'maralla/completor.vim'
Plug 'ervandew/supertab'
Plug 'tpope/vim-fugitive'

" Python IDE
Plug 'davidhalter/jedi-vim'

" Cpp IDE -> Install clang!
call plug#end()
endif

" This is needed to avoid error messages at first start
if exists('vim_plug_installed')
    finish
endif
" }}}

if has('termguicolors')
  let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
  let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
  set termguicolors
endif

nnoremap <Space> <nop>
let mapleader      = "\<Space>"
let maplocalleader = "\<Space>"

" Plugin's settings {{{
set statusline+=%{gutentags#statusline()}
set statusline+=%{fugitive#statusline()}
" let g:airline_powerline_fonts=1
let g:airline_theme='gruvbox'

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

let g:SuperTabDefaultCompletionType = "<c-n>"
" }}}

" Interface settings {{{
if has('gui_running')
    set guioptions=a
    if has('win32')
        set guifont=Input_Mono:h14,Consolas:h14
    else
        set guifont=Input\ Mono\ 12,Monospace\ 12
    endif
else
    " Settings for ConEmu (Windows Term Emulator)
    if !empty($CONEMUBUILD)
        set term=pcansi
        set t_Co=256
        let &t_AB="\e[48;5;%dm"
        let &t_AF="\e[38;5;%dm"
    endif
endif
syntax on
set background=dark
colorscheme gruvbox
" Highlight diff language input cursor with other color
highlight lCursor guifg=NONE guibg=Cyan
" }}}

" Basic settings {{{

set foldenable
set foldlevelstart=10
set foldnestmax=10

set keymap=russian-jcukenwin
set spelllang=ru_ru,en_us

set fileformats=unix,dos,mac
set modeline

set number
set ruler
set relativenumber

set tabstop=8
set softtabstop=4
set shiftwidth=4
set smarttab
set expandtab
set autoindent

set cursorline
set showmatch

set nobackup
set nowritebackup
set noswapfile

set clipboard^=unnamed,unnamedplus

set exrc
nnoremap <leader><leader> :Commands<CR>

set laststatus=2

set ignorecase
set smartcase
set gdefault
set incsearch
set showmatch
set hlsearch
set iminsert=0
set imsearch=0

set listchars=tab:→…,trail:•
set list

set ttyfast
set wildmenu
set wildmode=full

set mouse=a
set autoread
set hidden

set noerrorbells visualbell t_vb=
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
    execute 'vimgrep ' . a:pattern . ' ../**/*.py'
endfun
command! -nargs=1 Pysearch call s:pysearch(<f-args>)
" }}}

" Mappings {{{
nnoremap Q @q

nmap <silent> <leader>/ :nohlsearch<CR>
nnoremap / /\v
vnoremap / /\v

nnoremap <leader>ev :e $MYVIMRC<cr>
nnoremap <leader>s :set spell! <ENTER>
nnoremap <leader>v V`]

nnoremap <C-p> :Files<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader><leader> :Commands<CR>

fun! s:BetterExplore()
    if exists(':Rexplore')
        execute 'Rexplore'
    else
        execute 'Explore'
    endif
endfun
command! BetterExplore call s:BetterExplore()

nnoremap <F2> :BetterExplore<CR>
nnoremap <F3> :50Vex!<CR>
nnoremap <F10> :Goyo<CR>

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

nnoremap <leader>op o<ESC>p

nnoremap <tab> %
vnoremap <tab> %

" }}}

