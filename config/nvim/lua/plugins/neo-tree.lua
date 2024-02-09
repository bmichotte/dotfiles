---@type LazyPlugin
return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    keys = {
        { "<leader>tt", ":Neotree toggle<CR>", desc = "Toggle files tree", silent = true },
        { "<leader>tf", ":Neotree<CR>",        desc = "Focus files tree",  silent = true },
        { "<leader>ts", ":Neotree reveal<CR>", desc = "Find current file", silent = true },
    },
    opts = {
        close_if_last_window = true,
        sort_case_insensitive = true,
        filesystem = {
            filtered_items = {
                hide_dotfiles = false,
                hide_gitignored = true,
                hide_by_name = { ".git" },
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
    },
}
