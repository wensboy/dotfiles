"=========================
"        [options]
"=========================

let s:options_switch = v:true

if s:options_switch
    set nocompatible 
    set number
    set wrap
    set linebreak
    set relativenumber
    set tabstop=8
    set softtabstop=4
    set shiftwidth=4
    set expandtab
    set autoindent
    set smartindent
    set noignorecase
    set smartcase
    set incsearch
    set hlsearch
    set encoding=utf-8
    set fileencodings=utf-8,gbk,latin1
    set nobackup
    set noswapfile
    set showmatch
    set colorcolumn=80
    " set cursorline
    " set wildmenu
    syntax on
    filetype plugin indent on
    
    highlight ColorColumn ctermbg=239 guibg=#504549
endif
