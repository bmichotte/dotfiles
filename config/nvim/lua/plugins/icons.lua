---@type LazyPlugin[]
return {
    {
        "nvim-mini/mini.icons",
        opts = {
            file = {
                ["tailwind.config.ts"] = { glyph = "󱏿", hl = "MiniIconsCyan" },
                ["package.json"] = { glyph = "", hl = "MiniIconsRed" },
            },
        },
        lazy = true,
        init = function()
            package.preload["nvim-web-devicons"] = function()
                require("mini.icons").mock_nvim_web_devicons()
                return package.loaded["nvim-web-devicons"]
            end
        end,
    },
}
