" vim: set foldmethod=marker foldlevel=99 nomodeline:
" Author: Nikita Slepogin
" Date: 01.04.2017

" Where is a bug in Windows.
" If you change encoding to UTF8 you should repopulate runtimepath.
" language C
" set encoding=utf-8
" set runtimepath=$HOME/.vim,$VIMRUNTIME

" Normally `:set nocp` is not needed, because it is done automatically
if &compatible
  " `:set nocp` has many side effects. Therefore this should be done
  " only when 'compatible' is set.
  set nocompatible
endif

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

let mapleader      = "\<Space>"
let maplocalleader = "\<Space>"

let g:loaded_matchit = 1 " Don't need it
let g:loaded_gzip = 1 " Gzip is pointless
let g:loaded_zipPlugin = 1 " zip is also pointless
let g:loaded_logipat = 1 " No logs
let g:loaded_2html_plugin = 1 " Disable 2html
let g:loaded_rrhelper = 1 " I don't use r
let g:loaded_getscriptPlugin = 1 " Dont need it
let g:loaded_tarPlugin = 1 " Nope

" VIM-PLUG Plugins {{{

silent! if plug#begin('~/.vim/plugged')
" Colors
" Plug 'morhetz/gruvbox'
" Plug 'chriskempson/base16-vim'
Plug 'arcticicestudio/nord-vim'

" Git
Plug 'mhinz/vim-signify'
  let g:signify_vcs_list = ['git']
  let g:signify_sign_add          = '│'
  let g:signify_sign_change       = '│'
  let g:signify_sign_changedelete = '│'
Plug 'tpope/vim-fugitive'
  nmap     <Leader>g :Gstatus<CR>gg<c-n>
  nnoremap <Leader>d :Gdiff<CR>

" Edit
Plug 'tpope/vim-commentary'
  " xmap  <c-\/>  <Plug>Commentary
  " nmap  <c-\/>  <Plug>CommentaryLine
Plug 'mbbill/undotree', { 'on': 'UndotreeToggle' }
  let g:undotree_WindowLayout = 2
  nnoremap U :UndotreeToggle<CR>
Plug 'Yggdroot/indentLine', { 'on': 'IndentLinesEnable' }
  autocmd! User indentLine doautocmd indentLine Syntax
  let g:indentLine_color_term = 239
  let g:indentLine_color_gui = '#616161'
Plug 'vim-scripts/ReplaceWithRegister'
Plug 'jiangmiao/auto-pairs'
Plug 'junegunn/goyo.vim'

" Navigate and complete
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'justinmk/vim-gtfo'
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 0
let g:netrw_winsize = -25
let g:netrw_sort_sequence = '[\/]$,*'
let g:netrw_list_hide='.*\.git/$,'.netrw_gitignore#Hide()
nnoremap <silent> - :Explore<cr>
if has('nvim')
    augroup netrw_setup
        autocmd!
        autocmd FileType netrw setl bufhidden=wipe
        autocmd FileType netrw nnoremap <buffer> Q :Rexplore<CR>
"        autocmd FileType netrw setlocal cursorline winhighlight=Normal:Tabline fillchars=vert:\ 
    augroup END
endif

