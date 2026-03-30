vim.pack.add({ "https://github.com/vuki656/package-info.nvim" })

-- see https://github.com/vuki656/package-info.nvim/pull/143
require("package-info").setup({
    autostart = false,
    package_manager = "pnpm",
})

vim.api.nvim_create_autocmd("FileType", {
    pattern = "json",
    callback = function()
        -- wait 0.5 second
        if vim.fn.expand("%:t") == "package.json" then
            vim.defer_fn(function()
                require("package-info").show()
            end, 500)
        end
    end,
})

local package_api = require("package-info")
vim.keymap.set(
    "n",
    "<leader>ns",
    package_api.show,
    { desc = "Show dependency versions", silent = true, noremap = true }
)
vim.keymap.set(
    "n",
    "<leader>nc",
    package_api.hide,
    { desc = "Hide dependency versions", silent = true, noremap = true }
)
vim.keymap.set(
    "n",
    "<leader>nt",
    package_api.toggle,
    { desc = "Toggle dependency versions", silent = true, noremap = true }
)
vim.keymap.set(
    "n",
    "<leader>nu",
    package_api.update,
    { desc = "Update dependency on the line", silent = true, noremap = true }
)
vim.keymap.set(
    "n",
    "<leader>nd",
    package_api.delete,
    { desc = "Delete dependency on the line", silent = true, noremap = true }
)
vim.keymap.set(
    "n",
    "<leader>ni",
    package_api.install,
    { desc = "Install a new dependency", silent = true, noremap = true }
)
vim.keymap.set(
    "n",
    "<leader>np",
    package_api.change_version,
    { desc = "Install a different dependency version", silent = true, noremap = true }
)
