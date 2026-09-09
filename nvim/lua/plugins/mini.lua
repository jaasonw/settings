return {
  'echasnovski/mini.nvim',
  config = function()
    require('mini.ai').setup { n_lines = 500 }
    require('mini.surround').setup {
      mappings = {
        add = '<leader>sa',
        delete = '<leader>sd',
        find = '<leader>sf',
        find_left = '<leader>sF',
        highlight = '<leader>sh',
        replace = '<leader>sr',
        update_n_lines = '<leader>sn',
      },
      surroundings = {
        ['{'] = { input = { '{.-}' }, output = { left = '{ ', right = ' }' } },
        ['}'] = { input = { '{.-}' }, output = { left = '{', right = '}' } },
        ['['] = { input = { '%[.-%]' }, output = { left = '[', right = ']' } },
        [']'] = { input = { '%[.-%]' }, output = { left = '[ ', right = ' ]' } },
        ['('] = { input = { '%(.-%)' }, output = { left = '(', right = ')' } },
        [')'] = { input = { '%(.-%)' }, output = { left = '( ', right = ' )' } },
      },
    }
  end,
}