if has('nvim-0.5')
    Plug 'neovim/nvim-lsp'
    " Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
    " Plug 'Shougo/deoplete-lsp'
      let g:python_host_prog = expand('~/.pyenv/versions/2.7.17/envs/neovim2.7/bin/python')
      let g:python3_host_prog = expand('~/.pyenv/versions/3.6.6/envs/neovim/bin/python')
      let g:deoplete#enable_at_startup = 1
    Plug 'ervandew/supertab'
    Plug 'w0rp/ale'
      let g:ale_lint_delay = 1000
      nmap ]a <Plug>(ale_next_wrap)
      nmap [a <Plug>(ale_previous_wrap)

endif

Plug 'majutsushi/tagbar', { 'on': 'TagbarToggle' }
  let g:tagbar_sort = 1
  let g:tagbar_left = 1
  let g:tagbar_autofocus = 1
  nnoremap T :TagbarToggle<CR>
if has('nvim')
    augroup tagbar_setup
        autocmd!
        autocmd FileType tagbar setlocal winhighlight=Normal:Tabline fillchars=vert:\ 
    augroup END
endif
Plug 'junegunn/vim-slash'
Plug 'christoomey/vim-tmux-navigator'


Plug 'sheerun/vim-polyglot'
" Python
" Plug 'vim-python/python-syntax'
" Plug 'dccmx/google-style.vim'

" Golang
" Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries' }

" C/C++
" Plug 'octol/vim-cpp-enhanced-highlight'


" NOTE: Figure out how to lazy load
" Plug 'vimwiki/vimwiki', { 'branch': 'dev'}
" Plug 'mrk21/yaml-vim'
" Plug 'gabrielelana/vim-markdown'
" Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() } }


" Basically IDE
" Plug 'ludovicchabant/vim-gutentags'


" Lint
" Plug 'maralla/completor.vim' " NOTE: Uses JEDI already
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

if has('nvim-0.5')
lua << EOF
    local nvim_lsp = require 'nvim_lsp'
    do
        local method = 'textDocument/publishDiagnostics'
        local default_callback = vim.lsp.callbacks[method]
        vim.lsp.callbacks[method] = function(err, method, result, client_id)
        if not result then return end
            local uri = result.uri
            local bufnr = vim.uri_to_bufnr(uri)
            if not bufnr then
                err_message("LSP.publishDiagnostics: Couldn't find buffer for ", uri)
                return
            end
            vim.lsp.util.buf_clear_diagnostics(bufnr)
            vim.lsp.util.buf_diagnostics_save_positions(bufnr, result.diagnostics)
            vim.lsp.util.buf_diagnostics_underline(bufnr, result.diagnostics)
        end
        nvim_lsp.pyls_ms.setup{
            root_dir = nvim_lsp.util.root_pattern('.git', ".");
        }
    end
EOF

    augroup LSP
        autocmd!
        autocmd FileType python setlocal omnifunc=v:lua.vim.lsp.omnifunc
        autocmd FileType python autocmd CursorHold <buffer> lua vim.lsp.util.show_line_diagnostics()
        autocmd FileType python autocmd CursorMoved <buffer> lua vim.lsp.util.show_line_diagnostics()
        autocmd FileType python nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>
        autocmd FileType python nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
        autocmd FileType python nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
        autocmd FileType python nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
        autocmd FileType python nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
        autocmd FileType python nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
        autocmd FileType python nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
        autocmd FileType python nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
    augroup END
endif

" let g:coc_global_extensions = ['coc-python']
" 
" augroup coc-config
"   autocmd!
"   autocmd VimEnter * nmap <silent> gd <Plug>(coc-definition)
"   autocmd VimEnter * nmap <silent> g? <Plug>(coc-references)
" augroup END


" Plugin's settings {{{
let g:gruvbox_contrast_dark = 'soft'

let g:gutentags_cache_dir='~/.cache/tags'


" let g:ale_set_highlights = 0
" let g:ale_sign_column_always = 1
" let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
" let g:ale_sign_error = '•'
" let g:ale_sign_warning = '•'
" let g:ale_echo_msg_error_str =  '✹ Error'
" let g:ale_echo_msg_warning_str = '⚠ Warning'

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
" }}}

" Basic settings {{{


set completeopt-=preview

" No need in Import when tags completion used
" set complete-=i


" Title for timetracking
set title
" set titlestring=%t

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

set lazyredraw

if !has('nvim')
    " TTY settings for Vim only.
  set ttyfast ttymouse=xterm2 ttyscroll=3
endif

set mouse=a
set autoread
set hidden

set splitright
set splitbelow

set modelines=2
set synmaxcol=1000

" Disable audible bell because it's annoying.
set noerrorbells visualbell t_vb=
" }}}

" Autocmd {{{
augroup vimrc
    autocmd!
    " Autosave changes, convenient.
    autocmd TextChanged,InsertLeave <buffer>
          \  if empty(&buftype) && !empty(bufname(''))
          \|   silent! update
          \| endif
    " Autosource vimrc if saved.
    autocmd BufWritePost $MYVIMRC source %
augroup END
" }}}

" Mappings {{{
nnoremap Q @q
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

nnoremap <leader>vs :50Vex!<CR>
vnoremap <leader>da :<C-U>1,'<-1:delete<CR>:'>+1,$:delete<CR>

" Allow saving of files as sudo when I forgot to start vim using sudo.
cmap w!! w !sudo tee > /dev/null %

nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
inoremap <C-U> <C-G>u<C-U>

function! s:profile(bang)
  if a:bang
    profile pause
    noautocmd qall
  else
    profile start vim-profile.log
    profile func *
    profile file *
  endif
endfunction
command! -bang Profile call s:profile(<bang>0)
" }}}

