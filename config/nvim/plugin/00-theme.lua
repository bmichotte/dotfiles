-- vim.pack.add({ "https://github.com/rose-pine/neovim" })
--
-- require("rose-pine").setup({ variant = "moon" })
-- vim.cmd.colorscheme("rose-pine")

vim.pack.add({ "https://github.com/rmehri01/onenord.nvim" })

local colors = require("onenord.colors").load()

require("onenord").setup({
    custom_highlights = {
        -- used for highlighting "text" references
        LspReferenceText = { bg = colors.none, style = colors.none },
        -- used for highlighting "read" references
        LspReferenceRead = { bg = colors.none, style = colors.none },
        -- used for highlighting "write" references
        LspReferenceWrite = { bg = colors.none, style = colors.none },
    },
})
-- vim.cmd.colorscheme("rose-pine")

--[[{
        "catppuccin/nvim",
        name = "catppuccin",
        enabled = false,
        priority = 1000,
        ---@type CatppuccinOptions
        opts = {
            flavour = "mocha",
            styles = {
                comments = { "italic" },
                conditionals = { "italic" },
                loops = {},
                functions = {},
                keywords = { "italic" },
                strings = {},
                variables = {},
                numbers = {},
                booleans = {},
                properties = {},
                types = {},
                operators = {},
            },
            custom_highlights = function(colors)
                return {
                    -- override package info colors
                    PackageInfoOutdatedVersion = { fg = colors.peach },
                    PackageInfoUptodateVersion = { fg = colors.overlay0 },
                }
            end,
            integrations = {
                neotree = true,
                notify = true,
            },
        },
        config = function(_, opts)
            require("catppuccin").setup(opts)
            vim.cmd.colorscheme("catppuccin")
        end,
    }]]
