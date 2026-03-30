---@type LazyPlugin[]
return {
    {
        "rose-pine/neovim",
        name = "rose-pine",
        opts = {
            variant = 'moon'
        },
        config = function(_, opts)
            require("rose-pine").setup(opts)
            vim.cmd.colorscheme("rose-pine")
        end,
    },
    {
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
    },
}
