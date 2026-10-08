-- Color table for highlights
-- stylua: ignore
---@format disable-next
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

-- stylua: ignore
---@format disable-next
local mode_color = {
    n      = "green",
    i      = "blue",
    v      = "violet",
    V      = "violet",
    ["\22"] = "violet", -- CTRL-V
    c      = "magenta",
    s      = "orange",
    S      = "orange",
    ["\19"] = "orange", -- CTRL-S
    R      = "violet",
    r      = "cyan",
    ["!"]  = "red",
    t      = "red",
}

-- key: index in vim.diagnostic.count(), name: suffix of the Diagnostic* / StlDiagnostic* groups
-- stylua: ignore
---@format disable-next
local diagnostic_signs = {
    { key = vim.diagnostic.severity.ERROR, name = "Error", icon = "  " },
    { key = vim.diagnostic.severity.WARN,  name = "Warn",  icon = "  " },
    { key = vim.diagnostic.severity.INFO,  name = "Info",  icon = "  " },
    { key = vim.diagnostic.severity.HINT,  name = "Hint",  icon = "󰌶  " },
}

-- key: field of vim.b.gitsigns_status_dict, name: suffix of the StlDiff* groups
-- stylua: ignore
---@format disable-next
local diff_signs = {
    { key = "added",   name = "Added",   icon = "  " },
    { key = "changed", name = "Changed", icon = "󰝤  " },
    { key = "removed", name = "Removed", icon = "  " },
}

-- client.name -> icon, the other clients are shown by name
local lsp_icons = {
    tsc = "󰛦",
    cssls = "",
    tailwindcss = "󱏿",
    html = "",
    jsonls = "",
    lua_ls = "",
    prismals = "",
    intelephense = "",
}

-- stylua: ignore
---@format disable-next
local highlights = {
    StlRecording   = { fg = colors.green,   bold = true },
    StlFilename    = { fg = colors.magenta, bold = true },
    StlProgress    = { fg = colors.fg,      bold = true },
    StlEncoding    = { fg = colors.green,   bold = true },
    StlBranch      = { fg = colors.violet,  bold = true },
    StlDiffAdded   = { fg = colors.green },
    StlDiffChanged = { fg = colors.yellow },
    StlDiffRemoved = { fg = colors.red },
    StlClock       = { fg = colors.magenta, bold = true },
    StlLsp         = { fg = "#FFFFFF",      bold = true },
}

-- Every group gets the StatusLine background
local function set_highlights()
    local bg = vim.api.nvim_get_hl(0, { name = "StatusLine", link = false }).bg
    for name, color in pairs(colors) do
        vim.api.nvim_set_hl(0, "StlMode_" .. name, { fg = color, bg = bg })
    end
    for _, sign in ipairs(diagnostic_signs) do
        local fg = vim.api.nvim_get_hl(0, { name = "Diagnostic" .. sign.name, link = false }).fg
        vim.api.nvim_set_hl(0, "StlDiagnostic" .. sign.name, { fg = fg, bg = bg })
    end
    for name, hl in pairs(highlights) do
        vim.api.nvim_set_hl(0, name, vim.tbl_extend("force", hl, { bg = bg }))
    end
end
set_highlights()
vim.api.nvim_create_autocmd("ColorScheme", { callback = set_highlights })

-- Components, called from the statusline as v:lua.Stl.<name>()
local M = {}
_G.Stl = M

local function is_wide()
    return vim.fn.winwidth(0) > 80
end

-- "<icon>count <icon>count" for the non-zero counts, each colored with <hl_prefix><name>
local function counters(signs, counts, hl_prefix)
    local parts = {}
    for _, sign in ipairs(signs) do
        local count = counts[sign.key]
        if count and count > 0 then
            table.insert(parts, "%#" .. hl_prefix .. sign.name .. "#" .. sign.icon .. count)
        end
    end
    if #parts == 0 then
        return ""
    end
    return table.concat(parts, " ") .. "%*"
end

