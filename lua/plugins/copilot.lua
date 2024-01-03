return {
    {
        "zbirenbaum/copilot.lua",
        event = "VimEnter",
        config = function()
            vim.defer_fn(function()
                require("copilot").setup({})
            end, 100)
        end,
    },
    {
        "zbirenbaum/copilot-cmp",
        dependencies = { "copilot.lua" },
        config = function()
            local copilot_cmp = require("copilot_cmp")
            copilot_cmp.setup({
                formatters = {
                    insert_text = require("copilot_cmp.format").remove_existing,
                },
            })
        end
    }
}
