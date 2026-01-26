return {
    {
        "folke/trouble.nvim",
        opts = {
            use_diagnostic_signs = true,
        },
    },
    {
        "ray-x/lsp_signature.nvim",
        event = "VeryLazy",
        config = function()
            require("lsp_signature").setup({
                bind = true,
                handler_opts = {
                    border = "rounded"
                }
            })
        end
    },
    {
        'dgagn/diagflow.nvim',
        event = 'LspAttach',
        opts = {}
    },
    {
        "mason-org/mason-lspconfig.nvim",
        opts = {
            ensure_installed = {},
        },
        event = "VeryLazy",
        keys = {
            {
                "<leader>lI",
                "<cmd>MasonInstall clangd cmake-language-server lua-language-server python-lsp-server codelldb<cr>",
                mode = { "n" },
                desc = "Mason Install clangd, cmake, lua, python, codelldb",
            },
        },
        dependencies = {
            { "mason-org/mason.nvim",    opts = {} },
            { "mason-org/mason-registry" },
            { "neovim/nvim-lspconfig", }
        },
    },
    {
        "neovim/nvim-lspconfig",
        event = "VeryLazy",
        config = function()
            vim.lsp.inlay_hint.enable(require("core.options").enable_inlay_hint)

            -- Set default capabilities for all LSP servers
            if require("core.options").cmp == "blink" and require("util").is_available('blink.cmp') then
                vim.notify("Configuring blink.cmp capabilities to all LSP servers", vim.log.levels.INFO,
                    { icon = require("util.icons").get_icon("ui", "ActiveLSP"), title = "LSP" })
                vim.lsp.config('*', {
                    capabilities = require('blink.cmp').get_lsp_capabilities(),
                })
            end
        end
    },
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {
            library = {
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            },
        },
    },
    {
        "smjonas/inc-rename.nvim",
        event = "VeryLazy",
        opts = {}
    },
    {
        'numToStr/Comment.nvim',
        event = "VeryLazy",
        opts = {
            -- add any options here
        }
    },
    {
        "jakemason/ouroboros",
        event = "VeryLazy",
    }
}
