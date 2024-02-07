---@type LazyPlugin
return {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = { "windwp/nvim-ts-autotag", },
    opts = {
        sync_install = true,
        auto_install = true,
        indent = {
            enable = true,
        },
        highlight = {
            enable = true,
        },
        autotag = {
            enable = true,
        }
    },
    config = function(_, opts)
        require("nvim-treesitter.configs").setup(opts)
    end
}
