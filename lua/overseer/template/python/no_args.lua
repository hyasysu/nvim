return {
    name = "run python(no args)",
    params = {
        cmd = { optional = true, type = "string", default = "python3" },
        cwd = { optional = true, type = "string" },
    },
    builder = function(params)
        return {
            name = vim.fn.expand "%:t",
            cmd = params.cmd,
            args = { vim.fn.expand "%:p" },
            cwd = vim.fn.expand "%:p:h",
            components = {
                "task_list_on_complete",
                "on_exit_set_status",
                "on_complete_notify",
            },
        }
    end,
    condition = {
        filetype = { "python" },
    },
}
