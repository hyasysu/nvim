return {
    -- This plugin automatically adjusts 'shiftwidth' and 'expandtab'
    'tpope/vim-sleuth',
    enabled = false,
    event = { 'BufReadPost', 'BufNewFile' }
}
