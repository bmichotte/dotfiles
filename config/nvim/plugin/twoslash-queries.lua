vim.pack.add({ "https://github.com/marilari88/twoslash-queries.nvim" })

require("twoslash-queries").setup({})

vim.keymap.set(
    "n",
    "<C-k>",
    ":TwoslashQueriesInspect<CR>",
    { desc = "Inspect twoslash queries", silent = true, noremap = true }
)
