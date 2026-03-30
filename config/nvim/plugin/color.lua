vim.pack.add({ "https://github.com/brenoprata10/nvim-highlight-colors" })

require("nvim-highlight-colors").setup({
    render = "background",
    virtual_symbol = "●",
    enable_named_colors = false,
    enable_tailwind = true,
})
