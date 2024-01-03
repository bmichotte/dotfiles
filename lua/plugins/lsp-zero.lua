return {
    {
        "onsails/lspkind.nvim",
    },
    {
        "glepnir/lspsaga.nvim",
        branch = "main"
    },
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v2.x",
        dependencies = {
            { "neovim/nvim-lspconfig" },
            {
                "williamboman/mason.nvim",
                --[[build = function()
                pcall(vim.cmd, "MasonUpdate")
            end,]]
            },
            { "williamboman/mason-lspconfig.nvim" },
            { "hrsh7th/nvim-cmp" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "L3MON4D3/LuaSnip" },
            { "rafamadriz/friendly-snippets" },
            { "saadparwaiz1/cmp_luasnip" },
        },
        config = function()
            local lsp = require("lsp-zero").preset({})

            lsp.on_attach(function(client, bufnr)
                lsp.default_keymaps({ buffer = bufnr })
            end)

            local lspconfig = require("lspconfig")
            lspconfig.lua_ls.setup(lsp.nvim_lua_ls())
            lspconfig.biome.setup({})

            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = { "tsserver", "prismals", "tailwindcss", "lua_ls", "jsonls" },
            })

            lsp.set_sign_icons({
                error = "",
                warn = "",
                hint = " ",
                info = " ",
            })
            lsp.skip_server_setup({ "tsserver" })

            lsp.set_server_config({
                capabilities = {
                    textDocument = {
                        foldingRange = {
                            dynamicRegistration = false,
                            lineFoldingOnly = true,
                        },
                    },
                },
            })

            local group = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = false })
            local event = "BufWritePre" -- or "BufWritePost"
            local async = event == "BufWritePost"

            local keymap = vim.keymap
            lsp.on_attach(function(client, bufnr)
                local opts = { noremap = true, silent = true, buffer = bufnr }

                -- set keybinds
                --keymap.set("n", "<leader>f", "<cmd>Format<CR>", opts) -- format
                keymap.set("n", "<leader>f", function()
                    vim.lsp.buf.format({ async = true })
                end, opts)                                                                     -- format

                keymap.set("n", "gf", "<cmd>Lspsaga lsp_finder<CR>", opts)                     -- show definition, references
                keymap.set("n", "gD", "<Cmd>Lspsaga goto_definition<CR>", opts)                -- got to declaration
                keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>", opts)                -- see definition and make edits in window
                keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)       -- go to implementation
                keymap.set({ "n", "v" }, "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts)   -- see available code actions
                keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts)                 -- smart rename
                keymap.set("n", "<leader>D", "<cmd>Lspsaga show_line_diagnostics<CR>", opts)   -- show  diagnostics for line
                keymap.set("n", "<leader>d", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts) -- show diagnostics for cursor
                keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts)           -- jump to previous diagnostic in buffer
                keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts)           -- jump to next diagnostic in buffer
                keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts)                       -- show documentation for what is under cursor
                keymap.set("n", "<leader>o", "<cmd>LSoutlineToggle<CR>", opts)                 -- see outline on right hand side
                keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, opts)

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

            local luasnip = require("luasnip")
            require("luasnip/loaders/from_vscode").lazy_load({ paths = { "./snippets" } })

            local cmp = require("cmp")
            cmp.setup({
                window = {
                    completion = {
                        border = "rounded",
                        scrollbar = "║",
                        --winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None",
                        col_offset = -3,
                        side_padding = 0,
                    },
                    documentation = {
                        border = nil,
                        scrollbar = "",
                    },
                },
                sources = {
                    { name = "luasnip" },
                    { name = "nvim_lsp" },
                    { name = "copilot" },
                    --{ name = "buffer" },
                    { name = "path" },
                },
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                formatting = {
                    format = function(entry, vim_item)
                        return require("lspkind").cmp_format({
                            mode = "symbol_text",
                            maxwidth = 50,
                            ellipsis_char = "...",
                            symbol_map = { Copilot = " " },
                            before = require("tailwindcss-colorizer-cmp").formatter,
                        })(entry, vim_item)
                    end,
                },
                mapping = {
                    ["<CR>"] = cmp.mapping.confirm({ select = false }),
                    ["<C-Space>"] = cmp.mapping(function()
                        if cmp.visible() then
                            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                        else
                            cmp.complete()
                        end
                    end),
                    --[[
        ["<C-k>"] = cmp.mapping.select_prev_item(), -- previous suggestion
        ["<C-j>"] = cmp.mapping.select_next_item(), -- next suggestion
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(), -- show completion suggestions
        ["<C-e>"] = cmp.mapping.abort(), -- close completion window
        ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
        }),
        ]]
                },
            })

            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            lspconfig.prismals.setup({
                capabilities = capabilities,
                -- on_attach = on_attach,
                on_attach = function(client, bufnr)
                    if client.supports_method("textDocument/formatting") then
                        vim.keymap.set("n", "<leader>f", function()
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
                        vim.keymap.set("x", "<leader>f", function()
                            vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
                        end, { buffer = bufnr, desc = "[lsp] format" })
                    end
                end,
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
