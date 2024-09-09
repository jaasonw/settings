return {
  'ray-x/lsp_signature.nvim',
  event = 'VeryLazy',
  opts = {
    bind = true,
    handler_opts = {
      border = 'rounded',
    },
    hint_enable = true,
    floating_window = false,
    toggle_key = '<C-k>',
    zindex = 1024,
    transparency = 100,
  },
  config = function(_, opts)
    require('lsp_signature').setup(opts)
  end,
}
