return {
    "jackMort/ChatGPT.nvim",
    event = "VeryLazy",
    dependencies = {
        "MunifTanjim/nui.nvim",
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
    },
    opts = {
        -- api_key_cmd = "op read op://Personal/msrznwludsumyoz7v7y5xhurom/identifiant --no-newline",
    },
    keys = {
        {
            "<leader>cc",
            function()
                local chatgpt = require('chatgpt')
                chatgpt.edit_with_instructions()
            end,
            mode = "v",
            desc = "Edit current selection with ChatGPT"
        }
    }
}
