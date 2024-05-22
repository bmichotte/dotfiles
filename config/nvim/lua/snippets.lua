local global_snippets = {
    { trigger = "shebang", body = "#!/bin sh" },
}

-- setter = l(l._1:sub(1, 1):upper() .. l._1:sub(2, -1), 1)

local snippets_by_filetype = {
    lua = {
        { trigger = "fun", body = "function ${1:name}(${2:args})\n\t$0\nend", desc = "Create a new function" },
    },
    typescriptreact = {
        -- { trigger = "rus", body = "const [${1}, set${1/(.)/${1:/capitalize}/}] = useState<$3>($0)", desc = "Create a new useState()" },
        { trigger = "rus", body = "const [${1}, set${1}] = useState<$3>($0)", desc = "Create a new useState()" },
    },
}

-- helpers and registration
local function get_buf_snips()
    local ft = vim.bo.filetype
    local snips = vim.list_slice(global_snippets)

    if ft and snippets_by_filetype[ft] then
        vim.list_extend(snips, snippets_by_filetype[ft])
    end

    return snips
end

local function get_snippet()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    local cur_line = vim.api.nvim_buf_get_lines(0, line - 1, line, true)
    local line_pre_cursor = cur_line[1]:sub(1, col)

    for _, s in ipairs(get_buf_snips()) do
        if vim.endswith(line_pre_cursor, s.trigger) then
            return s.trigger, s.body, line, col
        end
    end

    return nil
end

local function expand_under_cursor()
    local trigger, body, line, col = get_snippet()
    if not trigger or not line or not col then
        return false
    end
    -- remove trigger
    vim.api.nvim_buf_set_text(0, line - 1, col - #trigger, line - 1, col, {})
    vim.api.nvim_win_set_cursor(0, { line, col - #trigger })

    vim.snippet.expand(body)
    return true
end

local M = {}

function M.register_cmp_source()
    local cmp_source = {}
    cmp_source.new = function()
        local self = setmetatable({ cache = {} }, { __index = cmp_source })
        return self
    end
    cmp_source.complete = function(self, _, callback)
        local bufnr = vim.api.nvim_get_current_buf()
        if not self.cache[bufnr] then
            local completion_items = vim.tbl_map(function(s)
                local cmp = require("cmp")
                local desc = ""
                if s.desc and s.desc ~= "" then
                    desc = "\n**" .. s.desc .. "**\n"
                end

                return {
                    word = s.trigger,
                    label = s.trigger,
                    kind = cmp.lsp.CompletionItemKind.Snippet,
                    documentation = {
                        kind = "markdown",
                        value = desc .. "```" .. vim.bo.filetype .. "\n" .. s.body .. "\n```",
                    },
                }
            end, get_buf_snips())

            self.cache[bufnr] = completion_items
            callback(completion_items)
        end

        callback(self.cache[bufnr])
    end

    function cmp_source:execute(completion_item, callback)
        expand_under_cursor()
        callback(completion_item)
    end

    require("cmp").register_source("snp", cmp_source.new())
end

return M
