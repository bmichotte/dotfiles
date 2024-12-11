---@type LazyPlugin[]
return {
    {
        "zbirenbaum/copilot.lua",
        event = { "InsertEnter" },
        opts = {
            suggestion = { enabled = false },
            panel = { enabled = false },
        },
    },
    {
        "yetone/avante.nvim",
        event = { "VeryLazy" },
        lazy = false,
        -- version = false,
        opts = {
            provider = "openai",
        },
        -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
        build = "make",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "stevearc/dressing.nvim",
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            "echasnovski/mini.icons",
            "zbirenbaum/copilot.lua",
            {
                -- support for image pasting
                "HakonHarnes/img-clip.nvim",
                event = "VeryLazy",
                opts = {
                    -- recommended settings
                    default = {
                        embed_image_as_base64 = false,
                        prompt_for_file_name = false,
                        drag_and_drop = {
                            insert_mode = true,
                        },
                        -- required for Windows users
                        use_absolute_path = true,
                    },
                },
            },
            {
                -- Make sure to set this up properly if you have lazy=true
                "MeanderingProgrammer/render-markdown.nvim",
                opts = {
                    file_types = { "markdown", "Avante" },
                },
                ft = { "markdown", "Avante" },
            },
        },
    },
    {
        "tzachar/cmp-ai",
        -- dir = "~/Developer/forks/cmp-ai",
        enabled = false,
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local cmp_ai = require("cmp_ai.config")

            cmp_ai:setup({
                max_lines = 1000,
                -- provider = "Codestral",
                -- provider = "OpenAI",
                provider = "Ollama",
                provider_options = {
                    -- model = "codeqwen",
                    -- model = "gpt-4o-mini",
                    -- model = "codestral-latest",
                },
                notify = false,
                -- notify_callback = function(msg)
                --     vim.notify(msg)
                -- end,
                run_on_every_keystroke = true,
                ignored_file_types = {
                    -- default is not to ignore
                    -- uncomment to ignore in lua:
                    -- lua = true
                },
            })
        end,
    },
    {
        "David-Kunz/gen.nvim",
        enabled = false,
        opts = {
            model = "codeqwen",
            debug = true,
        },
    },
    {
        "zbirenbaum/copilot-cmp",
        dependencies = { "copilot.lua" },
        config = true,
    },
    {
        "nomnivore/ollama.nvim",
        enabled = false,
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        lazy = true,
        cmd = { "Ollama", "OllamaModel", "OllamaServe", "OllamaServeStop" },
        keys = {
            {
                "<leader>oo",
                ":<c-u>lua require('ollama').prompt()<cr>",
                desc = "ollama prompt",
                mode = { "n", "v" },
            },
            {
                "<leader>oG",
                ":<c-u>lua require('ollama').prompt('Generate_Code')<cr>",
                desc = "ollama Generate Code",
                mode = { "n", "v" },
            },
        },
        ---@type Ollama.Config
        opts = {
            model = "codeqwen",
        },
    },
    {
        "jackMort/ChatGPT.nvim",
        event = { "VeryLazy" },
        dependencies = {
            "MunifTanjim/nui.nvim",
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
        },
        opts = {
            -- api_key_cmd = "op read op://Personal/msrznwludsumyoz7v7y5xhurom/identifiant --no-newline",
            openai_params = {
                model = "gpt-4o-mini",
                frequency_penalty = 0,
                presence_penalty = 0,
                max_tokens = 300,
                temperature = 0.2,
                top_p = 1,
                n = 1,
            },
            openai_edit_params = {
                model = "gpt-4o-mini",
                frequency_penalty = 0,
                presence_penalty = 0,
                temperature = 0.2,
                top_p = 1,
                n = 1,
            },
        },
        keys = {
            {
                "<leader>cc",
                function()
                    local chatgpt = require("chatgpt")
                    chatgpt.edit_with_instructions()
                end,
                mode = "v",
                desc = "Edit current selection with ChatGPT",
            },
        },
    },
    {
        "CopilotC-Nvim/CopilotChat.nvim",
        build = "make tiktoken",
        dependencies = {
            "zbirenbaum/copilot.lua",
            "nvim-lua/plenary.nvim",
        },
        opts = {
            debug = false,
        },
    },
}
