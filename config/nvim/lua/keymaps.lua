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
keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlight" })

-- split windows
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split vertically" })
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split horizontally" })
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splitted windows same width" })
keymap.set("n", "<leader>sx", ":close<CR>", { desc = "Close current split" })

keymap.set("n", "<c-h>", ":wincmd h<cr>", { desc = "Move to left pane", silent = true })
keymap.set("n", "<c-j>", ":wincmd j<cr>", { desc = "Move to down pane", silent = true })
keymap.set("n", "<c-k>", ":wincmd k<cr>", { desc = "Move to top pane", silent = true })
keymap.set("n", "<c-l>", ":wincmd l<cr>", { desc = "Move to right pane", silent = true })

-- move lines
keymap.set("n", "<A-Down>", ":m .+1<CR>==", { desc = "Move line up" })
keymap.set("n", "<A-Up>", ":m .-2<CR>==", { desc = "Move line down" })
keymap.set("v", "<A-Down>", ":m '>+1<CR>gv=gv", { desc = "Move line up" })
keymap.set("v", "<A-Up>", ":m '<-2<CR>gv=gv", { desc = "Move line down" })

-- accents
keymap.set("i", "<A-e>", "<C-k>'", { desc = "Accent é" })
keymap.set("i", "<A-`", " <C-k>`", { desc = "Accent è" })
keymap.set("i", "<A-i>", "<C-k>^", { desc = "Accent ê" })
keymap.set("i", "<A-u>", "<C-k>:", { desc = "Accent ë" })
keymap.set("i", "<A-c>", "<C-k>,c", { desc = "Accent ç" })
keymap.set("i", "<A-S-c>", "<C-k>,C", { desc = "Accent Ç" })

-- disable arrows
-- keymap.set("n", "<Up>", function() vim.notify("Use k instead of <Up>", "error") end,
--     { desc = "Disable arrow up", silent = true })
-- keymap.set("n", "<Down>", function() vim.notify("Use j instead of <Down>", "error") end,
--     { desc = "Disable arrow down", silent = true })
-- keymap.set("n", "<Left>", function() vim.notify("Use h instead of <Left>", "error") end,
--     { desc = "Disable arrow left", silent = true })
-- keymap.set("n", "<Right>", function() vim.notify("Use l instead of <Right>", "error") end,
--     { desc = "Disable arrow right", silent = true })
