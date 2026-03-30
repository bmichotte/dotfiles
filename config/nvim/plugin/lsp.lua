vim.pack.add({
    "https://github.com/mason-org/mason-lspconfig.nvim",
    -- dependencies
    "https://github.com/mason-org/mason.nvim",
    "https://github.com/saghen/blink.cmp",
    "https://github.com/neovim/nvim-lspconfig",
})

require("mason").setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
        },
    },
})
require("mason-lspconfig").setup({
    ensure_installed = {
        "html",
        "cssls",
        "tailwindcss",
        "lua_ls",
        "emmet_ls",
        "prismals",
        "biome",
        "vtsls",
    },
})
