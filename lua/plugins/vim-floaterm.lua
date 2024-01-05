return {
    "voldikss/vim-floaterm",
    keys = {
        { "<leader>g",  ":FloatermNew lazygit<CR>",       desc = "Show git window" },

        { "<leader>zt", ":FloatermNew<CR>",               desc = "New float term" },
        { "<leader>zp", ":FloatermPrev<CR>",              desc = "Previous float term" },
        { "<leader>zn", ":FloatermNext<CR>",              desc = "New float term" },
        { "<leader>zz", ":FloatermToggle<CR>",            desc = "Toggle float term" },

        { "<leader>zt", "<C-\\><C-n>:FloatermNew<CR>",    mode = "t",                  desc = "New float term in float term" },
        { "<leader>zp", "<C-\\><C-n>:FloatermPrev<CR>",   mode = "t",                  desc = "Previous float term in float term" },
        { "<leader>zn", "<C-\\><C-n>:FloatermNext<CR>",   mode = "t",                  desc = "New float term in float term" },
        { "<leader>zz", "<C-\\><C-n>:FloatermToggle<CR>", mode = "t",                  desc = "Toggle float term in float term" },
    },
    init = function()
        vim.g.floaterm_width = 0.95
        vim.g.floaterm_height = 0.95
    end
}
