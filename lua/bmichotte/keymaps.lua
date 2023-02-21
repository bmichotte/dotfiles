local options = { noremap = true }

local keymap = vim.keymap

-- set jk to act as esc when in insert mode
keymap.set("i", "jk", "<ESC>")

-- jumps and center
keymap.set("n", "<C-d>", "<C-d>zz", options)
keymap.set("n", "<C-u>", "<C-u>zz", options)

-- search and center
keymap.set("n", "n", "nzzzv", options)
keymap.set("n", "N", "Nzzzv", options)

-- clear search
keymap.set("n", "<leader>nh", ":nohl<CR>")

-- split windows
keymap.set("n", "<leader>sv", "<C-w>v") -- split vertically
keymap.set("n", "<leader>sh", "<C-w>s") -- split horizontally
keymap.set("n", "<leader>se", "<C-w>=") -- make splitted windows same width
keymap.set("n", "<leader>sx", ":close<CR>") -- close current split

-- vim-maximizer
keymap.set("n", "<leader>sm", ":MaximizerToggle<CR>")

-- telescope
local telescope_builtin = require("telescope.builtin")
keymap.set("n", "<leader>ff", telescope_builtin.find_files, options)
keymap.set("n", "<leader>fg", telescope_builtin.live_grep, options)
keymap.set("n", "<leader>fc", telescope_builtin.grep_string, options)
keymap.set("n", "<leader>fb", telescope_builtin.buffers, options)
keymap.set("n", "<leader>fh", telescope_builtin.help_tags, options)

-- nvim-tree
keymap.set("n", "<leader>tt", ":NvimTreeToggle<CR>", options)
keymap.set("n", "<leader>tf", ":NvimTreeFocus<CR>", options)
keymap.set("n", "<leader>ts", ":NvimTreeFindFile<CR>", options)
