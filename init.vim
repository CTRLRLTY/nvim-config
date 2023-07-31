" vim-plug Plugins {{{1
call plug#begin(stdpath('config') . '/plugged')
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
" UltiSnip {{{2
Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
" }}}
call plug#end()
" }}}
" Global Names {{{
let g:mapleader = "-"
let g:maplocalleader = "\\"
let g:init_lua = stdpath('config') . "/config.lua"
let g:map_config = stdpath('config') . "/maps.vimrc"
let g:map_lua_config = stdpath('config') . "/maps.lua"
let g:fzf_config = stdpath('config') . "/fzf.vim"
let g:native_lsp_config = stdpath('config') . "/lsp.lua"
" }}}
" Global settings {{{
set foldmethod=marker
set tabstop=8 shiftwidth=8 expandtab
set wildmode=longest,list,full
set wildmenu
set nu rnu

autocmd vimenter * ++nested colorscheme gruvbox

augroup numbertoggle
        autocmd!
        autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
        autocmd BufLeave,FocusLost,InsertEnter * set norelativenumber
augroup END
" }}}
" sources {{{
" execute "source" . map_config
execute "source" . init_lua
execute "source" . map_lua_config

if has('nvim')
        execute "luafile" . native_lsp_config
endif
" }}}
