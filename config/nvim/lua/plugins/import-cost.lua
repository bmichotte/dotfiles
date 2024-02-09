---@type LazyPlugin
return {
    "barrett-ruth/import-cost.nvim",
    build = "sh install.sh yarn",
    opts = {
        highlight = "Comment",
    },
}
