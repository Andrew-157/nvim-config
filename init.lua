
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

vim.opt.splitright = true  -- Open vertical splits to the right
vim.opt.splitbelow = true  -- Open horizontal splits below

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

    -- Window picker
    {
      "nvim-neo-tree/neo-tree.nvim",
      branch = "v3.x",
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-tree/nvim-web-devicons",
        "MunifTanjim/nui.nvim",
        -- Add the window picker here!
        {
          "s1n7ax/nvim-window-picker",
          version = "2.*",
          config = function()
            require("window-picker").setup({
              filter_rules = {
                autoselect_one = true, -- Automatically pick if there's only one window open
                include_current_win = false,
                bo = {
                  filetype = { "neo-tree", "neo-tree-popup", "notify" },
                  buftype = { "terminal", "quickfix" },
                },
              },
            })
          end,
        },
      },
      config = function()
        vim.keymap.set('n', '<leader>e', ':Neotree toggle<CR>', { silent = true })
      end
    },

    -- 7. Toggleable Terminal (toggleterm.nvim)
    {
      "akinsho/toggleterm.nvim",
      version = "*",
      config = function()
        local toggleterm = require("toggleterm")
        
        toggleterm.setup({
          size = function(term)
            if term.direction == "horizontal" then
              return 15
            elseif term.direction == "vertical" then
              -- Takes up 40% of the screen width when opened vertically
              return vim.o.columns * 0.4
            end
          end,
          float_opts = {
            border = "curved",
          },
        })

        -- Keymaps
        -- 1. Ctrl + t opens the Floating Terminal
        vim.keymap.set({'n', 't'}, '<C-t>', function() 
          toggleterm.toggle(1, nil, nil, 'float') 
        end, { desc = "Toggle Floating Terminal" })

        -- 2. Space + t opens a Vertical Panel on the side
        vim.keymap.set({'n', 't'}, '<leader>t', function() 
          toggleterm.toggle(2, nil, nil, 'vertical') 
        end, { desc = "Toggle Vertical Side Terminal" })

        -- Terminal navigation helpers (keeps window navigation seamless)
        function _G.set_terminal_keymaps()
          local opts = { buffer = 0 }
          vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
          vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
          vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
          vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
        end
        vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
      end
    },

})
