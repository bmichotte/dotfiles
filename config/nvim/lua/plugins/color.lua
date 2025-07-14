---@type LazyPlugin[]
return {
    {
        "brenoprata10/nvim-highlight-colors",
        -- enabled = vim.fn.has("nvim-0.12") == 0,
        opts = {
            render = "background",
            virtual_symbol = "●",
            enable_named_colors = false,
            enable_tailwind = true,
        },
    },
}
