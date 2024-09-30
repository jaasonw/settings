vim.notify = require 'notify'
require('neoscroll').setup()
require('numb').setup()
require('nvim-lastplace').setup()
require('scrollbar').setup()
require('auto-session').setup {}
require('copilot').setup()
require('code_runner').setup {
  mode = 'toggleterm',
  filetype_path = vim.fn.expand '~/.config/nvim/code_runner.json',
  project_path = vim.fn.expand '~/.config/nvim/projects.json',
}

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
