---@type LazyPlugin
return {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
        signs = {
            error = "",
            warning = "",
            hint = "",
            information = "",
            other = "",
        },
    },
    keys = {
        { "<leader>dt", function() require("trouble").toggle("workspace_diagnostics") end,               desc = "Toggle workspace diagnostics" },
        { "<leader>dj", function() require("trouble").next({ skip_groups = true, jump = true }) end,     desc = "Next diagnostic" },
        { "<leader>dk", function() require("trouble").previous({ skip_groups = true, jump = true }) end, desc = "Previous diagnostic" },
    }
}
