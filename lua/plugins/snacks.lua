return {
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        init = function()
            vim.api.nvim_create_autocmd("User", {
                pattern = "VeryLazy",
                callback = function()
                    -- -- Setup some globals for debugging (lazy-loaded)
                    -- _G.dd = function(...)
                    --     Snacks.debug.inspect(...)
                    -- end
                    -- _G.bt = function()
                    --     Snacks.debug.backtrace()
                    -- end

                    -- -- Override print to use snacks for `:=` command
                    -- if vim.fn.has("nvim-0.11") == 1 then
                    --     vim._print = function(_, ...)
                    --         dd(...)
                    --     end
                    -- else
                    --     vim.print = _G.dd
                    -- end

                    -- Create some toggle mappings
                    Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
                    Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
                    Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
                    Snacks.toggle.diagnostics():map("<leader>ud")
                    Snacks.toggle.line_number():map("<leader>ul")
                    Snacks.toggle.option("conceallevel",
                        { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 }):map("<leader>uc")
                    Snacks.toggle.treesitter():map("<leader>uT")
                    Snacks.toggle.option("background", { off = "light", on = "dark", name = "Dark Background" }):map(
                        "<leader>ub")
                    Snacks.toggle.inlay_hints():map("<leader>uh")
                    Snacks.toggle.indent():map("<leader>ug")
                    Snacks.toggle.dim():map("<leader>uz")
                end,
            })
        end,
        ---@type snacks.Config
        opts = {
            indent = {
                enabled = true,

                -- 背景灰色普通缩进线
                indent = {
                    priority = 1,
                    enabled = true,       -- enable indent guides
                    char = "│",
                    only_scope = false,   -- only show indent guides of the scope
                    only_current = false, -- only show indent guides in the current window
                },

                -- 当前所在代码块
                scope = {
                    enabled = true, -- enable highlighting the current scope
                    priority = 200,
                    char = "│",
                    underline = false,    -- underline the start of the scope
                    only_current = false, -- only show scope in the current window
                    hl = "SnacksIndentScope", ---@type string|string[] hl group for scopes
                },
            },
            lazygit = {
                enabled = true,
            },
            image = {
                enabled = true,
                doc = { enabled = true, inline = false, float = true, max_width = 80, max_height = 20 },
            },

            -- configure `vim.ui.input`
            input = { enabled = true, },

            -- configure notifier
            notifier = {
                enabled = true,
            },

            -- configure picker and `vim.ui.select`
            picker = { ui_select = true },

            bigfile = {
                notify = true,            -- show notification when big file detected
                size = 1.5 * 1024 * 1024, -- 1.5MB
                line_length = 1000,       -- average line length (useful for minified files)
                -- Enable or disable features when big file detected
                ---@param ctx {buf: number, ft:string}
                setup = function(ctx)
                    if vim.fn.exists(":NoMatchParen") ~= 0 then
                        vim.cmd([[NoMatchParen]])
                    end
                    Snacks.util.wo(0, { foldmethod = "manual", statuscolumn = "", conceallevel = 0 })
                    vim.b.completion = false
                    vim.b.minianimate_disable = true
                    vim.b.minihipatterns_disable = true
                    vim.schedule(function()
                        if vim.api.nvim_buf_is_valid(ctx.buf) then
                            vim.bo[ctx.buf].syntax = ctx.ft
                        end
                    end)
                end,
            },
            bufdelete = {
                enabled = true,
                quit = true, -- close window if the last buffer is deleted
            },
            toggle = {
                enabled = true,
            },
            dashboard = {
                width = 60,
                row = nil,                                                                   -- dashboard position. nil for center
                col = nil,                                                                   -- dashboard position. nil for center
                pane_gap = 4,                                                                -- empty columns between vertical panes
                autokeys = "1234567890abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ", -- autokey sequence
                -- These settings are used by some built-in sections
                preset = {
                    -- Defaults to a picker that supports `fzf-lua`, `telescope.nvim` and `mini.pick`
                    ---@type fun(cmd:string, opts:table)|nil
                    pick = nil,
                    -- Used by the `keys` section to show keymaps.
                    -- Set your custom keymaps here.
                    -- When using a function, the `items` argument are the default keymaps.
                    ---@type snacks.dashboard.Item[]
                    keys = {
                        { icon = " ", key = "f", desc = "Find File", action = ":lua Snacks.dashboard.pick('files')" },
                        { icon = " ", key = "n", desc = "New File", action = ":ene | startinsert" },
                        { icon = " ", key = "g", desc = "Find Text", action = ":lua Snacks.dashboard.pick('live_grep')" },
                        { icon = " ", key = "r", desc = "Recent Files", action = ":lua Snacks.dashboard.pick('oldfiles')" },
                        { icon = " ", key = "c", desc = "Config", action = ":lua Snacks.dashboard.pick('files', {cwd = vim.fn.stdpath('config')})" },
                        { icon = " ", key = "s", desc = "Restore Session", action = ":lua require('persistence').load()" },
                        { icon = " ", key = "S", desc = "Select Session", action = ":lua require('persistence').select()" },
                        { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy", enabled = package.loaded.lazy ~= nil },
                        { icon = " ", key = "<C-q>", desc = "Quit", action = ":qa" },
                    },
                    -- Used by the `header` section
                    --                 header = [[
                    -- ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
                    -- ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
                    -- ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
                    -- ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
                    -- ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
                    -- ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝]],
                    header =
                        "██╗   ██╗ ██╗   ██╗  ████╗           Z\n" ..
                        "██║   ██║ ╚██╗ ██╔╝ ██╔═██╗      Z    \n" ..
                        "████████║  ╚████╔╝  ██████║   z       \n" ..
                        "██╔═══██║   ╚██╔╝   ██╔═██║ z         \n" ..
                        "██║   ██║    ██║    ██║ ██║           \n" ..
                        "╚═╝   ╚═╝    ╚═╝    ╚═╝ ╚═╝           \n",
                },
                -- item field formatters
                formats = {
                    icon = function(item)
                        if item.file and item.icon == "file" or item.icon == "directory" then
                            return Snacks.dashboard.icon(item.file, item.icon)
                        end
                        return { item.icon, width = 2, hl = "icon" }
                    end,
                    footer = { "%s", align = "center" },
                    header = { "%s", align = "center" },
                    file = function(item, ctx)
                        local fname = vim.fn.fnamemodify(item.file, ":~")
                        fname = ctx.width and #fname > ctx.width and vim.fn.pathshorten(fname) or fname
                        if #fname > ctx.width then
                            local dir = vim.fn.fnamemodify(fname, ":h")
                            local file = vim.fn.fnamemodify(fname, ":t")
                            if dir and file then
                                file = file:sub(-(ctx.width - #dir - 2))
                                fname = dir .. "/…" .. file
                            end
                        end
                        local dir, file = fname:match("^(.*)/(.+)$")
                        return dir and { { dir .. "/", hl = "dir" }, { file, hl = "file" } } or
                            { { fname, hl = "file" } }
                    end,
                },
                -- sections = {
                --     { section = "header" },
                --     { section = "keys",   gap = 1, padding = 1 },
                --     { section = "startup" },
                -- },
                -- sections = {
                --     { section = "header" },
                --     {
                --         pane = 2,
                --         section = "terminal",
                --         cmd = "colorscript -e square",
                --         height = 5,
                --         padding = 1,
                --     },
                --     { section = "keys", gap = 1, padding = 1 },
                --     { pane = 2, icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
                --     { pane = 2, icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
                --     {
                --         pane = 2,
                --         icon = " ",
                --         title = "Git Status",
                --         section = "terminal",
                --         enabled = function()
                --             return Snacks.git.get_root() ~= nil
                --         end,
                --         cmd = "git status --short --branch --renames",
                --         height = 5,
                --         padding = 1,
                --         ttl = 5 * 60,
                --         indent = 3,
                --     },
                --     { section = "startup" },
                -- },
                sections = {
                    { section = "header" },
                    { section = "keys", gap = 0 },
                    { padding = 1 },
                    { icon = " ", title = "Recent Files", section = "recent_files", indent = 2, padding = 1 },
                    { icon = " ", title = "Projects", section = "projects", indent = 2, padding = 1 },
                    { section = "startup" },
                },

            },
        },
        keys = {
            -- lazygit
            { "<leader>gg", function() require('snacks').lazygit() end,                             desc = "Open LazyGit" },

            -- picker use <leader>f prefix (telescope use <leader>F)
            { "<leader>ff", function() Snacks.picker.smart() end,                                   desc = "Smart find file" },
            { "<leader>fb", function() Snacks.picker.buffers({ sort_lastused = true }) end,         desc = "Find buffers" },
            { "<leader>fo", function() Snacks.picker.recent() end,                                  desc = "Find recent file" },
            { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find nvim Config File" },
            { "<leader>fF", function() Snacks.picker.files() end,                                   desc = "Find Files" },
            { "<leader>fG", function() Snacks.picker.git_files() end,                               desc = "Find Git Files" },
            { "<leader>fp", function() Snacks.picker.projects() end,                                desc = "Projects" },

            -- Grep
            { "<leader>fw", function() Snacks.picker.grep() end,                                    desc = "Grep" },
            { "<leader>fW", function() Snacks.picker.grep_word() end,                               desc = "Visual selection or word",         mode = { "n", "x" } },
            { "<leader>fB", function() Snacks.picker.grep_buffers() end,                            desc = "Grep Open Buffers" },
            { "<leader>fl", function() Snacks.picker.lines() end,                                   desc = "Buffer Lines" },

            -- Search
            { '<leader>f"', function() Snacks.picker.registers() end,                               desc = "Registers" },
            { '<leader>f/', function() Snacks.picker.search_history() end,                          desc = "Search History" },
            { "<leader>fa", function() Snacks.picker.autocmds() end,                                desc = "Autocmds" },
            { "<leader>f:", function() Snacks.picker.command_history() end,                         desc = "Command History" },
            { "<leader>fC", function() Snacks.picker.commands() end,                                desc = "Commands" },

            { "<leader>fd", function() Snacks.picker.diagnostics() end,                             desc = "Diagnostics" },
            { "<leader>fD", function() Snacks.picker.diagnostics_buffer() end,                      desc = "Find diagnostic in current buffer" },
            { "<leader>fh", function() Snacks.picker.help() end,                                    desc = "Find in help" },
            { "<leader>fH", function() Snacks.picker.highlights() end,                              desc = "Find highlight" },

            { "<leader>fi", function() Snacks.picker.icons() end,                                   desc = "Find icon" },
            { "<leader>fj", function() Snacks.picker.jumps() end,                                   desc = "Find jump" },
            { "<leader>fk", function() Snacks.picker.keymaps({ hl = true }) end,                    desc = "Find keymap" },

            { "<leader>fO", function() Snacks.picker.loclist() end,                                 desc = "Location List" },
            { "<leader>fM", function() Snacks.picker.marks() end,                                   desc = "Find mark" },
            -- { "<leader>fm", function() Snacks.picker.man() end,                                     desc = "Man Pages" },

            { "<leader>fP", function() Snacks.picker.lazy() end,                                    desc = "Search for Plugin Spec" },
            { "<leader>fq", function() Snacks.picker.qflist() end,                                  desc = "Quickfix List" },

            { "<leader>fR", function() Snacks.picker.resume() end,                                  desc = "Resume" },

            { "<leader>fr", function() Snacks.rename.rename_file() end,                             desc = "Rename File" },
            { "<leader>R",  function() Snacks.rename.rename_file() end,                             desc = "Rename File" },

            { "<leader>fu", function() Snacks.picker.undo() end,                                    desc = "Undo History" },
            { "<leader>ft", function() Snacks.picker.colorschemes() end,                            desc = "Colorschemes" },

            { "<leader>fL", function() Snacks.picker.picker_layouts() end,                          desc = "Find picker layout" },
            { "<leader>fN", function() Snacks.picker.notifications() end,                           desc = "Find notification(Snacks)" },
            { "<leader>fS", function() Snacks.picker.lsp_workspace_symbols() end,                   desc = "Find workspace symbol" },
            {
                "<leader>fs",
                function()
                    local bufnr = vim.api.nvim_get_current_buf()
                    local clients = vim.lsp.get_clients({ bufnr = bufnr })

                    local function has_lsp_symbols()
                        for _, client in ipairs(clients) do
                            if client.server_capabilities.documentSymbolProvider then
                                return true
                            end
                        end
                        return false
                    end

                    if has_lsp_symbols() then
                        Snacks.picker.lsp_symbols({
                            tree = true,
                            -- filter = {
                            --     default = {
                            --         "Function",
                            --         "Method",
                            --         "Class",
                            --     }
                            -- }
                        })
                    else
                        Snacks.picker.treesitter()
                    end
                end,
                desc = "Find symbol in current buffer"
            },

            -- 草稿
            { "<leader>fx", function() Snacks.scratch() end,        desc = "Toggle Scratch Buffer" },
            { "<leader>fy", function() Snacks.scratch.select() end, desc = "Select Scratch Buffer" },

            { "<leader>fK", function() Snacks.image.hover() end,    desc = "Display image in hover" },
            {
                "<leader>fT",
                function()
                    local function get_tabs()
                        local tabs = {}
                        local tabpages = vim.api.nvim_list_tabpages()
                        for i, tabpage in ipairs(tabpages) do
                            local wins = vim.api.nvim_tabpage_list_wins(tabpage)
                            local cur_win = vim.api.nvim_tabpage_get_win(tabpage)
                            local buf = vim.api.nvim_win_get_buf(cur_win)
                            local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ":t")
                            if name == "" then
                                name = "[No Name]"
                            end

                            local preview_lines = {}
                            table.insert(preview_lines,
                                ("Tab %d: %d window%s"):format(i, #wins, #wins == 1 and "" or "s"))
                            table.insert(preview_lines, ("%-6s %-8s %s"):format("WinID", "Buf#", "File"))
                            table.insert(preview_lines, string.rep("-", 40))
                            for _, win in ipairs(wins) do
                                local win_buf = vim.api.nvim_win_get_buf(win)
                                local bufname = vim.api.nvim_buf_get_name(win_buf)
                                if bufname == "" then
                                    bufname = "[No Name]"
                                end
                                bufname = vim.fn.fnamemodify(bufname, ":~:.") -- relative to cwd, or ~
                                local win_marker = (win == cur_win) and "->" or "  "
                                table.insert(preview_lines, ("%s %-6d %-8d %s"):format(win_marker, win, win_buf, bufname))
                            end
                            if #wins == 0 then
                                table.insert(preview_lines, "No windows in tab")
                            end

                            table.insert(tabs, {
                                idx = i,
                                text = ("Tab %d: %s"):format(i, name),
                                tabnr = i,
                                tabpage = tabpage,
                                preview = {
                                    text = table.concat(preview_lines, "\n"),
                                    ft = "text",
                                },
                            })
                        end
                        return tabs
                    end

                    local items = get_tabs()
                    Snacks.picker({
                        title = "Tabs",
                        items = items,
                        format = "text",
                        confirm = function(picker, item)
                            picker:close()
                            vim.cmd(("tabnext %d"):format(item.tabnr))
                        end,
                        preview = "preview",
                        actions = {
                            close_tab = function(picker, item)
                                picker:close()
                                vim.cmd(("tabclose %d"):format(item.tabnr))
                            end,
                        },
                        win = {
                            input = {
                                keys = {
                                    ["d"] = "close_tab",
                                },
                            },
                        },
                    })
                end,
                desc = "Display image in hover"
            },

        },
    },
    {
        "folke/todo-comments.nvim",
        -- optional = true,
        lazy = true,
        keys = {
            {
                "<leader>fz",
                function()
                    if vim.bo.filetype == "markdown" then
                        Snacks.picker.grep_buffers({
                            finder = "grep",
                            format = "file",
                            prompt = " ",
                            search = "^\\s*- \\[ \\]",
                            regex = true,
                            live = false,
                            args = { "--no-ignore" },
                            on_show = function()
                                vim.cmd.stopinsert()
                            end,
                            buffers = false,
                            supports_live = false,
                            layout = "ivy",
                        })
                    else
                        Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME", "HACK" }, layout = "select", buffers = true })
                    end
                end,
                desc = "Todo/Fix/Fixme/HACK"
            }
        },
    }
}
