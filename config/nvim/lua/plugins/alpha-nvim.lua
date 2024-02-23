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
    text = "#cdd6f4",
    subtext1 = "#bac2de",
    subtext0 = "#a6adc8",
    overlay2 = "#9399b2",
    overlay1 = "#7f849c",
    overlay0 = "#6c7086",
    surface2 = "#585b70",
    surface1 = "#45475a",
    surface0 = "#313244",
    base = "#1e1e2e",
    mantle = "#181825",
    crust = "#11111b",
}

---@type LazyPlugin
return {
    "goolord/alpha-nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    event = { "VimEnter" },
    config = function()
        vim.api.nvim_set_hl(0, "NeovimDashboardLogo1", { fg = colors.red })
        vim.api.nvim_set_hl(0, "NeovimDashboardLogo2", { fg = colors.peach })
        vim.api.nvim_set_hl(0, "NeovimDashboardLogo3", { fg = colors.yellow })
        vim.api.nvim_set_hl(0, "NeovimDashboardLogo4", { fg = colors.green })
        vim.api.nvim_set_hl(0, "NeovimDashboardLogo5", { fg = colors.blue })
        vim.api.nvim_set_hl(0, "NeovimDashboardLogo6", { fg = colors.mauve })

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
