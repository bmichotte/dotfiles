return {
    {
        "zbirenbaum/copilot.lua",
        event = "VimEnter",
        opts = {
            suggestion = { enabled = false },
            panel = { enabled = false },
        },
    },
    {
        "zbirenbaum/copilot-cmp",
        dependencies = { "copilot.lua" },
        config = true
    }
}
