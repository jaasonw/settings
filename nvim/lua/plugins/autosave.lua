return {
  'Pocco81/auto-save.nvim',
  config = function()
    require('auto-save').setup {
      enabled = true,
      execution_message = {
        message = function()
          return '' -- Hide the save message
        end,
      },
      trigger_events = { 'InsertLeave' }, -- Only save when leaving insert mode
      condition = function(buf)
        local fn = vim.fn
        local utils = require 'auto-save.utils.data'
        if
          fn.getbufvar(buf, '&modifiable') == 1
          and utils.not_in(fn.getbufvar(buf, '&filetype'), {})
          and utils.not_in(fn.getbufvar(buf, '&buftype'), { 'terminal' })
        then
          return true
        end
        return false
      end,
      write_all_buffers = false,
      debounce_delay = 100, -- Short delay since we only trigger on InsertLeave
    }

    -- Add custom autocmd to format AND save when leaving insert mode
    vim.api.nvim_create_autocmd('InsertLeave', {
      callback = function()
        -- Format first
        require('conform').format {
          async = false, -- Use sync to ensure formatting happens before save
          lsp_format = 'fallback',
        }
        -- Auto-save will handle the actual saving via its trigger_events
      end,
    })
  end,
}
