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
  -- { "github/copilot.vim" },
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
  { "AckslD/swenv.nvim" },
  {
    "Pocco81/auto-save.nvim",
    config = function()
      require("auto-save").setup()
    end,
  },
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
    config = function()
      vim.cmd("let g:minimap_width = 10")
      vim.cmd("let g:minimap_auto_start = 1")
      vim.cmd("let g:minimap_auto_start_win_enter = 1")
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup()
    end,
  },
  {
    "FeiyouG/commander.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" }
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


require("commander").add({
  {
    desc = "Open commander",
    cmd = require("commander").show,
    keys = { "n", "<C-p>" },
    integration = {
      telescope = {
        enable = true,

      },
      lazy = {
        enable = true,
      },
    },
  }
})

table.insert(lvim.plugins, {
  "zbirenbaum/copilot-cmp",
  event = "InsertEnter",
  dependencies = { "zbirenbaum/copilot.lua" },
  config = function()
    vim.defer_fn(function()
      require("copilot").setup()     -- https://github.com/zbirenbaum/copilot.lua/blob/master/README.md#setup-and-configuration
      require("copilot_cmp").setup() -- https://github.com/zbirenbaum/copilot-cmp/blob/master/README.md#configuration
    end, 100)
  end,
})



-- GO LSP
vim.list_extend(lvim.lsp.automatic_configuration.skipped_servers, { "gopls" })

local lsp_manager = require "lvim.lsp.manager"
lsp_manager.setup("golangci_lint_ls", {
  on_init = require("lvim.lsp").common_on_init,
  capabilities = require("lvim.lsp").common_capabilities(),
})

lsp_manager.setup("gopls", {
  on_attach = function(client, bufnr)
    require("lvim.lsp").common_on_attach(client, bufnr)
    local _, _ = pcall(vim.lsp.codelens.refresh)
    local map = function(mode, lhs, rhs, desc)
      if desc then
        desc = desc
      end

      vim.keymap.set(mode, lhs, rhs, { silent = true, desc = desc, buffer = bufnr, noremap = true })
    end
    map("n", "<leader>Ci", "<cmd>GoInstallDeps<Cr>", "Install Go Dependencies")
    map("n", "<leader>Ct", "<cmd>GoMod tidy<cr>", "Tidy")
    map("n", "<leader>Ca", "<cmd>GoTestAdd<Cr>", "Add Test")
    map("n", "<leader>CA", "<cmd>GoTestsAll<Cr>", "Add All Tests")
    map("n", "<leader>Ce", "<cmd>GoTestsExp<Cr>", "Add Exported Tests")
    map("n", "<leader>Cg", "<cmd>GoGenerate<Cr>", "Go Generate")
    map("n", "<leader>Cf", "<cmd>GoGenerate %<Cr>", "Go Generate File")
    map("n", "<leader>Cc", "<cmd>GoCmt<Cr>", "Generate Comment")
    map("n", "<leader>DT", "<cmd>lua require('dap-go').debug_test()<cr>", "Debug Test")
  end,
  on_init = require("lvim.lsp").common_on_init,
  capabilities = require("lvim.lsp").common_capabilities(),
  settings = {
    gopls = {
      usePlaceholders = true,
      gofumpt = true,
      codelenses = {
        generate = false,
        gc_details = true,
        test = true,
        tidy = true,
      },
    },
  },
})


--local lspconfig = require('lspconfig')
--lspconfig.pyright.setup {
--  on_new_config = function(config, root_dir)
--    local env = vim.trim(vim.fn.system('cd "' .. root_dir .. '"; poetry env info -p 2>/dev/null'))
--    if string.len(env) > 0 then
--      config.settings.python.pythonPath = env .. '/bin/python'
--    end
--  end
--}
