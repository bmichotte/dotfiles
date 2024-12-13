---@type LazyPlugin[]
return {
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        ---@type snacks.Config
        opts = {
            bigfile = { enabled = true },
            dashboard = {
                enabled = true,
                preset = {
                    header = [[
                     ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
                     ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
                     ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
                     ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
                     ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
                     ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
                },
                sections = {
                    { section = "header" },
                    { section = "keys", gap = 0, padding = 1, hidden = true },
                    {
                        icon = " ",
                        title = "Recent Files",
                        section = "recent_files",
                        cwd = true,
                        indent = 2,
                        padding = 1,
                    },
                    -- { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
                    {
                        icon = " ",
                        title = "Git Status",
                        section = "terminal",
                        enabled = function()
                            return Snacks.git.get_root() ~= nil
                        end,
                        cmd = "hub status --short --branch --renames",
                        height = 5,
                        padding = 1,
                        ttl = 5 * 60,
                        indent = 3,
                    },
                    { section = "startup" },
                },
            },
            indent = {
                enabled = true,
                scope = {
                    animate = { duration = { step = 20 }, style = "out" },
                },
            },
            input = {
                enabled = true,
                icon = " ",
                icon_hl = "SnacksInputIcon",
                win = { style = "input" },
                expand = true,
            },
            notifier = { enabled = true },
            quickfile = { enabled = true },
            scroll = { enabled = true },
            scope = { enabled = true },
            statuscolumn = {
                enabled = true,
                left = { "mark", "sign" },
                right = { "fold", "git" },
                folds = {
                    open = true,
                    git_hl = false,
                },
                git = {
                    patterns = { "GitSign", "MiniDiffSign" },
                },
                refresh = 50,
            },
            words = { enabled = true },
            lazygit = {},
        },
        keys = {
            {
                "<leader>gb",
                function()
                    Snacks.git.blame_line()
                end,
                desc = "Git Blame Line",
            },
            {
                "<leader>g",
                function()
                    Snacks.lazygit()
                end,
                desc = "Lazygit",
            },
            {
                "<leader>un",
                function()
                    Snacks.notifier.hide()
                end,
                desc = "Dismiss All Notifications",
            },
            {
                "<c-/>",
                function()
                    Snacks.terminal()
                end,
                desc = "Toggle Terminal",
            },
            {
                "<c-_>",
                function()
                    Snacks.terminal()
                end,
                desc = "which_key_ignore",
            },
        },
    },
}
