return {
  'stevearc/conform.nvim',
  event = { 'BufWritePre' },
  cmd = { 'ConformInfo' },
  keys = {
    {
      '<leader>lf',
      function()
        require('conform').format { async = true, lsp_format = 'fallback' }
      end,
      mode = '',
      desc = '[L]SP [F]ormat buffer',
    },
  },
  opts = {
    notify_on_error = false,
    format_on_save = false,
    formatters_by_ft = {
      lua = { 'stylua' },
      html = { 'prettierd', 'prettier', stop_after_first = true },
      css = { 'prettierd', 'prettier', stop_after_first = true },
      javascript = { 'prettierd', 'prettier', stop_after_first = true },
      tex = { 'latexindent', stop_after_first = true },
    },
  },
}
