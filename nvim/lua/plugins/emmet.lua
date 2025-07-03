return {
  'mattn/emmet-vim',
  keys = {
    { '<leader>w', '<Plug>(emmet-expand-abbr)', mode = 'n', desc = 'Emmet expand abbreviation' },
    -- Use EmmetWrapWithAbbr instead of trying to call EmmetWrap manually
    { '<leader>w', '<Plug>(emmet-wrap-with-abbreviation)', mode = 'v', desc = 'Emmet wrap with abbreviation' },
  },
}
