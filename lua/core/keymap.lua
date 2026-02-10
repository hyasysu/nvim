local map = vim.keymap.set

local get_icon = require("util.icons").get_icon

map({ "n" }, "<C-q>", "<cmd>qa<CR>", { desc = "Quit Neovim" })
map({ "n" }, "<leader>q", "<cmd>wqa!<CR>", { desc = "Force quit Neovim" })

map({ "i", "n", "v", "s" }, "<C-s>", "<Cmd>w<CR>", { desc = "Save file", silent = true })
map({ "i", "n", "v", "s" }, "<D-s>", "<Cmd>w<CR>", { desc = "Save file", silent = true })

-- Ctrl+Insert Copy; Shift+Insert Paste
map({ "n", "v" }, "<C-Insert>", "\"+y", { silent = true, desc = "Copy to system clipboard" })
map("i", "<C-Insert>", "<Esc>\"+yya", { silent = true, desc = "Copy to system clipboard" })
map({ "n", "v" }, "<S-Insert>", "\"+p", { silent = true, desc = "Paste from system clipboard" })
map("i", "<S-Insert>", "<C-r>+", { silent = true, desc = "Paste from system clipboard" })

map("i", "jk", "<Esc>", { silent = true, desc = "Exit insert mode" })
map("i", "jh", "<Left>", { silent = true, desc = "Move left one character" })
map("i", "jl", "<Right>", { silent = true, desc = "Move right one character" })

map({ "n" }, "<C-p>", 'viw"_dP', { silent = true, desc = "Paste without overwriting clipboard" })
map({ "v" }, "<C-p>", '"_dP', { silent = true, desc = "Paste without overwriting clipboard" })
-- Mac
map({ "n" }, "<D-v>", 'viw"_dP', { silent = true, desc = "Paste without overwriting clipboard" })
map({ "v" }, "<D-v>", '"_dP', { silent = true, desc = "Paste without overwriting clipboard" })

-- map({ "i", "n" }, "<C-a>", "<Cmd>normal! ggVG<CR>", { silent = true, desc = "Select all" })

-- Copy whole file to clipboard or specified register
local function copy_whole_file(register)
    register = register or '+'
    local cur_pos = vim.api.nvim_win_get_cursor(0)

    -- 使用 silent 避免显示命令
    vim.cmd('silent normal! gg' .. register .. 'yG')

    -- 恢复位置
    vim.api.nvim_win_set_cursor(0, cur_pos)

    -- 获取文件信息
    local line_count = vim.api.nvim_buf_line_count(0)
    local filetype = vim.bo.filetype

    -- 显示友好的提示
    local reg_display = {
        ['+'] = '📋 System Clipboard',
        ['*'] = '📋 Primary Selection',
        ['"'] = '📋 Default Register',
        ['a'] = '📋 Register a',
        ['b'] = '📋 Register b',
        ['c'] = '📋 Register c',
    }

    vim.notify(string.format('✅ Already copied %d lines of %s to %s',
        line_count, vim.fn.expand("%:") or 'file',
        (reg_display[register] or 'Register ') .. register
    ), vim.log.levels.INFO)
end

-- 键位映射
vim.keymap.set('n', '<leader>yf', function() copy_whole_file('+') end,
    { desc = 'Copy entire file to system clipboard.' })

vim.keymap.set('n', '<leader>yF', function() copy_whole_file('"') end,
    { desc = 'Copy entire file to default clipboard.' })

-- 按需复制到不同寄存器
for _, reg in ipairs({ 'a', 'b', 'c', 'd' }) do
    vim.keymap.set('n', '<leader>y' .. reg, function()
        copy_whole_file(reg)
    end, { desc = 'Copy entire file to register ' .. reg })
end

if not pcall(require, 'tmux') then
    map({ 'v', 'n', 'i', 't' }, '<C-h>', [[<Cmd>wincmd h<CR>]], { desc = "Move to left window" })
    map({ 'v', 'n', 'i', 't' }, '<C-j>', [[<Cmd>wincmd j<CR>]], { desc = "Move to bottom window" })
    map({ 'v', 'n', 'i', 't' }, '<C-k>', [[<Cmd>wincmd k<CR>]], { desc = "Move to top window" })
    map({ 'v', 'n', 'i', 't' }, '<C-l>', [[<Cmd>wincmd l<CR>]], { desc = "Move to right window" })
