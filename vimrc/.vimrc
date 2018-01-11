set nocompatible

call plug#begin('~/.vim/plugged')
Plug 'VundleVim/Vundle.vim'
Plug 'scrooloose/nerdtree'
" Plugin 'ctrlpvim/ctrlp.vim'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-fugitive'
Plug 'nanotech/jellybeans.vim'
Plug 'nvie/vim-flake8'
Plug 'tell-k/vim-autopep8'
Plug 'valloric/youcompleteme'
Plug 'sheerun/vim-polyglot'
Plug 'majutsushi/tagbar'
Plug 'mileszs/ack.vim'
call plug#end()

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
" f for search
nnoremap <Leader>f :Ack 
" x to close
nnoremap <Leader>x :close<CR>
" t for tree
nnoremap <Leader>t :NERDTree<CR>
" o for outline
nnoremap <Leader>o :TagBarToggle<CR>
autocmd FileType python nnoremap <buffer> <F8> :call Autopep8()<CR>
let g:autopep8_max_line_length=100
let g:autopep8_disable_show_diff=1
set tw=0
hi StatusLine   ctermfg=7  ctermbg=1 cterm=bold 
hi StatusLineNC ctermfg=1 ctermbg=7 cterm=none
set ttymouse=xterm2
set mouse=a

" fzf mappings
nmap <Leader>p :Files<CR>
nmap <Leader>b :Buffers<CR>
nmap <C-p> :GFiles<CR>
nmap <C-h> :Ag<CR>
vmap <Leader>h "zy :Ag <C-R>z<CR>


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

" NERDTree compatible session managemnet
command Mksession NERDTreeClose | mksession!
command RestoreSession call RestoreSession() | NERDTree

let g:ycm_collect_identifiers_from_tags_files=1
let g:ycm_filetype_blacklist= {'c':1}

color jellybeans

" use ag for ack
let g:ackprg = 'ag --vimgrep'

" fix confusing nerdtree shortcuts

let NERDTreeMapOpenVSplit='v'
let NERDTreeMapOpenSplot='h'

" fix diff highlight
fun! SetDiffColors()
    highlight DiffAdd ctermfg=white ctermbg=Green
    highlight DiffDelete ctermfg=white ctermbg=DarkRed
    highlight DiffChange ctermfg=white ctermbg=DarkBlue
    highlight DiffText ctermfg=white ctermbg=DarkGrey
endfun
autocmd FilterWritePre * call SetDiffColors()

if has('gui_running') && has('win32')
    set guifont=Consolas:h12
endif
