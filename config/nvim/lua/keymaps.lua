-- set jk to act as esc when in insert mode
vim.keymap.set("i", "jk", "<ESC>", { desc = "jk is the new ESC", noremap = true })

-- jumps and center
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Jump down", noremap = true })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Jump up", noremap = true })

-- search and center
vim.keymap.set("n", "n", "nzzzv", { desc = "Search and jump center", noremap = true })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Search backward and jump center", noremap = true })

-- clear search
vim.keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlight", silent = true, noremap = true })

-- split windows
vim.keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split vertically", noremap = true })
vim.keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split horizontally", noremap = true })
vim.keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splitted windows same width", noremap = true })
vim.keymap.set("n", "<leader>sx", ":close<CR>", { desc = "Close current split", noremap = true })

vim.keymap.set("n", "<c-h>", ":wincmd h<cr>", { desc = "Move to left pane", silent = true, noremap = true })
vim.keymap.set("n", "<c-j>", ":wincmd j<cr>", { desc = "Move to down pane", silent = true, noremap = true })
vim.keymap.set("n", "<c-k>", ":wincmd k<cr>", { desc = "Move to top pane", silent = true, noremap = true })
vim.keymap.set("n", "<c-l>", ":wincmd l<cr>", { desc = "Move to right pane", silent = true, noremap = true })

-- move lines
vim.keymap.set("n", "<A-Down>", ":m .+1<CR>==", { desc = "Move line up", silent = true, noremap = true })
vim.keymap.set("n", "<A-Up>", ":m .-2<CR>==", { desc = "Move line down", silent = true, noremap = true })
vim.keymap.set("v", "<A-Down>", ":m '>+1<CR>gv=gv", { desc = "Move line up", silent = true, noremap = true })
vim.keymap.set("v", "<A-Up>", ":m '<-2<CR>gv=gv", { desc = "Move line down", silent = true, noremap = true })

-- accents
vim.keymap.set("i", "<A-e>", "<C-k>'", { desc = "Accent é", noremap = true })
vim.keymap.set("i", "<A-`", " <C-k>`", { desc = "Accent è", noremap = true })
vim.keymap.set("i", "<A-i>", "<C-k>^", { desc = "Accent ê", noremap = true })
vim.keymap.set("i", "<A-u>", "<C-k>:", { desc = "Accent ë", noremap = true })
vim.keymap.set("i", "<A-c>", "<C-k>,c", { desc = "Accent ç", noremap = true })
vim.keymap.set("i", "<A-S-c>", "<C-k>,C", { desc = "Accent Ç", noremap = true })

-- disable arrows
-- vim.keymap.set("n", "<Up>", function() vim.notify("Use k instead of <Up>", "error") end,
--     { desc = "Disable arrow up", silent = true })
-- vim.keymap.set("n", "<Down>", function() vim.notify("Use j instead of <Down>", "error") end,
--     { desc = "Disable arrow down", silent = true })
-- vim.keymap.set("n", "<Left>", function() vim.notify("Use h instead of <Left>", "error") end,
--     { desc = "Disable arrow left", silent = true })
-- vim.keymap.set("n", "<Right>", function() vim.notify("Use l instead of <Right>", "error") end,
--     { desc = "Disable arrow right", silent = true })

vim.keymap.set(
    "n",
    "<Leader>fj",
    '<Cmd>%!jq --indent 4 \'def sort_keys: . as $in | if type == "object" then $in | to_entries | sort_by(.key | ascii_downcase) | from_entries | map_values(sort_keys) elif type == "array" then map(sort_keys) else . end; sort_keys\'<CR>',
    { noremap = true, silent = true, desc = "Format json file using jq" }
)
