
-- Set leader key to space
vim.g.mapleader = " "

-- Basic options
vim.opt.number = true  -- Show line numbers
vim.opt.relativenumber = true  -- Relative line numbers
vim.opt.shiftwidth = 4  -- 4 spaces for indenting
vim.opt.clipboard = "unnamedplus"  -- Sync with system clipboard

-- Motions
-- Easy window navigation
vim.keymap.set('n', '<C-h>', '<C-w>h', { desc = "Move focus to the left window" })
vim.keymap.set('n', '<C-l>', '<C-w>l', { desc = "Move focus to the right window" })
vim.keymap.set('n', '<C-j>', '<C-w>j', { desc = "Move focus to the lower window" })
vim.keymap.set('n', '<C-k>', '<C-w>k', { desc = "Move focus to the upper window" })

-- Plugin manager
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
	"git",
	"clone",
	"--filter=blob:none",
	"https://github.com/folke/lazy.nvim.git",
	"--branch=stable",
	lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Plugins
require("lazy").setup({
    -- Color theme
    {
	"folke/tokyonight.nvim",
	lazy = false, -- make sure we load this during startup
	priority = 1000,
	config = function()
	    vim.cmd([[colorscheme tokyonight]])
	end,
    },

    -- Telescope
    {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
	   local builtin = require('telescope.builtin')
	   -- Press Space + f + f to find files
	   vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
	   -- Press Space + f + g to search text inside files
	   vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
	end
    },

    -- Status bar
    {
	"echasnovski/mini.statusline",
	version = false,
	config = function()
	    require("mini.statusline").setup()
	end
    },

    -- Git blame and signs
    {
	"lewis6991/gitsigns.nvim",
    	config = function()
    	  require("gitsigns").setup({
    	    current_line_blame = true, -- Shows git blame on the current line
    	    current_line_blame_opts = {
    	      delay = 300, -- Wait 300ms before showing the blame text
    	    },
    	  })
    	end
    },

    -- File Explorer Sidebar (Neo-tree)
    {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
      },
      config = function()
        -- Space + e opens/closes the sidebar
        vim.keymap.set('n', '<leader>e', ':Neotree toggle<CR>', { silent = true })
      end
    },

    -- In-buffer Filesystem Editor (Oil)
    {
      "stevearc/oil.nvim",
      dependencies = { "nvim-tree/nvim-web-devicons" },
      config = function()
        require("oil").setup()
        -- Minus (-) edits the current file's directory like a text file
        vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
      end,
    },
})
