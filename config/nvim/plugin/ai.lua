--[[    {
        "zbirenbaum/copilot.lua",
        enabled = false,
        event = { "InsertEnter" },
        opts = {
            suggestion = { enabled = false },
            panel = { enabled = false },
            -- copilot_model = "gpt-4o-copilot", -- default gpt-35-turbo
        },
    }]]

--[[
    {
        "yetone/avante.nvim",
        enabled = false,
        -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
        build = "make",
        event = { "VeryLazy" },
        -- lazy = false,
        version = false,
        ---@module 'avante'
        ---@type avante.Config
        opts = {
            provider = "claude",

            providers = {
                claude = {
                    auth_type = "max",
                },
            },
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            --- The below dependencies are optional,
            "nvim-mini/mini.pick", -- for file_selector provider mini.pick
            "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
            "hrsh7th/nvim-cmp", -- autocompletion for avante commands and mentions
            "ibhagwan/fzf-lua", -- for file_selector provider fzf
            -- "stevearc/dressing.nvim", -- for input provider dressing
            "folke/snacks.nvim", -- for input provider snacks
            "nvim-tree/nvim-web-devicons", -- or echasnovski/mini.icons
            "zbirenbaum/copilot.lua", -- for providers='copilot'
            ---@diagnostic disable-next-line: assign-type-mismatch
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
            ---@diagnostic disable-next-line: assign-type-mismatch
            {
                -- Make sure to set this up properly if you have lazy=true
                "MeanderingProgrammer/render-markdown.nvim",
                opts = {
                    file_types = { "markdown", "Avante" },
                },
                ft = { "markdown", "Avante" },
            },
        },
    }]]

--[[{
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
        enabled = false,
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
    }]]

--[[{
        "CopilotC-Nvim/CopilotChat.nvim",
        enabled = false,
        build = "make tiktoken",
        dependencies = {
            "zbirenbaum/copilot.lua",
            "nvim-lua/plenary.nvim",
        },
        opts = {
            debug = false,
        },
    }]]

--[[{
        "olimorris/codecompanion.nvim",
        -- enabled = false,
        opts = {
            strategies = {
                chat = {
                    adapter = "ollama",
                },
                inline = {
                    adapter = "ollama",
                },
                cmd = {
                    adapter = "ollama",
                },
            },
            adapters = {
                http = {
                    ollama = function()
                        return require("codecompanion.adapters").extend("openai_compatible", {
                            env = {
                                url = "http://localhost:1234",
                                api_key = "lmstudio",
                                chat_url = "/v1/chat/completions",
                            },
                        })
                    end,
                },
            },
            opts = {
                language = "Francais",
            },
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
        },
    }]]

vim.pack.add({
    "https://github.com/coder/claudecode.nvim",
    -- dependencies
    "https://github.com/folke/snacks.nvim",
})
require("claudecode").setup({
    terminal_cmd = "/Users/benjamin/.local/bin/claude",
})

-- vim.keymap.set("n", "<leader>a",  nil,                              {desc = "AI/Claude Code", silent=true, noremap=true })
vim.keymap.set("n", "<leader>ac", ":ClaudeCode<cr>", { desc = "Toggle Claude", silent = true, noremap = true })
vim.keymap.set("n", "<leader>af", ":ClaudeCodeFocus<cr>", { desc = "Focus Claude", silent = true, noremap = true })
vim.keymap.set("n", "<leader>ar", ":ClaudeCode --resume<cr>", { desc = "Resume Claude", silent = true, noremap = true })
vim.keymap.set(
    "n",
    "<leader>aC",
    ":ClaudeCode --continue<cr>",
    { desc = "Continue Claude", silent = true, noremap = true }
)
vim.keymap.set(
    "n",
    "<leader>am",
    ":ClaudeCodeSelectModel<cr>",
    { desc = "Select Claude model", silent = true, noremap = true }
)
vim.keymap.set(
    "n",
    "<leader>ab",
    ":ClaudeCodeAdd %<cr>",
    { desc = "Add current buffer", silent = true, noremap = true }
)
vim.keymap.set("v", "<leader>as", ":ClaudeCodeSend<cr>", { desc = "Send to Claude", silent = true, noremap = true })
vim.keymap.set("n", "<leader>as", ":ClaudeCodeTreeAdd<cr>", { desc = "Add file", silent = true, noremap = true })

-- Diff management
vim.keymap.set("n", "<leader>aa", ":ClaudeCodeDiffAccept<cr>", { desc = "Accept diff", silent = true, noremap = true })
vim.keymap.set("n", "<leader>ad", ":ClaudeCodeDiffDeny<cr>", { desc = "Deny diff", silent = true, noremap = true })
