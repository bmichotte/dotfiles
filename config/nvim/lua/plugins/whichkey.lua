---@type LazyPlugin
return {
    "folke/which-key.nvim",
    event = { "VeryLazy" },
    opts = {
        preset = "modern",
        delay = 800,
        triggers = {
            { "<auto>", mode = "nixsoc" },
        },
        -- modes = {
        --     t = false,
        -- },
        win = {
            border = "single",
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

        wk.add({
            { "<leader>c", group = "Code" },
            { "<leader>d", group = "Diagnostics" },
            { "<leader>f", group = "Files" },
            { "<leader>h", group = "Harpoon" },
            { "<leader>n", group = "Package infos" },
            { "<leader>s", group = "Split" },
            { "<leader>t", group = "File tree" },
            { "<leader>z", group = "Float term" },
        })
    end,
}
