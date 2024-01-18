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

return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { { "nvim-lua/plenary.nvim" } },
    keys = {
        { "<leader>ha", function() require("harpoon"):list():append() end,                                 desc = "Add file to Harpoon" },
        { "<leader>he", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, desc = "Toggle Harpoon quick menu" },
        { "<leader>hp", function() require("harpoon"):list():prev() end,                                   desc = "Previous Harpoon file" },
        { "<leader>hn", function() require("harpoon"):list():next() end,                                   desc = "Next Harpoon file" },
        { "<leader>fh", function() toggle_telescope(require("harpoon"):list()) end,                        desc = "Open harpoon window" },
    },
}
