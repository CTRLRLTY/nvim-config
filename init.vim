" vim-plug Plugins {{{1
call plug#begin(stdpath('config') . '/plugged')
Plug 'nvim-lua/plenary.nvim'

" Telescope {{{
Plug 'nvim-telescope/telescope.nvim', { 'tag': '0.1.8' }
Plug 'nvim-telescope/telescope-dap.nvim'
Plug 'LukasPietzschmann/telescope-tabs'
" }}}
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'vim/vim'
Plug 'nvim-treesitter/nvim-treesitter'
Plug 'sakhnik/nvim-gdb'
" {{{ DAP
Plug 'mfussenegger/nvim-dap'
Plug 'nvim-neotest/nvim-nio'
Plug 'rcarriga/nvim-dap-ui'
Plug 'leoluz/nvim-dap-go'
Plug 'jbyuki/one-small-step-for-vimkind'
" }}}
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
let g:map_lua_config = stdpath('config') . "/maps.lua"
let g:native_lsp_config = stdpath('config') . "/lsp.lua"
" }}}
" Global settings {{{
packadd termdebug
set foldmethod=marker
set tabstop=8 shiftwidth=8 expandtab
set wildmode=longest,list,full
set wildmenu
" }}}
" sources {{{ 
execute "source" . init_lua
execute "source" . map_lua_config

if has('nvim')
        execute "luafile" . native_lsp_config
endif
" }}}
