
-- Set leader key to space
vim.g.mapleader = " "

-- Basic options
vim.opt.number = true  -- Show line numbers
vim.opt.relativenumber = true  -- Relative line numbers
vim.opt.shiftwidth = 4  -- 4 spaces for indenting
vim.opt.clipboard = "unnamedplus"  -- Sync with system clipboard

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
	   vim.keymap.set('n', 'ff', builtin.find_files, {})
	   -- Press Space + f + g to search text inside files
	   vim.keymap.set('n', 'fg', builtin.live_grep, {})
	end
    }
})
