return {
    name = "g++ build (cpp17)",
    builder = function()
        -- Full path to current file (see :help expand())
        local file = vim.fn.expand("%:p")
        local filename = vim.fn.expand '%:t'
        local filename_no_ext = filename:match("(.+)%..+$")
        local cwd = vim.fn.expand("%:p:h")
        local target = cwd .. "/build/overseer/" .. filename_no_ext .. ".out"
        return {
            cmd = { "g++", file, "-std=c++17", "-o", target },
            -- attach a component to the task that will pipe the output to the quickfix.
            -- components customize the behavior of a task.
            -- see :help overseer-components for a list of all components.
            components = {
                -- "task_list_on_failed",
                { "on_output_quickfix", open = true },
                'on_exit_set_status',
                'on_complete_notify',
            },
        }
    end,
    -- provide a condition so the task will only be available when you are in a c++ file
    condition = {
        filetype = { "cpp" },
    },
}
