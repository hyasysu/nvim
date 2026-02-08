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
        opts_extend = { "servers.*.keys" },
        dependencies = {
            { "folke/neoconf.nvim", lazy = true, opts = {} },
        },
        opts = function()
            ---@class PluginLspOpts
            local ret = {
                -- options for vim.diagnostic.config()
                ---@type vim.diagnostic.Opts
                diagnostics = {
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
                },
                -- Enable this to enable the builtin LSP inlay hints on Neovim.
                -- Be aware that you also will need to properly configure your LSP server to
                -- provide the inlay hints.
                inlay_hints = {
                    enabled = require("core.options").enable_inlay_hint,
                    exclude = { "vue" }, -- filetypes for which you don't want to enable inlay hints
                },
                -- Enable this to enable the builtin LSP code lenses on Neovim.
                -- Be aware that you also will need to properly configure your LSP server to
                -- provide the code lenses.
                codelens = {
                    enabled = false,
                },
                -- Enable this to enable the builtin LSP folding on Neovim.
                -- Be aware that you also will need to properly configure your LSP server to
                -- provide the folds.
                folds = {
                    enabled = true,
                },
                -- options for vim.lsp.buf.format
                -- `bufnr` and `filter` is handled by the LazyVim formatter,
                -- but can be also overridden when specified
                format = {
                    formatting_options = nil,
                    timeout_ms = nil,
                },
                -- LSP Server Settings
                -- Sets the default configuration for an LSP client (or all clients if the special name "*" is used).
                ---@alias lazyvim.lsp.Config vim.lsp.Config|{mason?:boolean, enabled?:boolean, keys?:LazyKeysLspSpec[]}
                ---@type table<string, lazyvim.lsp.Config|boolean>
                servers = {
                    -- configuration for all lsp servers
                    ["*"] = {
                        capabilities = {
                            workspace = {
                                fileOperations = {
                                    didRename = true,
                                    willRename = true,
                                },
                            },
                        },
                        -- stylua: ignore
                        keys = {
                        },
                    },
                    stylua = { enabled = false },
                    lua_ls = {
                        -- mason = false, -- set to false if you don't want this server to be installed with mason
                        -- Use this to add any additional keymaps
                        -- for specific lsp servers
                        -- ---@type LazyKeysSpec[]
                        -- keys = {},
                        settings = {
                            Lua = {
                                workspace = {
                                    checkThirdParty = false,
                                },
                                codeLens = {
                                    enable = true,
                                },
                                completion = {
                                    callSnippet = "Replace",
                                },
                                doc = {
                                    privateName = { "^_" },
                                },
                                hint = {
                                    enable = true,
                                    setType = false,
                                    paramType = true,
                                    paramName = "Disable",
                                    semicolon = "Disable",
                                    arrayIndex = "Disable",
                                },
                            },
                        },
                    },
                },
                -- you can do any additional lsp server setup here
                -- return true if you don't want this server to be setup with lspconfig
                ---@type table<string, fun(server:string, opts: vim.lsp.Config):boolean?>
                setup = {
                    -- example to setup with typescript.nvim
                    -- tsserver = function(_, opts)
                    --   require("typescript").setup({ server = opts })
                    --   return true
                    -- end,
                    -- Specify * to use this function as a fallback for any server
                    -- ["*"] = function(server, opts) end,
                },
            }
            return ret
        end,
        ---@param opts PluginLspOpts
        config = vim.schedule_wrap(function(_, opts)
            -- inlay hints
            if opts.inlay_hints.enabled then
                Snacks.util.lsp.on({ method = "textDocument/inlayHint" }, function(buffer)
                    if
                        vim.api.nvim_buf_is_valid(buffer)
                        and vim.bo[buffer].buftype == ""
                        and not vim.tbl_contains(opts.inlay_hints.exclude, vim.bo[buffer].filetype)
                    then
                        vim.lsp.inlay_hint.enable(true, { bufnr = buffer })
                    end
                end)
            end

            -- folds
            if opts.folds.enabled then
                Snacks.util.lsp.on({ method = "textDocument/foldingRange" }, function()
                    if require('util').set_default("foldmethod", "expr") then
                        require('util').set_default("foldexpr", "v:lua.vim.lsp.foldexpr()")
                    end
                end)
            end

            -- code lens
            if opts.codelens.enabled and vim.lsp.codelens then
                Snacks.util.lsp.on({ method = "textDocument/codeLens" }, function(buffer)
                    vim.lsp.codelens.refresh()
                    vim.api.nvim_create_autocmd({ "BufEnter", "CursorHold", "InsertLeave" }, {
                        buffer = buffer,
                        callback = vim.lsp.codelens.refresh,
                    })
                end)
            end

            -- diagnostics
            vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

            if opts.servers["*"] then
                vim.lsp.config("*", opts.servers["*"])
            end

            -- get all the servers that are available through mason-lspconfig
            local have_mason = require('util').is_available("mason-lspconfig.nvim")
            local mason_all = have_mason
                and vim.tbl_keys(require("mason-lspconfig.mappings").get_mason_map().lspconfig_to_package)
                or {} --[[ @as string[] ]]
            local mason_exclude = {} ---@type string[]

            ---@return boolean? exclude automatic setup
            local function configure(server)
                if server == "*" then
                    return false
                end
                local sopts = opts.servers[server]
                sopts = sopts == true and {} or (not sopts) and { enabled = false } or sopts --[[@as lazyvim.lsp.Config]]

                if sopts.enabled == false then
                    mason_exclude[#mason_exclude + 1] = server
                    return
                end

                local use_mason = sopts.mason ~= false and vim.tbl_contains(mason_all, server)
                local setup = opts.setup[server] or opts.setup["*"]
                if setup and setup(server, sopts) then
                    mason_exclude[#mason_exclude + 1] = server
                else
                    vim.lsp.config(server, sopts) -- configure the server
                    if not use_mason then
                        vim.lsp.enable(server)
                    end
                end
                return use_mason
            end

            local install = vim.tbl_filter(configure, vim.tbl_keys(opts.servers))
            if have_mason then
                require("mason-lspconfig").setup({
                    ensure_installed = vim.list_extend(install,
                        require('util').opts("mason-lspconfig.nvim").ensure_installed or {}),
                    automatic_enable = { exclude = mason_exclude },
                })
            end
        end)
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
