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
" Force saving files that require root permission 
cnoremap w!! w !sudo tee > /dev/null %
