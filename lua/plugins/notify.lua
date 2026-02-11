return {
    "rcarriga/nvim-notify",
    events = { "VimEnter" },
    enabled = require("core.options").notify.use_nvim_notify,
    config = function()
        local notify = require("notify")
        vim.notify = notify
        notify.setup {
            background_colour = "#202020",
            timeout = 2000,
            stages = "fade_in_slide_out",
        }
    end
}
