-- Basic Config
vim.g.mapleader = " "

vim.o.number = true
vim.o.wrap = false
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.cursorline = true
vim.o.mouse = "a"
vim.o.encoding = "utf-8"
vim.o.backup = false
vim.o.signcolumn = "yes"
vim.o.termguicolors = true
vim.o.clipboard = "unnamedplus"

local function bootstrap_pckr()
	local pckr_path = vim.fn.stdpath("data") .. "/pckr/pckr.nvim"

	if not (vim.uv or vim.loop).fs_stat(pckr_path) then
		vim.fn.system({
			"git",
			"clone",
			"--filter=blob:none",
			"https://github.com/lewis6991/pckr.nvim",
			pckr_path,
		})
	end

	vim.opt.rtp:prepend(pckr_path)
end

bootstrap_pckr()

-- setup pckr.nvim
require("pckr").add({
	"nvim-lua/plenary.nvim",

	"nvim-treesitter/nvim-treesitter",
	"craftzdog/solarized-osaka.nvim",
	"nvim-lualine/lualine.nvim",

	"neovim/nvim-lspconfig",

	"hrsh7th/nvim-cmp",
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-cmdline",

	"williamboman/mason.nvim",

	"lewis6991/gitsigns.nvim",

	"windwp/nvim-autopairs",

	"nvimdev/lspsaga.nvim",
	"nvim-tree/nvim-web-devicons",

	"nvimtools/none-ls.nvim",

	"j-hui/fidget.nvim",

	"lukas-reineke/indent-blankline.nvim",

	"nvim-tree/nvim-tree.lua",

	"akinsho/bufferline.nvim",

	"nvim-telescope/telescope.nvim",
})

