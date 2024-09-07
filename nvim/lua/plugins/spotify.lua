return {
  'KadoBOT/nvim-spotify',
  dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lualine/lualine.nvim' },
  build = 'make',
  config = function()
    local spotify = require 'nvim-spotify'

    spotify.setup {
      status = {
        update_interval = 10000, -- interval (ms) to check for currently playing
        format = '%s %t by %a',  -- format for spotify-tui
      },
    }
  end,
}
