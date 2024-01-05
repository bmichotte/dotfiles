return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    keys = {
        { "<leader>tt", ":Neotree toggle<CR>", desc = "Toggle files tree" },
        { "<leader>tf", ":Neotree<CR>",        desc = "Focus files tree" },
        { "<leader>ts", ":Neotree reveal<CR>", desc = "Find current file" },
    },
    opts = {
        sort_case_insensitive = true,
        filesystem = {
            filtered_items = {
                hide_dotfiles = false,
                hide_gitignored = true,
                hide_by_name = { '.git' },
                always_show = {
                    ".env", '.env.local', '.env.development', '.env.test', '.env.production',
                }
            }
        },
        window = {
            position = "right",
        }
    },
}
