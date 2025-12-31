return {
    {
    "hyasysu/vscode.nvim",
    lazy = false,
    priority = 1000,
    config = function()
        -- For dark theme (neovim's default)
        vim.o.background = 'dark'
        -- For light theme
        -- vim.o.background = 'light'

        local c = require('vscode.colors').get_colors()
        require('vscode').setup({
            -- Alternatively set style in setup
            -- style = 'light'

            -- Enable transparent background
            transparent = true,

            -- Enable italic comment
            italic_comments = true,

            -- Underline `@markup.link.*` variants
            underline_links = true,

            -- Disable nvim-tree background color
            disable_nvimtree_bg = true,

            -- Apply theme colors to terminal
            terminal_colors = true,

            -- Override colors (see ./lua/vscode/colors.lua)
            -- color_overrides = {
                --     vscLineNumber = '#FFFFFF',
                -- },

                -- Override highlight groups (see ./lua/vscode/theme.lua)
                group_overrides = {
                    -- this supports the same val table as vim.api.nvim_set_hl
                    -- use colors from this colorscheme by requiring vscode.colors!
                    Cursor = { fg=c.vscDarkBlue, bg=c.vscLightGreen, bold=true },
                }
            })
        end
    },
    {
        "AstroNvim/astroui",
        ---@type AstroUIOpts
        opts = {
            -- change colorscheme
            -- colorscheme = "astrodark",
            -- colorscheme = "catppuccin",
            -- colorscheme = "everforest",
            -- colorscheme = "zephyr",
            -- colorscheme = "visual_studio_code",
            colorscheme = "vscode",
            -- colorscheme = "gruvbox-material",
            -- colorscheme = "edge",
            -- colorscheme = "dracula",
            -- AstroUI allows you to easily modify highlight groups easily for any and all colorschemes
            highlights = {
                init = { -- this table overrides highlights in all themes
                    -- Normal = { bg = "#000000" },
                },
                astrodark = { -- a table of overrides/changes when applying the astrotheme theme
                    -- Normal = { bg = "#000000" },
                },
            },
            -- Icons can be configured throughout the interface
            icons = {
                -- configure the loading of the lsp in the status line
                LSPLoading1 = "⠋",
                LSPLoading2 = "⠙",
                LSPLoading3 = "⠹",
                LSPLoading4 = "⠸",
                LSPLoading5 = "⠼",
                LSPLoading6 = "⠴",
                LSPLoading7 = "⠦",
                LSPLoading8 = "⠧",
                LSPLoading9 = "⠇",
                LSPLoading10 = "⠏",
            },
        },
    }
}
