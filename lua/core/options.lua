vim.opt.number = true          -- Show line numbers
vim.opt.relativenumber = false -- Do not show relative line numbers
vim.opt.signcolumn = "yes"     -- Always show the sign column

vim.opt.ignorecase = true      -- Ignore case in search patterns
vim.opt.smartcase = true       -- Override 'ignorecase' if search pattern contains uppercase letters

vim.opt.tabstop = 4            -- Number of spaces that a <Tab> counts formatted
vim.opt.shiftwidth = 4         -- Number of spaces to use for each step of (auto)indent
vim.opt.expandtab = true       -- Use spaces instead of tabs

-- custom paste function
local function paste_from_unnamed()
    local lines = vim.split(vim.fn.getreg(""), "\n", { plain = true })
    if #lines == 0 then
        lines = { "" }
    end
    local rtype = vim.fn.getregtype(""):sub(1, 1)
    return { lines, rtype }
end

local function my_paste(reg)
    return function(lines)
        --[ 返回 “” 寄存器的内容，用来作为 p 操作符的粘贴物 ]
        local content = vim.fn.getreg('"')
        return vim.split(content, '\n')
    end
end

if (os.getenv('SSH_TTY') == nil) then
    --[ 当前环境为本地环境，也包括 wsl ]
    vim.opt.clipboard:append("unnamedplus")
else
    vim.opt.clipboard:append("unnamedplus")
    vim.g.clipboard = {
        name = 'OSC 52',
        copy = {
            ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
            ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
        },
        paste = {
            --[ 小括号里面的内容可能是毫无意义的，但是保持原样可能看起来更好一点 ]
            ["+"] = my_paste("+"),
            ["*"] = my_paste("*"),
        },
    }
end

-- unnamedplus uses the system clipboard
-- vim.opt.clipboard:append("unnamedplus")

-- USE OSC 52
-- vim.g.clipboard = {
--     name = "OSC 52",
--     copy = {
--         ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
--         ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
--     },
--     paste = {
--         ["+"] = require("vim.ui.clipboard.osc52").paste("+"),
--         ["*"] = require("vim.ui.clipboard.osc52").paste("*"),
--     },
-- }
--[[
-- 如果使用的是 WezTerm 終端貼上會有問題，請使用此版本
vim.o.clipboard = "unnamedplus"

local function paste()
  return {
    vim.fn.split(vim.fn.getreg(""), "\n"),
    vim.fn.getregtype(""),
  }
end

vim.g.clipboard = {
  name = "OSC 52",
  copy = {
    ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
    ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
  },
  paste = {
    ["+"] = paste,
    ["*"] = paste,
  },
}]]

vim.opt.smartindent = true   -- Enable smart indentation

vim.opt.cursorline = true    -- Highlight the current line

vim.opt.termguicolors = true -- Enable 24-bit RGB colors

vim.opt.scrolloff = 6        -- Minimum number of screen lines to keep above and below the cursor
vim.opt.sidescrolloff = 8    -- Minimum number of screen columns to keep to the left and right of the cursor

vim.opt.undofile = true      -- Enable persistent undofile

vim.opt.laststatus = 3       -- Always show the status line

vim.opt.splitbelow = true
vim.opt.splitright = true

vim.opt.formatoptions:remove({ "c", "r", "o" }) -- Do not continue comments on new lines

-- ,globals,options,localoptions
vim.o.sessionoptions = "buffers,curdir,folds,help,tabpages,winsize,winpos,terminal"

local default_opts = {
    nerd_fonts = true,
    disable_notify = false,
    transparent_color = true,
    more_cpp_ftdetect = true,
    enable_signature_help = false,
    enable_inlay_hint = true,
    enable_clipboard = true,
    ai_assistant = {
        copilot = {
            enabled = false,
        },
        copilot_lua = {
            enabled = true,
        },
        avante = {
            enabled = true,
        },
        codecompanion = {
            enabled = false,
        }
    },
    cmp = "blink", -- The engineer of cmp ["blink", "nvim.cmp"]
}

return default_opts
