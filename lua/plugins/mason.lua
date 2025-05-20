return {
        {
                "mason-org/mason.nvim",
                config = true,
        },
        {
                "mason-org/mason-lspconfig.nvim",
                opts = {
                        ensure_installed = { 
                                "lua_ls",
                                "pyright",
                                "vimls",
                                "cmake",
                                "clangd",
                                "gopls",
                        },
                        automatic_enable = true,
                },
                dependencies = {
                        "mason-org/mason.nvim",
                        "neovim/nvim-lspconfig",
                },
        }
}
