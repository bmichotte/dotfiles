local diagnostic_icons = {
    [vim.diagnostic.severity.ERROR] = "",
    [vim.diagnostic.severity.WARN] = "",
    [vim.diagnostic.severity.HINT] = "",
    [vim.diagnostic.severity.INFO] = "",
}

local kind_icons = {
    Text = "󰉿",
    Method = "󰆧",
    Function = "󰊕",
    Constructor = "",

    Field = "󰜢",
    Variable = "󰀫",
    Property = "󰜢",

    Class = "",
    Interface = "",
    Struct = "",
    Module = "",

    Unit = "󰑭",
    Value = "󰎠",
    Enum = "",
    EnumMember = "",

    Keyword = "",
    Constant = "󰏿",

    Snippet = "",
    Color = "",
    File = "󰈙",
    Reference = "󰈇",
    Folder = "󰉋",
    Event = "",
    Operator = "",
    TypeParameter = "",

    Copilot = "",
    HF = "",
    OpenAI = "",
    Codestral = "",
    Bard = "",
}

---@type LazyPlugin[]
return {
    {
        "folke/lazydev.nvim",
        ft = { "lua" }, -- only load on lua files
        opts = {
            library = {
                "lazy.nvim",
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
    {
        "Bekaboo/dropbar.nvim",
        -- optional, but required for fuzzy finder support
        dependencies = {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
        },
        config = function()
            local dropbar_api = require("dropbar.api")
            vim.keymap.set("n", "<Leader>;", dropbar_api.pick, { desc = "Pick symbols in winbar" })
            vim.keymap.set("n", "[;", dropbar_api.goto_context_start, { desc = "Go to start of current context" })
            vim.keymap.set("n", "];", dropbar_api.select_next_context, { desc = "Select next context" })
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
                            "format",
                            "--apply-unsafe",
                            "--formatter-enabled=true",
                            "--organize-imports-enabled=true",
                            "--skip-errors",
                            "--colors=force",
                            "--stdin-file-path",
                            "$FILENAME",
                        },
                    }),
                    -- null_ls.builtins.formatting.biome,
                    null_ls.builtins.formatting.sqlfmt,
                    null_ls.builtins.formatting.stylua,
                    null_ls.builtins.formatting.yamlfmt,

                    null_ls.builtins.diagnostics.yamllint,
                    null_ls.builtins.code_actions.gitsigns,
                },
            })
        end,
    },
    {
        "williamboman/mason.nvim",
        dependencies = {
            "williamboman/mason-lspconfig.nvim",
            "neovim/nvim-lspconfig",
            "kevinhwang91/nvim-ufo",
        },
        lazy = false,
        config = function()
            require("mason").setup({
                ui = {
                    border = "rounded",
                },
            })

            vim.diagnostic.config({
                update_in_insert = false,
                virtual_lines = {
                    enabled = true,
                    format = function(diagnostic)
                        return diagnostic_icons[diagnostic.severity] .. " " .. diagnostic.message
                    end,
                    spacing = 4,
                },
                signs = {
                    text = diagnostic_icons,
                },
            })

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

            vim.api.nvim_create_autocmd("LspProgress", {
                ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
                callback = function(ev)
                    local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
                    vim.notify(vim.lsp.status(), vim.log.levels.INFO, {
                        id = "lsp_progress",
                        title = "LSP Progress",
                        opts = function(notif)
                            notif.icon = ev.data.params.value.kind == "end" and " "
                                or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
                        end,
                    })
                end,
            })
        end,
    },
    {
        "giuxtaposition/blink-cmp-copilot",
    },
    {
        "saghen/blink.cmp",
        dependencies = { "giuxtaposition/blink-cmp-copilot" },
        version = "1.*",
        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            keymap = {
                preset = "enter",
                ["<Up>"] = { "select_prev", "fallback" },
                ["<Down>"] = { "select_next", "fallback" },
            },

            appearance = {
                kind_icons = kind_icons,
            },

            completion = {
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 250,
                    treesitter_highlighting = true,
                    window = {
                        border = "rounded",
                        winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
                    },
                },
                menu = {
                    border = "rounded",

                    cmdline_position = function()
                        if vim.g.ui_cmdline_pos ~= nil then
                            local pos = vim.g.ui_cmdline_pos -- (1, 0)-indexed
                            return { pos[1] - 1, pos[2] }
                        end
                        local height = (vim.o.cmdheight == 0) and 1 or vim.o.cmdheight
                        return { vim.o.lines - height, 0 }
                    end,

                    draw = {
                        columns = {
                            { "kind_icon", "label", gap = 1 },
                            { "kind" },
                        },
                        components = {
                            kind_icon = {
                                text = function(item)
                                    local kind = kind_icons[item.kind] or ""
                                    return kind .. " "
                                end,
                                highlight = "CmpItemKind",
                            },
                            label = {
                                text = function(item)
                                    return item.label
                                end,
                                highlight = "CmpItemAbbr",
                            },
                            kind = {
                                text = function(item)
                                    return item.kind
                                end,
                                highlight = "CmpItemKind",
                            },
                        },
                    },
                },
            },
            signature = { enabled = true },
            sources = {
                default = { "lsp", "path", "snippets", "buffer", "copilot" },

                providers = {
                    copilot = {
                        name = "copilot",
                        module = "blink-cmp-copilot",
                        score_offset = 100,
                        async = true,
                        transform_items = function(_, items)
                            local CompletionItemKind = require("blink.cmp.types").CompletionItemKind
                            local kind_idx = #CompletionItemKind + 1
                            CompletionItemKind[kind_idx] = "Copilot"
                            for _, item in ipairs(items) do
                                item.kind = kind_idx
                            end
                            return items
                        end,
                    },
                },
            },
            fuzzy = { implementation = "rust" },
            snippets = { preset = "default" },
        },
        opts_extend = { "sources.default" },
    },
    {
        "neovim/nvim-lspconfig",
        dependencies = { "saghen/blink.cmp", "williamboman/mason-lspconfig.nvim" },
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

            local lspconfig = require("lspconfig")
            local util = require("lspconfig/util")
            local mason = require("mason-lspconfig")

            local on_attach = function(client, bufnr)
                vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>", { buffer = bufnr })

                if client.server_capabilities.inlayHintProvider then
                    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
                end

                vim.keymap.set(
                    "n",
                    "gd",
                    vim.lsp.buf.definition,
                    { noremap = true, silent = true, buffer = bufnr, desc = "Got to declaration" }
                )
                vim.keymap.set(
                    "n",
                    "gi",
                    vim.lsp.buf.implementation,
                    { noremap = true, silent = true, buffer = bufnr, desc = "Go to implementation" }
                )
                vim.keymap.set(
                    "n",
                    "<leader>d",
                    vim.diagnostic.open_float,
                    { noremap = true, silent = true, buffer = bufnr, desc = "Show  diagnostics for line" }
                )
                vim.keymap.set("n", "K", vim.lsp.buf.hover, {
                    noremap = true,
                    silent = true,
                    buffer = bufnr,
                    desc = "Show documentation for what is under cursor",
                })
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

            for _, server in pairs(mason.get_installed_servers()) do
                if server ~= "lua_ls" and server ~= "ts_ls" then
                    lspconfig[server].setup({
                        capabilities = capabilities,
                    })
                end
            end

            lspconfig.ts_ls.setup({
                capabilities = capabilities,
                root_dir = util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
                init_options = {
                    preferences = {
                        includeInlayParameterNameHints = "all",
                        includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                        includeInlayFunctionParameterTypeHints = false,
                        includeInlayVariableTypeHints = false,
                        includeInlayPropertyDeclarationTypeHints = true,
                        includeInlayFunctionLikeReturnTypeHints = false,
                        includeInlayEnumMemberValueHints = false,
                        importModuleSpecifierPreference = "non-relative",
                        preferTypeOnlyAutoImports = true,
                    },
                },
                on_attach = function(client, bufnr)
                    require("twoslash-queries").attach(client, bufnr)
                    -- client.server_capabilities.document_formatting = false
                    -- client.server_capabilities.document_range_formatting = false
                    on_attach(client, bufnr)
                end,
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
    },
    {
        "kevinhwang91/nvim-ufo",
        dependencies = {
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
        keys = {
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
        opts = {
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
        },
    },
}
