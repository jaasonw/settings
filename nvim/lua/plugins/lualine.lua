return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('lualine').setup {
      -- options = {},
      -- sections = {
      --   lualine_a = { 'mode' },
      --   lualine_b = { 'branch' },
      --   lualine_c = { 'filename' },
      --   lualine_x = { 'encoding', 'fileformat', 'filetype' },
      --   lualine_y = { 'progress' },
      --   lualine_z = { 'location' },
      -- },
      -- inactive_sections = {
      --   lualine_a = {},
      --   lualine_b = {},
      --   lualine_c = { 'filename' },
      --   lualine_y = { 'location' },
      --   lualine_z = {},
      -- },
      -- tabline = {},
      -- extensions = { 'fugitive', 'nvim-tree' },
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
  end,
}
