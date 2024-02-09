---@type LazyPlugin
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
        icons = {
            group = " ",
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
            c = { name = "Code" },
            d = { name = "Diagnostics" },
            h = { name = "Harpoon" },
            f = { name = "Files" },
            n = { name = "Package infos" },
            s = { name = "Split" },
            t = { name = "File tree" },
            z = { name = "Float term" },
        }, { prefix = "<leader>" })
    end,
}
