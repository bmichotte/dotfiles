return {
    "jackMort/ChatGPT.nvim",
    event = "VeryLazy",
    dependencies = {
        "MunifTanjim/nui.nvim",
        "nvim-lua/plenary.nvim",
        "nvim-telescope/telescope.nvim",
    },
    config = function()
        local chatgpt = require("chatgpt")
        chatgpt.setup({
            --    api_key_cmd = "op read op://Personal/msrznwludsumyoz7v7y5xhurom/identifiant --no-newline",
        })

        vim.keymap.set("v", "<leader>cc", chatgpt.edit_with_instructions, {
            noremap = true,
            desc =
            "Edit current selection with ChatGPT"
        })
    end
}
