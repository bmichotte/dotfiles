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
                --[[{
                    icon = "󰒲 ",
                    key = "L",
                    desc = "Lazy",
                    action = ":Lazy",
                    enabled = package.loaded.lazy ~= nil,
                },]]
                {
                    icon = " ",
                    key = "M",
                    desc = "Mason",
                    action = ":Mason",
                },
                { icon = " ", key = "q", desc = "Quit", action = ":qa" },
            },
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
vim.keymap.set("n", "<c-/>", function()
    Snacks.terminal()
end, { desc = "Toggle Terminal", silent = true, noremap = true })
vim.keymap.set("n", "<c-_>", function()
    Snacks.terminal()
end, { desc = "which_key_ignore", silent = true, noremap = true })

-- pickers
vim.keymap.set("n", "<leader>fg", function()
    Snacks.picker.grep()
end, { desc = "Grep", silent = true, noremap = true })
vim.keymap.set("n", "<leader>:", function()
    Snacks.picker.command_history()
end, { desc = "Command History", silent = true, noremap = true })
vim.keymap.set("n", "<leader>fb", function()
    Snacks.picker.buffers()
end, { desc = "Buffers", silent = true, noremap = true })
vim.keymap.set("n", "<leader>fc", function()
    Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
end, { desc = "Find Config File", silent = true, noremap = true })
vim.keymap.set("n", "<leader>ff", function()
    Snacks.picker.files()
end, { desc = "Find Files", silent = true, noremap = true })
vim.keymap.set("n", "<leader>fi", function()
    Snacks.picker.git_files()
end, { desc = "Find Git Files", silent = true, noremap = true })
vim.keymap.set("n", "<leader>fr", function()
    Snacks.picker.recent()
end, { desc = "Recent", silent = true, noremap = true })

-- git
vim.keymap.set("n", "<leader>gc", function()
    Snacks.picker.git_log()
end, { desc = "Git Log", silent = true, noremap = true })

vim.keymap.set("n", "<leader>gs", function()
    Snacks.picker.git_status()
end, { desc = "Git Status", silent = true, noremap = true })
vim.keymap.set("n", "<leader>gg", function()
    Snacks.lazygit()
end, { desc = "Lazygit", silent = true, noremap = true })
vim.keymap.set("n", "<leader>gb", function()
    Snacks.git.blame_line()
end, { desc = "Git Blame Line", silent = true, noremap = true })

-- Grep
vim.keymap.set("n", "<leader>sb", function()
    Snacks.picker.lines()
end, { desc = "Buffer Lines", silent = true, noremap = true })

vim.keymap.set("n", "<leader>sB", function()
    Snacks.picker.grep_buffers()
end, { desc = "Grep Open Buffers", silent = true, noremap = true })

vim.keymap.set("n", "<leader>sg", function()
    Snacks.picker.grep()
end, { desc = "Grep", silent = true, noremap = true })

vim.keymap.set({ "n", "x" }, "<leader>sw", function()
    Snacks.picker.grep_word()
end, { desc = "Visual selection or word", silent = true, noremap = true })

-- search
vim.keymap.set("n", '<leader>s"', function()
    Snacks.picker.registers()
end, { desc = "Registers", silent = true, noremap = true })

vim.keymap.set("n", "<leader>sa", function()
    Snacks.picker.autocmds()
end, { desc = "Autocmds", silent = true, noremap = true })

vim.keymap.set("n", "<leader>sc", function()
    Snacks.picker.command_history()
end, { desc = "Command History", silent = true, noremap = true })

vim.keymap.set("n", "<leader>sC", function()
    Snacks.picker.commands()
end, { desc = "Commands", silent = true, noremap = true })

vim.keymap.set("n", "<leader>sd", function()
    Snacks.picker.diagnostics()
end, { desc = "Diagnostics", silent = true, noremap = true })

vim.keymap.set("n", "<leader>sh", function()
    Snacks.picker.help()
end, { desc = "Help Pages", silent = true, noremap = true })

vim.keymap.set("n", "<leader>sH", function()
    Snacks.picker.highlights()
end, { desc = "Highlights", silent = true, noremap = true })

vim.keymap.set("n", "<leader>sj", function()
    Snacks.picker.jumps()
end, { desc = "Jumps", silent = true, noremap = true })

vim.keymap.set("n", "<leader>sk", function()
    Snacks.picker.keymaps()
end, { desc = "Keymaps", silent = true, noremap = true })

vim.keymap.set("n", "<leader>sl", function()
    Snacks.picker.loclist()
end, { desc = "Location List", silent = true, noremap = true })

vim.keymap.set("n", "<leader>sM", function()
    Snacks.picker.man()
end, { desc = "Man Pages", silent = true, noremap = true })

vim.keymap.set("n", "<leader>sm", function()
    Snacks.picker.marks()
end, { desc = "Marks", silent = true, noremap = true })

vim.keymap.set("n", "<leader>sR", function()
    Snacks.picker.resume()
end, { desc = "Resume", silent = true, noremap = true })

vim.keymap.set("n", "<leader>sq", function()
    Snacks.picker.qflist()
end, { desc = "Quickfix List", silent = true, noremap = true })

vim.keymap.set("n", "<leader>uC", function()
    Snacks.picker.colorschemes()
end, { desc = "Colorschemes", silent = true, noremap = true })

vim.keymap.set("n", "<leader>qp", function()
    Snacks.picker.projects()
end, { desc = "Projects", silent = true, noremap = true })

-- LSP
vim.keymap.set("n", "gd", function()
    Snacks.picker.lsp_definitions()
end, { desc = "Goto Definition", silent = true, noremap = true })

vim.keymap.set("n", "gr", function()
    Snacks.picker.lsp_references()
end, { desc = "References", silent = true, noremap = true })

vim.keymap.set("n", "gI", function()
    Snacks.picker.lsp_implementations()
end, { desc = "Goto Implementation", silent = true, noremap = true })

vim.keymap.set("n", "gy", function()
    Snacks.picker.lsp_type_definitions()
end, { desc = "Goto T[y]pe Definition", silent = true, noremap = true })

vim.keymap.set("n", "<leader>ss", function()
    Snacks.picker.lsp_symbols()
end, { desc = "LSP Symbols", silent = true, noremap = true })
