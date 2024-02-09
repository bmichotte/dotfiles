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
            return {
                -- override package info colors
                PackageInfoOutdatedVersion = { fg = colors.peach },
                PackageInfoUptodateVersion = { fg = colors.overlay0 },

                -- cmp
                CmpItemAbbrDeprecated = { fg = colors.overlay1, bg = "NONE", strikethrough = true },
                CmpItemAbbrMatch = { fg = colors.blue, bg = "NONE", bold = true },
                CmpItemAbbrMatchFuzzy = { fg = colors.blue, bg = "NONE", bold = true },
                CmpItemMenu = { fg = colors.lavender, bg = "NONE", italic = true },

                CmpItemKindField = { fg = colors.maroon, bg = colors.surface1 },
                CmpItemKindProperty = { fg = colors.maroon, bg = colors.surface1 },
                CmpItemKindEvent = { fg = colors.maroon, bg = colors.surface1 },

                CmpItemKindText = { fg = colors.green, bg = colors.surface1 },
                CmpItemKindEnum = { fg = colors.green, bg = colors.surface1 },
                CmpItemKindKeyword = { fg = colors.green, bg = colors.surface1 },

                CmpItemKindConstant = { fg = colors.peach, bg = colors.surface1 },
                CmpItemKindConstructor = { fg = colors.peach, bg = colors.surface1 },
                CmpItemKindReference = { fg = colors.peach, bg = colors.surface1 },

                CmpItemKindFunction = { fg = colors.teal, bg = colors.surface1 },
                CmpItemKindStruct = { fg = colors.teal, bg = colors.surface1 },
                CmpItemKindClass = { fg = colors.teal, bg = colors.surface1 },
                CmpItemKindModule = { fg = colors.teal, bg = colors.surface1 },
                CmpItemKindOperator = { fg = colors.teal, bg = colors.surface1 },

                CmpItemKindVariable = { fg = colors.pink, bg = colors.surface1 },
                CmpItemKindFile = { fg = colors.pink, bg = colors.surface1 },

                CmpItemKindUnit = { fg = colors.yellow, bg = colors.surface1 },
                CmpItemKindSnippet = { fg = colors.yellow, bg = colors.surface1 },
                CmpItemKindFolder = { fg = colors.yellow, bg = colors.surface1 },

                CmpItemKindMethod = { fg = colors.flamingo, bg = colors.surface1 },
                CmpItemKindValue = { fg = colors.flamingo, bg = colors.surface1 },
                CmpItemKindEnumMember = { fg = colors.flamingo, bg = colors.surface1 },

                CmpItemKindInterface = { fg = colors.sky, bg = colors.surface1 },
                CmpItemKindColor = { fg = colors.sky, bg = colors.surface1 },
                CmpItemKindTypeParameter = { fg = colors.sky, bg = colors.surface1 },

                CmpItemKindCopilot = { fg = colors.mauve, bg = colors.surface1 },
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
