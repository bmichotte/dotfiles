return {
    {
        "zbirenbaum/copilot.lua",
        event = "VimEnter",
        config = function()
            require("copilot").setup()
        end,
    },
    {
        "zbirenbaum/copilot-cmp",
        dependencies = { "copilot.lua" },
        config = function()
            require("copilot_cmp").setup()
        end
    }
}
