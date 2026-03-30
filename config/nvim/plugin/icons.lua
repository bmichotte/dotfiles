vim.pack.add({ "https://github.com/nvim-mini/mini.icons" })

require("mini.icons").setup({
    file = {
        ["tailwind.config.ts"] = { glyph = "󱏿", hl = "MiniIconsCyan" },
        ["package.json"] = { glyph = "", hl = "MiniIconsRed" },
    },
})

require("mini.icons").mock_nvim_web_devicons()
--         lazy = true,
--         init = function()
--             package.preload["nvim-web-devicons"] = function()
--                 require("mini.icons").mock_nvim_web_devicons()
--                 return package.loaded["nvim-web-devicons"]
--             end
--         end,
--     },
-- }
