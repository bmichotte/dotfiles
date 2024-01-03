local actions = require("telescope.actions")
local telescope_builtin = require("telescope.builtin")
local telescope = require("telescope")

telescope.setup({
    defaults = {
        mappings = {
            i = {
                ["<C-k>"] = actions.move_selection_previous,                       -- move to prev result
                ["<C-j>"] = actions.move_selection_next,                           -- move to next result
                ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist, -- send selected to quickfixlist
            },
            n = {
                ["d"] = "delete_buffer",
            },
        },
    },
})

telescope.load_extension("fzf")
telescope.load_extension("package_info")

local harpoon = require("harpoon")

harpoon:setup()

vim.keymap.set("n", "<leader>ha", function() harpoon:list():append() end)
--vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

vim.keymap.set("n", "<leader>hp", function() harpoon:list():prev() end)
vim.keymap.set("n", "<leader>hn", function() harpoon:list():next() end)

local conf = require("telescope.config").values
local function toggle_telescope(harpoon_files)
    local file_paths = {}
    for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
    end

    require("telescope.pickers").new({}, {
        prompt_title = "Harpoon",
        finder = require("telescope.finders").new_table({
            results = file_paths,
        }),
        previewer = conf.file_previewer({}),
        sorter = conf.generic_sorter({}),
    }):find()
end

local options = { noremap = true }
vim.keymap.set("n", "<leader>fh", function() toggle_telescope(harpoon:list()) end,
    { desc = "Open harpoon window", noremap = true })
vim.keymap.set("n", "<leader>ff", telescope_builtin.find_files, options)
vim.keymap.set("n", "<leader>fg", telescope_builtin.live_grep, options)
vim.keymap.set("n", "<leader>fc", telescope_builtin.grep_string, options)
vim.keymap.set("n", "<leader>fb", telescope_builtin.buffers, options)
--vim.keymap.set("n", "<leader>fh", telescope_builtin.help_tags, options)
