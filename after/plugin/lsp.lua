local lsp = require("lsp-zero").preset({})

lsp.on_attach(function(client, bufnr)
    lsp.default_keymaps({ buffer = bufnr })
end)

local lspconfig = require("lspconfig")
lspconfig.lua_ls.setup(lsp.nvim_lua_ls())

local formatter = require("formatter")
local util = require("formatter.util")

require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = { "tsserver", "prismals", "tailwindcss", "lua_ls", "jsonls" },
})

local prettierConfig = function()
    return {
        exe = "prettier",
        args = { "--stdin-filepath", vim.fn.shellescape(vim.api.nvim_buf_get_name(0)) },
        stdin = true,
    }
end

formatter.setup({
    logging = true,
    log_level = vim.log.levels.WARN,
    filetype = {
        lua = {
            -- "formatter.filetypes.lua" defines default configurations for the
            -- "lua" filetype
            require("formatter.filetypes.lua").stylua,

            -- You can also define your own configuration
            function()
                -- Supports conditional formatting
                if util.get_current_buffer_file_name() == "special.lua" then
                    return nil
                end

                -- Full specification of configurations is down below and in Vim help
                -- files
                return {
                    exe = "stylua",
                    args = {
                        "--search-parent-directories",
                        "--stdin-filepath",
                        util.escape_path(util.get_current_buffer_file_path()),
                        "--",
                        "-",
                    },
                    stdin = true,
                }
            end,
        },
        prisma = prettierConfig,
        html = { prettierConfig },
        javascript = { prettierConfig },
        typescript = { prettierConfig },
        typescriptreact = { prettierConfig },

        -- Use the special "*" filetype for defining formatter configurations on
        -- any filetype
        ["*"] = {
            -- "formatter.filetypes.any" defines default configurations for any
            -- filetype
            require("formatter.filetypes.any").remove_trailing_whitespace,
        },
    },
})

lsp.set_sign_icons({
    error = "",
    warn = "",
    hint = " ",
    info = " ",
})

--[[lsp.ensure_installed({
	"efm",
	"html",
	"jsonls",
	"lua_ls",
	"tailwindcss",
	--"tsserver",
	"prismals",
})]]

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

local keymap = vim.keymap
lsp.on_attach(function(client, bufnr)
    --autocmds(client, bufnr)
    --commands(client, bufnr)
    --mappings(client, bufnr)

    local opts = { noremap = true, silent = true, buffer = bufnr }

    -- set keybinds
    keymap.set("n", "f", "<cmd>Format<CR>", opts) -- format

    keymap.set("n", "gf", "<cmd>Lspsaga lsp_finder<CR>", opts) -- show definition, references
    keymap.set("n", "gD", "<Cmd>Lspsaga goto_definition<CR>", opts) -- got to declaration
    keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>", opts) -- see definition and make edits in window
    keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts) -- go to implementation
    keymap.set({ "n", "v" }, "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts) -- see available code actions
    keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts) -- smart rename
    keymap.set("n", "<leader>D", "<cmd>Lspsaga show_line_diagnostics<CR>", opts) -- show  diagnostics for line
    keymap.set("n", "<leader>d", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts) -- show diagnostics for cursor
    keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts) -- jump to previous diagnostic in buffer
    keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts) -- jump to next diagnostic in buffer
    keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts) -- show documentation for what is under cursor
    keymap.set("n", "<leader>o", "<cmd>LSoutlineToggle<CR>", opts) -- see outline on right hand side

    -- typescript specific keymaps (e.g. rename file and update imports)
    if client.name == "tsserver" then
        --keymap.set("n", "<leader>rf", ":TypescriptRenameFile<CR>") -- rename file and update imports
        --keymap.set("n", "<leader>oi", ":TypescriptOrganizeImports<CR>") -- organize imports (not in youtube nvim video)
        --keymap.set("n", "<leader>ru", ":TypescriptRemoveUnused<CR>") -- remove unused variables (not in youtube nvim video)
        --require("twoslash-queries").attach(client, bufnr)
    end

    --if client.server_capabilities.documentSymbolProvider then require("nvim-navic").attach(client, bufnr) end
end)

lsp.format_on_save({
    format_opts = {
        async = false,
        timeout_ms = 10000,
    },
    --servers = {
    --    ["efm"] = { "css", "html", "lua", "javascript", "json", "typescript", "markdown", "yaml" },
    --},
})

lsp.format_mapping("gq", {
    format_opts = {
        async = false,
        timeout_ms = 10000,
    },
    --servers = {
    --    ["efm"] = { "css", "html", "lua", "javascript", "json", "typescript", "markdown", "yaml" },
    --},
})

local ts_tools = require("typescript-tools")
ts_tools.setup({
    on_attach = function(client, bufnr) end,
    --handlers = { ... },
    settings = {
        -- spawn additional tsserver instance to calculate diagnostics on it
        --separate_diagnostic_server = true,
        -- "change"|"insert_leave" determine when the client asks the server about diagnostic
        publish_diagnostic_on = "insert_leave",
        -- string|nil -specify a custom path to `tsserver.js` file, if this is nil or file under path
        -- not exists then standard path resolution strategy is applied
        tsserver_path = nil,
        tsserver_max_memory = "auto",
        tsserver_format_options = {},
        tsserver_file_preferences = {},
    },
})

lsp.setup()

local lspsaga = require("lspsaga")
lspsaga.setup({})
local luasnip = require("luasnip")
require("luasnip/loaders/from_vscode").lazy_load({ paths = { "./snippets" } })

local copilot_cmp = require("copilot_cmp")
copilot_cmp.setup({
    formatters = {
        insert_text = require("copilot_cmp.format").remove_existing,
    },
})

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

