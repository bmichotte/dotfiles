return {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    opts = {
        provider_selector = function()
            return { 'lsp', 'indent' }
        end
    },
    init = function()
        vim.o.foldcolumn = "1"
        vim.o.foldlevel = 99
        vim.o.foldlevelstart = 99
        vim.o.foldenable = true
    end,
    keys = {
        { 'zR', function() require('ufo').openAllFolds() end,  desc = 'Open all folds' },
        { 'zM', function() require('ufo').closeAllFolds() end, desc = 'Close all folds' },
        {
            'zK',
            function()
                local winid = require('ufo').peekFoldedLinesUnderCursor()
                if not winid then
                    vim.lsp.buf.hover()
                end
            end,
            desc = 'Peek fold'
        },

    },
}
