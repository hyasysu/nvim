return {
    "akinsho/toggleterm.nvim",
    cmd = { "ToggleTerm", "TermExec" },
    keys = {
        { "<Leader>tf", "<Cmd>ToggleTerm direction=float<CR>",              mode = { "n" },                desc = "ToggleTerm float" },
        { "<F7>",       "<Cmd>ToggleTerm<CR>",                              mode = { "n", "v", "i", "t" }, desc = "Toggle terminal" },

        { "<Leader>th", "<Cmd>ToggleTerm size=10 direction=horizontal<CR>", mode = { "n" },                desc = "ToggleTerm horizontal split" },
        { "<Leader>tv", "<Cmd>ToggleTerm size=80 direction=vertical<CR>",   mode = { "n" },                desc = "ToggleTerm vertical split" }
    },
    opts = {
        size = 10,
        -- open_mapping = [[<C-\>]], -- Switch terminal with Ctrl-\
        hide_numbers = true,      -- hide the number column in toggleterm buffers
        -- shade_filetypes = {},
        autochdir = true,
        shade_terminals = false,
        -- shading_factor = '1', -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
        start_in_insert = true,
        insert_mappings = true, -- whether or not the open mapping applies in insert mode
        terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
        persist_size = true,
        persist_mode = true,
        -- direction = 'vertical',
        -- direction = 'tab',
        -- direction = 'vertical',
        close_on_exit = true, -- close the terminal window when the process exits
        auto_scroll = false, -- automatically scroll to the bottom on terminal output
        -- This field is only relevant if direction is set to 'float'
        -- float_opts = {
        --     -- The border key is *almost* the same as 'nvim_open_win'
        --     -- see :h nvim_open_win for details on borders however
        --     -- the 'curved' border is a custom border type
        --     -- not natively supported but implemented in this plugin.
        --     border = 'curved',
        --     width = 70,
        --     height = 18,
        --     winblend = 3,
        -- },
        highlights = {
            -- highlights which map to a highlight group name and a table of it's values
            -- NOTE: this is only a subset of values, any group placed here will be set for the terminal window split
            Normal = {
                guibg = "none",
            },
            NormalFloat = {
                link = 'Normal',
            },
            FloatBorder = {
                guibg = "none",
            },
        },
        winbar = {
            enabled = false,
            name_formatter = function(term) --  term: Terminal
                return term.name
            end
        },
    }
}
