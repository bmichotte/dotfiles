return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { { "nvim-lua/plenary.nvim" } },
        config = function()
            local actions = require("telescope.actions")
            local telescope_builtin = require("telescope.builtin")
            local telescope = require("telescope")

            telescope.setup({
                defaults = {
                    mappings = {
                        i = {
                            ["<C-k>"] = actions.move_selection_previous,                   -- move to prev result
                            ["<C-j>"] = actions.move_selection_next,                       -- move to next result
                            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist, -- send selected to quickfixlist
                        },
                        n = {
                            ["d"] = "delete_buffer",
                        },
                    },
                },
            })

            telescope.load_extension("fzf")
            telescope.load_extension("package_info")

            vim.keymap.set("n", "<leader>ff", telescope_builtin.find_files, { desc = "Find files", noremap = true })
            vim.keymap.set("n", "<leader>fg", telescope_builtin.live_grep, { desc = "Live grep files", noremap = true })
            vim.keymap.set("n", "<leader>fc", telescope_builtin.grep_string, { desc = "Grep string", noremap = true })
            vim.keymap.set("n", "<leader>fb", telescope_builtin.buffers, { desc = "Show opened buffers", noremap = true })
            --vim.keymap.set("n", "<leader>fh", telescope_builtin.help_tags, options)
        end
    },
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
        dependencies = { "nvim-telescope/telescope.nvim" },
    }
}
