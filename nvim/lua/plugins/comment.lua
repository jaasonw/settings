return {
  'numToStr/Comment.nvim',
  config = function()
    require('Comment').setup()
    vim.api.nvim_set_keymap(
      'n',
      '<leader>/',
      ':lua require("Comment.api").toggle.linewise.current()<CR>',
      { noremap = true, silent = true, desc = 'Comment line' }
    )
    vim.api.nvim_set_keymap(
      'v',
      '<leader>/',
      ':lua require("Comment.api").toggle.linewise(vim.fn.visualmode())<CR>',
      { noremap = true, silent = true, desc = 'Comment selection' }
    )
  end,
}
