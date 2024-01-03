return {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
    },
    config = function()
        require("neo-tree").setup({
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
        })

        vim.keymap.set("n", "<leader>tt", ":Neotree toggle<CR>", { noremap = true, desc = "Toggle files tree" })
        vim.keymap.set("n", "<leader>tf", ":Neotree<CR>", { noremap = true, desc = "Focus files tree" })
        vim.keymap.set("n", "<leader>ts", ":Neotree reveal<CR>", { noremap = true, desc = "Find current file" })
    end
}
