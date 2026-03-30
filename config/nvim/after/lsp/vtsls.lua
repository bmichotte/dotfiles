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

    on_attach = function(client, bufnr)
        require("twoslash-queries").attach(client, bufnr)

        -- we don't want ts to format
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
    end,

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
            settings = {
                preferences = {
                    importModuleSpecifier = "non-relative",
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
            pkreferences = {
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
}
