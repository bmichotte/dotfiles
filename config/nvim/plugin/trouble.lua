---@module "trouble"

vim.pack.add({ "https://github.com/folke/trouble.nvim" })

require("trouble").setup({
    signs = {
        error = "",
        warning = "",
        hint = "",
        information = "",
        other = "",
    },
    win = {
        border = vim.o.winborder,
        position = "bottom",
    },
})

vim.keymap.set("n", "<leader>dt", function()
    require("trouble").toggle("workspace_diagnostics")
end, { desc = "Toggle workspace diagnostics", silent = true, noremap = true })

vim.keymap.set("n", "<leader>dj", function()
    require("trouble").next({ skip_groups = true, jump = true })
end, { desc = "Next diagnostic", silent = true, noremap = true })

vim.keymap.set("n", "<leader>dk", function()
    require("trouble").previous({ skip_groups = true, jump = true })
end, { desc = "Previous diagnostic", silent = true, noremap = true })
