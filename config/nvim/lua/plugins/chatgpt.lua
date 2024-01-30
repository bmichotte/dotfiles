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
        openai_params = {
            model = "gpt-4-1106-preview",
            frequency_penalty = 0,
            presence_penalty = 0,
            max_tokens = 300,
            temperature = 0,
            top_p = 1,
            n = 1,
        },
        openai_edit_params = {
            model = "gpt-4-1106-preview",
            frequency_penalty = 0,
            presence_penalty = 0,
            temperature = 0,
            top_p = 1,
            n = 1,
        },
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
