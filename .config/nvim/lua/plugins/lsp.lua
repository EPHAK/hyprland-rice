return {
	{
		"williamboman/mason.nvim",
		build = ":MasonUpdate",
		opts = {
			ui = {
				border = "rounded",
				icons = { package_installed = "✓", package_pending = "➜", package_uninstalled = "✗" },
			},
		},
	},
	{
		"williamboman/mason-lspconfig.nvim",
		dependencies = { "mason.nvim", "neovim/nvim-lspconfig" },
		opts = {
			ensure_installed = {
				"lua_ls", "clangd", "pyright", "bashls", "rust_analyzer", "jsonls",
			},
			automatic_enable = true,
		},
	},
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			{ "j-hui/fidget.nvim", opts = {} }, -- LSP progress notifications
		},
		config = function()
			-- Neovim 0.11+ native LSP config: nvim-lspconfig now just ships
			-- default per-server configs that get picked up by vim.lsp.config/
			-- vim.lsp.enable, rather than exposing its old lspconfig[x].setup().
			local capabilities = require("cmp_nvim_lsp").default_capabilities()
			vim.lsp.config("*", { capabilities = capabilities })

			vim.lsp.config("lua_ls", {
				settings = {
					Lua = {
						diagnostics = { globals = { "vim" } },
						workspace = { checkThirdParty = false },
						telemetry = { enable = false },
					},
				},
			})

			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspAttach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc)
						vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end
					map("gd", vim.lsp.buf.definition, "Goto definition")
					map("gD", vim.lsp.buf.declaration, "Goto declaration")
					map("gr", require("telescope.builtin").lsp_references, "Goto references")
					map("gI", vim.lsp.buf.implementation, "Goto implementation")
					map("<leader>D", vim.lsp.buf.type_definition, "Type definition")
					map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "Document symbols")
					map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Workspace symbols")
					map("<leader>rn", vim.lsp.buf.rename, "Rename")
					map("<leader>ca", vim.lsp.buf.code_action, "Code action")
					map("K", vim.lsp.buf.hover, "Hover documentation")
					map("<leader>k", vim.lsp.buf.signature_help, "Signature help")
				end,
			})

			vim.diagnostic.config({
				virtual_text = { prefix = "●" },
				severity_sort = true,
				float = { border = "rounded" },
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "✘",
						[vim.diagnostic.severity.WARN] = "▲",
						[vim.diagnostic.severity.HINT] = "⚑",
						[vim.diagnostic.severity.INFO] = "»",
					},
				},
			})
		end,
	},
}
