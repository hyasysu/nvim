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
        dependencies = {
            { "mason-org/mason.nvim",    opts = {} },
            { "mason-org/mason-registry" },
            { "neovim/nvim-lspconfig", }
        },
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
        opts = {}
    },
    {
        'numToStr/Comment.nvim',
        opts = {
            -- add any options here
        }
    },
    {
        "jakemason/ouroboros",
    }
}
