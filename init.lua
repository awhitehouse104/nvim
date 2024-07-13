-- init.lua

-- Basic key mappings
vim.g.mapleader = " "

-- Enable relative line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Configure tabs to use spaces
vim.opt.expandtab = true      -- Use spaces instead of tabs
vim.opt.shiftwidth = 2        -- Number of spaces to use for each step of (auto)indent
vim.opt.tabstop = 2           -- Number of spaces that a <Tab> in the file counts for
vim.opt.softtabstop = 2       -- Number of spaces that a <Tab> counts for while editing

-- Bootstrap Lazy.nvim
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

require("lazy").setup({
  'nvim-treesitter/nvim-treesitter',
  'nvim-lua/plenary.nvim',
  'nvim-telescope/telescope.nvim',
  'folke/tokyonight.nvim',
  'stevearc/dressing.nvim',
  'nvim-lualine/lualine.nvim',
  'elkowar/yuck.vim',
  'kyazdani42/nvim-tree.lua',
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    init = function()
      vim.o.timeout = true
      vim.o.timeoutlen = 300
    end,
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
    },
  },
})

-- Tree-sitter configuration
require('nvim-treesitter.configs').setup {
  ensure_installed = { "c", "cpp", "lua", "vimdoc", "python", "javascript", "html", "css", "scss", "yuck" },
  highlight = {
    enable = true,
  },
}

-- Telescope configuration
require('telescope').setup {
  defaults = {
    file_ignore_patterns = {"node_modules", ".git"},
  }
}

-- Set theme
vim.cmd[[colorscheme tokyonight]]

-- Key mappings for Telescope
local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
vim.keymap.set('n', '<leader>fg', builtin.live_grep, {})
vim.keymap.set('n', '<leader>fb', builtin.buffers, {})
vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})

-- Dressing.nvim configuration for better UI
require('dressing').setup({
  input = {
    enabled = true,
  },
  select = {
    enabled = true,
  },
})

-- Lualine configuration
require('lualine').setup {
  options = {
    theme = 'tokyonight',
    section_separators = '',
    component_separators = ''
  },
}

-- Nvim-tree configuration
require('nvim-tree').setup {
  filters = {
    dotfiles = false,  -- Show dotfiles (e.g., .gitignore)
  },
  git = {
    ignore = false, -- Show files listed in .gitignore
  },
  view = {
    width = 35,
    side = 'left',
  },
}

-- Custom function to open Telescope find_files and then open the selected file in a vertical split and focus the new window
local function open_file_in_vsplit()
  builtin.find_files({
    attach_mappings = function(_, map)
      map('i', '<CR>', function(prompt_bufnr)
        local action_state = require('telescope.actions.state')
        local actions = require('telescope.actions')
        local entry = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        vim.cmd('vsplit ' .. entry.path)
        vim.cmd('wincmd l')  -- Move to the right window
      end)
      return true
    end
  })
end

-- Make the function global
_G.open_file_in_vsplit = open_file_in_vsplit

-- Key mapping for the custom open file in vertical split
vim.api.nvim_set_keymap('n', '<leader>fv', '<cmd>lua open_file_in_vsplit()<CR>', { noremap = true, silent = true })

-- Key mapping to toggle nvim-tree
vim.api.nvim_set_keymap('n', '<leader>e', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

-- Key mapping to focus nvim-tree
vim.api.nvim_set_keymap('n', '<leader>fe', ':NvimTreeFindFile<CR>', { noremap = true, silent = true })

-- Key mapping to yank to clipboard
vim.api.nvim_set_keymap('v', '<leader>y', '"+y', { noremap = true, silent = true })

-- Key mapping to open terminal in a vertical split to the right of the current window
vim.api.nvim_set_keymap('n', '<leader>tr', ':rightbelow vsp | term<CR>', { noremap = true, silent = true })

-- Key mapping to open terminal in a horizontal split below the current window
vim.api.nvim_set_keymap('n', '<leader>tb', ':belowright split | resize 15 | term<CR>', { noremap = true, silent = true })

-- Key mapping to exit terminal mode and switch to normal mode
vim.api.nvim_set_keymap('t', '<leader>te', [[<C-\><C-n>]], { noremap = true, silent = true })

-- Key mappings for window navigation
vim.api.nvim_set_keymap('n', '<leader>wh', '<C-w>h', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>wl', '<C-w>l', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>wj', '<C-w>j', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>wk', '<C-w>k', { noremap = true, silent = true })

-- Key mappings for splitting windows
vim.api.nvim_set_keymap('n', '<leader>vs', ':vsp<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>hs', ':sp<CR>', { noremap = true, silent = true })

-- Key mappings for resizing windows
vim.api.nvim_set_keymap('n', '<leader>w+', '<C-w>+', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>w-', '<C-w>-', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>w>', '<C-w>>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>w<', '<C-w><', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>w=', '<C-w>=', { noremap = true, silent = true })

-- Key mapping to close current window
vim.api.nvim_set_keymap('n', '<leader>wq', '<C-w>q', { noremap = true, silent = true })

