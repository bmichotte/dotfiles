---@type LazyPlugin[]
return {
    {
        enabled = false,
        "NvChad/nvim-colorizer.lua",
        opts = {
            user_default_options = {
                css = true,
                tailwind = true,
                names = false,
            },
        },
    },
    {
        "brenoprata10/nvim-highlight-colors",
        opts = {
            render = "virtual",
            virtual_symbol = "●",
            enable_named_colors = false,
            enable_tailwind = true,
        },
    },
}
