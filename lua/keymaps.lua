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
keymap.set("n", "<leader>sv", "<C-w>v")     -- split vertically
keymap.set("n", "<leader>sh", "<C-w>s")     -- split horizontally
keymap.set("n", "<leader>se", "<C-w>=")     -- make splitted windows same width
keymap.set("n", "<leader>sx", ":close<CR>") -- close current split
