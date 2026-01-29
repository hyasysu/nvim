return {
    -- When run :verbose set formatoptions?
    -- It should show:
    -- formatoptions=jcroql
    --       Last set from /usr/share/nvim/runtime/ftplugin/lua.vim line 32
    -- But in noice, it only show the first line without the source.
    "folke/noice.nvim",
    event = "VeryLazy",
    enabled = require("core.options").enable_noice,
    dependencies = {
        -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
        "MunifTanjim/nui.nvim",
        -- OPTIONAL:
        --   `nvim-notify` is only needed, if you want to use the notification view.
        --   If not available, we use `mini` as the fallback
        "rcarriga/nvim-notify",
    },
    opts = {
        -- add any options here
        -- you can enable a preset for easier configuration
        presets = {
            bottom_search = true,         -- use a classic bottom cmdline for search
            command_palette = true,       -- position the cmdline and popupmenu together
            long_message_to_split = true, -- long messages will be sent to a split
            inc_rename = false,           -- enables an input dialog for inc-rename.nvim
            lsp_doc_border = false,       -- add a border to hover docs and signature help
        },
        messages = {
            -- NOTE: If you enable messages, then the cmdline is enabled automatically.
            -- This is a current Neovim limitation.
            enabled = true,              -- enables the Noice messages UI
            view = "notify",             -- default view for messages
            view_error = "notify",       -- view for errors
            view_warn = "notify",        -- view for warnings
            view_history = "messages",   -- view for :messages
            view_search = "virtualtext", -- view for search count messages. Set to `false` to disable
        },
    },
}
