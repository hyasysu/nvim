return {
  "github/copilot.vim",
  enabled = require("core.options").ai_assistant == "copilot",
  config = function()
    vim.g.copilot_enabled = true
    vim.g.copilot_no_tab_map = true
    vim.api.nvim_set_keymap('n', '<leader>go', ':Copilot<CR>', { silent = true })
    vim.api.nvim_set_keymap('n', '<leader>ge', ':Copilot enable<CR>', { silent = true })
    vim.api.nvim_set_keymap('n', '<leader>gD', ':Copilot disable<CR>', { silent = true })
    vim.api.nvim_set_keymap('i', '<c-p>', '<Plug>(copilot-suggest)', { noremap = true })
    vim.api.nvim_set_keymap('i', '<c-n>', '<Plug>(copilot-next)', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('i', '<c-l>', '<Plug>(copilot-previous)', { noremap = true, silent = true })
    vim.api.nvim_set_keymap('i', '<C-C>', 'copilot#Accept("")', { noremap = true, silent = true, expr = true })
    -- vim.api.nvim_set_keymap({ 'i', 'n' }, '<Tab>', 'copilot#Accept("")', { silent = true, expr = true })
    -- vim.cmd('imap <silent><script><expr> <C-C> copilot#Accept("")')
    vim.cmd('imap <silent><script><expr> <Tab> copilot#Accept("")')
    vim.cmd([[
			let g:copilot_filetypes = {
	       \ 'TelescopePrompt': v:false,
	     \ }
		]])
  end
}
