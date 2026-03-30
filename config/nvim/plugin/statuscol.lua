--[[
vim.pack.add({
    "https://github.com/luukvbaal/statuscol.nvim",
    -- dependencies
    "https://github.com/lewis6991/gitsigns.nvim",
})

local builtin = require("statuscol.builtin")
require("statuscol").setup({
    relculright = true,
    segments = {
        { text = { builtin.foldfunc, " " }, click = "v:lua.ScFa" },
        {
            sign = { namespace = { "diagnostic" }, maxwidth = 1, colwidth = 1, auto = true },
            click = "v:lua.ScSa",
        },
        { text = { builtin.lnumfunc, " " }, click = "v:lua.ScLa", condition = { true, builtin.not_empty } },
        {
            sign = {
                namespace = { "gitsigns" },
                name = { ".*" },
                maxwidth = 2,
                colwidth = 1,
                auto = true,
                wrap = true,
            },
            click = "v:lua.ScSa",
        },
    },
})]]
