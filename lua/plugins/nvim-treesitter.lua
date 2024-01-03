return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
        require("nvim-treesitter.configs").setup({
            sync_install = true,
            auto_install = true,
            indent = {
                enable = true,
            },
            highlight = {
                enable = true,
            },
        })
    end
}