return {
    "marilari88/twoslash-queries.nvim",
    config = function()
        vim.api.nvim_set_keymap('n', "<C-k>", "<cmd>TwoslashQueriesInspect<CR>",
            { noremap = true, desc = "Inspect twoslash queries" })
    end,
}
