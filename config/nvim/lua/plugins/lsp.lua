---@type LazyPlugin[]
return {
    {
        "hrsh7th/nvim-cmp",
        lazy = false,
        dependencies = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-nvim-lsp",
            "L3MON4D3/LuaSnip",
            "rafamadriz/friendly-snippets",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "js-everts/cmp-tailwind-colors",
            "nvim-tree/nvim-web-devicons",
        },
    },
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp",
        keys = {
            {
                "<C-l>",
                function()
                    require("luasnip").jump(1)
                end,
                desc = "Jump to next snippet variable",
                mode = { "i", "s" },
            },
            {
                "<C-j>",
                function()
                    require("luasnip").jump(-1)
                end,
                desc = "Jump to previous sinppet variable",
                mode = { "i", "s" },
            },
        },
        config = function()
            local ls = require("luasnip")
            local i = ls.insert_node
            local extras = require("luasnip.extras")
            local l = extras.lambda
            local fmt = require("luasnip.extras.fmt").fmt
            local s = ls.snippet
            -- local sn = ls.snippet_node
            -- local isn = ls.indent_snippet_node
            -- local t = ls.text_node
            -- local f = ls.function_node
            -- local c = ls.choice_node
            -- local d = ls.dynamic_node
            -- local r = ls.restore_node
            -- local rep = extras.rep
            -- local events = require("luasnip.util.events")
            -- local ai = require("luasnip.nodes.absolute_indexer")
            -- local p = extras.partial
            -- local m = extras.match
            -- local n = extras.nonempty
            -- local dl = extras.dynamic_lambda
            -- local fmta = require("luasnip.extras.fmt").fmta
            -- local conds = require("luasnip.extras.expand_conditions")
            -- local postfix = require("luasnip.extras.postfix").postfix
            -- local types = require("luasnip.util.types")
            -- local parse = require("luasnip.util.parser").parse_snippet
            -- local ms = ls.multi_snippet
            -- local k = require("luasnip.nodes.key_indexer").new_key

            ls.add_snippets("typescriptreact", {
                s(
                    "rus",
                    fmt("const [{}, set{setter}] = useState<{}>({})", {
                        i(1, "state"),
                        i(2, "type"),
                        i(3, "initialValue"),
                        setter = l(l._1:sub(1, 1):upper() .. l._1:sub(2, -1), 1),
                    })
                ),
            })
        end,
    },
    {
        "nvimtools/none-ls.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            local null_ls = require("null-ls")

            null_ls.setup({
                sources = {
                    null_ls.builtins.formatting.biome.with({
                        args = {
                            "check",
                            "--apply-unsafe",
                            "--formatter-enabled=true",
                            "--organize-imports-enabled=true",
                            "--skip-errors",
                            "$FILENAME",
                        },
                    }),
                    null_ls.builtins.formatting.stylua,
                    null_ls.builtins.formatting.yamlfmt,

                    null_ls.builtins.diagnostics.yamllint,
                    -- null_ls.builtins.diagnostics.eslint_d,

                    null_ls.builtins.completion.luasnip,
                    null_ls.builtins.code_actions.gitsigns,
                },
            })
        end,
    },
    {
        "williamboman/mason.nvim",
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/nvim-cmp",
            "hrsh7th/cmp-nvim-lsp",
            "neovim/nvim-lspconfig",
            "nvimdev/lspsaga.nvim",
            "folke/neodev.nvim",
            "kevinhwang91/nvim-ufo",
            "kevinhwang91/promise-async",
        },
        init = function()
            -- init fold
            vim.o.foldcolumn = "1"
            vim.o.foldlevel = 99
            vim.o.foldlevelstart = 99
            vim.o.foldenable = true
            vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
        end,
        lazy = false,
        keys = {
            -- za toggle folds
            {
                "zR",
                function()
                    require("ufo").openAllFolds()
                end,
                desc = "Open all folds",
            },
            {
                "zM",
                function()
                    require("ufo").closeAllFolds()
                end,
                desc = "Close all folds",
            },
            {
                "zK",
                function()
                    local winid = require("ufo").peekFoldedLinesUnderCursor()
                    if not winid then
                        vim.lsp.buf.hover()
                    end
                end,
                desc = "Peek fold",
            },
        },
        config = function()
            require("mason").setup({
                ui = {
                    border = "rounded",
                },
            })

            require("neodev").setup({})

            local lspconfig = require("lspconfig")
            local util = require("lspconfig/util")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
            capabilities.textDocument.foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
            }

            require("lspsaga").setup({
                lightbulb = {
                    enable = false,
                },
            })

            local on_attach = function(client, bufnr)
                vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>", { buffer = bufnr })

                if client.server_capabilities.inlayHintProvider then
                    vim.lsp.inlay_hint.enable(bufnr, true)
                end

                -- vim.keymap.set("n", "gf", "<cmd>Lspsaga lsp_finder<CR>", { noremap = true, silent = true, buffer = bufnr, desc = "Show definition, references" })
                vim.keymap.set(
                    "n",
                    "gd",
                    --vim.lsp.buf.declaration,
                    "<cmd>Lspsaga goto_definition<cr>",
                    { noremap = true, silent = true, buffer = bufnr, desc = "Got to declaration" }
                )
                vim.keymap.set(
                    "n",
                    "gD",
                    vim.lsp.buf.definition,
                    { noremap = true, silent = true, buffer = bufnr, desc = "See definition and make edits in window" }
                )
                vim.keymap.set(
                    "n",
                    "gi",
                    vim.lsp.buf.implementation,
                    { noremap = true, silent = true, buffer = bufnr, desc = "Go to implementation" }
                )
                vim.keymap.set(
                    "n",
                    "gr",
                    vim.lsp.buf.rename,
                    { noremap = true, silent = true, buffer = bufnr, desc = "Smart rename" }
                )
                vim.keymap.set(
                    "n",
                    "<leader>D",
                    vim.lsp.buf.type_definition,
                    { noremap = true, silent = true, buffer = bufnr, desc = "Show  diagnostics for line" }
                )
                -- vim.keymap.set("n", "<leader>d", "<cmd>Lspsaga show_cursor_diagnostics<CR>", { noremap = true, silent = true, buffer = bufnr, desc = "Show diagnostics for cursor" })
                vim.keymap.set("n", "K", vim.lsp.buf.hover, {
                    noremap = true,
                    silent = true,
                    buffer = bufnr,
                    desc = "Show documentation for what is under cursor",
                })

                -- if client.name == "tsserver" then
                vim.keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", {
                    noremap = true,
                    silent = true,
                    buffer = bufnr,
                    desc = "Jump to previous diagnostic in buffer",
                })
                vim.keymap.set(
                    "n",
                    "]d",
                    "<cmd>Lspsaga diagnostic_jump_next<CR>",
                    { noremap = true, silent = true, buffer = bufnr, desc = "Jump to next diagnostic in buffer" }
                )
                -- else
                --     vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, {
                --         noremap = true,
                --         silent = true,
                --         buffer = bufnr,
                --         desc = "Jump to previous diagnostic in buffer",
                --     })
                --     vim.keymap.set(
                --         "n",
                --         "]d",
                --         vim.diagnostic.goto_next,
                --         { noremap = true, silent = true, buffer = bufnr, desc = "Jump to next diagnostic in buffer" }
                --     )
                -- end

                vim.keymap.set(
                    { "n", "v" },
                    "<leader>ca",
                    vim.lsp.buf.code_action,
                    { noremap = true, silent = true, buffer = bufnr, desc = "See code actions" }
                )
                vim.keymap.set(
                    "i",
                    "<C-h>",
                    vim.lsp.buf.signature_help,
                    { noremap = true, silent = true, buffer = bufnr, desc = "Show signature help" }
                )
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
                                    importModuleSpecifierPreference = "non-relative",
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
                                        groupSeverity = { ["codestyle-check"] = "Warning" },
                                        -- missing_parameters = false,
                                        disable = { "missing-parameters", "missing-fields" },
                                    },
                                    runtime = {
                                        version = "LuaJIT",
                                    },
                                    workspace = {
                                        library = vim.api.nvim_get_runtime_file("", true),
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
                    ["eslint"] = function()
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
                        [vim.diagnostic.severity.HINT] = " ",
                        [vim.diagnostic.severity.INFO] = " ",
                    },
                },
            })

            vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })

            vim.lsp.handlers["textDocument/signatureHelp"] =
                vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

            local setup_group = vim.api.nvim_create_augroup("lsp_format_config", { clear = true })
            vim.api.nvim_create_autocmd("LspAttach", {
                group = setup_group,
                desc = "Enable format on save",
                callback = function(event)
                    local format_group = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = true })
                    vim.api.nvim_create_autocmd("BufWritePre", {
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

                    vim.keymap.set({ "n", "x" }, "<leader>f", function()
                        vim.lsp.buf.format({ async = false, timeout_ms = 10000 })
                    end, { buffer = event.buf, desc = "Format buffer" })
                end,
            })

            require("ufo").setup({
                provider_selector = function()
                    return { "lsp", "indent" }
                end,
                fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
                    local newVirtText = {}
                    local suffix = (" 󰁂 %d "):format(endLnum - lnum)
                    local sufWidth = vim.fn.strdisplaywidth(suffix)
                    local targetWidth = width - sufWidth
                    local curWidth = 0
                    for _, chunk in ipairs(virtText) do
                        local chunkText = chunk[1]
                        local chunkWidth = vim.fn.strdisplaywidth(chunkText)
                        if targetWidth > curWidth + chunkWidth then
                            table.insert(newVirtText, chunk)
                        else
                            chunkText = truncate(chunkText, targetWidth - curWidth)
                            local hlGroup = chunk[2]
                            table.insert(newVirtText, { chunkText, hlGroup })
                            chunkWidth = vim.fn.strdisplaywidth(chunkText)
                            -- str width returned from truncate() may less than 2nd argument, need padding
                            if curWidth + chunkWidth < targetWidth then
                                suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
                            end
                            break
                        end
                        curWidth = curWidth + chunkWidth
                    end
                    table.insert(newVirtText, { suffix, "MoreMsg" })
                    return newVirtText
                end,
            })

            -- cmp setup
            local cmp = require("cmp")

            local kind_icons = {
                Text = "󰉿",
                Method = "󰆧",
                Function = "󰊕",
                Constructor = "",
                Field = "󰜢",
                Variable = "󰀫",
                Class = "",
                Interface = "",
                Module = "",
                Property = "󰜢",
                Unit = "󰑭",
                Value = "󰎠",
                Enum = "",
                Keyword = "",
                Snippet = "",
                Color = "",
                File = "󰈙",
                Reference = "󰈇",
                Folder = "󰉋",
                EnumMember = "",
                Constant = "󰏿",
                Struct = "",
                Event = "",
                Operator = "",
                TypeParameter = "",
                Copilot = "",
            }
            cmp.setup({
                window = {
                    completion = cmp.config.window.bordered({
                        col_offset = -3,
                        side_padding = 0,
                    }),
                    documentation = cmp.config.window.bordered(),
                },
                sources = cmp.config.sources({
                    -- { name = "cmp_ai" },
                    { name = "copilot" },
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                    { name = "path" },
                }, {
                    { name = "buffer" },
                }),
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                formatting = {
                    fields = {
                        cmp.ItemField.Kind,
                        cmp.ItemField.Abbr,
                        cmp.ItemField.Menu,
                    },
                    format = function(entry, item)
                        if item.kind == "Color" then
                            item = require("cmp-tailwind-colors").format(entry, item)

                            if item.kind ~= "Color" then
                                item.menu = "Color"
                                return item
                            end
                        end

                        item.menu = "   (" .. item.kind .. ")"
                        item.kind = " " .. kind_icons[item.kind] .. "  "

                        return item
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<CR>"] = cmp.mapping.confirm({ select = false }),
                    ["<Down>"] = { c = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }) },
                    ["<Up>"] = { c = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }) },
                    ["<C-Space>"] = cmp.mapping(function()
                        if cmp.visible() then
                            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                        else
                            cmp.complete()
                        end
                    end),
                }),
            })

            -- `/` cmdline setup.
            cmp.setup.cmdline("/", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = {
                    { name = "buffer" },
                },
            })

            -- `:` cmdline setup.
            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "path" },
                }, {
                    {
                        name = "cmdline",
                        option = {
                            ignore_cmds = { "Man", "!" },
                        },
                    },
                }),
            })
        end,
    },
    {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    },
}
