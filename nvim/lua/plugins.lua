local lazypath = vim.fn.stdpath 'data' .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system { 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath }
  if vim.v.shell_error ~= 0 then
    error('Error cloning lazy.nvim:\n' .. out)
  end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require('lazy').setup({
  require 'plugins.actionspreview',
  require 'plugins.autocomplete',
  require 'plugins.autoformat',
  require 'plugins.autopairs',
  require 'plugins.autosave',
  require 'plugins.autosave',
  require 'plugins.bufferline',
  require 'plugins.comment',
  require 'plugins.copilot',
  require 'plugins.gitsigns',
  require 'plugins.hop',
  require 'plugins.indent_line',
  require 'plugins.lazydev',
  require 'plugins.lsp',
  require 'plugins.lualine',
  require 'plugins.mini',
  require 'plugins.neotree',
  require 'plugins.spotify',
  require 'plugins.telescope',
  require 'plugins.trouble',
  require 'plugins.toggleterm',
  require 'plugins.treesitter',
  require 'plugins.whichkey',

  { 'folke/tokyonight.nvim' },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
  },
  { 'karb94/neoscroll.nvim' },
  { 'mattn/emmet-vim' },
  { 'RRethy/vim-illuminate' },
  { 'SmiteshP/nvim-navic' },
  { 'nvim-treesitter/nvim-treesitter-context' },
  { 'rcarriga/nvim-notify' },
  { 'APZelos/blamer.nvim' },
  { 'nacro90/numb.nvim' },
  { 'ethanholz/nvim-lastplace' },
  { 'jose-elias-alvarez/null-ls.nvim' },
  { 'MunifTanjim/prettier.nvim' },
  { 'mrjones2014/nvim-ts-rainbow' },
  { 'mbbill/undotree' },
  { 'tpope/vim-surround' },
  {
    'windwp/nvim-ts-autotag',
    config = function()
      require('nvim-ts-autotag').setup()
    end,
  },
}, {
  ui = {
    -- If you are using a Nerd Font: set icons to an empty table which will use the
    -- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
    icons = vim.g.have_nerd_font and {} or {
      cmd = '⌘',
      config = '🛠',
      event = '📅',
      ft = '📂',
      init = '⚙',
      keys = '🗝',
      plugin = '🔌',
      runtime = '💻',
      require = '🌙',
      source = '📄',
      start = '🚀',
      task = '📌',
      lazy = '💤 ',
    },
  },
})
