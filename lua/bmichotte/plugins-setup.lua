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

local plugins = {
    -- tree-sitter, syntax highligthing
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
    },
    {
        "windwp/nvim-ts-autotag",
        dependencies = { "nvim-treesitter" },
    }, -- autoclose tags

    -- auto closing
    "windwp/nvim-autopairs", -- autoclose parens, brackets, quotes, etc...

    -- color scheme
    -- "EdenEast/nightfox.nvim",
    --{ "tiagovla/tokyodark.nvim", lazy = false },
    -- { "rose-pine/neovim", name = "rose-pine", },
    -- "sainnhe/everforest",
    --{ "lalitmee/cobalt2.nvim", lazy = false, dependencies = { "tjdevries/colorbuddy.nvim" } },
    { "catppuccin/nvim", name = "catppuccin" },

    --"andweeb/presence.nvim",

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
            "hrsh7th/cmp-path",
            --use 'hrsh7th/cmp-cmdline'
        },
    },

    -- tree, file explorer
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = {
            "nvim-tree/nvim-web-devicons", -- for file icons
        },
    },

    -- indentation colors
    { "lukas-reineke/indent-blankline.nvim", main = "ibl", opts = {} },

    -- comments
    "numToStr/Comment.nvim",
    "JoosepAlviste/nvim-ts-context-commentstring",

    { "glepnir/lspsaga.nvim", branch = "main" }, -- enhanced lsp uis
    "onsails/lspkind.nvim", -- vs-code like icons for autocompletion

    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v2.x",
        dependencies = {
            { "neovim/nvim-lspconfig" },
            {
                "williamboman/mason.nvim",
                build = function()
                    pcall(vim.cmd, "MasonUpdate")
                end,
            },
            { "williamboman/mason-lspconfig.nvim" },
            { "hrsh7th/nvim-cmp" },
            { "hrsh7th/cmp-nvim-lsp" },
            { "L3MON4D3/LuaSnip" },
            { "rafamadriz/friendly-snippets" },
            { "saadparwaiz1/cmp_luasnip" },
        },
    },

    "mhartington/formatter.nvim",

    {
        "pmizio/typescript-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
        opts = {},
    },

    -- tmux and split window navigation
    "christoomey/vim-tmux-navigator", -- ctrl-l ctrl-h ctrl-j ctrl-k
    "szw/vim-maximizer", -- maximizes and restore current window

    -- cost import
    { "yardnsm/vim-import-cost", build = "npm install --production" },

    -- package.json
    {
        "vuki656/package-info.nvim",
        dependencies = { "MunifTanjim/nui.nvim" },
    },

    -- surround
    "tpope/vim-surround",

    -- status line
    "nvim-lualine/lualine.nvim",

    -- copilot
    {
        "zbirenbaum/copilot.lua",
        event = "VimEnter",
        config = function()
            vim.defer_fn(function()
                require("copilot").setup({})
            end, 100)
        end,
    },
    {
        "zbirenbaum/copilot-cmp",
        dependencies = { "copilot.lua" },
    },

    -- ts helper
    "marilari88/twoslash-queries.nvim",

    -- css colors
    "NvChad/nvim-colorizer.lua",
    "roobert/tailwindcss-colorizer-cmp.nvim",

    {
        "jackMort/ChatGPT.nvim",
        event = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim",
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
        },
    },
    --
    -- multi-cursor
    {
        "mg979/vim-visual-multi",
        branch = "master",
    },

    "derektata/lorem.nvim",
    -- "tpope/vim-fugitive",
    "voldikss/vim-floaterm",

    "lewis6991/gitsigns.nvim",
    -- "luukvbaal/statuscol.nvim",
}

local opts = {
    ui = {
        border = { "╔", "═", "╗", "║", "╝", "═", "╚", "║" },
    },
}

require("lazy").setup(plugins, opts)
