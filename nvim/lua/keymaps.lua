-- keymaps move to another file later idk
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear highlights' })
vim.keymap.set('n', '<Leader>h', '<cmd>nohlsearch<CR>', { desc = 'Clear highlights' })

vim.keymap.set('n', '<Leader><Tab>', '<cmd>b#<CR>', { desc = 'Previous Buffer' })

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Move lines up and down
vim.keymap.set('v', '<A-j>', ":m '>+1<CR>gv=gv", { desc = 'Move selected lines down' })
vim.keymap.set('v', '<A-k>', ":m '<-2<CR>gv=gv", { desc = 'Move selected lines up' })
vim.keymap.set('n', '<A-j>', ':m .+1<CR>==', { desc = 'Move current line down' })
vim.keymap.set('n', '<A-k>', ':m .-2<CR>==', { desc = 'Move current line up' })

-- ctrl f for normal find (jank ass work around but the real keybind is at the bottom of the file LOL)
vim.keymap.set('n', '<C-f>', '<cmd>Telescope current_buffer_fuzzy_find<cr>', { desc = 'Find in buffer' })
vim.keymap.set('n', '<C-g>', '<cmd>Telescope live_grep<cr>', { desc = 'Live Grep' })
vim.keymap.set('n', '<C-p>', '<cmd>Telescope commands<cr>', { desc = 'Command Pallete' })
vim.keymap.set('n', '<C-s>', ':w<cr>', { desc = 'Save' })
vim.keymap.set('n', '<C-n>', ':ene<cr>', { desc = 'New Buffer' })
vim.keymap.set('n', '<C-w>', ':bd<cr>', { desc = 'Close Buffer' })

-- undotree
vim.keymap.set('n', '<Leader>u', function()
  vim.cmd 'UndotreeToggle'
  vim.cmd 'UndotreeFocus'
end, { desc = 'Undotree' })

-- Disable D copying to clipboard (use x)
vim.keymap.set('n', 'd', '"_d')
vim.keymap.set('n', 'D', '"_D')
vim.keymap.set('v', 'd', '"_d')

vim.keymap.set('n', '<Leader>gg', '<cmd>LazyGit<CR>', { desc = 'LazyGit' })
