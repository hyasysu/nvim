return {
    {
        "github/copilot.vim",
        event = "VeryLazy",
        enabled = require("core.options").ai_assistant.copilot.enabled,
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
        enabled = require("core.options").ai_assistant.copilot_lua.enabled,
        cmd = "Copilot",
        opts = {

        }
    },
    {
        "olimorris/codecompanion.nvim",
        enabled = require("core.options").ai_assistant.codecompanion.enabled,
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
    {
        "yetone/avante.nvim",
        enabled = require("core.options").ai_assistant.avante.enabled,
        event = "VeryLazy",
        version = false, -- Never set this value to "*"! Never!
        -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
        -- ⚠️ must add this setting! ! !
        build = vim.fn.has("win32") ~= 0
            and "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false"
            or "make",
        -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
        dependencies = {
            -- "ravitemer/mcphub.nvim",
            "nvim-treesitter/nvim-treesitter",
            "stevearc/dressing.nvim",
            "nvim-lua/plenary.nvim",
            "MunifTanjim/nui.nvim",
            --- The below dependencies are optional,
            "echasnovski/mini.pick",         -- for file_selector provider mini.pick
            "nvim-telescope/telescope.nvim", -- for file_selector provider telescope
            "nvim-tree/nvim-web-devicons",   -- or echasnovski/mini.icons
            "zbirenbaum/copilot.lua",        -- for providers='copilot'
            {
                -- support for image pasting
                "HakonHarnes/img-clip.nvim",
                event = "VeryLazy",
                opts = {
                    -- recommended settings
                    default = {
                        embed_image_as_base64 = false,
                        prompt_for_file_name = false,
                        drag_and_drop = {
                            insert_mode = true,
                        },
                        -- required for Windows users
                        use_absolute_path = true,
                    },
                },
            },
            {
                -- Make sure to set this up properly if you have lazy=true
                "MeanderingProgrammer/render-markdown.nvim",
                opts = {
                    file_types = { "Avante" },
                },
                ft = { "Avante" },
            },
        },
        opts = {
            provider   = "openrouter",
            -- auto_suggestions_provider = "openrouter",
            providers  = {
                openrouter = {
                    __inherited_from = "openai",
                    disable_tools = true,
                    endpoint = "https://openrouter.ai/api/v1",
                    api_key_name = "OPENROUTER_API_KEY",
                    model = "tngtech/deepseek-r1t2-chimera:free",
                    -- model = "deepseek/deepseek-chat-v3-0324:free",
                },
            },
            behaviour  = {
                -- auto_suggestions = false,
                enable_cursor_planning_mode = true, -- enable cursor planning mode!
            },
            suggestion = {
                -- debounce = 100,
            },
            -- provider = "deepseek",
            -- vendors = {
            -- 	deepseek = {
            -- 		__inherited_from = "openai",
            -- 		api_key_name = "DEEPSEEK_API_KEY",
            -- 		endpoint = "https://api.deepseek.com",
            -- 		model = "deepseek-chat",
            -- 	},
            -- },
            -- The system_prompt type supports both a string and a function that returns a string. Using a function here allows dynamically updating the prompt with mcphub
            -- system_prompt = function()
            -- 	local hub = require("mcphub").get_hub_instance()
            -- 	return hub:get_active_servers_prompt()
            -- end,
            -- -- The custom_tools type supports both a list and a function that returns a list. Using a function here prevents requiring mcphub before it's loaded
            -- custom_tools = function()
            -- 	return {
            -- 		require("mcphub.extensions.avante").mcp_tool(),
            -- 	}
            -- end,
        },
    }
}
