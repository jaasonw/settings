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
lvim.keys.normal_mode["<C-p>"] = "<cmd>Telescope commands<cr>"


-- control f for normal find
lvim.keys.normal_mode["<c-f>"] = "<cmd>Telescope current_buffer_fuzzy_find<cr>"

-- ctrl shift f for better find
lvim.keys.normal_mode["<c-g>"] = "<cmd>Telescope live_grep<cr>"

-- Disable D copying to clipboard (use x)
vim.keymap.set("n", "d", '"_d')
vim.keymap.set("n", "D", '"_D')
vim.keymap.set("v", "d", '"_d')

-- which_key mappings
lvim.builtin.which_key.mappings["<Tab>"] = { "<cmd>b#<CR>", "Previous Buffer" }
lvim.builtin.which_key.mappings["<F5>"] = { "<cmd>UndotreeToggle<cr>", "Toggle UndoTree" }

-- Minimap settings
lvim.builtin.which_key.mappings["m"] = {
  name = "Minimap",
  m = { "<cmd>MinimapToggle<cr>", "MinimapToggle" },
  r = { "<cmd>MinimapRefresh<cr>", "MinimapRefresh" },
  c = { "<cmd>MinimapClose<cr>", "MinimapClose" },
  u = { "<cmd>MinimapUpdateHighlight<cr>", "MinimapUpdateHighlight" },
}

-- Telescope keybinds
lvim.builtin.which_key.mappings["t"] = {
  name = "Telescope",
  g = {
    name = "Git",
    b = { "<cmd>Telescope git_branches<cr>", "Checkout Branch" },
    c = { "<cmd>Telescope git_commits<cr>", "Checkout Commit" },
    s = { "<cmd>Telescope git_status<cr>", "Git Status" },
  },
  l = {
    name = "LSP",
    a = { "<cmd>lua require('actions-preview').code_actions()<cr>", "Actions" },
    d = { "<cmd>Telescope lsp_definitions<cr>", "Definitions" },
    r = { "<cmd>Telescope lsp_references<cr>", "References" },
    s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
    w = { "<cmd>Telescope lsp_workspace_symbols<cr>", "Workspace Symbols" },
  },
  f = {
    name = "Find",
    f = { "<cmd>Telescope find_files<cr>", "Find Files" },
    g = { "<cmd>Telescope live_grep<cr>", "Live Grep" },
    r = { "<cmd>Telescope oldfiles<cr>", "Recent Files" },
  }
}

-- lvim.builtin.which_key.mappings["W"] = { function() require('nvim-emmet').wrap_with_abbreviation() end, "Emmet Wrap" }


-- this is just to make the which_key menu show up faster
vim.opt.timeoutlen = 100

-- telescope settings, makes the layout sideways
lvim.builtin.telescope = {
  active = true,
  defaults = {
    layout_strategy = "horizontal",
  },
  pickers = {
    git_files = {
      hidden = true,
    },
    live_grep = {
      hidden = true,
    },
  },
}

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
  { 'mbbill/undotree' },
  {
    "aznhe21/actions-preview.nvim",
    config = function()
      -- vim.keymap.set({ "v", "n" }, "gf", require("actions-preview").code_actions)
    end,
  },
  {
    "tpope/vim-surround",

    -- make sure to change the value of `timeoutlen` if it's not triggering correctly, see https://github.com/tpope/vim-surround/issues/117
    -- setup = function()
    --  vim.o.timeoutlen = 500
    -- end
  },
  { "AckslD/swenv.nvim" },
  {
    "Pocco81/auto-save.nvim",
    config = function()
      require("auto-save").setup()
    end,
  },
  -- {
  --   "olrtg/nvim-emmet",
  --   config = function()
  --     -- vim.keymap.set({ "n", "v" }, '<leader>xe', require('nvim-emmet').wrap_with_abbreviation)
  --   end,
  -- },
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
    cmd = { "Minimap", "MinimapClose", "MinimapToggle", "MinimapRefresh", "MinimapUpdateHighlight" },
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
    'KadoBOT/nvim-spotify',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    build = 'make',
    config = function()
      local spotify = require 'nvim-spotify'

      spotify.setup {
        status = {
          update_interval = 10000, -- interval (ms) to check for currently playing
          format = '%s %t by %a'   -- format for spotify-tui
        }
      }
    end
  }
}
require('neoscroll').setup()
require('numb').setup()
require('nvim-lastplace').setup()



require("actions-preview").setup {
  diff = {
    algorithm = "patience",
    ignore_whitespace = true,
  },
  telescope = require("telescope.themes").get_dropdown { winblend = 10 },
}


-- Copilot extension that isnt aids like the github one
-- puts the copilot suggestions in the autocomplete instead of fighting the lsp all the fucking time
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



-- General LSP settings
-- Auto hover setup
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

if vim.fn.executable("spt") == 1 then
  local spotify = require 'nvim-spotify'
  local status = spotify.status

  status:start() -- Start the status listener

  -- Customize LunarVim's lualine configuration
  lvim.builtin.lualine.sections.lualine_x = {
    status.listen -- Add Spotify's status to lualine
  }

  -- Additional nvim-spotify setup if needed
  spotify.setup {
    status = {
      update_interval = 10000, -- Interval to check for currently playing
      format = '%s %t by %a'   -- Format for displaying track info
    }
  }
else
  -- Optionally, you can add a message here to notify the user
  vim.notify("Spotify TUI (spt) not found, nvim-spotify not activated.", vim.log.levels.WARN)
end




--local lspconfig = require('lspconfig')
--lspconfig.pyright.setup {
--  on_new_config = function(config, root_dir)
--    local env = vim.trim(vim.fn.system('cd "' .. root_dir .. '"; poetry env info -p 2>/dev/null'))
--    if string.len(env) > 0 then
--      config.settings.python.pythonPath = env .. '/bin/python'
--    end
--  end
--}
--}
--}
--}
--}
--}
--}