local status_ok, solarized_osaka = pcall(require, "solarized-osaka")
if status_ok then
	solarized_osaka.setup({
		-- your configuration comes here
		-- or leave it empty to use the default settings
		transparent = true, -- Enable this to disable setting the background color
		terminal_colors = true, -- Configure the colors used when opening a `:terminal` in [Neovim](https://github.com/neovim/neovim)
		styles = {
			-- Style to be applied to different syntax groups
			-- Value is any valid attr-list value for `:help nvim_set_hl`
			comments = { italic = true },
			keywords = { italic = true },
			functions = {},
			variables = {},
			-- Background styles. Can be "dark", "transparent" or "normal"
			sidebars = "dark", -- style for sidebars, see below
			floats = "dark", -- style for floating windows
		},
		sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
		day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
		hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
		dim_inactive = false, -- dims inactive windows
		lualine_bold = false, -- When `true`, section headers in the lualine theme will be bold

		--- You can override specific color groups to use other groups or a hex color
		--- function will be called with a ColorScheme table
		---@param colors ColorScheme
		on_colors = function(colors) end,

		--- You can override specific highlights to use other groups or a hex color
		--- function will be called with a Highlights and ColorScheme table
		---@param highlights Highlights
		---@param colors ColorScheme
		on_highlights = function(highlights, colors) end,
	})

	vim.cmd([[ colorscheme solarized-osaka ]])
end

local status_ok, lualine = pcall(require, "lualine")
if status_ok then
	lualine.setup({
		options = {
			icons_enabled = true,
			theme = "solarized_dark",
			component_separators = { left = "", right = "" },
			section_separators = { left = "", right = "" },
			disabled_filetypes = {
				statusline = {},
				winbar = {},
			},
			ignore_focus = {},
			always_divide_middle = true,
			always_show_tabline = true,
			globalstatus = false,
			refresh = {
				statusline = 100,
				tabline = 100,
				winbar = 100,
			},
		},
		sections = {
			lualine_a = { "mode" },
			lualine_b = { "branch", "diff", "diagnostics" },
			lualine_c = { "filename" },
			lualine_x = { "encoding", "fileformat", "filetype" },
			lualine_y = { "progress" },
			lualine_z = { "location" },
		},
		inactive_sections = {
			lualine_a = {},
			lualine_b = {},
			lualine_c = { "filename" },
			lualine_x = { "location" },
			lualine_y = {},
			lualine_z = {},
		},
		tabline = {},
		winbar = {},
		inactive_winbar = {},
		extensions = {},
	})
end

local status_ok, nvim_treesitter_configs = pcall(require, "nvim-treesitter.configsっk")
if status_ok then
	nvim_treesitter_configs.setup({
		-- Install parsers synchronously (only applied to `ensure_installed`)
		sync_install = false,

		-- Automatically install missing parsers when entering buffer
		-- Recommendation: set to false if you don"t have `tree-sitter` CLI installed locally
		auto_install = true,

		---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
		-- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

		highlight = {
			enable = true,

			-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
			-- Set this to `true` if you depend on "syntax" being enabled (like for indentation).
			-- Using this option may slow down your editor, and you may see some duplicate highlights.
			-- Instead of true it can also be a list of languages
			additional_vim_regex_highlighting = true,
		},
	})
end

local status_ok, cmp = pcall(require, "cmp")
if status_ok then
	cmp.setup({
		window = {
			completion = cmp.config.window.bordered(),
			documentation = cmp.config.window.bordered(),
		},
		mapping = cmp.mapping.preset.insert({
			["<C-b>"] = cmp.mapping.scroll_docs(-4),
			["<C-f>"] = cmp.mapping.scroll_docs(4),
			["<C-Space>"] = cmp.mapping.complete(),
			["<C-e>"] = cmp.mapping.abort(),
			["<CR>"] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
		}),
		sources = cmp.config.sources({
			{ name = "buffer" },
			{ name = "nvim_lsp" },
		}),
	})

	-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
	cmp.setup.cmdline({ "/", "?" }, {
		mapping = cmp.mapping.preset.cmdline(),
		sources = {
			{ name = "buffer" },
		},
	})

	-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
	cmp.setup.cmdline(":", {
		mapping = cmp.mapping.preset.cmdline(),
		sources = cmp.config.sources({
			{ name = "path" },
		}, {
			{ name = "cmdline" },
		}),
		matching = { disallow_symbol_nonprefix_matching = false },
	})
end

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
local capabilities_status_ok, capabilities = pcall(require, "cmp_nvim_lsp")
if lspconfig_status_ok and capabilities_status_ok then
	lspconfig.ts_ls.setup({
		capabilities = capabilities.default_capabilities(),
	})
	lspconfig.lua_ls.setup({
		capabilities = capabilities.default_capabilities(),
	})
end

local status_ok, mason = pcall(require, "mason")
if status_ok then
	mason.setup()
end

local status_ok, gitsigns = pcall(require, "gitsigns")
if status_ok then
	gitsigns.setup({
		signs = {
			add = { text = "┃" },
			change = { text = "┃" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
			untracked = { text = "┆" },
		},
		signs_staged = {
			add = { text = "┃" },
			change = { text = "┃" },
			delete = { text = "_" },
			topdelete = { text = "‾" },
			changedelete = { text = "~" },
			untracked = { text = "┆" },
		},
		signs_staged_enable = true,
		signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
		numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
		linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
		word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
		watch_gitdir = {
			follow_files = true,
		},
		auto_attach = true,
		attach_to_untracked = false,
		current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
		current_line_blame_opts = {
			virt_text = true,
			virt_text_pos = "eol", -- "eol" | "overlay" | "right_align"
			delay = 1000,
			ignore_whitespace = false,
			virt_text_priority = 100,
			use_focus = true,
		},
		current_line_blame_formatter = "<author>, <author_time:%R> - <summary>",
		sign_priority = 6,
		update_debounce = 100,
		status_formatter = nil, -- Use default
		max_file_length = 40000, -- Disable if file is longer than this (in lines)
		preview_config = {
			-- Options passed to nvim_open_win
			border = "single",
			style = "minimal",
			relative = "cursor",
			row = 0,
			col = 1,
		},
	})
end

local status_ok, nvim_autopairs = pcall(require, "nvim-autopairs")
if status_ok then
	nvim_autopairs.setup()
end

local status_ok, lspsaga = pcall(require, "lspsaga")
if status_ok then
	lspsaga.setup()

	vim.keymap.set("n", "K", "<CMD>Lspsaga hover_doc<CR>")
	vim.keymap.set("n", "ca", "<CMD>Lspsaga code_action<CR>")
	vim.keymap.set("n", "gd", "<CMD>Lspsaga goto_definition<CR>")
	vim.keymap.set("n", "gt", "<CMD>Lspsaga goto_type_definition<CR>")
	vim.keymap.set("n", "gr", "<CMD>Lspsaga finder tyd+ref+imp+def<CR>")
	vim.keymap.set("n", "gR", "<CMD>Lspsaga rename<CR>")
	vim.keymap.set("n", "[e", "<CMD>Lspsaga diagnostic_jump_next<CR>")
	vim.keymap.set("n", "]e", "<CMD>Lspsaga diagnostic_jump_prev<CR>")
	vim.keymap.set("n", "gT", "<CMD>Lspsaga term_toggle<CR>")
end

local status_ok, fidget = pcall(require, "fidget")
if status_ok then
	fidget.setup()
end

local status_ok, ibl = pcall(require, "ibl")
if status_ok then
	ibl.setup()
end

local status_ok, null_ls = pcall(require, "null-ls")
if status_ok then
	local augroup = vim.api.nvim_create_augroup("LspFormatting", {})
	null_ls.setup({
		sources = {
			null_ls.builtins.formatting.stylua,
			null_ls.builtins.formatting.prettierd,
		},
		on_attach = function(client, bufnr)
			if client.supports_method("textDocument/formatting") then
				vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
				vim.api.nvim_create_autocmd("BufWritePre", {
					group = augroup,
					buffer = bufnr,
					callback = function()
						vim.lsp.buf.format({ async = false })
					end,
				})
			end
		end,
	})
end

local status_ok, nvim_tree = pcall(require, "nvim-tree")
if status_ok then
	nvim_tree.setup()
	vim.keymap.set("n", "<leader>n", "<CMD>NvimTreeToggle<CR>")
end

local status_ok, bufferline = pcall(require, "bufferline")
if status_ok then
	bufferline.setup()
end

local status_ok, telescope_builtin = pcall(require, "telescope.builtin")
if status_ok then
	vim.keymap.set("n", "<leader>ff", telescope_builtin.find_files, { desc = "Telescope find files" })
	vim.keymap.set("n", "<leader>fg", telescope_builtin.live_grep, { desc = "Telescope live grep" })
	vim.keymap.set("n", "<leader>fb", telescope_builtin.buffers, { desc = "Telescope buffers" })
	vim.keymap.set("n", "<leader>fh", telescope_builtin.help_tags, { desc = "Telescope help tags" })
end
