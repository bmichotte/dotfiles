return {
    {
        "numToStr/Comment.nvim",
        config = function()
            require('Comment').setup({
                pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook()
            })
        end,
        lazy = false,
    },
    {
        "JoosepAlviste/nvim-ts-context-commentstring",
        opts = {
            enable_autocmd = false,
        },
        init = function()
            vim.g.skip_ts_context_commentstring_module = true
        end,
    }
}
