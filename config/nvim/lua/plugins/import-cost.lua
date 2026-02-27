---@type LazyPlugin
return {
    "barrett-ruth/import-cost.nvim",
    opts = {
        highlight = "Comment",
    },
    config = function(opts)
        vim.g.import_cost = opts
    end,
}
