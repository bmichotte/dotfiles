---@type LazyPlugin[]
return {
    --[[{
        "neovim/nvim-lspconfig",
        dependencies = { "saghen/blink.cmp", "mason-org/mason.nvim", "williamboman/mason-lspconfig.nvim" },
        config = function()
            local capabilities = {
                textDocument = {
                    foldingRange = {
                        dynamicRegistration = false,
                        lineFoldingOnly = true,
                    },
                },
            }
            capabilities = require("blink.cmp").get_lsp_capabilities(capabilities)

            require("mason").setup()



            local on_attach = function(client, bufnr)

            end

            local ignore_servers = {
                ["lua_ls"] = true,
                ["ts_ls"] = true,
                ["vtsls"] = true,
                ["tsgo"] = true,
                ["sqlls"] = true,
            }
            local mason = require("mason-lspconfig")
            for _, server in pairs(mason.get_installed_servers()) do
                if not ignore_servers[server] then
                    vim.lsp.config(server, {
                        capabilities = capabilities,
                        on_attach = on_attach,
                    })
                    vim.lsp.enable(server)
                end
            end

            vim.lsp.config("vtsls", {
                capabilities = capabilities,
                settings = servers.vtsls.settings,
                on_attach = function(client, bufnr)
                    require("twoslash-queries").attach(client, bufnr)

                    -- we don't want ts to format
                    client.server_capabilities.documentFormattingProvider = false
                    client.server_capabilities.documentRangeFormattingProvider = false
                    on_attach(client, bufnr)
                end,
            })
            vim.lsp.enable("vtsls")

            vim.lsp.config("lua_ls", {
                capabilities = capabilities,
                settings = servers.lua_ls.settings,
                on_attach = on_attach,
            })
            vim.lsp.enable("lua_ls")

            -- vim.lsp.config("tsgo", {
            --     cmd = { "bun", "tsgo", "--lsp", "-stdio" },
            --     filetypes = {
            --         "javascript",
            --         "javascriptreact",
            --         "javascript.jsx",
            --         "typescript",
            --         "typescriptreact",
            --         "typescript.tsx",
            --     },
            --     root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
            -- })
            -- vim.lsp.enable("tsgo")
        end,
    },]]
    {
        "mason-org/mason-lspconfig.nvim",
        opts = {
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
        },
        dependencies = {
            {
                "mason-org/mason.nvim",
                opts = {
                    ui = {
                        icons = {
                            package_installed = "✓",
                            package_pending = "➜",
                            package_uninstalled = "✗",
                        },
                    },
                },
            },
            "saghen/blink.cmp",
            "neovim/nvim-lspconfig",
        },
    },
}
