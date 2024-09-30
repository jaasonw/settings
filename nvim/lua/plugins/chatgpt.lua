return {
  'jackMort/ChatGPT.nvim',
  event = 'VeryLazy',
  config = function()
    require('chatgpt').setup {
      -- assumes OPENAI_API_KEY is set
      chat = {
        keymaps = {
          close = { '<C-c>', '<C-q>', '<Esc>' },
        },
      },

      openai_params = {
        model = 'gpt-4o-mini',
        max_tokens = 3000,
      },
    }
  end,
  dependencies = {
    'MunifTanjim/nui.nvim',
    'nvim-lua/plenary.nvim',
    'folke/trouble.nvim',
    'nvim-telescope/telescope.nvim',
  },
}
