vim.pack.add({ "https://github.com/ibhagwan/fzf-lua" })

-- require("fzf-lua").setup({
--     grep = {
--         RG_OPTS = "--column --line-number --no-heading --color=always --smart-case --max-columns=4096 -e",
--         formatter = "path.filename_first",
--     },
-- })

require("fzf-lua").register_ui_select()

vim.keymap.set("n", "<leader>ff", ":FzfLua files<CR>", { desc = "Find Files", silent = true, noremap = true })
vim.keymap.set("n", "<leader>fg", ":FzfLua live_grep<CR>", { desc = "Grep", silent = true, noremap = true })
vim.keymap.set("n", "<leader>fb", ":FzfLua buffers<CR>", { desc = "Buffers", silent = true, noremap = true })

vim.keymap.set("n", "<leader>sq", ":FzfLua quickfix<CR>", { desc = "Quickfix List", silent = true, noremap = true })

vim.keymap.set("n", "<leader>sk", ":FzfLua keymaps<CR>", { desc = "Keymaps", silent = true, noremap = true })

-- LSP
vim.keymap.set("n", "gd", ":FzfLua lsp_definitions<CR>", { desc = "Goto Definition", silent = true, noremap = true })

vim.keymap.set("n", "gR", ":FzfLua lsp_references<CR>", { desc = "References", silent = true, noremap = true })

vim.keymap.set(
    "n",
    "gI",
    ":FzfLua lsp_implementations<CR>",
    { desc = "Goto Implementation", silent = true, noremap = true }
)

vim.keymap.set(
    "n",
    "gy",
    ":FzfLua lsp_typedefs<CR>",
    { desc = "Goto T[y]pe Definition", silent = true, noremap = true }
)

vim.keymap.set(
    "n",
    "<leader>ss",
    ":FzfLua lsp_workspace_symbols<CR>",
    { desc = "LSP Symbols", silent = true, noremap = true }
)

-- git
vim.keymap.set("n", "<leader>gs", ":FzfLua git_status<CR>", { desc = "Git Status", silent = true, noremap = true })

vim.keymap.set("n", "<leader>gg", function()
    Snacks.lazygit()
end, { desc = "Lazygit", silent = true, noremap = true })

vim.keymap.set("n", "<leader>gb", ":FzfLua git_blame<CR>", { desc = "Git Blame Line", silent = true, noremap = true })
