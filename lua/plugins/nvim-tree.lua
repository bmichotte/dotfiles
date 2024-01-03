return {
    enabled = false,
    "nvim-tree/nvim-tree.lua",
    dependencies = {
        "nvim-tree/nvim-web-devicons", -- for file icons
    },
    config = function()
        local nvimtree = require("nvim-tree")

        -- recommended settings from nvim-tree documentation
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        nvimtree.setup({
            sort_by = "case_sensitive",
            view = {
                side = "right",
            },
            filters = {
                dotfiles = true,
                exclude = { ".env", ".eslintrc.json" },
            },
        })

        vim.keymap.set("n", "<leader>tt", ":NvimTreeToggle<CR>", { noremap = true, desc = "Toggle files tree" })
        vim.keymap.set("n", "<leader>tf", ":NvimTreeFocus<CR>", { noremap = true, desc = "Focus files tree" })
        vim.keymap.set("n", "<leader>ts", ":NvimTreeFindFile<CR>", { noremap = true, desc = "Find current file" })
    end
}
