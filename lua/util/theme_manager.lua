-- Manages theme setup and related utilities
local M = {}

-- Function to set up the colorscheme
function M.setup_colorscheme()
    -- lualine autocmd on ColorScheme
    vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("lualine_group", { clear = true }),
        callback = function()
            if not require('core.options').lualine_winbar_show then
                vim.defer_fn(function()
                    local ok, lualine = pcall(require, 'lualine')
                    if ok and lualine then
                        require('lualine').hide({
                            place = { 'winbar' },     -- The segment this change applies to.
                            unhide = false,           -- whether to re-enable lualine again/
                        })
                    end
                end, 100)
            end
        end,
    })

    -- All the themes have installed on plugins/ui.lua
    local theme = "vscode" -- Default theme
    -- if in macos, use catppuccin-mocha
    if vim.fn.has("mac") == 1 then
        theme = "catppuccin-mocha"
    end
    vim.cmd.colorscheme(theme)
end

return M
