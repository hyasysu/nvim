return {
    {
        "github/copilot.vim",
        event = "VeryLazy",
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
    },
    {
        "zbirenbaum/copilot.lua",
        event = "VeryLazy",
        enabled = require("core.options").ai_assistant == "copilot.lua",
        cmd = "Copilot",
        opts = {

        }
    },
    {
        "olimorris/codecompanion.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-treesitter/nvim-treesitter",
            "echasnovski/mini.diff",
            "j-hui/fidget.nvim",
        },
        init = function()
            require("util.codecompanion_fidget_spinner"):init()
        end,

        -- stylua: ignore
        keys = {
            { "<leader>ca", "<CMD>CodeCompanionActions<CR>",     mode = { "n", "v" }, noremap = true, silent = true, desc = "CodeCompanion actions" },
            { "<leader>ci", "<CMD>CodeCompanion<CR>",            mode = { "n", "v" }, noremap = true, silent = true, desc = "CodeCompanion inline" },
            { "<leader>cc", "<CMD>CodeCompanionChat Toggle<CR>", mode = { "n", "v" }, noremap = true, silent = true, desc = "CodeCompanion chat (toggle)" },
            { "<leader>cp", "<CMD>CodeCompanionChat Add<CR>",    mode = { "v" },      noremap = true, silent = true, desc = "CodeCompanion chat add code" },
        },

        opts = {
            display = {
            },

            interactions = {
                -- chat = { adapter = "copilot" },
                inline = {
                    -- adapter = "copilot",
                    keymaps = {
                        accept_change = {
                            modes = { n = "gca" }, -- Remember this as DiffAccept
                        },
                        reject_change = {
                            modes = { n = "gcr" }, -- Remember this as DiffReject
                        },
                        always_accept = {
                            modes = { n = "gcy" }, -- Remember this as DiffYolo
                        },
                    },
                },
            },

            opts = {
                language = "English", -- "English"|"Chinese"
            },
        },
    },
}
