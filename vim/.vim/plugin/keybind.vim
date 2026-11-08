"=========================
"       [keybind]
"=========================

let s:keybind_switch = v:true

if s:keybind_switch
    let g:mapleader = '\'
    :vnoremap foo :<C-u>command<cr>
endif