local colors = {
    rosewater = "#f5e0dc",
    flamingo = "#f2cdcd",
    pink = "#f5c2e7",
    mauve = "#cba6f7",
    red = "#f38ba8",
    maroon = "#eba0ac",
    peach = "#fab387",
    yellow = "#f9e2af",
    green = "#a6e3a1",
    teal = "#94e2d5",
    sky = "#89dceb",
    sapphire = "#74c7ec",
    blue = "#89b4fa",
    lavender = "#b4befe",
}

---@type LazyPlugin
return {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = { "VimEnter" },
    config = function()
        local keyset = {}
        for k in pairs(colors) do
            table.insert(keyset, colors[k])
        end
        local color = keyset[math.random(#keyset)]

        vim.api.nvim_set_hl(0, "NeovimDashboardLogo1", { fg = color })
        vim.api.nvim_set_hl(0, "NeovimDashboardLogo2", { fg = color })
        vim.api.nvim_set_hl(0, "NeovimDashboardLogo3", { fg = color })
        vim.api.nvim_set_hl(0, "NeovimDashboardLogo4", { fg = color })
        vim.api.nvim_set_hl(0, "NeovimDashboardLogo5", { fg = color })
        vim.api.nvim_set_hl(0, "NeovimDashboardLogo6", { fg = color })

        local alpha = require("alpha")
        local dashboard = require("alpha.themes.startify")

        dashboard.section.header.type = "group"

        -- stylua: ignore start
        dashboard.section.header.val = {
            { type = "text", val = "  ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗ ", opts = { hl = "NeovimDashboardLogo1", shrink_margin = false, position = "center" } },
            { type = "text", val = "  ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║ ", opts = { hl = "NeovimDashboardLogo2", shrink_margin = false, position = "center" } },
            { type = "text", val = "  ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║ ", opts = { hl = "NeovimDashboardLogo3", shrink_margin = false, position = "center" } },
            { type = "text", val = "  ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║ ", opts = { hl = "NeovimDashboardLogo4", shrink_margin = false, position = "center" } },
            { type = "text", val = "  ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║ ", opts = { hl = "NeovimDashboardLogo5", shrink_margin = false, position = "center" } },
            { type = "text", val = "  ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝ ", opts = { hl = "NeovimDashboardLogo6", shrink_margin = false, position = "center" } },
        }
        -- stylua: ignore end

        dashboard.section.mru.val = { { type = "padding", val = 0 } }

        alpha.setup(dashboard.opts)
    end,
}
