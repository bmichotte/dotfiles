---@type LazyPlugin
return {
    "nvim-lualine/lualine.nvim",
    commit = "640260d7c2d98779cab89b1e7088ab14ea354a02",
    --enabled = false,
    config = function()
        local lualine = require("lualine")

        -- Color table for highlights
        -- stylua: ignore
        local colors = {
            bg       = '#181926',
            fg       = '#949CBB',
            yellow   = '#E5C890',
            cyan     = '#8BD5CA',
            darkblue = '#1E2030',
            green    = '#A6D189',
            orange   = '#FE640B',
            violet   = '#CBA6F7',
            magenta  = '#F4B8E4',
            blue     = '#8CAAEE',
            red      = '#D20F39',
        }

        local conditions = {
            buffer_not_empty = function()
                return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
            end,
            hide_in_width = function()
                return vim.fn.winwidth(0) > 80
            end,
            check_git_workspace = function()
                local filepath = vim.fn.expand("%:p:h")
                local gitdir = vim.fn.finddir(".git", filepath .. ";")
                return gitdir and #gitdir > 0 and #gitdir < #filepath
            end,
            ollama_is_running = function()
                return package.loaded["ollama"] and require("ollama").status() ~= nil
            end,
            in_tmux_session = function()
                return vim.fn.system("echo $TMUX") ~= ""
            end,
        }

        -- Config
        local config = {
            options = {
                -- Disable sections and component separators
                component_separators = "",
                section_separators = "",
                theme = {
                    -- We are going to use lualine_c an lualine_x as left and
                    -- right section. Both are highlighted by c theme .  So we
                    -- are just setting default looks o statusline
                    normal = { c = { fg = colors.fg, bg = colors.bg } },
                    inactive = { c = { fg = colors.fg, bg = colors.bg } },
                },
            },
            sections = {
                -- these are to remove the defaults
                lualine_a = {},
                lualine_b = {},
                lualine_y = {},
                lualine_z = {},
                -- These will be filled later
                lualine_c = {},
                lualine_x = {},
            },
            inactive_sections = {
                -- these are to remove the defaults
                lualine_a = {},
                lualine_b = {},
                lualine_y = {},
                lualine_z = {},
                lualine_c = {},
                lualine_x = {},
            },
        }

        -- Inserts a component in lualine_c at left section
        local function ins_left(component)
            table.insert(config.sections.lualine_c, component)
        end

        -- Inserts a component in lualine_x at right section
        local function ins_right(component)
            table.insert(config.sections.lualine_x, component)
        end

        ins_left({
            -- mode component
            function()
                local get_mode = require("lualine.utils.mode").get_mode
                local mode_text = {
                    n = "",
                    i = "",
                    v = "",
                    V = "",
                    c = "",
                }

                return mode_text[vim.fn.mode()] or get_mode() .. " (" .. vim.fn.mode() .. ")"
            end,
            color = function()
                -- auto change color according to neovims mode
                local mode_color = {
                    n = colors.green,
                    i = colors.blue,
                    v = colors.violet,
                    -- [''] = colors.violet,
                    V = colors.violet,
                    c = colors.magenta,
                    no = colors.red,
                    s = colors.orange,
                    S = colors.orange,
                    [""] = colors.orange,
                    ic = colors.yellow,
                    R = colors.violet,
                    Rv = colors.violet,
                    cv = colors.red,
                    ce = colors.red,
                    r = colors.cyan,
                    rm = colors.cyan,
                    ["r?"] = colors.cyan,
                    ["!"] = colors.red,
                    t = colors.red,
                }
                return { fg = mode_color[vim.fn.mode()] }
            end,
            padding = { right = 1 },
        })

        vim.api.nvim_create_autocmd("RecordingEnter", {
            callback = function()
                lualine.refresh({
                    place = { "statusline" },
                })
            end,
        })

        vim.api.nvim_create_autocmd("RecordingLeave", {
            callback = function()
                -- This is going to seem really weird!
                -- Instead of just calling refresh we need to wait a moment because of the nature of
                -- `vim.fn.reg_recording`. If we tell lualine to refresh right now it actually will
                -- still show a recording occuring because `vim.fn.reg_recording` hasn't emptied yet.
                -- So what we need to do is wait a tiny amount of time (in this instance 50 ms) to
                -- ensure `vim.fn.reg_recording` is purged before asking lualine to refresh.
                local timer = vim.loop.new_timer()
                timer:start(
                    50,
                    0,
                    vim.schedule_wrap(function()
                        lualine.refresh({
                            place = { "statusline" },
                        })
                    end)
                )
            end,
        })

        ins_left({
            function()
                local recording_register = vim.fn.reg_recording()
                if recording_register == "" then
                    return ""
                end

                return " @" .. recording_register
            end,
            cond = conditions.buffer_not_empty,
            color = { fg = colors.green, gui = "bold" },
        })

        ins_left({
            function()
                local status = require("ollama").status()

                if status == "IDLE" then
                    return ""
                elseif status == "WORKING" then
                    return "󱚟"
                end
            end,
            cond = conditions.ollama_is_running,
            color = { fg = colors.yellow, gui = "bold" },
        })

        ins_left({
            -- filesize component
            "filesize",
            cond = conditions.buffer_not_empty,
        })

        ins_left({
            "filename",
            cond = conditions.buffer_not_empty,
            color = { fg = colors.magenta, gui = "bold" },
        })

        ins_left({ "location" })

        ins_left({ "progress", color = { fg = colors.fg, gui = "bold" } })

        ins_left({
            function()
                local str = vim.fn.system("tmux display-message -p '#S ###I'")
                if str == nil then
                    return ""
                end
                return vim.re.gsub(str, "[\r\n]", "")
            end,
            cond = conditions.in_tmux_session,
            color = { fg = colors.blue, gui = "bold" },
        })

        ins_left({
            function()
                local package_info = require("package-info")

                return package_info.get_status()
            end,
            cond = conditions.buffer_not_empty,
        })

        ins_left({
            "diagnostics",
            sources = { "nvim_diagnostic" },
            symbols = { error = "  ", warn = "  ", info = "  " },
            diagnostics_color = {
                color_error = { fg = colors.red },
                color_warn = { fg = colors.yellow },
                color_info = { fg = colors.cyan },
            },
        })

        -- Insert mid section. You can make any number of sections in neovim :)
        -- for lualine it's any number greater then 2
        ins_left({
            function()
                return "%="
            end,
        })

        ins_left({
            -- Lsp server name .
            function()
                local msg = "No Active Lsp"
                local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
                local clients = vim.lsp.get_clients()
                if next(clients) == nil then
                    return msg
                end

                local langs = {
                    ["ts_ls"] = "󰛦",
                    ["cssls"] = "",
                    ["tailwindcss"] = "󱏿",
                    ["html"] = "",
                    ["jsonls"] = "",
                    ["lua_ls"] = "",
                    ["prismals"] = "",
                    ["intelephense"] = "",
                }

                local client_names = {}
                for _, client in ipairs(clients) do
                    local filetypes = client.config.filetypes
                    if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
                        local name = langs[client.name] or client.name
                        if vim.fn.index(client_names, name) == -1 then
                            table.insert(client_names, name)
                        end
                    end
                end
                if next(client_names) == nil then
                    return msg
                end
                return table.concat(client_names, " ")
            end,
            -- icon = '  ',
            color = { fg = "#ffffff", gui = "bold" },
        })

        -- Add components to right sections
        ins_right({
            "o:encoding",       -- option component same as &encoding in viml
            fmt = string.upper, -- I'm not sure why it's upper case either ;)
            cond = conditions.hide_in_width,
            color = { fg = colors.green, gui = "bold" },
        })

        ins_right({
            "fileformat",
            fmt = string.upper,
            icons_enabled = false, -- I think icons are cool but Eviline doesn't have them. sigh
            color = { fg = colors.green, gui = "bold" },
        })

        ins_right({
            "branch",
            icon = "",
            color = { fg = colors.violet, gui = "bold" },
        })

        ins_right({
            "diff",
            -- Is it me or the symbol for modified us really weird
            symbols = { added = " ", modified = "󰝤 ", removed = " " },
            diff_color = {
                added = { fg = colors.green },
                modified = { fg = colors.yellow },
                removed = { fg = colors.red },
            },
            cond = conditions.hide_in_width,
        })

        ins_right({
            function()
                return " " .. os.date("%H:%M", os.time())
            end,
            color = { fg = colors.magenta, gui = "bold" },
        })

        -- ins_right ({
        --     function()
        --         return '▊'
        --     end,
        --     color = { fg = colors.blue },
        --     padding = { left = 1 },
        -- })

        lualine.setup(config)
    end,
}
