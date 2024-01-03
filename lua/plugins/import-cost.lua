return {
    'barrett-ruth/import-cost.nvim',
    build = 'sh install.sh yarn',
    config = function()
        require('import-cost').setup({
            highlight = 'Comment',
        })
    end
}
