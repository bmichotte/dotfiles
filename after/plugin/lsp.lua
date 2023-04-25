require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = { "tsserver", "lua_ls", "prismals", "tailwindcss" },
})
local lspconfig = require("lspconfig")
local null_ls = require("null-ls")
local typescript = require("typescript")
local eslint = require("eslint")
local lspsaga = require("lspsaga")

lspsaga.setup({})

local event = "BufWritePre" -- or "BufWritePost"
local async = event == "BufWritePost"

null_ls.setup({
    sources = {
        null_ls.builtins.formatting.stylua,
        --null_ls.builtins.diagnostics.eslint,
        --null_ls.builtins.completion.spell,
        require("typescript.extensions.null-ls.code-actions"),
    },
    on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            vim.keymap.set("n", "<Leader>f", function()
                vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
            end, { buffer = bufnr, desc = "[lsp] format" })

            -- format on save
            vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
            vim.api.nvim_create_autocmd(event, {
                buffer = bufnr,
                group = group,
                callback = function()
                    vim.lsp.buf.format({ bufnr = bufnr, async = async })
                end,
                desc = "[lsp] format on save",
            })
        end

        if client.supports_method("textDocument/rangeFormatting") then
            vim.keymap.set("x", "<Leader>f", function()
                vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
            end, { buffer = bufnr, desc = "[lsp] format" })
        end
    end,
})

eslint.setup({
    bin = "eslint_d", -- or `eslint_d`
    code_actions = {
        enable = true,
        apply_on_save = {
            enable = true,
            types = { "directive", "problem", "suggestion", "layout" },
        },
        disable_rule_comment = {
            enable = true,
            location = "separate_line", -- or `same_line`
        },
    },
    diagnostics = {
        enable = true,
        report_unused_disable_directives = false,
        run_on = "save",
    },
})

local keymap = vim.keymap -- for conciseness

-- enable keybinds only for when lsp server available
local on_attach = function(client, bufnr)
    -- keybind options
    local opts = { noremap = true, silent = true, buffer = bufnr }

    -- set keybinds
    keymap.set("n", "gf", "<cmd>Lspsaga lsp_finder<CR>", opts)                  -- show definition, references
    keymap.set("n", "gD", "<Cmd>Lspsaga goto_definition<CR>", opts)             -- got to declaration
    keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>", opts)             -- see definition and make edits in window
    keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)    -- go to implementation
    keymap.set({ "n", "v" }, "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts) -- see available code actions
    keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts)              -- smart rename
    keymap.set("n", "<leader>D", "<cmd>Lspsaga show_line_diagnostics<CR>", opts) -- show  diagnostics for line
    keymap.set("n", "<leader>d", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts) -- show diagnostics for cursor
    keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts)        -- jump to previous diagnostic in buffer
    keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts)        -- jump to next diagnostic in buffer
    keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts)                    -- show documentation for what is under cursor
    keymap.set("n", "<leader>o", "<cmd>LSoutlineToggle<CR>", opts)              -- see outline on right hand side

    -- typescript specific keymaps (e.g. rename file and update imports)
    if client.name == "tsserver" then
        keymap.set("n", "<leader>rf", ":TypescriptRenameFile<CR>") -- rename file and update imports
        keymap.set("n", "<leader>oi", ":TypescriptOrganizeImports<CR>") -- organize imports (not in youtube nvim video)
        keymap.set("n", "<leader>ru", ":TypescriptRemoveUnused<CR>") -- remove unused variables (not in youtube nvim video)
        --require("twoslash-queries").attach(client, bufnr)
    end
end

-- Change the Diagnostic symbols in the sign column (gutter)
-- (not in youtube nvim video)
local signs = { Error = " ", Warn = " ", Hint = "ﴞ ", Info = " " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- configure html server
lspconfig["html"].setup({
    capabilities = capabilities,
    on_attach = on_attach,
})

-- configure typescript server with plugin
typescript.setup({
    server = {
        capabilities = capabilities,
        on_attach = on_attach,
    },
    disable_commands = false, -- prevent the plugin from creating Vim commands
    debug = false,         -- enable debug logging for commands
    go_to_source_definition = {
        fallback = true,   -- fall back to standard LSP definition on failure
    },
})

-- configure css server
lspconfig["cssls"].setup({
    capabilities = capabilities,
    on_attach = on_attach,
})

-- configure tailwindcss server
lspconfig["prismals"].setup({
    capabilities = capabilities,
    on_attach = on_attach,
})

lspconfig["tailwindcss"].setup({
    capabilities = capabilities,
    on_attach = on_attach,
})

-- configure emmet language server
lspconfig["emmet_ls"].setup({
    capabilities = capabilities,
    on_attach = on_attach,
    filetypes = { "html", "typescriptreact", "javascriptreact", "css" },
})

lspconfig.lua_ls.setup({
    settings = {
        Lua = {
            format = {
                enable = true,
                defaultConfig = {
                    indent_style = "space",
                    indent_size = "4",
                },
            },
        },
    },
})
