-- get nice icons for diagnostic
local diagnostic_icons = {
    [vim.diagnostic.severity.ERROR] = "",
    [vim.diagnostic.severity.WARN] = "",
    [vim.diagnostic.severity.HINT] = "",
    [vim.diagnostic.severity.INFO] = "",
}

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

-- Folding
vim.o.foldcolumn = "1"
vim.o.foldlevel = 99
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
vim.o.foldtext = ""

-- Format
vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("lsp_format_config", { clear = true }),
    desc = "Enable format on save",
    callback = function(event)
        vim.keymap.set({ "n", "x" }, "<leader>f", function()
            vim.lsp.buf.format({
                async = false,
                timeout_ms = 10000,
            })
            vim.lsp.buf.code_action({
                ---@diagnostic disable-next-line: assign-type-mismatch
                context = { only = { "source.fixAll.biome" } },
                apply = true,
            })
        end, { buffer = event.buf, desc = "Format buffer" })
    end,
})

--- wraps message with tmux prefix so that the underlying terminal can interpret it correctly
--- needs 'set-option -g allow-passthrough on' in tmux config
---@param content string
---@return string
local function wrap_tmux(content)
    return string.format("\27Ptmux;\27%s\27\\", content)
end

local original_ui_send = vim.api.nvim_ui_send

---@diagnostic disable-next-line: duplicate-set-field
vim.api.nvim_ui_send = function(content)
    -- wrap in TMUX passthrough if needed
    if os.getenv("TMUX") then
        content = wrap_tmux(content)
    end
    original_ui_send(content)
end

-- Show LSP progress
--[[vim.api.nvim_create_autocmd("LspProgress", {
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

        local value = ev.data.params.value or {}
        if not value.kind then
            return
        end

        -- data
        local status = value.kind == "end" and 0 or 1 -- 0: success/hide, 1: running
        local percent = value.percentage or 0

        -- Ghostty progress 9;4 (Ghostty progress)
        local osc_seq = string.format("\27]9;4;%d;%d\a", status, percent)
        vim.api.nvim_ui_send(osc_seq)
    end,
})]]

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if not client then
            return
        end

        local opts = { noremap = true, buffer = args.buf, silent = true }

        opts.desc = "Show diagnostics for line"
        vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

        opts.desc = "Show documentation for what is under cursor"
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)

        opts.desc = "See code actions"
        vim.keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

        opts.desc = "Show signature help"
        vim.keymap.set("i", "<C-h>", vim.lsp.buf.signature_help, opts)

        opts.desc = "Rename symbol"

        vim.keymap.set("n", "<leader>r", function()
            require("snacks").input.input({
                prompt = "Rename to: ",
                default = vim.fn.expand("<cword>"),
            }, function(new_name)
                if new_name and #new_name > 0 then
                    vim.lsp.buf.rename(new_name)
                end
            end)
        end, opts)

        -- fold
        if client:supports_method("textDocument/foldingRange") then
            local win = vim.api.nvim_get_current_win()
            vim.wo[win][0].foldmethod = "expr"
            vim.wo[win][0].foldexpr = "v:lua.vim.lsp.foldexpr()"
        end

        -- atm, nvim-highlight-colors has functionnalities neovim doesn't have (like tailwindcss colors)
        if client.server_capabilities.inlayHintProvider then
            vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
        end

        -- codelens
        -- if client:supports_method("textDocument/codeLens") then
        --     vim.lsp.codelens.enable(true)
        -- end

        -- colors
        if client:supports_method("textDocument/documentColor") then
            vim.lsp.document_color.enable(true, { bufnr = args.buf })
        end

        -- biome
        if client.name == "biome" then
            vim.api.nvim_create_autocmd("BufWritePre", {
                group = vim.api.nvim_create_augroup("BiomeFixAll", { clear = true }),
                callback = function()
                    vim.lsp.buf.code_action({
                        context = {
                            ---@diagnostic disable-next-line: assign-type-mismatch
                            only = { "source.fixAll.biome" },
                            diagnostics = {},
                        },
                        apply = true,
                    })
                end,
            })
        end
    end,
})

vim.api.nvim_create_autocmd("LspDetach", { command = "setl foldexpr<" })

vim.lsp.config("tsc", {
    settings = {
        ["js/ts"] = {
            inlayHints = {
                parameterTypes = { enabled = false },
                variableTypes = { enabled = false },
            },
            preferences = {
                importModuleSpecifier = "non-relative",
                importModuleSpecifierPreference = "non-relative",
                importModuleSpecifierEnding = "auto",
                preferTypeOnlyAutoImports = true,
                quoteStyle = "auto",
            },
        },
    },
})
