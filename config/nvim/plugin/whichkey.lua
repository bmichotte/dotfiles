vim.pack.add({ "https://github.com/folke/which-key.nvim" })

require("which-key").setup({
    preset = "modern",
    delay = 800,
    triggers = {
        { "<auto>", mode = "nixsoc" },
    },
    layout = {
        align = "center",
    },
    icons = {
        group = " ",
    },
})

vim.o.timeout = true
vim.o.timeoutlen = 800

local wk = require("which-key")

wk.add({
    { "<leader>c", group = "Code" },
    { "<leader>d", group = "Diagnostics" },
    { "<leader>f", group = "Files" },
    -- { "<leader>h", group = "Harpoon" },
    { "<leader>n", group = "Package infos" },
    { "<leader>s", group = "Split" },
    { "<leader>t", group = "File tree" },
    { "<leader>z", group = "Float term" },
})
