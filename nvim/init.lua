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

require 'plugins'

-- set theme
vim.cmd.colorscheme 'tokyonight-night'

vim.notify = require 'notify'
require('neoscroll').setup()
require('numb').setup()
require('nvim-lastplace').setup()

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

-- load keymaps last as to avoid any conflicts
require 'keymaps'

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
