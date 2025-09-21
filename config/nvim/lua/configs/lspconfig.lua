-- ~/.config/nvim/lua/configs/lspconfig.lua

-- mantiene las opciones y keymaps por defecto de nvchad
require("nvchad.configs.lspconfig").defaults()

-- lista de servidores que quieres habilitar
local servers = { "html", "cssls", "nil_ls", "asm_lsp", "clangd", "rust_analyzer", "pyright" }

-- habilita los servidores (usa la API nativa)
vim.lsp.enable(servers)

