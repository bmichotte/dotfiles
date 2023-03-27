local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

--[[vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins-setup.lua source <afile> | PackerSync
  augroup end
  ] ])
]]

local plugins = {
	-- tree-sitter, syntax highligthing
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
	},
	{ 
        "windwp/nvim-ts-autotag", 
        dependencies = { "nvim-treesitter" }
    }, -- autoclose tags
	--"nvim-treesitter/playground",

	-- auto closing
	"windwp/nvim-autopairs", -- autoclose parens, brackets, quotes, etc...

	-- color scheme
	-- "EdenEast/nightfox.nvim",
	-- "tiagovla/tokyodark.nvim",
	-- { "rose-pine/neovim", name = "rose-pine", },
	-- "sainnhe/everforest",
    { "lalitmee/cobalt2.nvim", dependencies = { "tjdevries/colorbuddy.nvim" } },
	-- { "catppuccin/nvim", name = "catppuccin" },

	-- telescope, file search/open
	{
		"nvim-telescope/telescope.nvim",
		dependencies = { { "nvim-lua/plenary.nvim" } },
	},

	-- Use fzf native for telescope (fuzzy finder)
	{
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
        dependencies = { "nvim-telescope/telescope.nvim" },
	},

	{
        "hrsh7th/nvim-cmp",
        dependencies = {
            -- cmp, completion engine
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path"
            --use 'hrsh7th/cmp-cmdline'
        }
    },

	-- tree, file explorer
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = {
			"nvim-tree/nvim-web-devicons", -- for file icons
		},
	},

	-- indentation colors
	"lukas-reineke/indent-blankline.nvim",

	-- comments
	"numToStr/Comment.nvim",
	"JoosepAlviste/nvim-ts-context-commentstring",

	-- lsp
	"williamboman/mason.nvim",
	"williamboman/mason-lspconfig.nvim",
	"jose-elias-alvarez/null-ls.nvim",
	"jayp0521/mason-null-ls.nvim",
	"MunifTanjim/prettier.nvim",
	"MunifTanjim/eslint.nvim",

	"neovim/nvim-lspconfig",
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-nvim-lua",
	{ "glepnir/lspsaga.nvim", branch = "main" }, -- enhanced lsp uis
	"jose-elias-alvarez/typescript.nvim", -- additional functionality for typescript server (e.g. rename file & update imports)
	"onsails/lspkind.nvim", -- vs-code like icons for autocompletion

	-- tmux and split window navigation
	"christoomey/vim-tmux-navigator", -- ctrl-l ctrl-h ctrl-j ctrl-k
	"szw/vim-maximizer", -- maximizes and restore current window

	-- cost import
	{ "yardnsm/vim-import-cost", build = "npm install --production" },

	-- package.json
	{
		"vuki656/package-info.nvim",
		dependencies = { "MunifTanjim/nui.nvim" } 
	},

	-- surround
    "tpope/vim-surround" ,

	-- status line
	"nvim-lualine/lualine.nvim",

	"L3MON4D3/LuaSnip",
	"rafamadriz/friendly-snippets",
	"saadparwaiz1/cmp_luasnip",

	-- git integration
	"lewis6991/gitsigns.nvim",

	-- copilot
	{
		"zbirenbaum/copilot.lua",
		event = "VimEnter",
		config = function()
			vim.defer_fn(function()
				require("copilot").setup({
					--suggestion = {
					--	auto_trigger = true,
					--},
				})
			end, 100)
		end,
	},
	{
		"zbirenbaum/copilot-cmp",
		dependencies = { "copilot.lua" },
		config = function()
			require("copilot_cmp").setup()
		end,
	},

	-- ts helper
	"marilari88/twoslash-queries.nvim",

	"hrsh7th/cmp-nvim-lsp-signature-help",

	-- css colors
	{
		"rrethy/vim-hexokinase",
		build = "make hexokinase",
		config = function()
			vim.cmd([[
                let g:Hexokinase_highlighters = [ 'backgroundfull' ]
            ]])
		end,
	},

	-- matchup
	--[[use({
		"andymass/vim-matchup",
		config = function()
			vim.g.matchup_matchparen_offscreen = { method = "popup" }
		end,
	})]]

	-- multi-cursor
	{
		"mg979/vim-visual-multi",
		branch = "master",
	},

	"derektata/lorem.nvim",
	-- "tpope/vim-fugitive",
    "voldikss/vim-floaterm",
}

local opts = {}

require("lazy").setup(plugins, opts)

