return {
    "voldikss/vim-floaterm",
    config = function()
        vim.g.floaterm_width = 0.95
        vim.g.floaterm_height = 0.95

        vim.keymap.set("n", "<leader>g", ":FloatermNew lazygit<CR>", { noremap = true, desc = "Show git window" })

        vim.keymap.set("n", "<leader>zt", ":FloatermNew<CR>", { noremap = true, desc = "New float term" })
        vim.keymap.set("t", "<leader>zt", "<C-\\><C-n>:FloatermNew<CR>",
            { noremap = true, desc = "New float term in float term" })
        vim.keymap.set("n", "<leader>zp", ":FloatermPrev<CR>", { noremap = true, desc = "Previous float term" })
        vim.keymap.set("t", "<leader>zp", "<C-\\><C-n>:FloatermPrev<CR>",
            { noremap = true, desc = "Previous float term in float term" })
        vim.keymap.set("n", "<leader>zn", ":FloatermNext<CR>", { noremap = true, desc = "New float term" })
        vim.keymap.set("t", "<leader>zn", "<C-\\><C-n>:FloatermNext<CR>",
            { noremap = true, desc = "New float term in float term" })
        vim.keymap.set("n", "<leader>zz", ":FloatermToggle<CR>", { noremap = true, desc = "Toggle float term" })
        vim.keymap.set("t", "<leader>zz", "<C-\\><C-n>:FloatermToggle<CR>",
            { noremap = true, desc = "Toggle float term in float term" })
    end
}
