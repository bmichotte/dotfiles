---@type LazyPlugin[]
return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-ui-select.nvim",
            "nvim-telescope/telescope-fzf-native.nvim",
        },
        keys = {
            {
                "<leader>ff",
                function()
                    require("telescope.builtin").find_files()
                end,
                desc = "Find files",
            },
            {
                "<leader>fg",
                function()
                    require("telescope.builtin").live_grep()
                end,
                desc = "Live grep files",
            },
            {
                "<leader>fc",
                function()
                    require("telescope.builtin").grep_string()
                end,
                desc = "Grep string",
            },
            {
                "<leader>fb",
                function()
                    require("telescope.builtin").buffers()
                end,
                desc = "Show opened buffers",
            },
        },
        config = function()
            local actions = require("telescope.actions")
            local telescope = require("telescope")

            telescope.setup({
                defaults = {
                    mappings = {
                        i = {
                            ["<C-k>"] = actions.move_selection_previous,                       -- move to prev result
                            ["<C-j>"] = actions.move_selection_next,                           -- move to next result
                            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist, -- send selected to quickfixlist
                        },
                        n = {
                            ["d"] = "delete_buffer",
                        },
                    },
                },
                extensions = {
                    ["ui-select"] = {
                        require("telescope.themes").get_dropdown(),
                    },
                    fzf = {
                        fuzzy = true,
                        override_generic_sorter = true,
                        override_file_sorter = true,
                        case_mode = "smart_case",
                    },
                },
            })

            telescope.load_extension("package_info")
            telescope.load_extension("fzf")
            telescope.load_extension("ui-select")
        end,
    },
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
    },
}
