require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = { "eslint", "tsserver", "lua_ls", "prismals", "sqlls", "tailwindcss" }
})

local null_ls = require("null-ls")

null_ls.setup({
    sources = {
        null_ls.builtins.formatting.stylua,
        null_ls.builtins.diagnostics.eslint,
        null_ls.builtins.completion.spell,
        require("typescript.extensions.null-ls.code-actions"),
    },
})

require("typescript").setup({
    disable_commands = false, -- prevent the plugin from creating Vim commands
    debug = false, -- enable debug logging for commands
    go_to_source_definition = {
        fallback = true, -- fall back to standard LSP definition on failure
    },
    server = { -- pass options to lspconfig's setup method
        --on_attach = ...,
    },
})
