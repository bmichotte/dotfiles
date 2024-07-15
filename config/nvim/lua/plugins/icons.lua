---@type LazyPlugin[]
return {
    -- {
    --     "nvim-tree/nvim-web-devicons",
    --     init = function() end,
    -- },
    {
        "echasnovski/mini.icons",
        opts = {},
        lazy = true,
        init = function()
            package.preload["nvim-web-devicons"] = function()
                require("mini.icons").mock_nvim_web_devicons()
                return package.loaded["nvim-web-devicons"]
            end
        end,
    },
}
