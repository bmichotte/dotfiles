vim.pack.add({ "https://github.com/christoomey/vim-tmux-navigator" })

vim.keymap.set("n", "C-h", ":TmuxNavigateLeft<CR>", { desc = "Tmux navigate left", noremap = true, silent = true })
vim.keymap.set("n", "C-l", ":TmuxNavigateRight<CR>", { desc = "Tmux navigate right", noremap = true, silent = true })
vim.keymap.set("n", "C-j", ":TmuxNavigateDown<CR>", { desc = "Tmux navigate down", noremap = true, silent = true })
vim.keymap.set("n", "C-k", ":TmuxNavigateUp<CR>", { desc = "Tmux navigate up", noremap = true, silent = true })