else
    map({ 'v', 'i', 't' }, '<C-h>', [[<Cmd>lua require'tmux'.move_left()<CR>]], { desc = "Move to left tmux pane" })
    map({ 'v', 'i', 't' }, '<C-j>', [[<Cmd>lua require'tmux'.move_bottom()<CR>]], { desc = "Move to bottom tmux pane" })
    map({ 'v', 'i', 't' }, '<C-k>', [[<Cmd>lua require'tmux'.move_top()<CR>]], { desc = "Move to top tmux pane" })
    map({ 'v', 'i', 't' }, '<C-l>', [[<Cmd>lua require'tmux'.move_right()<CR>]], { desc = "Move to right tmux pane" })
end
map({ 'v', 'n', 'i', 't' }, '<C-S-h>', [[<Cmd>wincmd H<CR>]], { desc = "Move window to left" })
map({ 'v', 'n', 'i', 't' }, '<C-S-j>', [[<Cmd>wincmd J<CR>]], { desc = "Move window to bottom" })
map({ 'v', 'n', 'i', 't' }, '<C-S-k>', [[<Cmd>wincmd K<CR>]], { desc = "Move window to top" })
map({ 'v', 'n', 'i', 't' }, '<C-S-l>', [[<Cmd>wincmd L<CR>]], { desc = "Move window to right" })

map({ 'v', 'n', 'i', 't' }, '<M-r>', [[<Cmd>wincmd r<CR>]], { desc = "Rotate windows" })
map({ 'v', 'n', 'i', 't' }, '<M-x>', [[<Cmd>wincmd x<CR>]], { desc = "Swap windows" })
map({ 'v', 'n', 'i', 't' }, '<M-s>', [[<Cmd>wincmd s<CR>]], { desc = "Split window horizontally" })
map({ 'v', 'n', 'i', 't' }, '<M-v>', [[<Cmd>wincmd v<CR>]], { desc = "Split window vertically" })

map({ 'v', 'n', 'i', 't' }, '<M-=>', [[<Cmd>wincmd +<CR>]], { desc = "Increase window height" })
map({ 'v', 'n', 'i', 't' }, '<M-->', [[<Cmd>wincmd -<CR>]], { desc = "Decrease window height" })
map({ 'v', 'n', 'i', 't' }, '<M-,>', [[<Cmd>wincmd <Lt><CR>]], { desc = "Decrease window width" })
map({ 'v', 'n', 'i', 't' }, '<M-.>', [[<Cmd>wincmd ><CR>]], { desc = "Increase window width" })

map({ 'v', 'n', 'i', 't' }, '<M-Up>', [[<Cmd>wincmd +<CR>]], { desc = "Increase window height" })
map({ 'v', 'n', 'i', 't' }, '<M-Down>', [[<Cmd>wincmd -<CR>]], { desc = "Decrease window height" })
map({ 'v', 'n', 'i', 't' }, '<M-Left>', [[<Cmd>wincmd <Lt><CR>]], { desc = "Decrease window width" })
map({ 'v', 'n', 'i', 't' }, '<M-Right>', [[<Cmd>wincmd ><CR>]], { desc = "Increase window width" })

map({ 'v', 'n', 'i', 't' }, '<M-q>', [[<Cmd>wincmd q<CR>]], { desc = "Close current window" })

map('n', '<Esc>', function() require("util").escape_to_normal_with_nohls() end,
    { noremap = true, desc = "Clear search highlighting" })
map('t', '<Esc>', [[<C-\><C-n>]], { noremap = true, desc = "Exit terminal mode" })

-- GitHub Copilot
map('n', '<leader>go', ':Copilot<CR>', { silent = true })
map('n', '<leader>ge', ':Copilot enable<CR>', { silent = true })
map('n', '<leader>gD', ':Copilot disable<CR>', { silent = true })

-- Notify
map({ "n" }, "<Leader>uD", function() require("notify").dismiss { pending = true, silent = true } end,
    { desc = "Dismiss notifications", })
