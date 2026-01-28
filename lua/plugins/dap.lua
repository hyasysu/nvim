local function set_breakpoint()
    local ok, persistence_bp = pcall(require, "persistent-breakpoints.api")
    if ok and persistence_bp then
        persistence_bp.toggle_breakpoint()
    else
        require("dap").toggle_breakpoint()
    end
end

local function set_conditional_breakpoint()
    local ok, persistence_bp = pcall(require, "persistent-breakpoints.api")
    if ok and persistence_bp then
        persistence_bp.set_conditional_breakpoint()
    else
        vim.ui.input({ prompt = "Condition: " }, function(condition)
            if condition then require("dap").set_breakpoint(condition) end
        end)
    end
end

return {
    "mfussenegger/nvim-dap",
    lazy = true,
    keys = {
        { "<F5>",       function() require("dap").continue() end,      desc = "Debugger: Start",                             mode = { "n" } },
        { "<F17>",      function() require("dap").terminate() end,     desc = "Debugger: Stop (Shift+F5)",                   mode = { "n" } }, -- Shift+F5
        { "<F21>",      set_conditional_breakpoint,                    desc = "Debugger: Conditional Breakpoint (Shift+F9)", mode = { "n" } }, -- Shift+F9
        { "<F29>",      function() require("dap").restart_frame() end, desc = "Debugger: Restart (Control+F5)",              mode = { "n" } }, -- Control+F5
        { "<F6>",       function() require("dap").pause() end,         desc = "Debugger: Pause",                             mode = { "n" } },
        { "<F9>",       set_breakpoint,                                desc = "Debugger: Toggle Breakpoint",                 mode = { "n" } },
        { "<F10>",      function() require("dap").step_over() end,     desc = "Debugger: Step Over",                         mode = { "n" } },
        { "<F11>",      function() require("dap").step_into() end,     desc = "Debugger: Step Into",                         mode = { "n" } },
        { "<F23>",      function() require("dap").step_out() end,      desc = "Debugger: Step Out (Shift+F11)",              mode = { "n" } }, -- Shift+F11

        { "<Leader>db", set_breakpoint,                                desc = "Toggle Breakpoint (F9)",                      mode = { "n" } },
        { "<Leader>dB", set_conditional_breakpoint,                    desc = "Conditional Breakpoint (S-F9)",               mode = { "n" } },
        {
            "<Leader>dC",
            function()
                local ok, persistence_bp = pcall(require, "persistent-breakpoints.api")
                if ok and persistence_bp then
                    persistence_bp.clear_all_breakpoints()
                else
                    require("dap").clear_breakpoints()
                end
            end,
            desc = "Clear Breakpoints",
            mode = { "n" }
        },
        { "<Leader>dc", function() require("dap").continue() end,      desc = "Start/Continue (F5)",      mode = { "n" } },
        { "<Leader>di", function() require("dap").step_into() end,     desc = "Step Into (F11)",          mode = { "n" } },
        { "<Leader>do", function() require("dap").step_over() end,     desc = "Step Over (F10)",          mode = { "n" } },
        { "<Leader>dO", function() require("dap").step_out() end,      desc = "Step Out (S-F11)",         mode = { "n" } },
        { "<Leader>dq", function() require("dap").close() end,         desc = "Close Session",            mode = { "n" } },
        { "<Leader>dQ", function() require("dap").terminate() end,     desc = "Terminate Session (S-F5)", mode = { "n" } },
        { "<Leader>dp", function() require("dap").pause() end,         desc = "Pause (F6)",               mode = { "n" } },
        { "<Leader>dr", function() require("dap").restart_frame() end, desc = "Restart (C-F5)",           mode = { "n" } },
        { "<Leader>dR", function() require("dap").repl.toggle() end,   desc = "Toggle REPL",              mode = { "n" } },
        { "<Leader>ds", function() require("dap").run_to_cursor() end, desc = "Run To Cursor",            mode = { "n" } },
        {
            "<Leader>dl",
            function()
                local ok, persistence_bp = pcall(require, "persistent-breakpoints.api")
                if ok and persistence_bp then
                    persistence_bp.set_log_point()
                else
                    require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
                end
            end,
            desc = "Set Log Point",
            mode = { "n" }
        },
    },
    dependencies = {
        {
            "jay-babu/mason-nvim-dap.nvim",
            dependencies = { "nvim-dap", "williamboman/mason.nvim" },
            cmd = { "DapInstall", "DapUninstall" },
            opts_extend = { "ensure_installed" },
            opts = { ensure_installed = {}, handlers = {} },
        },
        {
            "rcarriga/nvim-dap-ui",
            lazy = true,
            keys = {
                { "<Leader>du", function() require("dapui").toggle() end,         desc = "Toggle Debugger UI", mode = { "n" } },
                { "<Leader>dh", function() require("dap.ui.widgets").hover() end, desc = "Debugger Hover",     mode = { "n" } },
                {
                    "<Leader>dE",
                    function()
                        vim.ui.input({ prompt = "Expression: " }, function(expr)
                            if expr then require("dapui").eval(expr, { enter = true }) end
                        end)
                    end,
                    desc = "Evaluate Input",
                    mode = { "n" }
                },
                {
                    "<Leader>dE",
                    function() require("dapui").eval() end,
                    desc = "Evaluate Input",
                    mode = { "v" }
                },
            },
            dependencies = { { "nvim-neotest/nvim-nio", lazy = true } },
            opts = { floating = { border = "rounded" } },
            config = function(_, opts)
                local dap, dapui = require "dap", require "dapui"
                dap.listeners.after.event_initialized.dapui_config = function() dapui.open() end
                dap.listeners.before.event_terminated.dapui_config = function() dapui.close() end
                dap.listeners.before.event_exited.dapui_config = function() dapui.close() end
                dapui.setup(opts)
            end,
        },
        {
            "rcarriga/cmp-dap",
            lazy = true,
            enabled = function()
                return require("core.options").cmp == "nvim.cmp"
            end,
            dependencies = { "hrsh7th/nvim-cmp" },
            config = function(_, _)
                require("cmp").setup.filetype({ "dap-repl", "dapui_watches", "dapui_hover" }, {
                    sources = {
                        { name = "dap" },
                    },
                })
            end,
        },
        {
            "Weissle/persistent-breakpoints.nvim",
            lazy = true,
            opts = {
                load_breakpoints_event = { "BufReadPost" },
            },
        },
        {
            "theHamsta/nvim-dap-virtual-text",
            lazy = true,
            opts = {
                enabled = true,                     -- enable this plugin (the default)
                enabled_commands = true,            -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
                highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
                highlight_new_as_changed = false,   -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
                show_stop_reason = true,            -- show stop reason when stopped for exceptions
                commented = true,                   -- prefix virtual text with comment string
                only_first_definition = true,       -- only show virtual text at first definition (if there are multiple)
                all_references = false,             -- show virtual text on all all references of the variable (not only definitions)
                clear_on_continue = false,          -- clear virtual text on "continue" (might cause flickering when stepping)

                -- experimental features:
                all_frames = false, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
                virt_lines = true,  -- show virtual lines instead of virtual text (will flicker!)
            },
        }
    },
    config = function()
        local parser, cleaner
        local vscode = require "dap.ext.vscode"
        vscode.json_decode = function(str)
            if cleaner == nil then
                local plenary_avail, plenary = pcall(require, "plenary.json")
                cleaner = plenary_avail and function(s) return plenary.json_strip_comments(s, {}) end or false
            end
            if not parser then
                local json5_avail, json5 = pcall(require, "json5")
                parser = json5_avail and json5.parse or vim.json.decode
            end
            if type(cleaner) == "function" then str = cleaner(str) end
            local parsed_ok, parsed = pcall(parser, str)
            if not parsed_ok then
                vim.notify("Error parsing `.vscode/launch.json`.", vim.log.levels.ERROR,
                    { icon = require('util.icons').get_icon("dap", "Debugger"), title = "DAP" })
                parsed = {}
            end
            return parsed
        end

        vim.fn.sign_define('DapBreakpoint', { text = '🔴', texthl = '', linehl = '', numhl = '' })
        vim.fn.sign_define('DapBreakpointCondition', { text = '⭕', texthl = '', linehl = '', numhl = '' })
        vim.fn.sign_define('DapBreakpointRejected', { text = '🚫', texthl = '', linehl = '', numhl = '' })
        vim.fn.sign_define('DapLogPoint', { text = '󰛿', texthl = '', linehl = '', numhl = '' })
        vim.fn.sign_define('DapStopped', { text = '👉', texthl = '', linehl = '', numhl = '' })
    end,
}
