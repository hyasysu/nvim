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
    -- {
    --     -- It shows diagnostics in virtual text at the top-right corner of your screen,
    --     -- only when the cursor is positioned over the problematic code or across an entire line, according to your preference.
    --     'dgagn/diagflow.nvim',
    --     event = 'LspAttach',
    --     opts = {}
    -- },
    {
        "rachartier/tiny-inline-diagnostic.nvim",
        event = "VeryLazy",
        priority = 1000,
        config = function()
            require("tiny-inline-diagnostic").setup({
                preset = "modern",
                options = {
                    multilines = {
                        enabled = true,
                        always_show = true,
                    },
                    enable_on_select = true,

                    virt_texts = {
                        priority = 2048,
                    },
                },
            })

            -- Configure diagnostics
            vim.diagnostic.config({
                underline = true,
                virtual_text = false, -- Disable Neovim's default virtual text diagnostics
                signs = {
                    text = {
                        [vim.diagnostic.severity.ERROR] = "",
                        [vim.diagnostic.severity.WARN] = "",
                        [vim.diagnostic.severity.HINT] = "󰌵",
                        [vim.diagnostic.severity.INFO] = "󰋼"
                    },
                    texthl = {
                        [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
                        [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
                        [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
                        [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
                    },
                },
                update_in_insert = false,
                severity_sort = true,
                float = {
                    focused = false,
                    style = "minimal",
                    border = "rounded",
                    source = true,
                    header = "",
                    prefix = "",
                },
                jump = vim.fn.has "nvim-0.11" == 1 and { float = true } or nil,
            })
        end,
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
                function()
                    -- "<cmd>MasonInstall clangd cmake-language-server lua-language-server python-lsp-server codelldb<cr>",
                    local registry = require("mason-registry")
                    local packages = {
                        "clangd",
                        "cmake-language-server",
                        "lua-language-server",
                        "python-lsp-server",
                        "codelldb",
                    }
                    for _, package_name in ipairs(packages) do
                        if not registry.is_installed(package_name) then
                            local package = registry.get_package(package_name)
                            package:install()
                            vim.notify("Installing " .. package_name .. " via Mason.", vim.log.levels.INFO,
                                { icon = require("util.icons").get_icon("ui", "Mason"), title = "Mason" })
                        else
                            vim.notify(package_name .. " is already installed.", vim.log.levels.INFO,
                                { icon = require("util.icons").get_icon("ui", "Mason"), title = "Mason" })
                        end
                    end
                end,
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
