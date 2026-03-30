vim.pack.add({
    "https://github.com/rcarriga/nvim-notify",
})

require("notify").setup({
    render = "minimal",
    stages = "slide",
    timeout = 1500,
})

vim.pack.add({
    "https://github.com/folke/noice.nvim",
    -- dependencies
    "https://github.com/MunifTanjim/nui.nvim",
    "https://github.com/rcarriga/nvim-notify",
    "https://github.com/nvim-lua/plenary.nvim",
    "https://github.com/nvim-telescope/telescope.nvim",
})

require("telescope").setup()
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
-- require("telescope").load_extension("noice")
