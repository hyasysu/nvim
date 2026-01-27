return {
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
