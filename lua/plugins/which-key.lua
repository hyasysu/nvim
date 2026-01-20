return {
	"folke/which-key.nvim",
	event = "VeryLazy",
	opts_extend = { "spec", "disable.ft", "disable.bt" },
	config = function(_, opts)
		local wk = require("which-key")
		local get_icon = require("util.icons").get_icon
		wk.setup(opts)
		wk.add({
			{ "<leader>e", group = " Neotree", icon = get_icon("ui", "NeoTree", 1) },
			{ "<leader>f", group = "Find",     icon = get_icon("ui", "Search", 1) },
			{ "<leader>t", group = "Terminal", icon = get_icon("ui", "Terminal", 1) },
			{ "<leader>l", group = "LSP",      icon = get_icon("ui", "ActiveLSP", 1) },
			{ "<leader>u", group = "UI/UX",    icon = get_icon("ui", "Window", 1) },
		}, {
			mode = { "n", "v" },
		})
	end,
}
