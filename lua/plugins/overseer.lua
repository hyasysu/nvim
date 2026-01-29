return {
    'stevearc/overseer.nvim',
    cmd = {
        "OverseerOpen",
        "OverseerClose",
        "OverseerToggle",
        "OverseerSaveBundle",
        "OverseerLoadBundle",
        "OverseerDeleteBundle",
        "OverseerRunCmd",
        "OverseerRun",
        "OverseerInfo",
        "OverseerBuild",
        "OverseerQuickAction",
        "OverseerTaskAction ",
        "OverseerClearCache",
    },
    keys = {
        { "<leader>ot", "<cmd>OverseerToggle<CR>",      desc = "Toggle Overseer" },
        { "<leader>oc", "<cmd>OverseerRunCmd<CR>",      desc = "Run Command" },
        { "<leader>or", "<cmd>OverseerRun<CR>",         desc = "Run Task" },
        { "<leader>oq", "<cmd>OverseerQuickAction<CR>", desc = "Quick Action" },
        { "<leader>oa", "<cmd>OverseerTaskAction<CR>",  desc = "Task Action" },
        { "<leader>oi", "<cmd>OverseerInfo<CR>",        desc = "Overseer Info" },
    },
    ---@module 'overseer'
    ---@type overseer.SetupOpts
    opts = {
        template_timeout = 8000,
        templates = { "builtin", "make", "cargo", "shell", "python", "run_script", 'cpp' },
        component_aliases = {
            default = {
                { "display_duration", detail_level = 1 },
                "on_output_summarize",
                "on_exit_set_status",
                "on_complete_notify",
            },
            default_vscode = {
                'default',
                'display_duration',
                'task_list_on_start',
                'on_output_quickfix',
                'unique',
            },
        },
        task_list = {
            direction = "right",
            bindings = {
                ["<C-l>"] = false,
                ["<C-h>"] = false,
                ["<C-k>"] = false,
                ["<C-j>"] = false,
                q = "<Cmd>close<CR>",
                K = "IncreaseDetail",
                J = "DecreaseDetail",
                ["<C-p>"] = "ScrollOutputUp",
                ["<C-n>"] = "ScrollOutputDown",
            },
        },
    },
    config = function(_, opts)
        local overseer = require("overseer")
        overseer.setup(opts)

        -- overseer template hooks
        overseer.add_template_hook({
            module = '^make$',
        }, function(task_defn, util)
            util.add_component(task_defn, 'task_list_on_start')
            util.add_component(task_defn, { 'on_output_write_file', filename = task_defn.cmd[1] .. '.log' })
            util.add_component(task_defn, { 'on_output_quickfix', open_on_exit = 'failure' })
            util.add_component(task_defn, 'on_complete_notify')
            util.add_component(task_defn, { 'display_duration', detail_level = 1 })
            util.add_component(task_defn, 'unique')
            util.remove_component(task_defn, 'on_output_summarize')
        end)

        overseer.add_template_hook({
            module = '^remake Fit$',
        }, function(task_defn, util)
            util.add_component(task_defn, 'unique')
        end)

        -- autocmds
        vim.api.nvim_create_autocmd('FileType', {
            pattern = 'OverseerList',
            callback = function()
                vim.opt_local.winfixbuf = true
            end,
        })

        -- vim.api.nvim_create_user_command("WatchRun", function()
        --     overseer.run_template({ name = "run script" }, function(task)
        --         if task then
        --             task:add_component({ "restart_on_save", paths = { vim.fn.expand("%:p") } })
        --             local main_win = vim.api.nvim_get_current_win()
        --             overseer.run_action(task, "open")
        --             vim.api.nvim_set_current_win(main_win)
        --         else
        --             vim.notify("WatchRun not supported for filetype " .. vim.bo.filetype, vim.log.levels.ERROR)
        --         end
        --     end)
        -- end, {})

        -- vim.api.nvim_create_user_command("Grep", function(params)
        --     -- Insert args at the '$*' in the grepprg
        --     local cmd, num_subs = vim.o.grepprg:gsub("%$%*", params.args)
        --     if num_subs == 0 then
        --         cmd = cmd .. " " .. params.args
        --     end
        --     local task = overseer.new_task({
        --         cmd = vim.fn.expandcmd(cmd),
        --         components = {
        --             {
        --                 "on_output_quickfix",
        --                 errorformat = vim.o.grepformat,
        --                 open = not params.bang,
        --                 open_height = 8,
        --                 items_only = true,
        --             },
        --             -- We don't care to keep this around as long as most tasks
        --             { "on_complete_dispose", timeout = 30 },
        --             "default",
        --         },
        --     })
        --     task:start()
        -- end, { nargs = "*", bang = true, complete = "file" })

        -- vim.api.nvim_create_user_command("Make", function(params)
        --     -- Insert args at the '$*' in the makeprg
        --     local cmd, num_subs = vim.o.makeprg:gsub("%$%*", params.args)
        --     if num_subs == 0 then
        --         cmd = cmd .. " " .. params.args
        --     end
        --     local task = require("overseer").new_task({
        --         cmd = vim.fn.expandcmd(cmd),
        --         components = {
        --             { "on_output_quickfix", open = not params.bang, open_height = 8 },
        --             "default",
        --         },
        --     })
        --     task:start()
        -- end, {
        --     desc = "Run your makeprg as an Overseer task",
        --     nargs = "*",
        --     bang = true,
        -- })

        -- vim.api.nvim_create_user_command("OverseerRestartLast", function()
        --     local tasks = overseer.list_tasks({ recent_first = true })
        --     if vim.tbl_isempty(tasks) then
        --         vim.notify("No tasks found", vim.log.levels.WARN)
        --     else
        --         overseer.run_action(tasks[1], "restart")
        --     end
        -- end, {})
    end,
}
