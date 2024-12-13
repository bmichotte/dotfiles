---@type LazyPlugin[]
return {
    {
        "rcarriga/nvim-notify",
        config = function()
            require("notify").setup({
                render = "minimal",
                stages = "slide",
                timeout = 1500,
            })
        end,
    },
    {
        "folke/noice.nvim",
        event = { "VeryLazy" },
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
            "nvim-telescope/telescope.nvim",
        },
        config = function()
            require("noice").setup({
                lsp = {
                    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                    override = {
                        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                        ["vim.lsp.util.stylize_markdown"] = true,
                        ["cmp.entry.get_documentation"] = true,
                    },
                    hover = {
                        silent = true,
                    },
                    progress = {
                        enabled = false,
                    },
                },
                presets = {
                    lsp_doc_border = true,
                },
            })
            require("telescope").load_extension("noice")
        end,
    },
}
