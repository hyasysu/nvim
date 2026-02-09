local function set_breakpoint()
    local ok, persistence_bp = pcall(require, "persistent-breakpoints.api")
    if ok and persistence_bp then
        persistence_bp.toggle_breakpoint()
        vim.notify("Successed set_breakpoint", vim.log.levels.INFO)
    else
        require("dap").toggle_breakpoint()
    end
end

local function set_conditional_breakpoint()
    vim.ui.input({ prompt = "[Condition]> " }, function(condition)
        if condition then
            require("dap").set_breakpoint(condition)
            local ok, persistence_bp = pcall(require, "persistent-breakpoints.api")
            if ok and persistence_bp then
                persistence_bp.breakpoints_changed_in_current_buffer()
            end
        end
    end)
end

local function set_log_point()
    local ok, persistence_bp = pcall(require, "persistent-breakpoints.api")
    if ok and persistence_bp then
        persistence_bp.set_log_point()
    else
        require("dap").set_breakpoint(nil, nil, vim.fn.input("Log point message: "))
    end
end

local function clear_all_breakpoints()
    local ok, persistence_bp = pcall(require, "persistent-breakpoints.api")
    if ok and persistence_bp then
        persistence_bp.clear_all_breakpoints()
    else
        require("dap").clear_breakpoints()
    end
end

