-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugin specifications
require("lazy").setup({
  -- "github/copilot.vim",
  "Mofiqul/dracula.nvim",
  "nvim-tree/nvim-tree.lua",
  "renerocksai/telekasten.nvim",
  "nvim-tree/nvim-web-devicons",
  "nvim-lualine/lualine.nvim",
  "lukas-reineke/indent-blankline.nvim",
  "nvim-telescope/telescope.nvim",
  "nvim-lua/plenary.nvim",
  "MeanderingProgrammer/render-markdown.nvim",
  "windwp/nvim-autopairs",
  "tpope/vim-commentary",
  "farmergreg/vim-lastplace",
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
      vim.g.mkdp_browser = "firefox"
      vim.g.mkdp_markdown_css = ""
      vim.g.mkdp_preview_options = {
        mkit = {},
        katex = {},
        uml = {},
        maid = {},
        disable_sync_scroll = 0,
        sync_scroll_type = "middle",
      }
    end,
    ft = { "markdown" },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate"
  },
  -- LSP Support
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "neovim/nvim-lspconfig",
  -- Completion
  "hrsh7th/nvim-cmp",
  "hrsh7th/cmp-nvim-lsp",
  "hrsh7th/cmp-buffer",
  "L3MON4D3/LuaSnip",
  "saadparwaiz1/cmp_luasnip",
})

-- Leader key
vim.g.mapleader = " "

-- Basic settings
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.clipboard = "unnamedplus"
vim.opt.undofile = true

-- Colorscheme settings
vim.g.dracula_colorterm = 0
vim.cmd([[colorscheme dracula]])

-- Custom highlight groups
vim.api.nvim_set_hl(0, "Normal", { bg = "#14121c" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#14121c" })
vim.api.nvim_set_hl(0, "SignColumn", { bg = "#14121c" })
vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = "#14121c" })

-- Plugin setup with error handling
local setup_plugin = function(name, setup_fn)
  local ok, plugin = pcall(require, name)
  if ok then
    if setup_fn then
      setup_fn(plugin)
    end
    return true
  end
  return false
end

-- Plugin configurations
setup_plugin("nvim-tree", function(p) p.setup() end)
setup_plugin("nvim-autopairs", function(p) p.setup({}) end)
setup_plugin("ibl", function(p) p.setup({}) end)
setup_plugin("render-markdown", function(p) p.setup({}) end)
setup_plugin("lualine", function(p)
  p.setup({
    options = {
      theme = 'iceberg_dark',
      icons_enabled = true,
    }
  })
end)

setup_plugin("telekasten", function(p)
  p.setup({
    home = vim.fn.expand("~/.nb/difinal"),
  })
end)

-- Tree-sitter setup with delay to ensure it loads
vim.schedule(function()
  setup_plugin("nvim-treesitter.configs", function(p)
    p.setup({
      ensure_installed = { "lua", "python", "javascript", "typescript", "nim", "c", "cpp" },
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
    })
  end)
end)

-- Completion setup
local cmp_ok, cmp = pcall(require, "cmp")
if cmp_ok then
  cmp.setup({
    snippet = {
      expand = function(args)
        require('luasnip').lsp_expand(args.body)
      end,
    },
    mapping = cmp.mapping.preset.insert({
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
      ['<Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_next_item()
        else
          fallback()
        end
      end, { 'i', 's' }),
      ['<S-Tab>'] = cmp.mapping(function(fallback)
        if cmp.visible() then
          cmp.select_prev_item()
        else
          fallback()
        end
      end, { 'i', 's' }),
    }),
    sources = cmp.config.sources({
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
    }, {
      { name = 'buffer' },
    })
  })
end

-- Mason setup for LSP server management
setup_plugin("mason", function(p) p.setup() end)
setup_plugin("mason-lspconfig", function(p)
  p.setup({
    ensure_installed = { "pyright", "clangd", "ts_ls" },
    automatic_installation = true,
  })
end)

-- Get capabilities for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
local cmp_lsp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if cmp_lsp_ok then
  capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
end

vim.lsp.config('*', {
  capabilities = capabilities,
})

vim.lsp.config('pyright', {
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = 'workspace',
      }
    }
  }
})

vim.lsp.config('clangd', {
  cmd = {
    "clangd",
    "--query-driver=/usr/bin/x86_64-w64-mingw32-g++",
    "--background-index",
    "--clang-tidy",
  },
})

vim.lsp.enable({ 'pyright', 'nimls', 'clangd', 'ts_ls' })
---

-- LSP keybindings and settings
vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(args)
    local bufnr = args.buf
    local opts = { noremap=true, silent=true, buffer=bufnr }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<leader>f', function() vim.lsp.buf.format { async = true } end, opts)
  end,
})

-- Diagnostic settings for error highlighting
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  update_in_insert = false,
  underline = true,
  severity_sort = true,
  float = {
    border = 'rounded',
    source = 'always',
  },
})

-- Show diagnostic on hover
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, { focusable = false })
  end
})

-- Key mappings
vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>fb', '<cmd>Telescope buffers<cr>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-n>', ':NvimTreeToggle<CR>', { noremap = true, silent = true })

-- Telekasten keybindings
vim.keymap.set('n', '<leader>zf', '<cmd>Telekasten find_notes<cr>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>zg', '<cmd>Telekasten search_notes<cr>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>zz', '<cmd>Telekasten follow_link<cr>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>zn', '<cmd>Telekasten new_note<cr>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>zb', '<cmd>Telekasten show_backlinks<cr>', { noremap = true, silent = true })

-- Diagnostic keybindings
vim.keymap.set('n', '<leader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', { noremap = true, silent = true })
vim.keymap.set('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', { noremap = true, silent = true })
