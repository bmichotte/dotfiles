return {
    "voldikss/vim-floaterm",
    keys = {
        { "<leader>g",  ":FloatermNew lazygit<CR>",       desc = "Show git window" },

        { "<leader>zt", ":FloatermNew<CR>",               desc = "New float term" },
        { "<leader>zp", ":FloatermPrev<CR>",              desc = "Previous float term" },
        { "<leader>zn", ":FloatermNext<CR>",              desc = "New float term" },
        { "<leader>zz", ":FloatermToggle<CR>",            desc = "Toggle float term" },

        { "<leader>zt", "<C-\\><C-n>:FloatermNew<CR>",    desc = "New float term in float term",       mode = "t" },
        { "<leader>zp", "<C-\\><C-n>:FloatermPrev<CR>",   desc = "Previous float term in float term",  mode = "t" },
        { "<leader>zn", "<C-\\><C-n>:FloatermNext<CR>",   desc = "New float term in float term",       mode = "t" },
        { "<leader>zz", "<C-\\><C-n>:FloatermToggle<CR>", desc = "Toggle float term in float term",    mode = "t" },
    },
    init = function()
        vim.g.floaterm_width = 0.95
        vim.g.floaterm_height = 0.95
    end
}
