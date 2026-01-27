-- Events:
-- PersistenceLoadPre: before loading a session
-- PersistenceLoadPost: after loading a session
-- PersistenceSavePre: before saving a session
-- PersistenceSavePost: after saving a session
return {
    "folke/persistence.nvim",
    event = "BufReadPre",                              -- this will only start session saving when an actual file was opened
    opts = {
        dir = vim.fn.stdpath("state") .. "/sessions/", -- directory where session files are saved
        -- minimum number of file buffers that need to be open to save
        -- Set to 0 to always save
        need = 1,
        branch = true, -- use git branch to save session
    },
    keys = {
        { "<Leader>ss", function() require("persistence").load() end,                desc = "Load session for current dir" },
        { "<Leader>sS", function() require("persistence").select() end,              desc = "Select session to load" },
        { "<Leader>sl", function() require("persistence").load({ last = true }) end, desc = "Load last session" },
        { "<Leader>sd", function() require("persistence").stop() end,                desc = "Stop persistence (don't save session on exit)" },
    }
}