function M.mode_name()
    local mode_text = {
        n = "",
        i = "",
        v = "",
        V = "",
        c = "",
        t = "",
    }

    local mode = vim.fn.mode()
    local text = mode_text[mode] or (" (" .. mode .. ")")
    -- trailing space: Nerd Font icons overflow onto the next cell (lualine's padding.right)
    return "%#StlMode_" .. (mode_color[mode] or "fg") .. "#" .. text .. "%* "
end

-- reg_recording() is not cleared yet during RecordingLeave, so track it ourselves
local recording_register = ""

function M.recording()
    if recording_register == "" or vim.fn.expand("%:t") == "" then
        return ""
    end
    return "%#StlRecording# @" .. recording_register .. "%*"
end

vim.api.nvim_create_autocmd("RecordingEnter", {
    callback = function()
        recording_register = vim.fn.reg_recording()
        vim.cmd.redrawstatus()
    end,
})

vim.api.nvim_create_autocmd("RecordingLeave", {
    callback = function()
        recording_register = ""
        vim.cmd.redrawstatus()
    end,
})

-- %t: file name (tail), %m: [+] when modified, %r: [RO] when readonly
function M.filename()
    if vim.fn.expand("%:t") == "" then
        return ""
    end
    return " %#StlFilename#%t%( %m%r%)%*"
end

-- Based on the cursor line like lualine (%P would follow the visible window instead)
function M.progress()
    local line = vim.fn.line(".")
    local text = "%2p%%"
    if line == 1 then
        text = "Top"
    elseif line == vim.fn.line("$") then
        text = "Bot"
    end
    return "%#StlProgress#" .. text .. "%*"
end

-- Clients attached to the buffer that declare its filetype (skips generic ones like copilot)
function M.lsp()
    local names = {}
    for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
        -- set by vim.lsp.config()/enable(), but only declared on vim.lsp.Config
        local config = client.config --[[@as vim.lsp.Config]]
        if config.filetypes and vim.tbl_contains(config.filetypes, vim.bo.filetype) then
            local name = lsp_icons[client.name] or client.name
            if not vim.tbl_contains(names, name) then
                table.insert(names, name)
            end
        end
    end
    local text = #names > 0 and table.concat(names, "  ") or "No Active Lsp"
    return "%#StlLsp#" .. (text:gsub("%%", "%%%%")) .. "%*"
end

-- 'encoding' as fallback when the buffer has no 'fileencoding' yet (new file)
function M.encoding()
    if not is_wide() then
        return ""
    end
    local encoding = vim.bo.fileencoding ~= "" and vim.bo.fileencoding or vim.o.encoding
    return " %#StlEncoding#" .. encoding:upper() .. "%*"
end

-- Branch and diff come from the buffer variables set by gitsigns
function M.branch()
    local head = vim.b.gitsigns_head
    if not head or head == "" then
        return ""
    end
    return " %#StlBranch#  " .. (head:gsub("%%", "%%%%")) .. "%*"
end

function M.diff()
    local status = vim.b.gitsigns_status_dict
    if not status or not is_wide() then
        return ""
    end
    local diff = counters(diff_signs, status, "StlDiff")
    return diff ~= "" and " " .. diff or ""
end

function M.clock()
    return " %#StlClock#  " .. os.date("%H:%M") .. "%* "
end

-- Redraw every time the minute changes
local clock_timer = assert(vim.uv.new_timer())
local function schedule_clock()
    clock_timer:start(
        (60 - os.date("*t").sec) * 1000,
        0,
        vim.schedule_wrap(function()
            vim.cmd.redrawstatus({ bang = true })
            schedule_clock()
        end)
    )
end
schedule_clock()

vim.api.nvim_create_autocmd("ModeChanged", { command = "redrawstatus" })
vim.api.nvim_create_autocmd("User", { pattern = "GitSignsUpdate", command = "redrawstatus!" })

-- The client is still listed during LspDetach, so wait for it to be gone
vim.api.nvim_create_autocmd({ "LspAttach", "LspDetach" }, {
    callback = function()
        vim.schedule(function()
            vim.cmd.redrawstatus({ bang = true })
        end)
    end,
})

-- %{%...%} re-evaluates the result as a statusline string, so %#Group# works
local left = table.concat({
    "%{%v:lua.Stl.mode_name()%}",
    "%{%v:lua.Stl.recording()%}",
    "%{%v:lua.Stl.filename()%}",
    " %3l:%-2v", -- location, same format as lualine
    " %{%v:lua.Stl.progress()%}",
})

local right = table.concat({
    "%{%v:lua.Stl.encoding()%}",
    "%{%v:lua.Stl.branch()%}",
    "%{%v:lua.Stl.diff()%}",
    "%{%v:lua.Stl.clock()%}",
})

local function width(fmt)
    return vim.api.nvim_eval_statusline(fmt, {}).width
end

-- Diagnostics + LSP, centered in the window: the two %= around it share the free space
-- evenly, so pad the narrower side until left and right have the same width.
-- Diagnostics are redrawn on DiagnosticChanged by Neovim itself (shipped with vim.diagnostic.status)
function M.center()
    local diagnostics = counters(diagnostic_signs, vim.diagnostic.count(0), "StlDiagnostic")
    local center = (diagnostics ~= "" and diagnostics .. "  " or "") .. M.lsp()

    local left_width, right_width = width(left), width(right)
    local pad = right_width - left_width
    -- not enough room to center: keep it between the two sides
    if left_width + right_width + math.abs(pad) + width(center) > vim.fn.winwidth(0) then
        return center
    end
    if pad > 0 then
        return string.rep(" ", pad) .. center
    end
    return center .. string.rep(" ", -pad)
end

vim.o.statusline = left .. "%=%{%v:lua.Stl.center()%}%=" .. right
