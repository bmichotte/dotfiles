require("nvim-treesitter.configs").setup({
    ensure_installed = {
        "bash",
        "css",
        "gitattributes",
        "gitignore",
        "gitcommit",
        "html",
        "javascript",
        "json",
        "lua",
        "markdown",
        "php",
        "prisma",
        "sql",
        "typescript",
        "markdown",
        "markdown_inline",
    },
    sync_install = true,
    auto_install = true,
    context_commentstring = {
        enable = true,
    },
    highlight = {
        enable = true,
    },
})
