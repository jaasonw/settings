-- keymaps move to another file later idk
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear highlights' })
vim.keymap.set('n', '<Leader>h', '<cmd>nohlsearch<CR>', { desc = 'Clear highlights' })
vim.keymap.set('n', '<Leader><Tab>', '<cmd>b#<CR>', { desc = 'Previous Buffer' })
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
vim.keymap.set('n', '<C-f>', '<cmd>Telescope current_buffer_fuzzy_find<cr>', { desc = 'Find in buffer' })
vim.keymap.set('n', '<C-g>', '<cmd>Telescope live_grep<cr>', { desc = 'Live Grep' })
vim.keymap.set('n', '<C-p>', '<cmd>Telescope commands<cr>', { desc = 'Command Pallete' })
vim.keymap.set('n', '<C-s>', ':w<cr>', { desc = 'Save' })
vim.keymap.set('n', '<C-n>', ':ene<cr>', { desc = 'New Buffer' })
vim.keymap.set('n', '<C-w>', ':bd<cr>', { desc = 'Close Buffer' })
vim.keymap.set('n', '<Leader>gg', '<cmd>LazyGit<CR>', { desc = 'LazyGit' })
vim.keymap.set('n', '<Leader>v', '<cmd>Telescope neoclip<CR>', { desc = 'Neoclip' })
vim.keymap.set('n', '<Leader>q', '<cmd>qa<CR>', { desc = 'Quit' })
vim.keymap.set('n', '<C-h>', '<C-w>h', { noremap = true, silent = true, desc = 'Move to the left window' })
vim.keymap.set('n', '<C-j>', '<C-w>j', { noremap = true, silent = true, desc = 'Move to the bottom window' })
vim.keymap.set('n', '<C-k>', '<C-w>k', { noremap = true, silent = true, desc = 'Move to the top window' })
vim.keymap.set('n', '<C-l>', '<C-w>l', { noremap = true, silent = true, desc = 'Move to the right window' })
vim.keymap.set('n', '<Leader>la', '<cmd>lua require("actions-preview").code_actions()<cr>', { desc = 'Code Actions' })

-- Move lines up and down
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv", { desc = 'Move selected lines down' })
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv", { desc = 'Move selected lines up' })
vim.keymap.set('n', '<A-j>', ':m .+1<CR>==', { desc = 'Move current line down' })
vim.keymap.set('n', '<A-k>', ':m .-2<CR>==', { desc = 'Move current line up' })

-- undotree
vim.keymap.set('n', '<Leader>u', function()
  vim.cmd 'UndotreeToggle'
  vim.cmd 'UndotreeFocus'
end, { desc = 'Undotree' })

-- Disable D copying to clipboard (use x)
vim.keymap.set('n', 'd', '"_d')
vim.keymap.set('n', 'D', '"_D')
vim.keymap.set('v', 'd', '"_d')

-- telescope keybinds
vim.keymap.set('n', '<leader>f', '<cmd> Telescope find_files<cr>', { desc = 'Find File' })
vim.keymap.set('n', '<leader>bf', '<cmd> Telescope buffers<cr>', { desc = 'Find Buffer' })
vim.keymap.set('n', '<C-g>', '<cmd> Telescope live_grep<cr>', { desc = 'Live Grep' })
vim.keymap.set('n', '<leader>sb', '<cmd> Telescope git_branches<cr>', { desc = 'Branch' })
vim.keymap.set('n', '<leader>sc', '<cmd> Telescope colorscheme<cr>', { desc = 'Colorscheme' })
vim.keymap.set('n', '<leader>sC', '<cmd> Telescope commands<cr>', { desc = 'Commands' })
vim.keymap.set('n', '<leader>sh', '<cmd> Telescope help_tags<cr>', { desc = 'Help' })
vim.keymap.set('n', '<leader>sk', '<cmd> Telescope keymaps<cr>', { desc = 'Keymaps' })
vim.keymap.set('n', '<leader>ss', '<cmd> Telescope builtin<cr>', { desc = 'Select Telescope' })
vim.keymap.set('n', '<leader>sw', '<cmd> Telescope grep_string<cr>', { desc = 'current Word' })
vim.keymap.set('n', '<leader>sg', '<cmd> Telescope live_grep<cr>', { desc = 'by Grep' })
vim.keymap.set('n', '<leader>sd', '<cmd> Telescope diagnostics<cr>', { desc = 'Diagnostics' })
vim.keymap.set('n', '<leader>sr', '<cmd> Telescope resume<cr>', { desc = 'Resume' })
vim.keymap.set('n', '<leader>s.', '<cmd> Telescope oldfiles<cr>', { desc = 'Recent Files ("." for repeat)' })

vim.keymap.set('n', '<leader>s/', function()
  require('telescope.builtin').live_grep {
    grep_open_files = true,
    prompt_title = 'Live Grep in Open Files',
  }
end, { desc = 'Search in Open Files' })

vim.keymap.set('n', '<leader>sn', function()
  require('telescope.builtin').find_files { cwd = vim.fn.stdpath 'config' }
end, { desc = 'Search Neovim files' })
