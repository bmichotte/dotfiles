local setup, nvimtree = pcall(require, "nvim-tree")
if not setup then
    return
end

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
