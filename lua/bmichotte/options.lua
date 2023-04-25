local opt = vim.opt

-- make sure we use sh as shell
opt.shell = "/bin/sh"

-- force term colors
opt.termguicolors = true

-- line numbers
opt.relativenumber = true -- relative number in gutter
opt.nu = true             -- Indent current line number
opt.tabstop = 4           -- Tabs are 4 spaces: Reference - https://stackoverflow.com/questions/1878974/redefine-tab-as-4-spaces
opt.softtabstop = 0
opt.shiftwidth = 4
opt.expandtab = true
opt.smartindent = true
opt.cursorline = true

-- line wrapping
opt.wrap = false -- don't wrap long lines

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true  -- Unless we explicitly use cases in search
--opt.hlsearch = false  -- Don't highlight search
opt.incsearch = true  -- jump incrementally to search results

-- appearance
opt.background = "dark"
opt.signcolumn = "yes" -- always set the far left bar/column

-- backspace
opt.backspace = "indent,eol,start"

-- clipboard
opt.clipboard:append("unnamedplus")

-- split windows
opt.splitbelow = true     -- automagically h split going down
opt.splitright = true     -- automagically v split going right

opt.iskeyword:append("-") -- allow to delete word with dash
opt.mouse = "a"           -- always enable mouse mode

--[[
opt.exrc = true  -- exec a local vimrc (like direnv)
opt.hidden = true -- allow hidden buffers
opt.errorbells = false -- ding ding!
opt.swapfile = false -- don't need no swap files!
opt.backup = false  -- ... or a backup!
opt.undodir = "~/.nvim/undodir"  -- sets where undo files land
opt.scrolloff = 8  -- scroll offwidth so it's not the very bottom
--opt.colorcolumn = "80"  -- bar at 80 chars width
-- opt.nocompatible = true

opt.listchars = {  -- see hidden chars and their colors
    tab = "| ",
    -- eol = '¬',
    -- trail = '·'
}
opt.list = true
opt.updatetime = 100
]]
