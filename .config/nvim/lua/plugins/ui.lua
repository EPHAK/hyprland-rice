return {
	{
		"nvim-tree/nvim-tree.lua",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		keys = {
			{ "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Toggle file explorer" },
		},
		opts = {
			view = { width = 32 },
			renderer = { group_empty = true },
			filters = { dotfiles = false },
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		event = "VeryLazy",
		opts = {
			options = {
				theme = "catppuccin-mocha",
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
			},
		},
	},
	{
		"akinsho/bufferline.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		event = "VeryLazy",
		keys = {
			{ "<S-l>", "<cmd>BufferLineCycleNext<CR>" },
			{ "<S-h>", "<cmd>BufferLineCyclePrev<CR>" },
		},
		opts = {
			options = {
				diagnostics = "nvim_lsp",
				offsets = {
					{ filetype = "NvimTree", text = "Explorer", highlight = "Directory", text_align = "left" },
				},
			},
		},
	},
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {},
	},
}
