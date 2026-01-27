-- Manages theme setup and related utilities
local M = {}

-- Function to set up the colorscheme
function M.setup_colorscheme()
    -- All the themes have installed on plugins/ui.lua
    local theme = "vscode" -- Default theme
    -- if in macos, use catppuccin-mocha
    if vim.fn.has("mac") == 1 then
        theme = "catppuccin-mocha"
    end
    vim.cmd.colorscheme(theme)
end

return M
