---@type LazyPlugin
return {
    "szw/vim-maximizer", -- maximizes and restore current window
    lazy = true,
    keys = {
        { "<leader>sm", ":MaximizerToggle<CR>", desc = "Maximize current window" },
    },
}