local group = vim.api.nvim_create_augroup("lsp_format_on_save", { clear = false })
local event = "BufWritePre" -- or "BufWritePost"
local async = event == "BufWritePost"

local capabilities = require("cmp_nvim_lsp").default_capabilities()
lspconfig.prismals.setup({
    capabilities = capabilities,
    -- on_attach = on_attach,
    on_attach = function(client, bufnr)
        if client.supports_method("textDocument/formatting") then
            vim.keymap.set("n", "<Leader>f", function()
                vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
            end, { buffer = bufnr, desc = "[lsp] format" })

            -- format on save
            --[[vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
            vim.api.nvim_create_autocmd(event, {
                buffer = bufnr,
                group = group,
                callback = function()
                    vim.lsp.buf.format({ bufnr = bufnr, async = async })
                end,
                desc = "[lsp] format on save",
            })]]
        end

        if client.supports_method("textDocument/rangeFormatting") then
            vim.keymap.set("x", "<Leader>f", function()
                vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
            end, { buffer = bufnr, desc = "[lsp] format" })
        end
    end,
})

vim.api.nvim_exec([[
augroup FormatAutogroup
  autocmd!
  autocmd BufWritePost *.js,*.lua,*.prisma,*.css,*.ts,*.tsx,*.json FormatWrite
augroup END
]], true)

lspconfig.eslint.setup({
    on_attach = function(client, bufnr)
        vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            command = "EslintFixAll",
        })
    end,
})

--[[local eslint = require("eslint")
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
})]]

--[[
--local null_ls = require("null-ls")
--local typescript = require("typescript")

local keymap = vim.keymap -- for conciseness

-- enable keybinds only for when lsp server available
local on_attach = function(client, bufnr)
    -- keybind options
    local opts = { noremap = true, silent = true, buffer = bufnr }

    -- set keybinds
    keymap.set("n", "gf", "<cmd>Lspsaga lsp_finder<CR>", opts) -- show definition, references
    keymap.set("n", "gD", "<Cmd>Lspsaga goto_definition<CR>", opts) -- got to declaration
    keymap.set("n", "gd", "<cmd>Lspsaga peek_definition<CR>", opts) -- see definition and make edits in window
    keymap.set("n", "gi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts) -- go to implementation
    keymap.set({ "n", "v" }, "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts) -- see available code actions
    keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts) -- smart rename
    keymap.set("n", "<leader>D", "<cmd>Lspsaga show_line_diagnostics<CR>", opts) -- show  diagnostics for line
    keymap.set("n", "<leader>d", "<cmd>Lspsaga show_cursor_diagnostics<CR>", opts) -- show diagnostics for cursor
    keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", opts) -- jump to previous diagnostic in buffer
    keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", opts) -- jump to next diagnostic in buffer
    keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", opts) -- show documentation for what is under cursor
    keymap.set("n", "<leader>o", "<cmd>LSoutlineToggle<CR>", opts) -- see outline on right hand side

    -- typescript specific keymaps (e.g. rename file and update imports)
    if client.name == "tsserver" then
        --keymap.set("n", "<leader>rf", ":TypescriptRenameFile<CR>") -- rename file and update imports
        --keymap.set("n", "<leader>oi", ":TypescriptOrganizeImports<CR>") -- organize imports (not in youtube nvim video)
        --keymap.set("n", "<leader>ru", ":TypescriptRemoveUnused<CR>") -- remove unused variables (not in youtube nvim video)
        --require("twoslash-queries").attach(client, bufnr)
    end

    if vim.tbl_contains(allowed_to_format, client.name) then
        client.server_capabilities.documentFormattingProvider = true
        client.server_capabilities.documentFormattingRangeProvider = true
    end
end

-- Change the Diagnostic symbols in the sign column (gutter)
local signs = { Error = " ", Warn = " ", Hint = "", Info = " " }
for type, icon in pairs(signs) do
    local hl = "DiagnosticSign" .. type
    vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end


lspconfig.html.setup({
    capabilities = capabilities,
    on_attach = on_attach,
})

lspconfig.cssls.setup({
    capabilities = capabilities,
    on_attach = on_attach,
})


lspconfig.tailwindcss.setup({
    capabilities = capabilities,
    on_attach = on_attach,
})

lspconfig.emmet_ls.setup({
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
            diagnostics = {
                globals = { "vim" },
            },
        },
    },
})

--[[local formatting = null_ls.builtins.formatting

null_ls.setup({
    sources = {
        formatting.stylua.with({ extra_args = { "--indent-type", "Spaces" } }),
        formatting.eslint_d,
        formatting.prismaFmt,
        require("typescript.extensions.null-ls.code-actions"),
    },
    on_attach = function(client, bufnr)
        bufnr = bufnr or vim.api.nvim_get_current_buf()

        local callback = function()
            vim.lsp.buf.format({
                bufnr = bufnr,
                filter = function(client)
                    return client.name == "null-ls"
                end,
            })
        end

        if client.supports_method("textDocument/formatting") then
            vim.keymap.set("n", "<Leader>f", function()
                vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
            end, { buffer = bufnr, desc = "[lsp] format" })

            -- format on save
            vim.api.nvim_clear_autocmds({ buffer = bufnr, group = group })
            vim.api.nvim_create_autocmd(event, {
                buffer = bufnr,
                group = group,
                callback = callback,
                desc = "[lsp] format on save",
            })
        end

        if client.supports_method("textDocument/rangeFormatting") then
            vim.keymap.set("x", "<Leader>f", function()
                vim.lsp.buf.format({ bufnr = vim.api.nvim_get_current_buf() })
            end, { buffer = bufnr, desc = "[lsp] format" })
        end
    end,
})]]
