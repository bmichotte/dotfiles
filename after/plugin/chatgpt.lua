local chatgpt = require("chatgpt")
chatgpt.setup({
    --    api_key_cmd = "op read op://Personal/msrznwludsumyoz7v7y5xhurom/identifiant --no-newline",
})

local options = { noremap = true }
local keymap = vim.keymap

keymap.set("v", "<leader>cc", chatgpt.edit_with_instructions, options)
