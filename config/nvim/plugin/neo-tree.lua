vim.pack.add({
    {
        src = "https://github.com/nvim-neo-tree/neo-tree.nvim",
        version = vim.version.range("3")
    },
    -- dependencies
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/MunifTanjim/nui.nvim",
})

require('neo-tree').setup({
    close_if_last_window = true,
    sort_case_insensitive = true,
    filesystem = {
        filtered_items = {
            hide_dotfiles = false,
            hide_gitignored = true,
            hide_by_name = { ".git" },
            never_show = {
                ".DS_Store",
                "thumbs.db",
            },
            always_show = {
                ".env",
                ".env.local",
                ".env.development",
                ".env.test",
                ".env.production",
            },
        },
    },
    window = {
        position = "right",
    },
})

vim.keymap.set("n", "<leader>tt", ":Neotree toggle<CR>", { desc = "[T]oggle files [t]ree", noremap = true, silent = true })
vim.keymap.set("n", "<leader>tf", ":Neotree<CR>", { desc = "[F]ocus files tree", noremap = true, silent = true })
vim.keymap.set("n", "<leader>ts", ":Neotree reveal<CR>", { desc = "Reveal current file", noremap = true, silent = true })
