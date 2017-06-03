set nocompatible

" Vundle start
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
Plugin 'tell-k/vim-autopep8'
Plugin 'valloric/youcompleteme'
Plugin 'sheerun/vim-polyglot'
Plugin 'majutsushi/tagbar'
call vundle#end()
filetype plugin indent on
" Vundle end

let g:ycm_python_binary_path = 'python3'
syntax on
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
set history=200
set ruler
set showcmd
set display=truncate
set scrolloff=5

" Force saving files that require root permission 
cnoremap w!! w !sudo tee > /dev/null %

nnoremap <F2> :YcmCompleter GetDoc<CR>
nnoremap <F3> :YcmCompleter GoTo<CR>
nnoremap <C-1> :YcmCompleter FixIt<CR>
inoremap <F2> <ESC>:YcmCompleter GetDoc<CR>
inoremap <F3> <ESC>:YcmCompleter GoTo<CR>
inoremap <C-1> <ESC>:YcmCompleter FixIt<CR>
nnoremap <Leader>x :close<CR>
nnoremap <Leader>t :NERDTree<CR>
nnoremap <Leader>o :TagBarToggle<CR>
autocmd FileType python nnoremap <buffer> <F8> :call Autopep8()<CR>
let g:autopep8_max_line_length=100
let g:autopep8_disable_show_diff=1
set tw=0
hi StatusLine   ctermfg=7  ctermbg=1 cterm=bold 
hi StatusLineNC ctermfg=1 ctermbg=7 cterm=none
set ttymouse=xterm2
set mouse=a

" Session hax
fu! RestoreSession()
    if filereadable(getcwd() . '/Session.vim')
        execute 'so ' . getcwd() . '/Session.vim'
        if bufexists(1)
            for l in range(1, bufnr('$'))
                if bufwinnr(l) == -1
                    exec 'sbuffer ' . l
                endif
            endfor
        endif
    endif
endfunction

" autocmd VimLeave * NERDTreeClose | mksessio! Session.vim
" autocmd VimEnter * nested call RestoreSession() | NERDTree
let g:ycm_collect_identifiers_from_tags_files=1
let g:ycm_filetype_blacklist= {'c':1}

if has('gui_running')
    color jellybeans
endif
