---@type LazyPlugin
return {
    "lewis6991/gitsigns.nvim",
    opts = {
        current_line_blame = true,
        current_line_blame_opts = {
            delay = 500,
        },
        current_line_blame_formatter = "<author>, <author_time:%R> - <summary> - <abbrev_sha>",
    },
}
