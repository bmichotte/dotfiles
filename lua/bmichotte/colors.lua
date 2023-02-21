-- require('zephyr')

-- vim.cmd('colorscheme zephyr')

require("nightfox").setup({
	options = {
		modules = {
			nvimtree = true,
		},
		transparent = false,
		styles = { -- Choose from "bold,italic,underline"
			types = "NONE", -- Style that is applied to types
			numbers = "NONE", -- Style that is applied to numbers
			strings = "NONE", -- Style that is applied to strings
			comments = "italic", -- Style that is applied to comments
			keywords = "italic", -- Style that is applied to keywords
			constants = "bold", -- Style that is applied to constants
			functions = "NONE", -- Style that is applied to functions
			operators = "NONE", -- Style that is applied to operators
			variables = "NONE", -- Style that is applied to variables
			conditionals = "italic", -- Style that is applied to conditionals
			virtual_text = "NONE", -- Style that is applied to virtual text
		},
	},
})
--vim.cmd("colorscheme terafox")

require("rose-pine").setup({
	--- @usage 'main' | 'moon'
	dark_variant = "main",
})
--vim.cmd("colorscheme rose-pine")

vim.g.tokyodark_transparent_background = false
vim.g.tokyodark_enable_italic_comment = true
vim.g.tokyodark_enable_italic = true
vim.g.tokyodark_color_gamma = "1.0"
--vim.cmd("colorscheme tokyodark")

vim.g.everforest_background = "hard"
vim.g.everforest_enable_italic = true
vim.g.everforest_better_performance = true
vim.g.everforest_enable_italic = true
--vim.cmd("colorscheme everforest")

require("colorbuddy").colorscheme("cobalt2")

require("catppuccin").setup({
	flavour = "mocha",
})
--vim.cmd.colorscheme("catppuccin")
