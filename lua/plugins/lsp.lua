return {
    {
        "folke/trouble.nvim",
        opts = {
            use_diagnostic_signs = true,
        },
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
        "neovim/nvim-lspconfig",
        event = "VeryLazy",
        config = function()
            -- vim.api.nvim_create_autocmd('LspAttach', {
            --     group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
            --     callback = function(event)
            --         local client = vim.lsp.get_client_by_id(event.data.client_id)
            --         -- Highlight words under cursor
            --         if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) and vim.bo.filetype ~= 'bigfile' then
            --             local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight',
            --                 { clear = false })
            --             vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            --                 buffer = event.buf,
            --                 group = highlight_augroup,
            --                 callback = vim.lsp.buf.document_highlight,
            --             })
            --
            --             vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            --                 buffer = event.buf,
            --                 group = highlight_augroup,
            --                 callback = vim.lsp.buf.clear_references,
            --             })
            --
            --             vim.api.nvim_create_autocmd('LspDetach', {
            --                 group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
            --                 callback = function(event2)
            --                     vim.lsp.buf.clear_references()
            --                     vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
            --                     -- vim.cmd 'setl foldexpr <'
            --                 end,
            --             })
            --         end
            --     end
            -- })
            vim.lsp.inlay_hint.enable(require("core.options").enable_inlay_hint)
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
