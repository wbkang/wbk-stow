syntax on
set nocompatible
set autoindent
set hlsearch
set ignorecase
set incsearch
set smartcase
set softtabstop=4
set tabstop=4
set shiftwidth=4
set smarttab
set expandtab
set backspace=indent,eol,start
set number
" Force saving files that require root permission 
cnoremap w!! w !sudo tee > /dev/null %

filetype off
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'tpope/vim-sensible'
Plugin 'nanotech/jellybeans.vim'
Plugin 'nvie/vim-flake8'
Plugin 'valloric/youcompleteme'
Plugin 'sheerun/vim-polyglot'
Plugin 'majutsushi/tagbar'
call vundle#end()
filetype plugin indent on
let g:ycm_python_binary_path = 'python3'
nnoremap <F2> :YcmCompleter GetDoc<CR>
nnoremap <F3> :YcmCompleter GoTo<CR>
nnoremap <C-1> :YcmCompleter FixIt<CR>
inoremap <F2> <ESC>:YcmCompleter GetDoc<CR>
inoremap <F3> <ESC>:YcmCompleter GoTo<CR>
inoremap <C-1> <ESC>:YcmCompleter FixIt<CR>
nnoremap <C-x> :close<CR>
nnoremap <Leader>t :NERDTree<CR>
nnoremap <Leader>o :TagBarToggle<CR>
set tw=0
hi StatusLine   ctermfg=15  guifg=#ffffff ctermbg=239 guibg=#4e4e4e cterm=bold gui=bold
hi StatusLineNC ctermfg=249 guifg=#b2b2b2 ctermbg=237 guibg=#3a3a3a cterm=none
gui=none

