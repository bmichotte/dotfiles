local kind_icons = {
    Text = "󰉿",
    Method = "󰆧",
    Function = "󰊕",
    Constructor = "",

    Field = "󰜢",
    Variable = "󰀫",
    Property = "󰜢",

    Class = "",
    Interface = "",
    Struct = "",
    Module = "",

    Unit = "󰑭",
    Value = "󰎠",
    Enum = "",
    EnumMember = "",

    Keyword = "",
    Constant = "󰏿",

    Snippet = "",
    Color = "",
    File = "󰈙",
    Reference = "󰈇",
    Folder = "󰉋",
    Event = "",
    Operator = "",
    TypeParameter = "",

    Copilot = "",
    HF = "",
    OpenAI = "",
    Codestral = "",
    Bard = "",

    -- LLM Provider icons
    claude = "󰋦",
    openai = "󱢆",
    codestral = "󱎥",
    gemini = "",
    Groq = "",
    Openrouter = "󱂇",
    Ollama = "󰳆",
    ["Llama.cpp"] = "󰳆",
    Deepseek = "",
}

vim.pack.add({
    {
        src = "https://github.com/saghen/blink.cmp",
        version = vim.version.range("^1"),
    },
})

---@module 'blink.cmp'
---@type blink.cmp.Config
require("blink.cmp").setup({
    keymap = {
        preset = "enter",
    },

    appearance = {
        kind_icons = kind_icons,
    },

    completion = {
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 250,
            treesitter_highlighting = true,
            window = {
                winhighlight =
                "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
            },
        },
        menu = {
            auto_show = false,
            border = "rounded",

            cmdline_position = function()
                if vim.g.ui_cmdline_pos ~= nil then
                    local pos = vim.g.ui_cmdline_pos -- (1, 0)-indexed
                    return { pos[1] - 1, pos[2] }
                end
                local height = (vim.o.cmdheight == 0) and 1 or vim.o.cmdheight
                return { vim.o.lines - height, 0 }
            end,

            draw = {
                columns = {
                    { "kind_icon", "label", "label_description", gap = 1 },
                    { "kind" },
                },
                components = {
                    kind_icon = {
                        text = function(ctx)
                            local icon = ctx.kind_icon
                            if vim.tbl_contains({ "Path" }, ctx.source_name) then
                                local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                                if dev_icon then
                                    icon = dev_icon
                                end
                            else
                                icon = kind_icons[ctx.kind] or ""
                            end

                            return icon .. ctx.icon_gap
                        end,

                        highlight = function(ctx)
                            local hl = ctx.kind_hl
                            if vim.tbl_contains({ "Path" }, ctx.source_name) then
                                local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
                                if dev_icon then
                                    hl = dev_hl
                                end
                            end
                            return hl
                        end,
                    },
                    label = {
                        text = function(item)
                            return item.label
                        end,
                        highlight = "CmpItemAbbr",
                    },
                    kind = {
                        text = function(item)
                            return item.kind
                        end,
                        highlight = "CmpItemKind",
                    },
                    source_name = {
                        text = function(ctx)
                            if ctx.source_id == "cmdline" then
                                return
                            end
                            return ctx.source_name:sub(1, 4)
                        end,
                    },
                },
            },
        },
    },
    signature = { enabled = true },
    sources = {
        default = {
            "lsp",
            "snippets",
            "buffer",
            "path",
        },
    },

    -- FIXME: revert to rust
    fuzzy = { implementation = "lua" },
    snippets = { preset = "default" },
})
-- opts_extend = { "sources.default" },
