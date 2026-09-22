return {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		"nvim-tree/nvim-web-devicons",
	},
	config = function()
		local telescope = require("telescope")
		telescope.setup({
			defaults = {
				mappings = {
					i = { ["<C-u>"] = false, ["<C-d>"] = false },
				},
			},
		})
		pcall(telescope.load_extension, "fzf")

		local builtin = require("telescope.builtin")
		local map = vim.keymap.set
		map("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
		map("n", "<leader>fg", builtin.live_grep, { desc = "Grep (live)" })
		map("n", "<leader>fb", builtin.buffers, { desc = "Find buffers" })
		map("n", "<leader>fh", builtin.help_tags, { desc = "Help tags" })
		map("n", "<leader>fr", builtin.oldfiles, { desc = "Recent files" })
		map("n", "<leader>fw", builtin.grep_string, { desc = "Grep word under cursor" })
		map("n", "<leader>fd", builtin.diagnostics, { desc = "Diagnostics" })
		map("n", "<leader>/", function()
			builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({ winblend = 10, previewer = false }))
		end, { desc = "Fuzzy search in buffer" })
	end,
}
