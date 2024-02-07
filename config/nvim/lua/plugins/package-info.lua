---@type LazyPlugin
return {
    "vuki656/package-info.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    keys = {
        { "<leader>ns", function() require("package-info").show() end,           desc = "Show dependency versions" },
        { "<leader>nc", function() require("package-info").hide() end,           desc = "Hide dependency versions" },
        { "<leader>nt", function() require("package-info").toggle() end,         desc = "Toggle dependency versions" },
        { "<leader>nu", function() require("package-info").update() end,         desc = "Update dependency on the line" },
        { "<leader>nd", function() require("package-info").delete() end,         desc = "Delete dependency on the line" },
        { "<leader>ni", function() require("package-info").install() end,        desc = "Install a new dependency" },
        { "<leader>np", function() require("package-info").change_version() end, desc = "Install a different dependency version" },
    },
    opts = {
        -- colors = {
        --     up_to_date = "#6c7086",
        --     outdated = "#fab387",
        -- },
    },
}
