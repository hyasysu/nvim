-- 由于`nvim-treesitter`创建了新的分支，而且不兼容以前的分支，因此作了区分
-- Attention: `nvim-treesitter.configs` is not exist in new version
-- 其实`neovim v0.11`之后已经内置很多treesitter，这里主要是为了集中管理一些treesitter的设置而引入这两个插件
local current_treesitter = {
    {
        'nvim-treesitter/nvim-treesitter',
        lazy = false,
        branch = "main",
        version = false, -- last release is way too old and doesn't work on Windows
        -- cmd = { "TSUpdate", "TSInstall", "TSLog", "TSUninstall" },
        -- build = ':TSUpdate', -- 不知道为啥会报错(not found nvim-treesitter.install)
        build = function(plugin)
            -- Execute the build only after the plugin is installed
            -- Manually add the plugin path to package.pathl to find `nvim-treesitter.install`
            -- Reason: Because the `core/autocmd.lua` will use `core/options.lua`
            -- And if load autocmd first in the `init.lua`, then the build will failed.
            -- local plugin_path = vim.fn.stdpath('data') .. '/lazy/' .. plugin.name
            -- package.path = package.path .. ';' .. plugin_path .. '/lua/?.lua'
            -- package.path = package.path .. ';' .. plugin_path .. '/lua/?/init.lua'

            local TS = require("nvim-treesitter")
            if not TS.get_installed then
                vim.notify("Please restart Neovim and run `:TSUpdate` to use the `nvim-treesitter` **main** branch.",
                    vim.log.levels.ERROR)
                return
            end
            local ts_util = require("util.treesitter")
            ts_util.build(function()
                TS.update(nil, { summary = true })
            end)
        end,
        init = function(plugin)
            -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
            -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
            -- no longer trigger the **nvim-treeitter** module to be loaded in time.
            -- Luckily, the only thins that those plugins need are the custom queries, which we make available
            -- during startup.
            -- CODE FROM LazyVim (thanks folke!) https://github.com/LazyVim/LazyVim/commit/1e1b68d633d4bd4faa912ba5f49ab6b8601dc0c9
            require("lazy.core.loader").add_to_rtp(plugin)
            pcall(require, "nvim-treesitter.query_predicates")
        end,
        opts_extend = { "ensure_installed" },
        opts = {
            ensure_installed = {
                "c",
                "cpp",
                "bash",
            }
        },
        config = function(_, opts)
            local TS = require("nvim-treesitter")

            -- some quick sanity checks
            if not TS.get_installed then
                return vim.notify("Please use `:Lazy` and update `nvim-treesitter`", vim.log.levels.ERROR)
            elseif type(opts.ensure_installed) ~= "table" then
                return vim.notify("`nvim-treesitter` opts.ensure_installed must be a table", vim.log.levels.ERROR)
            end

            -- setup treesitter
            TS.setup(opts)

            local ts_util = require("util.treesitter")
            -- install missing parsers
            local install = vim.tbl_filter(function(lang)
                return not ts_util.have(lang)
            end, opts.ensure_installed or {})
            if #install > 0 then
                ts_util.build(function()
                    TS.install(install, { summary = true }):await(function()
                        ts_util.get_installed(true) -- refresh the installed langs
                    end)
                end)
            end
        end
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        lazy = true,
        branch = "main",
        init = function()
            -- Disable entire built-in ftplugin mappings to avoid conflicts.
            -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin for built-in ftplugins.
            vim.g.no_plugin_maps = true

            -- Or, disable per filetype (add as you like)
            -- vim.g.no_python_maps = true
            -- vim.g.no_ruby_maps = true
            -- vim.g.no_rust_maps = true
            -- vim.g.no_go_maps = true
        end,
        config = function()
            -- configuration
            require("nvim-treesitter-textobjects").setup {
                select = {
                    -- Automatically jump forward to textobj, similar to targets.vim
                    lookahead = true,
                    -- You can choose the select mode (default is charwise 'v')
                    --
                    -- Can also be a function which gets passed a table with the keys
                    -- * query_string: eg '@function.inner'
                    -- * method: eg 'v' or 'o'
                    -- and should return the mode ('v', 'V', or '<c-v>') or a table
                    -- mapping query_strings to modes.
                    selection_modes = {
                        ['@parameter.outer'] = 'v',   -- charwise
                        ['@function.outer'] = 'V',    -- linewise
                        ['@statement.outer'] = 'V',   -- linewise
                        ['@assignment.outer'] = 'V',  -- linewise
                        ['@block.outer'] = 'V',       -- linewise
                        ['@loop.outer'] = 'V',        -- linewise
                        ['@conditional.outer'] = 'V', -- linewise
                        ['@class.outer'] = 'V',       -- linewise
                    },
                    -- If you set this to `true` (default is `false`) then any textobject is
                    -- extended to include preceding or succeeding whitespace. Succeeding
                    -- whitespace has priority in order to act similarly to eg the built-in
                    -- `ap`.
                    --
                    -- Can also be a function which gets passed a table with the keys
                    -- * query_string: eg '@function.inner'
                    -- * selection_mode: eg 'v'
                    -- and should return true of false
                    include_surrounding_whitespace = false,
                },
                move = {
                    -- whether to set jumps in the jumplist
                    set_jumps = true,
                },
            }

            ---@param key string
            ---@param query_string string
            ---@param query_group string
            local function select_map(key, query_string, query_group)
                vim.keymap.set({ "x", "o" }, key,
                    function()
                        require "nvim-treesitter-textobjects.select".select_textobject(query_string, query_group)
                    end,
                    { desc = query_string });
            end

            -- keymaps
            -- You can use the capture groups defined in `textobjects.scm`
            select_map("af", "@function.outer", "textobjects")
            select_map("if", "@function.inner", "textobjects")
            select_map("ac", "@class.outer", "textobjects")
            select_map("ic", "@class.inner", "textobjects")
            select_map("as", "@local.scope", "locals")
            select_map("az", "@fold", "folds")
            select_map("ai", "@call.outer", "textobjects")
            select_map("ii", "@call.inner", "textobjects")
            select_map("ad", "@conditional.outer", "textobjects")
            select_map("id", "@conditional.inner", "textobjects")
            select_map("ae", "@loop.outer", "textobjects")
            select_map("ie", "@loop.inner", "textobjects")
            select_map("ap", "@parameter.outer", "textobjects")
            select_map("ip", "@parameter.inner", "textobjects")
            select_map("ab", "@block.outer", "textobjects")
            select_map("ib", "@block.inner", "textobjects")
            select_map("at", "@comment.outer", "textobjects")
            select_map("it", "@comment.inner", "textobjects")
            select_map("ar", "@return.outer", "textobjects")
            select_map("ir", "@return.inner", "textobjects")
            select_map("al", "@statement.outer", "textobjects")
            select_map("il", "@statement.inner", "textobjects")
            select_map("an", "@number.outer", "textobjects")
            select_map("in", "@number.inner", "textobjects")
            select_map("ah", "@assignment.outer", "textobjects")
            select_map("ih", "@assignment.inner", "textobjects")

            ---@param key string
            ---@param next boolean whether next or previous
            ---@param capture string
            local function swap_map(key, next, capture)
                if next then
                    vim.keymap.set("n", key, function()
                        require("nvim-treesitter-textobjects.swap").swap_next(capture)
                    end, { desc = "swap_next " .. capture })
                else
                    vim.keymap.set("n", key, function()
                        require("nvim-treesitter-textobjects.swap").swap_previous(capture)
                    end, { desc = "swap_previous " .. capture })
                end
            end
            -- keymaps
            swap_map("<M-m>l", true, "@parameter.inner")
            swap_map("<M-m>j", true, "@statement.outer")
            swap_map("<M-m>ip", true, "@parameter.inner")
            swap_map("<M-m>ib", true, "@block.outer")
            swap_map("<M-m>il", true, "@statement.outer")
            swap_map("<M-m>if", true, "@function.outer")
            swap_map("<M-m>ic", true, "@class.outer")
            swap_map("<M-m>in", true, "@number.inner")
            swap_map("<M-m>h", false, "@parameter.inner")
            swap_map("<M-m>k", false, "@statement.outer")
            swap_map("<M-m>ap", false, "@parameter.inner")
            swap_map("<M-m>ab", false, "@block.outer")
            swap_map("<M-m>al", false, "@statement.outer")
            swap_map("<M-m>af", false, "@function.outer")
            swap_map("<M-m>ac", false, "@class.outer")
            swap_map("<M-m>an", false, "@number.inner")

            ---@param key string
            ---@param direction "goto_next_start" | "goto_next_end" | "goto_previous_start" | "goto_previous_end"
            ---@param query_string string
            ---@param query_group string
            local function move_map(key, direction, query_string, query_group)
                if direction == "goto_next_start" then
                    vim.keymap.set({ "n", "x", "o" }, key, function()
                        require("nvim-treesitter-textobjects.move").goto_next_start(query_string, query_group)
                    end, { desc = direction .. " " .. query_string })
                elseif direction == "goto_next_end" then
                    vim.keymap.set({ "n", "x", "o" }, key, function()
                        require("nvim-treesitter-textobjects.move").goto_next_end(query_string, query_group)
                    end, { desc = direction .. " " .. query_string })
                elseif direction == "goto_previous_start" then
                    vim.keymap.set({ "n", "x", "o" }, key, function()
                        require("nvim-treesitter-textobjects.move").goto_previous_start(query_string, query_group)
                    end, { desc = direction .. " " .. query_string })
                elseif direction == "goto_previous_end" then
                    vim.keymap.set({ "n", "x", "o" }, key, function()
                        require("nvim-treesitter-textobjects.move").goto_previous_end(query_string, query_group)
                    end, { desc = direction .. " " .. query_string })
                end
            end
            -- keymaps
            -- You can use the capture groups defined in `textobjects.scm`
            move_map("]f", "goto_next_start", "@function.outer", "textobjects")
            move_map("]F", "goto_next_end", "@function.outer", "textobjects")
            move_map("[f", "goto_previous_start", "@function.outer", "textobjects")
            move_map("[F", "goto_previous_end", "@function.outer", "textobjects")

            move_map("]c", "goto_next_start", "@class.outer", "textobjects")
            move_map("]C", "goto_next_end", "@class.outer", "textobjects")
            move_map("[c", "goto_previous_start", "@class.outer", "textobjects")
            move_map("[C", "goto_previous_end", "@class.outer", "textobjects")

            move_map("]s", "goto_next_start", "@local.scope", "locals")
            move_map("]S", "goto_next_end", "@local.scope", "locals")
            move_map("[s", "goto_previous_start", "@local.scope", "locals")
            move_map("[S", "goto_previous_end", "@local.scope", "locals")

            move_map("]z", "goto_next_start", "@fold", "folds")
            move_map("]Z", "goto_next_end", "@fold", "folds")
            move_map("[z", "goto_previous_start", "@fold", "folds")
            move_map("[Z", "goto_previous_end", "@fold", "folds")

            -- local ts_repeat_move = require "nvim-treesitter-textobjects.repeatable_move"

            -- Repeat movement with ; and ,
            -- ensure ; goes forward and , goes backward regardless of the last direction
            -- vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
            -- vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

            -- vim way: ; goes to the direction you were moving.
            -- vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
            -- vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

            -- Optionally, make builtin f, F, t, T also repeatable with ; and ,
            -- vim.keymap.set({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f_expr, { expr = true })
            -- vim.keymap.set({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F_expr, { expr = true })
            -- vim.keymap.set({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t_expr, { expr = true })
            -- vim.keymap.set({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T_expr, { expr = true })
        end,
    },
    -- Automatically add closing tags for HTML and JSX
    {
        "windwp/nvim-ts-autotag",
        event = { "BufReadPost", "BufNewFile", "BufWritePre" },
        opts = {},
    },
}



local old_treesitter = {
    "nvim-treesitter/nvim-treesitter",
    main = "nvim-treesitter.configs",
    build = ":TSUpdate",
    branch = "master", -- Because nvim-treesitter moved to main branch, use old branch to match other plugins
    dependencies = {
        {
            "nvim-treesitter/nvim-treesitter-textobjects",
            lazy = true,
            branch = "master"                            -- To match nvim-treesitter branch
        },
        { "windwp/nvim-ts-autotag",       lazy = true }, -- Auto close and rename html tag
        { "p00f/nvim-ts-rainbow",         lazy = true }, -- Rainbow parentheses
        { "andymass/vim-matchup",         lazy = true }, -- % matching for treesitter
        { "mfussenegger/nvim-treehopper", lazy = true }, -- Move between code blocks
    },

    init = function(plugin)
        -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
        -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
        -- no longer trigger the **nvim-treeitter** module to be loaded in time.
        -- Luckily, the only thins that those plugins need are the custom queries, which we make available
        -- during startup.
        -- CODE FROM LazyVim (thanks folke!) https://github.com/LazyVim/LazyVim/commit/1e1b68d633d4bd4faa912ba5f49ab6b8601dc0c9
        require("lazy.core.loader").add_to_rtp(plugin)
        pcall(require, "nvim-treesitter.query_predicates")
    end,
    lazy = false,
    keys = {
        {
            "<leader>ti",
            "<cmd>TSInstall c cpp lua python bash zsh rust json java go vim <cr>",
            desc = "Install Treesitter Parsers(c cpp lua python bash zsh rust json java go vim)",
        },
        {
            "<leader>tp",
            "<cmd>TSInstallInfo<cr>",
            desc = "List Installed Treesitter Parsers",
        }
    },
    config = function(_, opts)
        require 'nvim-treesitter.configs'.setup {
            -- ensure_installed = {"c", "cpp", "cuda", "cmake", "lua", "python", "html", "javascript", "css", "json", "bash", "regex", "markdown", "diff", "glsl", "vim", "vimdoc"},
            sync_install = false,
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = '+',
                    node_incremental = '+',
                    node_decremental = '-',
                    -- scope_incremental = '+',
                }
            },
            indent = {
                enable = true,
            },
            rainbow = {
                enable = false,
                extended_mode = true,
            },
            matchup = {
                enable = true,
            },
            context_commentstring = {
                enable = true,
            },
            textobjects = {
                select = {
                    enable = true,

                    -- Automatically jump forward to textobj, similar to targets.vim
                    lookahead = true,

                    keymaps = {
                        -- You can use the capture groups defined in textobjects.scm
                        ["af"] = "@function.outer",
                        ["if"] = "@function.inner",
                        ["ac"] = "@class.outer",
                        ["ic"] = "@class.inner",
                        ["as"] = { query = "@scope", query_group = "locals" },
                        ["az"] = { query = "@fold", query_group = "folds" },
                        ["ai"] = "@call.outer",
                        ["ii"] = "@call.inner",
                        ["ad"] = "@conditional.outer",
                        ["id"] = "@conditional.inner",
                        ["ae"] = "@loop.outer",
                        ["ie"] = "@loop.inner",
                        ["ap"] = "@parameter.outer",
                        ["ip"] = "@parameter.inner",
                        ["ab"] = "@block.outer",
                        ["ib"] = "@block.inner",
                        ["at"] = "@comment.outer",
                        ["it"] = "@comment.inner",
                        ["ar"] = "@return.outer",
                        ["ir"] = "@return.inner",
                        ["al"] = "@statement.outer",
                        ["il"] = "@statement.inner",
                        ["an"] = "@number.outer",
                        ["in"] = "@number.inner",
                        ["ah"] = "@assignment.outer",
                        ["ih"] = "@assignment.inner",
                    },
                    -- You can choose the select mode (default is charwise 'v')
                    --
                    -- Can also be a function which gets passed a table with the keys
                    -- * query_string: eg '@function.inner'
                    -- * method: eg 'v' or 'o'
                    -- and should return the mode ('v', 'V', or '<c-v>') or a table
                    -- mapping query_strings to modes.
                    selection_modes = {
                        ['@parameter.outer'] = 'v',   -- charwise
                        ['@function.outer'] = 'V',    -- linewise
                        ['@statement.outer'] = 'V',   -- linewise
                        ['@assignment.outer'] = 'V',  -- linewise
                        ['@block.outer'] = 'V',       -- linewise
                        ['@loop.outer'] = 'V',        -- linewise
                        ['@conditional.outer'] = 'V', -- linewise
                        ['@class.outer'] = 'V',       -- linewise
                    },
                    -- If you set this to `true` (default is `false`) then any textobject is
                    -- extended to include preceding or succeeding whitespace. Succeeding
                    -- whitespace has priority in order to act similarly to eg the built-in
                    -- `ap`.
                    --
                    -- Can also be a function which gets passed a table with the keys
                    -- * query_string: eg '@function.inner'
                    -- * selection_mode: eg 'v'
                    -- and should return true of false
                    include_surrounding_whitespace = false,
                },
                swap = {
                    enable = true,
                    swap_next = {
                        ["ml"] = "@parameter.inner",
                        ["mj"] = "@statement.outer",
                        ["mip"] = "@parameter.inner",
                        ["mib"] = "@block.outer",
                        ["mil"] = "@statement.outer",
                        ["mif"] = "@function.outer",
                        ["mic"] = "@class.outer",
                        ["min"] = "@number.inner",
                    },
                    swap_previous = {
                        ["mh"] = "@parameter.inner",
                        ["mk"] = "@statement.outer",
                        ["map"] = "@parameter.inner",
                        ["mab"] = "@block.outer",
                        ["mal"] = "@statement.outer",
                        ["maf"] = "@function.outer",
                        ["mac"] = "@class.outer",
                        ["man"] = "@number.inner",
                    },
                },
                move = {
                    enable = true,
                    set_jumps = true, -- whether to set jumps in the jumplist
                    goto_next_start = {
                        ["]f"] = "@function.outer",
                        ["]c"] = "@class.outer",
                        ["]s"] = { query_group = "locals", query = "@scope" },
                        ["]z"] = { query = "@fold", query_group = "folds" },
                        ["]i"] = "@call.*",
                        ["]d"] = "@conditional.*",
                        ["]o"] = "@loop.*",
                        ["]p"] = "@parameter.inner",
                        -- ["]b"] = "@block.outer",
                        ["]t"] = "@comment.*",
                        ["]r"] = "@return.inner",
                        ["]l"] = "@statement.*",
                        ["]n"] = "@number.*",
                        ["]h"] = "@assignment.outer",
                    },
                    goto_next_end = {
                        ["]F"] = "@function.outer",
                        ["]C"] = "@class.outer",
                        ["]S"] = { query = "@scope", query_group = "locals" },
                        ["]Z"] = { query = "@fold", query_group = "folds" },
                        ["]I"] = "@call.*",
                        ["]D"] = "@conditional.*",
                        ["]E"] = "@loop.*",
                        ["]P"] = "@parameter.inner",
                        -- ["]B"] = "@block.outer",
                        ["]T"] = "@comment.*",
                        ["]R"] = "@return.inner",
                        ["]L"] = "@statement.*",
                        ["]N"] = "@number.*",
                        ["]H"] = "@assignment.outer",
                    },
                    goto_previous_start = {
                        ["[f"] = "@function.outer",
                        ["[c"] = "@class.outer",
                        ["[s"] = { query = "@scope", query_group = "locals" },
                        ["[z"] = { query = "@fold", query_group = "folds" },
                        ["[i"] = "@call.*",
                        ["[d"] = "@conditional.*",
                        ["[e"] = "@loop.*",
                        ["[p"] = "@parameter.inner",
                        -- ["[b"] = "@block.outer",
                        ["[t"] = "@comment.*",
                        ["[r"] = "@return.inner",
                        ["[l"] = "@statement.*",
                        ["[n"] = "@number.*",
                        ["[h"] = "@assignment.outer",
                    },
                    goto_previous_end = {
                        ["[F"] = "@function.outer",
                        ["[C"] = "@class.outer",
                        ["[S"] = { query = "@scope", query_group = "locals" },
                        ["[Z"] = { query = "@fold", query_group = "folds" },
                        ["[I"] = "@call.*",
                        ["[D"] = "@conditional.*",
                        ["[E"] = "@loop.*",
                        ["[P"] = "@parameter.*",
                        -- ["[B"] = "@block.outer",
                        ["[T"] = "@comment.*",
                        ["[R"] = "@return.inner",
                        ["[L"] = "@statement.*",
                        ["[N"] = "@number.*",
                        ["[H"] = "@assignment.outer",
                    },
                    -- Below will go to either the start or the end, whichever is closer.
                    -- Use if you want more granular movements
                    -- Make it even more gradual by adding multiple queries and regex.
                    -- goto_next = {
                    --     ["]d"] = "@conditional.outer",
                    -- },
                    -- goto_previous = {
                    --     ["[d"] = "@conditional.outer",
                    -- }
                },
                lsp_interop = {
                    enable = true,
                    border = 'none',
                    floating_preview_opts = {},
                    peek_definition_code = {
                        ["gsf"] = "@function.outer",
                        ["gsc"] = "@class.outer",
                    },
                },
            },
            autotag = {
                enable = true,
            },
            -- refactor = {
            --     highlight_definitions = {
            --         enable = false,
            --         -- Set to false if you have an `updatetime` of ~100.
            --         clear_on_cursor_move = true,
            --     },
            --     highlight_current_scope = {
            --         enable = false,
            --     },
            --     smart_rename = {
            --         enable = true,
            --         -- Assign keymaps to false to disable them, e.g. `smart_rename = false`.
            --         keymaps = {
            --             smart_rename = "gnr",
            --         },
            --     },
            --     navigation = {
            --         enable = true,
            --         -- Assign keymaps to false to disable them, e.g. `goto_definition = false`.
            --         keymaps = {
            --             goto_definition = "gnd",
            --             list_definitions = "gnl",
            --             list_definitions_toc = "gno",
            --             goto_next_usage = "gn]",
            --             goto_previous_usage = "gn[",
            --         },
            --     },
            -- },
        }

        vim.g.skip_ts_context_commentstring_module = true

        vim.g.matchup_matchparen_offscreen = { method = "status" }
        vim.g.matchup_surround_enabled = 1
        vim.g.matchup_delim_noskips = 2
    end,
}

return current_treesitter
