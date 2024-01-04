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
            "neovim/nvim-lspconfig",
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
        },
        config = function()
            local lsp = require("lsp-zero").preset({})

            lsp.on_attach(function(client, bufnr)
                lsp.default_keymaps({ buffer = bufnr })
                vim.keymap.set({ "n", "v" }, "<leader>ca", "<cmd>Lspsaga code_action<CR>",
                    { noremap = true, silent = true, buffer = bufnr, desc = "See code actions" })

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
            lspconfig.tsserver.setup({
                capabilities = capabilities
            })
            lspconfig.html.setup({
                capabilities = capabilities
            })
            lspconfig.lua_ls.setup({
                capabilities = capabilities
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
