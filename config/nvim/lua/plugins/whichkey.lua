return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        window = {
            border = "double",
        },
        layout = {
            align = "center",
        },
    },
    init = function()
        vim.o.timeout = true
        vim.o.timeoutlen = 800
    end,
    config = function(_, opts)
        local wk = require("which-key")
        wk.setup(opts)

        wk.register({
            ["<leader>c"] = { name = "Code", },
            ["<leader>h"] = { name = "Harpoon", },
            ["<leader>f"] = { name = "Files", },
            ["<leader>n"] = { name = "Package infos", },
            ["<leader>s"] = { name = "Split", },
            ["<leader>t"] = { name = "File tree", },
            ["<leader>z"] = { name = "Float term", },
        })
    end
}
