return {
    "voldikss/vim-floaterm",
    config = function()
        vim.g.floaterm_width = 0.95
        vim.g.floaterm_height = 0.95
        vim.keymap.set("n", "<leader>g", ":FloatermNew lazygit<CR>")

        vim.keymap.set("n", "<leader>zt", ":FloatermNew<CR>")
        vim.keymap.set("t", "<leader>zt", "<C-\\><C-n>:FloatermNew<CR>")
        vim.keymap.set("n", "<leader>zp", ":FloatermPrev<CR>")
        vim.keymap.set("t", "<leader>zp", "<C-\\><C-n>:FloatermPrev<CR>")
        vim.keymap.set("n", "<leader>zn", ":FloatermNext<CR>")
        vim.keymap.set("t", "<leader>zn", "<C-\\><C-n>:FloatermNext<CR>")
        vim.keymap.set("n", "<leader>zz", ":FloatermToggle<CR>")
        vim.keymap.set("t", "<leader>zz", "<C-\\><C-n>:FloatermToggle<CR>")
    end
}
