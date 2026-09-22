-- nvim-treesitter's `main` branch (the actively maintained one -- `master`
-- was archived over a year ago) is a minimal rewrite: it only installs
-- parsers. Highlighting/indentation/folding are wired up separately here,
-- exactly as the plugin's own current README documents.

local ensure_installed = {
	"lua", "vim", "vimdoc", "query",
	"c", "cpp", "rust", "python", "go",
	"bash", "json", "yaml", "toml", "markdown", "markdown_inline",
	"html", "css", "javascript", "typescript",
	"regex", "diff", "gitcommit", "gitignore",
}

return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		build = ":TSUpdate",
		lazy = false,
		config = function()
			require("nvim-treesitter").setup()
			require("nvim-treesitter").install(ensure_installed)

			vim.api.nvim_create_autocmd("FileType", {
				callback = function(args)
					local ok = pcall(vim.treesitter.start, args.buf)
					if not ok then
						return
					end
					vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
					vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
					vim.wo[0][0].foldmethod = "expr"
				end,
			})
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-context",
		event = { "BufReadPost", "BufNewFile" },
		opts = { max_lines = 3 },
	},
}
