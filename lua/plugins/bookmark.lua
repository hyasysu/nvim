return -- Using lazy.nvim
{
    "walkersumida/fusen.nvim",
    event = "BufReadPost",
    opts = {
        -- Storage location
        save_file = vim.fn.expand("$HOME") .. "/fusen_marks.json",

        -- Mark appearance
        mark = {
            icon = require('util.icons').get_icon('ui', 'BookMark'),
            hl_group = "FusenMark",
        },

        -- Key mappings
        keymaps = {
            add_mark = "me",     -- Add/edit sticky note
            clear_mark = "mc",   -- Clear mark at current line
            clear_buffer = "mC", -- Clear all marks in buffer
            clear_all = "mD",    -- Clear ALL marks (deletes entire JSON content)
            next_mark = "mn",    -- Jump to next mark
            prev_mark = "mp",    -- Jump to previous mark
            list_marks = "ml",   -- Show marks in quickfix
        },

        -- Telescope integration settings
        telescope = {
            keymaps = {
                delete_mark_insert = "<C-x>", -- Delete mark in insert mode
                delete_mark_normal = "dd",    -- Delete mark in normal mode
            },
        },

        -- Sign column priority
        sign_priority = 10,

        -- Annotation display settings
        annotation_display = {
            mode = "none", -- "eol", "float", "both", "none"
            spacing = 2,   -- Number of spaces before annotation in eol mode

            -- Float window settings
            float = {
                delay = 100,
                border = "rounded",
                max_width = 50,
                max_height = 10,
            },
        },

        -- Exclude specific filetypes from keymaps
        exclude_filetypes = {
            -- "neo-tree",     -- Example: neo-tree
            -- "NvimTree",     -- Example: nvim-tree
            -- "nerdtree",     -- Example: NERDTree
        },

        -- Plugin enabled state
        enabled = true,
    },
    keys = {
        { '<leader>fm',         "<cmd>Telescope fusen marks<CR>",                  desc = "Find fusen marks" },

        { '<leader><leader>mm', function() require("fusen").add_mark() end,   desc = "fusen add mark" },
        { '<leader><leader>mc', function() require("fusen").clear_mark() end, desc = "fusen delete mark at current line" },
    }
}
