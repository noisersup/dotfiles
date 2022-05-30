vim.g.loaded_matchit = 1
vim.g.dashboard_default_executive = 'telescope'
vim.g.dashboard_custom_header = {
[[ ▄▄    ▄ ▄▄▄▄▄▄▄ ▄▄▄▄▄▄▄ ▄▄   ▄▄ ▄▄▄ ▄▄   ▄▄ ]],
[[█  █  █ █       █       █  █ █  █   █  █▄█  █]],
[[█   █▄█ █    ▄▄▄█   ▄   █  █▄█  █   █       █]],
[[█       █   █▄▄▄█  █ █  █       █   █       █]],
[[█  ▄    █    ▄▄▄█  █▄█  █       █   █       █]],
[[█ █ █   █   █▄▄▄█       ██     ██   █ ██▄██ █]],
[[█▄█  █▄▄█▄▄▄▄▄▄▄█▄▄▄▄▄▄▄█ █▄▄▄█ █▄▄▄█▄█   █▄█]],
}

local chadtree_settings = {
	["xdg"] = true,
	["view.width"] = 25,
}

vim.api.nvim_set_var("chadtree_settings", chadtree_settings)


local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true


require'lspconfig'.tsserver.setup{}

require'lspconfig'.html.setup{
	capabilities = capabilities,
	autostart = true,
	filetypes = { "html" },
}
