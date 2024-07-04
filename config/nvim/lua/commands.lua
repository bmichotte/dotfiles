vim.api.nvim_create_user_command("W", ":w", { desc = "I can't type :w without typing :W !" })
vim.api.nvim_create_user_command("Wa", ":wa", { desc = "I can't type :wa without typing :Wa !" })
vim.api.nvim_create_user_command("Wq", ":wq", { desc = "I can't type :wq without typing :Wq !" })
vim.api.nvim_create_user_command("Wqa", ":wqa", { desc = "I can't type :wqa without typing :Waq !" })
vim.api.nvim_create_user_command("Q", ":q", { desc = "I can't type :q without typing :Q !" })
vim.api.nvim_create_user_command("Wall", ":wall", { desc = "I can't type :wall without typing :Wall !" })

-- local augroup = vim.api.nvim_create_augroup -- Create/get autocommand group
local autocmd = vim.api.nvim_create_autocmd -- Create autocommand
autocmd("CmdlineEnter", {
    command = "command! Term :botright vsplit term://$SHELL",
})
--
-- Enter insert mode when switching to terminal
autocmd("TermOpen", {
    command = "setlocal listchars= nonumber norelativenumber nocursorline",
})

autocmd("TermOpen", {
    pattern = "",
    command = "startinsert",
})

-- Close terminal buffer on process exit
autocmd("BufLeave", {
    pattern = "term://*",
    command = "stopinsert",
})

vim.keymap.set(
    "n",
    "<Leader>fj",
    '<Cmd>%!jq --indent 4 \'def sort_keys: . as $in | if type == "object" then $in | to_entries | sort_by(.key | ascii_downcase) | from_entries | map_values(sort_keys) elif type == "array" then map(sort_keys) else . end; sort_keys\'<CR>',
    { noremap = true, silent = true }
)