return {
    "mfussenegger/nvim-dap",
    lazy = true,
    keys = {
        { "<F5>",       function() require("dap").continue() end,      desc = "Debugger: Start",                mode = { "n" } },
        { "<F17>",      function() require("dap").terminate() end,     desc = "Debugger: Stop (Shift+F5)",      mode = { "n" } },              -- Shift+F5
        { "<F29>",      function() require("dap").restart_frame() end, desc = "Debugger: Restart (Control+F5)", mode = { "n" } },              -- Control+F5
        { "<F6>",       function() require("dap").pause() end,         desc = "Debugger: Pause",                mode = { "n" } },
        { "<F10>",      function() require("dap").step_over() end,     desc = "Debugger: Step Over",            mode = { "n" } },
        { "<F11>",      function() require("dap").step_into() end,     desc = "Debugger: Step Into",            mode = { "n" } },
        { "<F23>",      function() require("dap").step_out() end,      desc = "Debugger: Step Out (Shift+F11)", mode = { "n" } },              -- Shift+F11

        -- Set on `persistent-breakpoints.nvim`
        -- { "<F9>",       set_breakpoint,                                desc = "Debugger: Toggle Breakpoint",                 mode = { "n" } },
        -- { "<F21>",      set_conditional_breakpoint,                    desc = "Debugger: Conditional Breakpoint (Shift+F9)", mode = { "n" } }, -- Shift+F9
        -- { "<Leader>db", set_breakpoint,                                desc = "Toggle Breakpoint (F9)",                      mode = { "n" } },
        -- { "<Leader>dB", set_conditional_breakpoint,                    desc = "Conditional Breakpoint (S-F9)",               mode = { "n" } },
        -- { "<Leader>dC", clear_all_breakpoints,                         desc = "Clear Breakpoints",                           mode = { "n" } },

        { "<Leader>dc", function() require("dap").continue() end,      desc = "Start/Continue (F5)",            mode = { "n" } },
        { "<Leader>di", function() require("dap").step_into() end,     desc = "Step Into (F11)",                mode = { "n" } },
        { "<Leader>do", function() require("dap").step_over() end,     desc = "Step Over (F10)",                mode = { "n" } },
        { "<Leader>dO", function() require("dap").step_out() end,      desc = "Step Out (S-F11)",               mode = { "n" } },
        { "<Leader>dq", function() require("dap").close() end,         desc = "Close Session",                  mode = { "n" } },
        { "<Leader>dQ", function() require("dap").terminate() end,     desc = "Terminate Session (S-F5)",       mode = { "n" } },
        { "<Leader>dp", function() require("dap").pause() end,         desc = "Pause (F6)",                     mode = { "n" } },
        { "<Leader>dr", function() require("dap").restart_frame() end, desc = "Restart (C-F5)",                 mode = { "n" } },
        { "<Leader>dR", function() require("dap").repl.toggle() end,   desc = "Toggle REPL",                    mode = { "n" } },
        { "<Leader>ds", function() require("dap").run_to_cursor() end, desc = "Run To Cursor",                  mode = { "n" } },
        { "<Leader>dl", set_log_point,                                 desc = "Set Log Point",                  mode = { "n" } },
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
            event = { "BufReadPost" },
            keys = {
                { "<F9>",       set_breakpoint,             desc = "Debugger: Toggle Breakpoint",                 mode = { "n" } },
                { "<F21>",      set_conditional_breakpoint, desc = "Debugger: Conditional Breakpoint (Shift+F9)", mode = { "n" } }, -- Shift+F9
                { "<Leader>db", set_breakpoint,             desc = "Toggle Breakpoint (F9)",                      mode = { "n" } },
                { "<Leader>dB", set_conditional_breakpoint, desc = "Conditional Breakpoint (S-F9)",               mode = { "n" } },
                { "<Leader>dC", clear_all_breakpoints,      desc = "Clear Breakpoints",                           mode = { "n" } },
            },
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

        local dap = require("dap")
        -- NOTE: configure adapters
        dap.adapters.codelldb = {
            type = "executable",
            command = "codelldb", -- or if not in $PATH: "/absolute/path/to/codelldb"
        }
        dap.adapters.cppdbg = {
            id = "cppdbg",
            type = "executable",
            command = "OpenDebugAD7", -- or if not in $PATH: "/absolute/path/to/OpenDebugAD7"
            options = { detached = false },
        }
        dap.adapters.gdb = {
            type = "executable",
            command = "gdb",
            args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
        }

        dap.adapters.cudagdb = {
            type = "executable",
            command = "cuda-gdb",
        }

        -- NOTE: filetype configurations
        dap.configurations.cuda = {
            {
                name = "Launch (cuda-gdb)",
                type = "cudagdb",
                request = "launch",
                program = function()
                    return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                end,
                cwd = "${workspaceFolder}",
                stopOnEntry = false,
            },
            {
                name = "Launch (gdb)",
                type = "cppdbg",
                MIMode = "gdb",
                request = "launch",
                miDebuggerPath = "gdb",
                program = function()
                    return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                end,
                cwd = "${workspaceFolder}",
                setupCommands = {
                    {
                        description = "Enable pretty-printing for gdb",
                        ignoreFailures = true,
                        text = "-enable-pretty-printing",
                    },
                },
                stopAtBeginningOfMainSubprogram = false,
            },
        }
        dap.configurations.cpp = dap.configurations.cpp or {}

        vim.list_extend(dap.configurations.cpp, {
            {
                name = "Launch (codelldb)",
                type = "codelldb",
                request = "launch",
                program = function()
                    return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                end,
                cwd = "${workspaceFolder}",
                stopOnEntry = false,
            },
            {
                name = "Launch (gdb-cppdbg)",
                type = "cppdbg",
                MIMode = "gdb",
                request = "launch",
                miDebuggerPath = "gdb",
                program = function()
                    return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                end,
                cwd = "${workspaceFolder}",
                setupCommands = {
                    {
                        description = "Enable pretty-printing for gdb",
                        ignoreFailures = true,
                        text = "-enable-pretty-printing",
                    },
                },
                stopAtBeginningOfMainSubprogram = false,
            },
            {
                name = "Launch (gdb-gdb)",
                type = "gdb",
                request = "launch",
                MIMode = "gdb",
                miDebuggerPath = "gdb",
                program = function()
                    return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                end,
                cwd = "${workspaceFolder}",
                setupCommands = {
                    {
                        description = "Enable pretty-printing for gdb",
                        ignoreFailures = true,
                        text = "-enable-pretty-printing",
                    },
                },
                stopAtBeginningOfMainSubprogram = false,
            },
            {
                name = "Select and attach to process",
                type = "cppdbg",
                request = "attach",
                program = function()
                    return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
                end,
                pid = function()
                    local name = vim.fn.input("Executable name (filter): ")
                    return require("dap.utils").pick_process({ filter = name })
                end,
                cwd = "${workspaceFolder}",
            },
        })

        dap.configurations.python = dap.configurations.python or {}
        vim.list_extend(dap.configurations.python, {
            {
                type = "python",
                request = "launch",
                name = "file:args (cwd)",
                program = "${file}",
                args = function()
                    local args_string = vim.fn.input("Arguments: ")
                    local utils = require("dap.utils")
                    if utils.splitstr and vim.fn.has("nvim-0.10") == 1 then
                        return utils.splitstr(args_string)
                    end
                    return vim.split(args_string, " +")
                end,
                console = "integratedTerminal",
                cwd = vim.fn.getcwd(),
            },
            {
                MIMode = "gdb",
                args = {
                    "${workspaceFolder}/Gaudi/Gaudi/scripts/gaudirun.py",
                    "${file}",
                },
                cwd = "${fileDirname}",
                externalConsole = false,
                miDebuggerPath = "${workspaceFolder}/Moore/gdb",
                name = "GDB: gaudirun.py (Moore)",
                program = function()
                    local result = vim.system({ "utils/run-env", "Gaudi", "which", "python3" }, { text = true }):wait()
                    return vim.trim(result.stdout)
                end,
                request = "launch",
                setupCommands = {
                    {
                        description = "Enable pretty-printing for gdb",
                        ignoreFailures = true,
                        text = "-enable-pretty-printing",
                    },
                },
                type = "cppdbg",
                preLaunchTask = "make fast/Rec",
            },
            {
                MIMode = "gdb",
                args = {
                    "${workspaceFolder}/Gaudi/Gaudi/scripts/gaudirun.py",
                    "${file}",
                },
                cwd = "${fileDirname}",
                externalConsole = false,
                -- miDebuggerPath = '${workspaceFolder}/${input:lhcbProject}/gdb',
                miDebuggerPath = function()
                    local project = vim.fn.input("Project name: ", "Moore")
                    return "${workspaceFolder}/" .. project .. "/gdb"
                end,
                name = "GDB: gaudirun.py",
                program = function()
                    local result = vim.system({ "utils/run-env", "Gaudi", "which", "python3" }, { text = true }):wait()
                    return vim.trim(result.stdout)
                end,
                request = "launch",
                setupCommands = {
                    {
                        description = "Enable pretty-printing for gdb",
                        ignoreFailures = true,
                        text = "-enable-pretty-printing",
                    },
                },
                type = "cppdbg",
            },
            {
                MIMode = "gdb",
                args = {
                    "qmtexec",
                    "${file}",
                },
                cwd = "${fileDirname}",
                externalConsole = false,
                miDebuggerPath = "${workspaceFolder}/Gaudi/gdb",
                name = "GDB: qmtexec",
                program = function()
                    local project = vim.fn.input("Project name: ", "Moore")
                    return "${workspaceFolder}/" .. project .. "/run"
                end,
                request = "launch",
                setupCommands = {
                    {
                        description = "Enable pretty-printing for gdb",
                        ignoreFailures = true,
                        text = "-enable-pretty-printing",
                    },
                },
                type = "cppdbg",
            },
            {
                MIMode = "gdb",
                miDebuggerPath = "${workspaceFolder}/Gaudi/Gaudi/gdb",
                name = "GDB: attach",
                processId = "${command:pickProcess}",
                program = "/cvmfs/lhcb.cern.ch/lib/lcg/releases/Python/3.9.12-9a1bc/x86_64-el9-gcc13-opt/bin/python",
                request = "attach",
                setupCommands = {
                    {
                        description = "Enable pretty-printing for gdb",
                        ignoreFailures = true,
                        text = "-enable-pretty-printing",
                    },
                },
                type = "cppdbg",
            },
        })
        dap.configurations.qmt = dap.configurations.python

        vim.fn.sign_define('DapBreakpoint', { text = '🔴', texthl = '', linehl = '', numhl = '' })
        vim.fn.sign_define('DapBreakpointCondition', { text = '⭕', texthl = '', linehl = '', numhl = '' })
        vim.fn.sign_define('DapBreakpointRejected', { text = '🚫', texthl = '', linehl = '', numhl = '' })
        vim.fn.sign_define('DapLogPoint', { text = '󰛿', texthl = '', linehl = '', numhl = '' })
        vim.fn.sign_define('DapStopped', { text = '👉', texthl = '', linehl = '', numhl = '' })
    end,
}
