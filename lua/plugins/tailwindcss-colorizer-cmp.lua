return {
    "roobert/tailwindcss-colorizer-cmp.nvim",
    enabled = false,
    config = function()
        require("tailwindcss-colorizer-cmp").setup({
            color_square_width = 2,
        })
    end
}
