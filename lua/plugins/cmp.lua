return {
    {
        "Saghen/blink.cmp",
        enabled = require("core.options").cmp == "blink",
        event = "InsertEnter",
        -- optional: provides snippets for the snippet source
        dependencies = {
            'rafamadriz/friendly-snippets',
            {
                "onsails/lspkind.nvim",
                lazy = false,
                config = function()
                    require("lspkind").init()
                end
            },
        },
        -- use a release tag to download pre-built binaries
        version = '1.*',
        -- AND/OR build from source, requires nightly: https://rust-lang.github.io/rustup/concepts/channels.html#working-with-nightly-rust
        -- build = 'cargo build --release',
        -- If you use nix, you can build from source using latest nightly rust with:
        -- build = 'nix run .#build-plugin',

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
            -- 'super-tab' for mappings similar to vscode (tab to accept)
            -- 'enter' for enter to accept
            -- 'none' for no mappings
            --
            -- All presets have the following mappings:
            -- C-space: Open menu or open docs if already open
            -- C-n/C-p or Up/Down: Select next/previous item
            -- C-e: Hide menu
            -- C-k: Toggle signature help (if signature.enabled = true)
            --
            -- See :h blink-cmp-config-keymap for defining your own keymap
            keymap = {
                preset = 'none',
                ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
                ['<C-l>'] = { 'show', 'show_documentation', 'hide_documentation' },
                ['<C-e>'] = { 'hide', 'fallback' },
                ['<CR>'] = { 'select_and_accept', 'fallback' },

                ['<Up>'] = { 'select_prev', 'fallback' },
                ['<Down>'] = { 'select_next', 'fallback' },
                ['<S-tab>'] = { 'select_prev', 'fallback_to_mappings' },
                ['<tab>'] = { 'select_next', 'fallback_to_mappings' },

                ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
                ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },

                -- ['<C-e>'] = { 'snippet_forward', 'fallback' },
                -- ['<C-u>'] = { 'snippet_backward', 'fallback' },

                ['<C-k>'] = { 'show_signature', 'hide_signature', 'fallback' },
            },

            appearance = {
                -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                -- Adjusts spacing to ensure icons are aligned
                nerd_font_variant = 'mono'
            },

            cmdline = {
                completion = {
                    menu = {
                        auto_show = true,
                        -- auto_show = function(ctx)
                        --     return vim.fn.getcmdtype() == ':'
                        --     -- enable for inputs as well, with:
                        --     -- or vim.fn.getcmdtype() == '@'
                        -- end,
                    },
                    ghost_text = {
                        enabled = false,
                    }
                }
            },

            -- (Default) Only show the documentation popup when manually triggered
            completion = {
                keyword = {
                    range = 'full', -- 'full' or 'prefix' to match against the full word or only the prefix
                },
                menu = {
                    auto_show = true,
                    border = "rounded",
                    winhighlight =
                    "Normal:BlinkCmpMenu,FloatBorder:FloatBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
                    draw = {
                        components = {
                            kind_icon = {
                                text = function(ctx)
                                    local icon = ctx.kind_icon
                                    if vim.tbl_contains({ "Path" }, ctx.source_name) then
                                        local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
                                        if dev_icon then
                                            icon = dev_icon
                                        end
                                    else
                                        icon = require("lspkind").symbol_map[ctx.kind] or ""
                                    end

                                    return icon .. ctx.icon_gap
                                end,

                                -- Optionally, use the highlight groups from nvim-web-devicons
                                -- You can also add the same function for `kind.highlight` if you want to
                                -- keep the highlight groups in sync with the icons.
                                highlight = function(ctx)
                                    local hl = ctx.kind_hl
                                    if vim.tbl_contains({ "Path" }, ctx.source_name) then
                                        local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
                                        if dev_icon then
                                            hl = dev_hl
                                        end
                                    end
                                    return hl
                                end,
                            },

                            source_name = {
                                text = function(ctx)
                                    return "[" .. ctx.source_name .. "]"
                                end,
                                highlight = "Comment",
                                width = { fill = true },
                            },
                        },
                        columns = {
                            { "kind_icon",  "kind",              gap = 1 },
                            { "label",      "label_description", gap = 1 },
                            { "source_name" },
                        },
                    },
                },
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 500,
                    window = {
                        border = "rounded",
                        winhighlight = "Normal:BlinkCmpDoc,FloatBorder:FloatBorder,EndOfBuffer:BlinkCmpDoc",
                    },
                }
            },

            signature = {
                enabled = true,
                window = {
                    border = "rounded",
                },
            },

            -- Default list of enabled providers defined so that you can extend it
            -- elsewhere in your config, without redefining it, due to `opts_extend`
            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer' },
            },

            -- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
            -- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
            -- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
            --
            -- See the fuzzy documentation for more information
            fuzzy = { implementation = "prefer_rust_with_warning" }
        },
        opts_extend = { "sources.default" }
    },
    {
        'hrsh7th/nvim-cmp',
        enabled = require("core.options").cmp == "nvim.cmp",
        event = "InsertEnter",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            'hrsh7th/cmp-nvim-lsp-signature-help',
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            'hrsh7th/cmp-cmdline',
            "hrsh7th/cmp-nvim-lua",
            "hrsh7th/cmp-calc",
            'lukas-reineke/cmp-rg',
            "lukas-reineke/cmp-under-comparator",
            'f3fora/cmp-spell',
            {
                "onsails/lspkind.nvim",
                lazy = false,
                config = function()
                    require("lspkind").init()
                end
            },
            'saadparwaiz1/cmp_luasnip',
            {
                "L3MON4D3/LuaSnip",
                dependencies = { "rafamadriz/friendly-snippets" },
                build = "make install_jsregexp",
                config = function()
                    require("luasnip.loaders.from_vscode").lazy_load()
                end
            }
        },
        config = function()
            local has_lspkind, lspkind = pcall(require, 'lspkind')
            local cmp = require 'cmp'

            local function has_words_before()
                local cursor = vim.api.nvim_win_get_cursor(0)
                local line = cursor[1]
                local col = cursor[2]
                return col ~= 0 and
                    vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
            end

            cmp.setup {
                -- view = 'custom',
                preselect = 'none',
                completion = {
                    completeopt = 'menu,menuone,noinsert,noselect'
                    -- completeopt = 'menu,menuone'
                },
                -- experimental = { ghost_text = true },

                -- 指定 snippet 引擎
                snippet = {
                    expand = function(args)
                        -- -- For `vsnip` users.
                        -- vim.fn["vsnip#anonymous"](args.body)
                        -- For `luasnip` users.
                        require('luasnip').lsp_expand(args.body)
                        -- For `ultisnips` users.
                        -- vim.fn["UltiSnips#Anon"](args.body)
                        -- For `snippy` users.
                        -- require'snippy'.expand_snippet(args.body)
                    end,
                },

                -- 来源
                sources = cmp.config.sources {
                    -- {name = "lazydev", group_index = 0},
                    { name = "nvim_lsp", max_item_count = 10 },
                    -- {name = "nvim_lsp_signature_help", max_item_count = 1},
                    { name = "buffer",   max_item_count = 8, keyword_length = 2 },
                    { name = "rg",       max_item_count = 5, keyword_length = 4 },
                    -- {name = "git", max_item_count = 5, keyword_length = 2},
                    -- {
                    --     name = 'rime',
                    --     option = {
                    --     },
                    -- },
                    -- {
                    --     name = 'rime_punct',
                    --     option = {
                    --     },
                    -- },
                    { name = "luasnip",  max_item_count = 8 },
                    { name = "path" },
                    -- {name = "codeium"}, -- INFO: uncomment this for AI completion
                    -- {name = "spell", max_item_count = 4},
                    -- {name = "cmp_yanky", max_item_count = 2},
                    { name = "calc",     max_item_count = 3 },
                    -- {name = "cmdline"},
                    -- {name = "git"},
                    -- {name = "emoji", max_item_count = 3},
                    -- {name = "copilot"}, -- INFO: uncomment this for AI completion
                    -- {name = "cmp_tabnine"}, -- INFO: uncomment this for AI completion
                },

                -- 对补全建议排序
                sorting = {
                    comparators = {
                        cmp.config.compare.offset,
                        cmp.config.compare.exact,
                        cmp.config.compare.score,
                        cmp.config.compare.recently_used,
                        require("cmp-under-comparator").under,
                        -- require("cmp_tabnine.compare"), -- INFO: uncomment this for AI completion
                        cmp.config.compare.kind,
                        cmp.config.compare.sort_text,
                        cmp.config.compare.length,
                        cmp.config.compare.order,
                    }
                },


                -- 快捷键
                mapping = {
                    -- 上一个
                    ['<C-p>'] = cmp.mapping.select_prev_item(),
                    -- 下一个
                    ['<C-n>'] = cmp.mapping.select_next_item(),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif require("luasnip").expand_or_jumpable() then
                            require("luasnip").expand_or_jump()
                        elseif has_words_before() then
                            cmp.complete()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif require("luasnip").jumpable(-1) then
                            require("luasnip").jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    -- 出现补全
                    -- ['<C-j>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
                    -- -- 取消
                    -- ['<C-k>'] = cmp.mapping({
                    --     i = cmp.mapping.abort(),
                    --     c = cmp.mapping.close(),
                    -- }),
                    -- RIME 专用确认
                    -- ['<Space>'] = cmp.mapping(function(fallback)
                    --     if cmp.visible() then
                    --         cmp.mapping.confirm({
                    --             select = true,
                    --             behavior = cmp.ConfirmBehavior.Replace,
                    --         })
                    --     else
                    --         fallback()
                    --     end
                    -- end, { 'i', 's' }),
                    -- 确认
                    -- Accept currently selected item. If none selected, `select` first item.
                    -- Set `select` to `false` to only confirm explicitly selected items.
                    ['<CR>'] = cmp.mapping.confirm({
                        select = false,
                        behavior = cmp.ConfirmBehavior.Insert,
                    }),

                    -- ['<Space>'] = cmp.mapping.confirm({
                    --     select = false,
                    --     behavior = cmp.ConfirmBehavior.Insert,
                    -- }),
                    -- ['<C-Space>'] = cmp.mapping.disable,
                    -- ['<CR>'] = cmp.mapping({
                    --     i = cmp.mapping.abort(),
                    --     c = cmp.mapping.close(),
                    -- }),

                    -- ['1'] = cmp.mapping(function(fallback)
                    --     if cmp.visible() then
                    --         cmp.mapping.confirm({
                    --             select = true,
                    --             behavior = cmp.ConfirmBehavior.Replace,
                    --         })
                    --     else
                    --         fallback()
                    --     end
                    -- end),
                    -- ['2'] = cmp.mapping(function(fallback)
                    --     if cmp.visible() then
                    --         cmp.select_next_item()
                    --     else
                    --         fallback()
                    --     end
                    -- end, { "i", "s" }),
                    -- ['3'] = cmp.mapping(function(fallback)
                    --     if cmp.visible() then
                    --         cmp.select_next_item()
                    --         cmp.select_next_item()
                    --     else
                    --         fallback()
                    --     end
                    -- end, { "i", "s" }),
                    -- ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
                    ['<C-u>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
                    ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
                },

                -- 使用 lspkind-nvim 显示类型图标
                formatting = {
                    format = require('core.options').nerd_fonts and has_lspkind and lspkind.cmp_format {
                        mode = 'symbol',
                        maxwidth = 50,
                        before = function(entry, vim_item)
                            vim_item.menu = "[" .. string.upper(entry.source.name) .. "]"

                            if entry.source.name == "calc" then
                                vim_item.kind = "Calc"
                            end

                            if entry.source.name == "git" then
                                vim_item.kind = "Git"
                            end

                            if entry.source.name == "rg" then
                                vim_item.kind = "Search"
                            end

                            if entry.source.name == "rime" then
                                vim_item.kind = "Rime"
                            end

                            if entry.source.name == "cmp_yanky" then
                                vim_item.kind = "Clipboard"
                            end

                            -- if entry.source.name == "nvim_lsp_signature_help" then
                            --     vim_item.kind = "Call"
                            -- end

                            -- vim_item = require("tailwindcss-colorizer-cmp").formatter(entry, vim_item)
                            return vim_item
                        end,
                        ellipsis_char = '...',
                        symbol_map = {
                            Text = "󰉿",
                            Method = "󰆧",
                            Function = "󰊕",
                            Constructor = "",
                            Field = "󰜢",
                            Variable = "󰀫",
                            Class = "󰠱",
                            Interface = "",
                            Module = "",
                            Property = "󰜢",
                            Unit = "󰑭",
                            Value = "󰎠",
                            Enum = "",
                            Keyword = "󰌋",
                            Snippet = "",
                            Color = "󰏘",
                            File = "󰈙",
                            Reference = "󰈇",
                            Folder = "󰉋",
                            EnumMember = "",
                            Constant = "󰏿",
                            Struct = "󰙅",
                            Event = "",
                            Operator = "󰆕",
                            TypeParameter = "",
                            Calc = "",
                            Git = "",
                            Search = "",
                            Rime = "",
                            Clipboard = "",
                            Call = "",
                        },
                    },
                },
            }
        end,
    }
}
