return {
    {
        "williamboman/mason.nvim",
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/nvim-cmp",
            "hrsh7th/cmp-nvim-lsp",
            "neovim/nvim-lspconfig",
            "nvimdev/lspsaga.nvim",
            "folke/neodev.nvim"
        },
        lazy = false,
        config = function()
            require("mason").setup({
                ui = {
                    border = "rounded"
                }
            })

            require("neodev").setup({})

            local lspconfig = require("lspconfig")
            local util = require("lspconfig/util")
            local capabilities = require('cmp_nvim_lsp').default_capabilities()

            require('lspsaga').setup({
                lightbulb = {
                    enable = false,
                }
            })

            local on_attach = function(client, bufnr)
                vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references<cr>', { buffer = bufnr })

                if client.server_capabilities.inlayHintProvider then
                    vim.lsp.inlay_hint.enable(bufnr, true)
                end

                -- vim.keymap.set("n", "gf", "<cmd>Lspsaga lsp_finder<CR>", { noremap = true, silent = true, buffer = bufnr, desc = "Show definition, references" })
                vim.keymap.set("n", "gd", vim.lsp.buf.declaration,
                    { noremap = true, silent = true, buffer = bufnr, desc = "Got to declaration" })
                vim.keymap.set("n", "gD", vim.lsp.buf.definition,
                    { noremap = true, silent = true, buffer = bufnr, desc = "See definition and make edits in window" })
                vim.keymap.set("n", "gi", vim.lsp.buf.implementation,
                    { noremap = true, silent = true, buffer = bufnr, desc = "Go to implementation" })
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename,
                    { noremap = true, silent = true, buffer = bufnr, desc = "Smart rename" })
                vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition,
                    { noremap = true, silent = true, buffer = bufnr, desc = "Show  diagnostics for line" })
                -- vim.keymap.set("n", "<leader>d", "<cmd>Lspsaga show_cursor_diagnostics<CR>", { noremap = true, silent = true, buffer = bufnr, desc = "Show diagnostics for cursor" })
                vim.keymap.set("n", "K", vim.lsp.buf.hover,
                    { noremap = true, silent = true, buffer = bufnr, desc = "Show documentation for what is under cursor" })
                -- vim.keymap.set("n", "[d", vim.diagnostic.goto_prev,
                --     { noremap = true, silent = true, buffer = bufnr, desc = "Jump to previous diagnostic in buffer" })
                -- vim.keymap.set("n", "]d", vim.diagnostic.goto_next,
                --     { noremap = true, silent = true, buffer = bufnr, desc = "Jump to next diagnostic in buffer" })

                vim.keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>",
                    { noremap = true, silent = true, buffer = bufnr, desc = "Jump to previous diagnostic in buffer" })
                vim.keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>",
                    { noremap = true, silent = true, buffer = bufnr, desc = "Jump to next diagnostic in buffer" })

                vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action,
                    { noremap = true, silent = true, buffer = bufnr, desc = "See code actions" })
                vim.keymap.set('i', '<C-h>', vim.lsp.buf.signature_help,
                    { noremap = true, silent = true, buffer = bufnr, desc = "Show signature help" })
            end

            require("mason-lspconfig").setup({
                auto_install = true,
                handlers = {
                    function(server_name)
                        lspconfig[server_name].setup({
                            capabilities = capabilities,
                            on_attach = on_attach,
                        })
                    end,
                    ["tsserver"] = function()
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
                                on_attach(client, bufnr)
                            end,
                        })
                    end,
                    ["lua_ls"] = function()
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
                                    runtime = {
                                        version = 'LuaJIT'
                                    },
                                    workspace = {
                                        library = vim.api.nvim_get_runtime_file('', true),
                                        checkThirdParty = false,
                                    },
                                    completion = {
                                        callSnippet = "Replace",
                                    },
                                },
                            },
                            on_attach = on_attach,
                        })
                    end,
                    ['eslint'] = function()
                        lspconfig.eslint.setup({
                            capabilities = capabilities,
                            on_attach = function(client, bufnr)
                                vim.api.nvim_create_autocmd("BufWritePre", {
                                    buffer = bufnr,
                                    command = "EslintFixAll",
                                })
                                on_attach(client, bufnr)
                            end,
                        })
                    end,
                },
            })

            vim.diagnostic.config({
                underline = true,
                update_in_insert = false,
                virtual_text = {
                    spacing = 4,
                    source = "if_many",
                    prefix = "●",
                    -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
                    -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
                    -- prefix = "icons",
                },
                severity_sort = true,
                float = { border = "rounded" },
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = "",
                        [vim.diagnostic.severity.WARN] = "",
                        [vim.diagnostic.severity.HINT] = " ",
                        [vim.diagnostic.severity.INFO] = " ",
                    }
                }
            })

            vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
                vim.lsp.handlers.hover,
                { border = "rounded" }
            )

            vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
                vim.lsp.handlers.signature_help,
                { border = "rounded" }
            )

            local setup_group = vim.api.nvim_create_augroup("lsp_format_config", { clear = true })
            vim.api.nvim_create_autocmd('LspAttach', {
                group = setup_group,
                desc = 'Enable format on save',
                callback = function(event)
                    local format_group = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = true })
                    vim.api.nvim_create_autocmd('BufWritePre', {
                        group = format_group,
                        buffer = event.buf,
                        desc = "Format buffer",
                        callback = function()
                            vim.lsp.buf.format({
                                async = false,
                                timeout_ms = 10000,
                            })
                        end,
                    })

                    vim.keymap.set({ 'n', 'x' }, '<leader>f',
                        function() vim.lsp.buf.format({ async = false, timeout_ms = 10000 }) end,
                        { buffer = event.buf, desc = "Format buffer" })
                end,
            })
        end,
    },
    {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    }
}
