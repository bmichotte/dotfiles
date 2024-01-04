return {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
        window = {
            border = "double",        -- none, single, double, shadow
            position = "bottom",      -- bottom, top
            margin = { 1, 0, 1, 0 },  -- extra window margin [top, right, bottom, left]. When between 0 and 1, will be treated as a percentage of the screen size.
            padding = { 1, 2, 1, 2 }, -- extra window padding [top, right, bottom, left]
            winblend = 0,             -- value between 0-100 0 for fully opaque and 100 for fully transparent
            zindex = 1000,            -- positive value to position WhichKey above other floating windows.
        },
        layout = {
            -- height = { min = 4, max = 25 }, -- min and max height of the columns
            -- width = { min = 20, max = 50 }, -- min and max width of the columns
            -- spacing = 3,            -- spacing between columns
            align = "center", -- align columns left, center or right
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
            ["<leader>f"] = { name = "Files", },
            ["<leader>h"] = { name = "Harpoon", },
            ["<leader>c"] = { name = "Code", },
            ["<leader>n"] = { name = "Package infos", },
            ["<leader>s"] = { name = "Code", },
            ["<leader>t"] = { name = "File tree", },
            ["<leader>z"] = { name = "Float term", },
        })
    end
}
