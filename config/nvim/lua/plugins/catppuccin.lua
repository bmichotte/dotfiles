---@type LazyPlugin
return {
    "catppuccin/nvim",
    name = "catppuccin",
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
            -- override package info colors
            return {
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
}
