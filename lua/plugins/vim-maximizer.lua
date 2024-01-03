return {
    "szw/vim-maximizer",     -- maximizes and restore current window
    config = function()
        vim.keymap.set("n", "<leader>sm", ":MaximizerToggle<CR>")
    end
}
