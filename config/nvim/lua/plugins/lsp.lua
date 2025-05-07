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

local servers = {
    vtsls = {
        settings = {
            complete_function_calls = true,
            vtsls = {
                enableMoveToFileCodeAction = true,
                autoUseWorkspaceTsdk = true,
                experimental = {
                    completion = {
                        enableServerSideFuzzyMatch = true,
                    },
                },
            },
            -- https://github.com/yioneko/vtsls/blob/main/packages/service/configuration.schema.json
            ["js/ts"] = {
                implicitProjectConfig = { checkJs = true },
            },
            javascript = {
                updateImportsOnFileMove = { enabled = "always" },
                suggest = {
                    completeFunctionCalls = true,
                },
                inlayHints = {
                    enumMemberValues = { enabled = true },
                    parameterNames = { enabled = "all", suppressWhenArgumentMatchesName = false },
                    propertyDeclarationTypes = { enabled = true },
                    variableTypes = { enabled = false },
                },
                preferences = {
                    importModuleSpecifier = "non-relative",
                },
            },
            typescript = {
                updateImportsOnFileMove = { enabled = "always" },
                suggest = {
                    completeFunctionCalls = true,
                },
                preferences = {
                    preferTypeOnlyAutoImports = true,
                    importModuleSpecifier = "non-relative",
                },
                inlayHints = {
                    enumMemberValues = { enabled = true },
                    parameterNames = { enabled = "all", suppressWhenArgumentMatchesName = false },
                    propertyDeclarationTypes = { enabled = true },
                    variableTypes = { enabled = false },
                },
            },
        },
    },
    lua_ls = {
        settings = {
            Lua = {
                format = {
                    enable = true,
                },
                telemetry = { enable = false },
                diagnostics = {
                    globals = { "vim" },
                    neededFileStatus = {
                        ["codestyle-check"] = "Any",
                    },
                    groupSeverity = { ["codestyle-check"] = "Warning" },
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
    },
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
        "saghen/blink.cmp",
        dependencies = {
            "fang2hou/blink-copilot",
        },
        version = "1.*",
        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            keymap = {
                preset = "enter",
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
                        winhighlight =
                        "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
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
                                text = function(ctx)
                                    local icon = ctx.kind_icon
                                    if vim.tbl_contains({ "Path" }, ctx.source_name) then
                                        local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                                        if dev_icon then
                                            icon = dev_icon
                                        end
                                    else
                                        icon = kind_icons[ctx.kind] or ""
                                    end

                                    return icon .. ctx.icon_gap
                                end,

                                highlight = function(ctx)
                                    local hl = ctx.kind_hl
                                    if vim.tbl_contains({ "Path" }, ctx.source_name) then
                                        local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
                                        if dev_icon then
                                            hl = dev_hl
                                        end
                                    end
                                    return hl
                                end,
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
                default = { "lsp", "snippets", "buffer", "copilot", "path" },

                providers = {
                    copilot = {
                        name = "copilot",
                        module = "blink-copilot",
                        score_offset = 100,
                        async = true,
                    },
                    lsp = {
                        name = "lsp",
                        score_offset = 90,
                    },
                },

                per_filetype = {
                    codecompanion = { "codecompanion" },
                },
            },
            fuzzy = { implementation = "rust" },
            snippets = { preset = "default" },
        },
        opts_extend = { "sources.default" },
    },
    {
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

            local lspconfig = require("lspconfig")
            local util = require("lspconfig/util")
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

            -- Format on save
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

            -- Folding
            vim.o.foldcolumn = "1"
            vim.o.foldlevel = 99
            vim.o.foldlevelstart = 99
            vim.o.foldenable = true
            vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
            vim.o.foldtext = ""

            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(args)
                    local client = vim.lsp.get_client_by_id(args.data.client_id)
                    if client then
                        if client:supports_method("textDocument/foldingRange") then
                            local win = vim.api.nvim_get_current_win()
                            vim.wo[win][0].foldmethod = "expr"
                            vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
                        end

                        if vim.fn.has("nvim-0.12") == 1 and client:supports_method("textDocument/documentColor") then
                            vim.lsp.document_color.enable(true, args.buf)
                        end
                    end
                end,
            })
            vim.api.nvim_create_autocmd("LspDetach", { command = "setl foldexpr<" })

            -- Show LSP progress
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
                    { noremap = true, silent = true, buffer = bufnr, desc = "Show diagnostics for line" }
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

            local mason = require("mason-lspconfig")
            for _, server in pairs(mason.get_installed_servers()) do
                if server ~= "lua_ls" and server ~= "ts_ls" and server ~= "vtsls" then
                    lspconfig[server].setup({
                        capabilities = capabilities,
                        on_attach = on_attach,
                    })
                end
            end

            lspconfig.vtsls.setup({
                capabilities = capabilities,
                root_dir = util.root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
                settings = servers.vtsls.settings,
                on_attach = function(client, bufnr)
                    require("twoslash-queries").attach(client, bufnr)
                    -- client.server_capabilities.document_formatting = false
                    -- client.server_capabilities.document_range_formatting = false
                    on_attach(client, bufnr)
                end,
            })

            lspconfig.lua_ls.setup({
                capabilities = capabilities,
                settings = servers.lua_ls.settings,
                on_attach = on_attach,
            })
        end,
    },
}
