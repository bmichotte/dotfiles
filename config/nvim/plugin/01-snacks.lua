---@module "lazy"
---@module "snacks"

vim.pack.add({ "https://github.com/folke/snacks.nvim" })

---@type snacks.Config
require("snacks").setup({
    bigfile = { enabled = true },
    dashboard = {
        enabled = true,
        preset = {
            keys = {
                {
                    icon = " ",
                    key = "f",
                    desc = "Find File",
                    action = ":lua Snacks.dashboard.pick('files')",
                },
                { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
                {
                    icon = " ",
                    key = "g",
                    desc = "Find Text",
                    action = ":lua Snacks.dashboard.pick('live_grep')",
                },
                {
                    icon = " ",
                    key = "r",
                    desc = "Recent Files",
                    action = ":lua Snacks.dashboard.pick('oldfiles')",
                },
                {
                    icon = " ",
                    key = "c",
                    desc = "Config",
                    action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})",
                },
                { icon = " ", key = "s", desc = "Restore Session", section = "session" },
                {
                    icon = " ",
                    key = "M",
                    desc = "Mason",
                    action = ":Mason",
                },
                { icon = " ", key = "q", desc = "Quit", action = ":qa" },
            },
            header = [[



  ▀
█▀█▄█▀█▀█▀█

]],
        },
        sections = {
            { section = "header" },
            { section = "keys",  gap = 0, padding = 1, hidden = true },
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
            -- { section = "startup" },
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
    picker = {
        enabled = true,
        layout = {
            width = 0.3,
        },
    },
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
    styles = {
        input = {
            position = "float",
            relative = "editor",
            border = "rounded",
            title_pos = "center",
            backdrop = false,
            row = math.floor(vim.o.lines / 2) - 2,
            noautocmd = true,
            wo = {
                winhighlight = "NormalFloat:SnacksInputNormal,FloatBorder:SnacksInputBorder,FloatTitle:SnacksInputTitle",
                cursorline = false,
            },
            bo = {
                filetype = "snacks_input",
                buftype = "prompt",
            },
            b = {
                completion = false,
            },
        },
    },
    words = { enabled = true },
    lazygit = {},
})

vim.keymap.set("n", "<leader>un", function()
    Snacks.notifier.hide()
end, { desc = "Dismiss All Notifications", silent = true, noremap = true })

