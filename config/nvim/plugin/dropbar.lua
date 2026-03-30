vim.pack.add({
    "https://github.com/Bekaboo/dropbar.nvim",
    -- optional, but required for fuzzy finder support
    -- dependencies
    "https://github.com/nvim-telescope/telescope-fzf-native.nvim",
    -- build = "make",
})

local dropbar_api = require("dropbar.api")
vim.keymap.set("n", "<leader>;", dropbar_api.pick, { desc = "Pick symbols in winbar", silent = true, noremap = true })
vim.keymap.set(
    "n",
    "[;",
    dropbar_api.goto_context_start,
    { desc = "Go to start of current context", silent = true, noremap = true }
)
vim.keymap.set(
    "n",
    "];",
    dropbar_api.select_next_context,
    { desc = "Select next context", silent = true, noremap = true }
)
