local ensure_packer = function()
	local fn = vim.fn
	local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
	if fn.empty(fn.glob(install_path)) > 0 then
		fn.system({ "git", "clone", "--depth", "1", "https://github.com/wbthomason/packer.nvim", install_path })
		vim.cmd([[packadd packer.nvim]])
		return true
	end
	return false
end

local packer_bootstrap = ensure_packer() -- true if packer was just installed-- auto reload plugins and install then when saving plugins-setup.lua

vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins-setup.lua source <afile> | PackerSync
  augroup end
]])

local packer = require("packer")

return packer.startup(function(use)
	-- Packer just manages itself
	use("wbthomason/packer.nvim")

	-- tree-sitter, syntax highligthing
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
	})
	--use("nvim-treesitter/playground")

	-- auto closing
	use("windwp/nvim-autopairs") -- autoclose parens, brackets, quotes, etc...
	use({ "windwp/nvim-ts-autotag", after = "nvim-treesitter" }) -- autoclose tags

	-- color scheme
	--use("EdenEast/nightfox.nvim")
	--use("tiagovla/tokyodark.nvim")
	--use({
	--	"rose-pine/neovim",
	--	as = "rose-pine",
	--})
	--use("sainnhe/everforest")
	use({ "lalitmee/cobalt2.nvim", requires = "tjdevries/colorbuddy.nvim" })
	--use({ "catppuccin/nvim", as = "catppuccin" })

	-- telescope, file search/open
	use({
		"nvim-telescope/telescope.nvim",
		requires = { { "nvim-lua/plenary.nvim" } },
	})

	-- Use fzf native for telescope (fuzzy finder)
	use({
		"nvim-telescope/telescope-fzf-native.nvim",
		run = "make",
	})

	-- cmp, completion engine
	use("hrsh7th/cmp-buffer")
	use("hrsh7th/cmp-path")
	--use 'hrsh7th/cmp-cmdline'
	use("hrsh7th/nvim-cmp")

	-- tree, file explorer
	use({
		"nvim-tree/nvim-tree.lua",
		requires = {
			"nvim-tree/nvim-web-devicons", -- for file icons
		},
	})

	-- indentation colors
	use("lukas-reineke/indent-blankline.nvim")

	-- comments
	use({
		"numToStr/Comment.nvim",
	})
	use("JoosepAlviste/nvim-ts-context-commentstring")

	-- lsp
	use("williamboman/mason.nvim")
	use("williamboman/mason-lspconfig.nvim")
	use("jose-elias-alvarez/null-ls.nvim")
	use("jayp0521/mason-null-ls.nvim")
	use("MunifTanjim/prettier.nvim")
	use("MunifTanjim/eslint.nvim")

	use("neovim/nvim-lspconfig")
	use("hrsh7th/cmp-nvim-lsp")
	use("hrsh7th/cmp-nvim-lua")
	use({ "glepnir/lspsaga.nvim", branch = "main" }) -- enhanced lsp uis
	use("jose-elias-alvarez/typescript.nvim") -- additional functionality for typescript server (e.g. rename file & update imports)
	use("onsails/lspkind.nvim") -- vs-code like icons for autocompletion

	-- tmux and split window navigation
	use("christoomey/vim-tmux-navigator") -- ctrl-l ctrl-h ctrl-j ctrl-k
	use("szw/vim-maximizer") -- maximizes and restore current window

	-- cost import
	use({ "yardnsm/vim-import-cost", run = "npm install --production" })

	-- package.json
	use({
		"vuki656/package-info.nvim",
		requires = "MunifTanjim/nui.nvim",
	})

	-- surround
	use("tpope/vim-surround") -- using cs

	-- status line
	use("nvim-lualine/lualine.nvim")

	use("L3MON4D3/LuaSnip")
	use("rafamadriz/friendly-snippets")
	use("saadparwaiz1/cmp_luasnip")

	-- git integration
	use("lewis6991/gitsigns.nvim")

	-- copilot
	use({
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
	})
	use({
		"zbirenbaum/copilot-cmp",
		after = { "copilot.lua" },
		config = function()
			require("copilot_cmp").setup()
		end,
	})

	-- ts helper
	use("marilari88/twoslash-queries.nvim")

	use("hrsh7th/cmp-nvim-lsp-signature-help")

	-- css colors
	use({
		"rrethy/vim-hexokinase",
		run = "make hexokinase",
		config = function()
			vim.cmd([[
                let g:Hexokinase_highlighters = [ 'backgroundfull' ]
            ]])
		end,
	})

	-- matchup
	--[[use({
		"andymass/vim-matchup",
		config = function()
			vim.g.matchup_matchparen_offscreen = { method = "popup" }
		end,
	})]]

	-- multi-cursor
	use({
		"mg979/vim-visual-multi",
		branch = "master",
	})

	-- lorem ispum
	use("derektata/lorem.nvim")

	use("tpope/vim-fugitive")

    use 'voldikss/vim-floaterm'

	if packer_bootstrap then
		require("packer").sync()
	end
end)
