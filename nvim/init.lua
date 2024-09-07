-- jasonw nvim
-- based on kickstart

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '
vim.g.have_nerd_font = true
vim.opt.number = true
vim.opt.mouse = 'a'
vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }
vim.opt.inccommand = 'split'
vim.opt.cursorline = true
vim.opt.scrolloff = 10

-- keymaps move to another file later idk
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear highlights' })
vim.keymap.set('n', '<Leader>h', '<cmd>nohlsearch<CR>', { desc = 'Clear highlights' })

vim.keymap.set('n', '<Leader><Tab>', '<cmd>b#<CR>', { desc = 'Previous Buffer' })

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Move lines up and down
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv", { desc = 'Move selected lines down' })
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv", { desc = 'Move selected lines up' })
vim.keymap.set('n', '<A-j>', ':m .+1<CR>==', { desc = 'Move current line down' })
vim.keymap.set('n', '<A-k>', ':m .-2<CR>==', { desc = 'Move current line up' })

-- ctrl f for normal find (jank ass work around but the real keybind is at the bottom of the file LOL)
vim.keymap.set('n', '<C-f>', '<cmd>Telescope current_buffer_fuzzy_find<cr>', { desc = 'Find in buffer' })
vim.keymap.set('n', '<C-g>', '<cmd>Telescope live_grep<cr>', { desc = 'Live Grep' })
vim.keymap.set('n', '<C-p>', '<cmd>Telescope commands<cr>', { desc = 'Command Pallete' })
vim.keymap.set('n', '<C-s>', ':w<cr>', { desc = 'Save' })
vim.keymap.set('n', '<C-n>', ':ene<cr>', { desc = 'New Buffer' })
vim.keymap.set('n', '<C-w>', ':bd<cr>', { desc = 'Close Buffer' })

-- undotree
vim.keymap.set('n', '<Leader>u', function()
  vim.cmd 'UndotreeToggle'
  vim.cmd 'UndotreeFocus'
end, { desc = 'Undotree' })

-- Disable D copying to clipboard (use x)
vim.keymap.set('n', 'd', '"_d')
vim.keymap.set('n', 'D', '"_D')
vim.keymap.set('v', 'd', '"_d')

-- Sync clipboard with os
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  require 'plugins.actionspreview',
  require 'plugins.autocomplete',
  require 'plugins.autoformat',
  require 'plugins.autopairs',
  require 'plugins.autosave',
  require 'plugins.autosave',
  require 'plugins.bufferline',
  require 'plugins.comment',
  require 'plugins.copilot',
  require 'plugins.gitsigns',
  require 'plugins.hop',
  require 'plugins.indent_line',
  require 'plugins.lazydev',
  require 'plugins.lsp',
  require 'plugins.lualine',
  require 'plugins.mini',
  require 'plugins.neotree',
  require 'plugins.spotify',
  require 'plugins.telescope',
  require 'plugins.trouble',
  require 'plugins.toggleterm',
  require 'plugins.treesitter',
  require 'plugins.whichkey',

  { 'folke/tokyonight.nvim' },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
  },
  { 'karb94/neoscroll.nvim' },
  { 'mattn/emmet-vim' },
  { 'RRethy/vim-illuminate' },
  { 'SmiteshP/nvim-navic' },
  { 'nvim-treesitter/nvim-treesitter-context' },
  { 'rcarriga/nvim-notify' },
  { 'APZelos/blamer.nvim' },
  { 'nacro90/numb.nvim' },
  { 'ethanholz/nvim-lastplace' },
  { 'jose-elias-alvarez/null-ls.nvim' },
  { 'MunifTanjim/prettier.nvim' },
  { 'mrjones2014/nvim-ts-rainbow' },
  { 'mbbill/undotree' },
  { 'tpope/vim-surround' },
  {
    'windwp/nvim-ts-autotag',
    config = function()
      require('nvim-ts-autotag').setup()
    end,
  },
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})

-- set theme
vim.cmd.colorscheme 'tokyonight-night'

vim.notify = require 'notify'
require('neoscroll').setup()
require('numb').setup()
require('nvim-lastplace').setup()
-- require('lualine').setup()

if vim.fn.executable 'spt' == 1 then
  local spotify = require 'nvim-spotify'
  spotify.setup {
    status = {
      update_interval = 10000, -- Interval to check for currently playing
      format = '%s %t by %a', -- Format for displaying track info
    },
  }

  local status = require('nvim-spotify').status

  status:start()

  require('lualine').setup {
    sections = {
      lualine_x = {
        status.listen,
      },
    },
  }
else
  -- Optionally, you can add a message here to notify the user
  vim.notify('Spotify TUI (spt) not found, nvim-spotify not activated.', vim.log.levels.WARN)
end

vim.api.nvim_set_keymap('n', '<C-f>', '<cmd>Telescope current_buffer_fuzzy_find<cr>', { desc = 'Find in file', noremap = true, silent = true })

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
