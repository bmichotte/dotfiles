---@type LazyPlugin
return {
    "mg979/vim-visual-multi",
    branch = "master",
    init = function()
        vim.g.VM_maps = {
            ["Select Cursor Down"] = '<M-C-Down>',
            ["Select Cursor Up"]   = '<M-C-Up>',
            ["I BS"]               = '', -- disable backspace mapping to avoid an error
        }
    end
}
