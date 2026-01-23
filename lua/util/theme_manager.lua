-- Manages theme setup and related utilities
local M = {}

-- Function to set up the colorscheme
function M.setup_colorscheme()
    -- All the themes have installed on plugins/ui.lua
    local theme = "vscode"  -- Default theme
    vim.cmd.colorscheme(theme)
end

return M