return {
    {
        -- Improves the Neovim built-in LSP experience.
        "glepnir/lspsaga.nvim",
        branch = "main",
        config = function()
            require('lspsaga').setup({})
        end,
        dependencies = {
            'nvim-treesitter/nvim-treesitter',
            'nvim-tree/nvim-web-devicons',
        }
    },
    {
        "williamboman/mason.nvim",
        lazy = false,
        config = function()
            require("mason").setup()
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        lazy = false,
        config = function()
            require("mason-lspconfig").setup({
                handlers = {
                    require('lsp-zero').default_setup,
                },
                auto_install = true,
            })
        end,
    },
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v2.x",
        dependencies = {
            "hrsh7th/nvim-cmp",
            "neovim/nvim-lspconfig",
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            local lsp = require("lsp-zero").preset({})

            lsp.on_attach(function(client, bufnr)
                lsp.default_keymaps({ buffer = bufnr })
                vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references<cr>', { buffer = bufnr })

                if client.server_capabilities.inlayHintProvider then
                    vim.lsp.inlay_hint.enable(bufnr, true)
                end

                if client.name == 'tsserver' then
                    vim.keymap.set("n", "gf", "<cmd>Lspsaga lsp_finder<CR>",
                        { noremap = true, silent = true, buffer = bufnr, desc = "Show definition, references" })
                    vim.keymap.set("n", "gD", "<Cmd>Lspsaga goto_definition<CR>",
                        { noremap = true, silent = true, buffer = bufnr, desc = "Got to declaration" })
                    vim.keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>",
                        { noremap = true, silent = true, buffer = bufnr, desc = "See definition and make edits in window" })
                    vim.keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>",
                        { noremap = true, silent = true, buffer = bufnr, desc = "Go to implementation" })
                    vim.keymap.set({ "n", "v" }, "<leader>ca", "<cmd>Lspsaga code_action<CR>",
                        { noremap = true, silent = true, buffer = bufnr, desc = "See available code actions" })
                    vim.keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>",
                        { noremap = true, silent = true, buffer = bufnr, desc = "Smart rename" })
                    vim.keymap.set("n", "<leader>D", "<cmd>Lspsaga show_line_diagnostics<CR>",
                        { noremap = true, silent = true, buffer = bufnr, desc = "Show  diagnostics for line" })
                    vim.keymap.set("n", "<leader>d", "<cmd>Lspsaga show_cursor_diagnostics<CR>",
                        { noremap = true, silent = true, buffer = bufnr, desc = "Show diagnostics for cursor" })
                    vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>",
                        {
                            noremap = true,
                            silent = true,
                            buffer = bufnr,
                            desc =
                            "Show documentation for what is under cursor"
                        })

                    vim.keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>",
                        { noremap = true, silent = true, buffer = bufnr, desc = "Jump to previous diagnostic in buffer" })
                    vim.keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>",
                        { noremap = true, silent = true, buffer = bufnr, desc = "Jump to next diagnostic in buffer" })
                    vim.keymap.set({ "n", "v" }, "<leader>ca", "<cmd>Lspsaga code_action<CR>",
                        { noremap = true, silent = true, buffer = bufnr, desc = "See code actions" })
                else
                    vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action,
                        { noremap = true, silent = true, buffer = bufnr, desc = "See code actions" })
                end
                vim.keymap.set('i', '<C-h>', '<cmd>lua vim.lsp.buf.signature_help()<CR>',
                    { noremap = true, silent = true, buffer = bufnr, desc = "Show signature help" })

                local group = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = false })
                local event = "BufWritePre"
                local async = event == "BufWritePost"

                vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
                vim.api.nvim_create_autocmd(event, {
                    buffer = bufnr,
                    group = group,
                    callback = function()
                        vim.lsp.buf.format({ bufnr = bufnr, async = async })
                    end,
                    desc = "[lsp] format on save",
                })
            end)

            local lspconfig = require("lspconfig")
            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            lsp.set_sign_icons({
                error = "",
                warn = "",
                hint = " ",
                info = " ",
            })
            --lsp.skip_server_setup({ "tsserver" })

            --[[lsp.set_server_config({
                capabilities = {
                    textDocument = {
                        foldingRange = {
                            dynamicRegistration = false,
                            lineFoldingOnly = true,
                        },
                    },
                },
            })]]

            lsp.format_on_save({
                format_opts = {
                    async = false,
                    timeout_ms = 10000,
                },
            })

            lsp.format_mapping("gq", {
                format_opts = {
                    async = false,
                    timeout_ms = 10000,
                },
            })

            lsp.setup()

            lspconfig.biome.setup({
                capabilities = capabilities
            })
            local util = require("lspconfig/util")
            lspconfig.tsserver.setup({
                capabilities = capabilities,
                root_dir = util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
                init_options = {
                    preferences = {
                        includeInlayParameterNameHints = "all",
                        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                        includeInlayFunctionParameterTypeHints = true,
                        includeInlayVariableTypeHints = false,
                        includeInlayPropertyDeclarationTypeHints = true,
                        includeInlayFunctionLikeReturnTypeHints = false,
                        includeInlayEnumMemberValueHints = false,
                        importModuleSpecifierPreference = 'non-relative'
                    },
                },
                on_attach = function(client, bufnr)
                    require("twoslash-queries").attach(client, bufnr)
                    -- client.server_capabilities.document_formatting = false
                    -- client.server_capabilities.document_range_formatting = false
                    -- on_attach(client, bufnr)
                end,
            })
            lspconfig.html.setup({
                capabilities = capabilities
            })
            lspconfig.lua_ls.setup({
                capabilities = capabilities,
                settings = {
                    Lua = {
                        format = {
                            enable = true,
                        },
                        diagnostics = {
                            globals = { "vim" },
                            neededFileStatus = {
                                ["codestyle-check"] = "Any",
                            },
                            groupSeverity = { ["codestyle-check"] = "Warning", },
                        },
                        workspace = {
                            checkThirdParty = false,
                        },
                        completion = {
                            callSnippet = "Replace",
                        },
                    },
                },
            })
            lspconfig.prismals.setup({
                capabilities = capabilities,
            })

            vim.cmd(
                [[
augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost *.js,*.lua,*.prisma,*.css,*.ts,*.tsx,*.json FormatWrite
augroup END
]],
                true
            )
        end
    },
    {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    }
}
