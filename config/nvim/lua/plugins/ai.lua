---@type LazyPlugin[]
return {
    {
        "zbirenbaum/copilot.lua",
        event = { "VimEnter" },
        opts = {
            suggestion = { enabled = false },
            panel = { enabled = false },
        },
    },
    {
        "tzachar/cmp-ai",
        dependencies = "nvim-lua/plenary.nvim",
        config = function()
            local cmp_ai = require("cmp_ai.config")

            cmp_ai:setup({
                max_lines = 100,
                provider = "Ollama",
                provider_options = {
                    model = "codellama:7b-code",
                },
                notify = true,
                notify_callback = function(msg)
                    vim.notify(msg)
                end,
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
        opts = {
            model = "mixtral", -- The default model to use.
            -- host = "localhost", -- The host running the Ollama service.
            -- port = "11434", -- The port on which the Ollama service is listening.
            -- display_mode = "float", -- The display mode. Can be "float" or "split".
            -- show_prompt = false, -- Shows the Prompt submitted to Ollama.
            -- show_model = false, -- Displays which model you are using at the beginning of your chat session.
            -- quit_map = "q", -- set keymap for quit
            -- no_auto_close = false, -- Never closes the window automatically.
            -- init = function(options)
            --     pcall(io.popen, "ollama serve > /dev/null 2>&1 &")
            -- end,
            -- Function to initialize Ollama
            -- command = function(options)
            --     return "curl --silent --no-buffer -X POST http://"
            --         .. options.host
            --         .. ":"
            --         .. options.port
            --         .. "/api/chat -d $body"
            -- end,
            -- The command for the Ollama service. You can use placeholders $prompt, $model and $body (shellescaped).
            -- This can also be a command string.
            -- The executed command must return a JSON object with { response, context }
            -- (context property is optional).
            -- list_models = '<omitted lua function>', -- Retrieves a list of model names
            debug = true, -- Prints errors and the command which is run.
        },
    },
    {
        "zbirenbaum/copilot-cmp",
        dependencies = { "copilot.lua" },
        config = true,
    },
    {
        "nomnivore/ollama.nvim",
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
            model = "codellama",
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
                    local chatgpt = require("chatgpt")
                    chatgpt.edit_with_instructions()
                end,
                mode = "v",
                desc = "Edit current selection with ChatGPT",
            },
        },
    },
}
