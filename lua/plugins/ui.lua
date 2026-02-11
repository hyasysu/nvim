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
                    Cursor = { fg = c.vscDarkBlue, bg = c.vscLightGreen, bold = true },
                }
            })
        end
    },
    {
        "theniceboy/nvim-deus",
        event = "VeryLazy",
    },
    {
        "shaunsingh/nord.nvim",
        event = "VeryLazy",
    },
    {
        "catppuccin/nvim",
        name = "catppuccin",
        event = "VeryLazy",
    },
    {
        "sainnhe/gruvbox-material",
        event = "VeryLazy",
        config = function()
            -- Optionally configure and load the colorscheme
            -- directly inside the plugin declaration.
            vim.g.gruvbox_material_enable_italic = true
            vim.g.gruvbox_material_background = "medium"
            vim.g.gruvbox_material_better_performance = 1
            vim.g.gruvbox_material_current_word = "high contrast background"
        end,
    },
    {
        "hyasysu/zephyr-nvim",
        event = "VeryLazy",
    },
    {
        "folke/tokyonight.nvim",
        event = "VeryLazy",
        opts = {},
    },
    {
        "rebelot/kanagawa.nvim",
        event = "VeryLazy",
    },
    {
        "ellisonleao/gruvbox.nvim",
        event = "VeryLazy",
    },
    {
        "hyasysu/visual_studio_code",
        event = "VeryLazy"
    }
}
