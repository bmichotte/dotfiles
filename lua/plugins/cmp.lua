return {
    {
        "hrsh7th/nvim-cmp",
        lazy = false,
        dependencies = {
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-nvim-lsp",
            "L3MON4D3/LuaSnip",
            "rafamadriz/friendly-snippets",
            "saadparwaiz1/cmp_luasnip",
            "hrsh7th/cmp-path",
            'js-everts/cmp-tailwind-colors',
        },
    },
    {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp",
        keys = {
            { "<C-l>", function() require('luasnip').jump(1) end,  desc = "Jump to next snippet variable",     mode = { "i", "s" } },
            { "<C-j>", function() require('luasnip').jump(-1) end, desc = "Jump to previous sinppet variable", mode = { "i", "s" } },
        },
        config = function()
            local ls = require("luasnip")
            local i = ls.insert_node
            local extras = require("luasnip.extras")
            local l = extras.lambda
            local fmt = require("luasnip.extras.fmt").fmt
            local s = ls.snippet
            -- local sn = ls.snippet_node
            -- local isn = ls.indent_snippet_node
            -- local t = ls.text_node
            -- local f = ls.function_node
            -- local c = ls.choice_node
            -- local d = ls.dynamic_node
            -- local r = ls.restore_node
            -- local rep = extras.rep
            -- local events = require("luasnip.util.events")
            -- local ai = require("luasnip.nodes.absolute_indexer")
            -- local p = extras.partial
            -- local m = extras.match
            -- local n = extras.nonempty
            -- local dl = extras.dynamic_lambda
            -- local fmta = require("luasnip.extras.fmt").fmta
            -- local conds = require("luasnip.extras.expand_conditions")
            -- local postfix = require("luasnip.extras.postfix").postfix
            -- local types = require("luasnip.util.types")
            -- local parse = require("luasnip.util.parser").parse_snippet
            -- local ms = ls.multi_snippet
            -- local k = require("luasnip.nodes.key_indexer").new_key

            ls.add_snippets('typescriptreact', {
                s(
                    "rus",
                    fmt("const [{}, set{setter}] = useState<{}>({})", {
                        i(1, "state"),
                        i(2, "type"),
                        i(3, "initialValue"),
                        setter = l(l._1:sub(1, 1):upper() .. l._1:sub(2, -1), 1)
                    })
                )
            })
        end
    }
}
