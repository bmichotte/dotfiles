---@type vim.lsp.Config
return {
    capabilities = {
        textDocument = {
            foldingRange = {
                dynamicRegistration = false,
                lineFoldingOnly = true,
            },
        },
    },

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
}
