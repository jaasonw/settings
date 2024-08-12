-- general
lvim.log.level = "warn"
lvim.format_on_save.enabled = true
lvim.colorscheme = "catppuccin-macchiato"

-- keymappings
lvim.leader = "space"
lvim.keys.normal_mode["<C-s>"] = ":w<cr>"
lvim.builtin.alpha.active = true
lvim.builtin.alpha.mode = "dashboard"
lvim.builtin.terminal.active = true
lvim.builtin.nvimtree.setup.view.side = "left"
lvim.builtin.nvimtree.setup.renderer.icons.show.git = false

lvim.builtin.treesitter.ensure_installed = {
  "bash",
  "c",
  "javascript",
  "json",
  "lua",
  "python",
  "typescript",
  "tsx",
  "css",
  "rust",
  "java",
  "yaml",
}

lvim.builtin.treesitter.ignore_install = { "haskell" }
lvim.builtin.treesitter.highlight.enable = true

-- Additional Plugins
lvim.plugins = {
  {
    "folke/trouble.nvim",
    cmd = "TroubleToggle",
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000
  },
  { "github/copilot.vim" },
  { "karb94/neoscroll.nvim" },
  { "mattn/emmet-vim" },
  { "neovim/nvim-lspconfig" },
  { "RRethy/vim-illuminate" },
  { "SmiteshP/nvim-navic" },
  { "nvim-treesitter/nvim-treesitter-context" },
  { "rcarriga/nvim-notify" },
  { "APZelos/blamer.nvim" },
  { "nacro90/numb.nvim" },
  { "ethanholz/nvim-lastplace" },
  { "jose-elias-alvarez/null-ls.nvim" },
  { "MunifTanjim/prettier.nvim" },
  { "mrjones2014/nvim-ts-rainbow" },
  {
    "olrtg/nvim-emmet",
    config = function()
      vim.keymap.set({ "n", "v" }, '<leader>xe', require('nvim-emmet').wrap_with_abbreviation)
    end,
  },
  {
    "smoka7/hop.nvim",
    event = "BufRead",
    config = function()
      require("hop").setup()
      vim.api.nvim_set_keymap("n", "s", ":HopChar2<cr>", { silent = true })
      vim.api.nvim_set_keymap("n", "S", ":HopWord<cr>", { silent = true })
    end,
  },
  {
    'wfxr/minimap.vim',
    build = "cargo install --locked code-minimap",
    -- cmd = {"Minimap", "MinimapClose", "MinimapToggle", "MinimapRefresh", "MinimapUpdateHighlight"},
    config = function ()
      vim.cmd ("let g:minimap_width = 10")
      vim.cmd ("let g:minimap_auto_start = 1")
      vim.cmd ("let g:minimap_auto_start_win_enter = 1")
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
}
require('neoscroll').setup()
require('numb').setup()
require('nvim-lastplace').setup()

local formatters = require("lvim.lsp.null-ls.formatters")
formatters.setup {
  {
    command = "prettier",
    filetypes = { "javascript", "typescript", "css", "scss", "html", "json", "yaml", "markdown" },
  },
}



--local lspconfig = require('lspconfig')
--lspconfig.pyright.setup {
--  on_new_config = function(config, root_dir)
--    local env = vim.trim(vim.fn.system('cd "' .. root_dir .. '"; poetry env info -p 2>/dev/null'))
--    if string.len(env) > 0 then
--      config.settings.python.pythonPath = env .. '/bin/python'
--    end
--  end
--}
