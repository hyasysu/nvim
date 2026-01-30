local M = {
    filetype_map_func = {}
}

local split = function()
    vim.cmd("set splitbelow")
    vim.cmd("sp")
    vim.cmd("res -5")
end

M.filetype_map_func = {
    dart = function()
        vim.cmd(":FlutterRun -d " .. vim.g.flutter_default_device .. " " .. vim.g.flutter_run_args)
    end,
    markdown = function()
        vim.cmd(":InstantMarkdownPreview")
    end,
    c = function()
        split()
        vim.cmd("term gcc '%' -o '%<' && .'/%<' && rm '%<'")
        vim.cmd('startinsert!')
    end,
    cpp = function()
        split()
        vim.cmd("term g++ '%' -o '%<' && .'/%<' && rm '%<'")
        vim.cmd('startinsert!')
    end,
    javascript = function()
        split()
        vim.cmd("term node %")
        vim.cmd('startinsert!')
    end,
    lua = function()
        split()
        vim.cmd("term luajit %")
        vim.cmd('startinsert!')
    end,
    tex = function()
        vim.cmd(":VimtexCompile")
    end,
    python = function()
        split()
        vim.cmd("term python3 %")
        vim.cmd('startinsert!')
    end,
    sh = function()
        split()
        vim.cmd("term bash %")
        vim.cmd('startinsert!')
    end,
}

function M.compileRun()
    vim.cmd("w")
    -- check file type
    local ft = vim.bo.filetype
    local func = M.filetype_map_func[ft]
    if func then
        func()
    end
end

return M
