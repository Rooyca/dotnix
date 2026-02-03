{ config, lib, pkgs, ... }:
{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    
    extraConfig = ''
      let mapleader = " "
      set number relativenumber
      set expandtab shiftwidth=2 tabstop=2
      set ignorecase smartcase
      set splitright splitbelow
      set clipboard=unnamedplus
      set undofile
      
      lua << EOF
        vim.g.dracula_colorterm = 0
        vim.cmd([[colorscheme dracula]])
        
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
        
        -- Get capabilities for completion
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        local cmp_lsp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
        if cmp_lsp_ok then
          capabilities = cmp_nvim_lsp.default_capabilities(capabilities)
        end
        
        -- Python LSP (pyright)
        vim.lsp.config.pyright = {
          cmd = { 'pyright-langserver', '--stdio' },
          filetypes = { 'python' },
          root_markers = { 'pyproject.toml', 'setup.py', 'setup.cfg', 'requirements.txt', 'Pipfile', '.git' },
          settings = {
            python = {
              analysis = {
                autoSearchPaths = true,
                useLibraryCodeForTypes = true,
                diagnosticMode = 'workspace',
              }
            }
          },
          capabilities = capabilities,
        }
        
        -- Nim LSP (nimlsp)
        vim.lsp.config.nimls = {
          cmd = { 'nimlsp' },
          filetypes = { 'nim' },
          root_markers = { '*.nimble', '.git' },
          capabilities = capabilities,
        }
        
        -- C/C++ LSP (clangd)
        vim.lsp.config.clangd = {
          cmd = { 'clangd' },
          filetypes = { 'c', 'cpp', 'objc', 'objcpp' },
          root_markers = { 'compile_commands.json', 'compile_flags.txt', '.git' },
          capabilities = capabilities,
        }
        
        -- Enable LSP servers
        vim.lsp.enable('pyright')
        vim.lsp.enable('nimls')
        vim.lsp.enable('clangd')
        
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
      EOF
      
      " Key mappings
      nnoremap <leader>ff <cmd>Telescope find_files<cr>
      nnoremap <leader>fg <cmd>Telescope live_grep<cr>
      nnoremap <leader>fb <cmd>Telescope buffers<cr>
      nnoremap <C-n> :NvimTreeToggle<CR>
      
      " Telekasten keybindings
      nnoremap <leader>zf <cmd>Telekasten find_notes<cr>
      nnoremap <leader>zg <cmd>Telekasten search_notes<cr>
      nnoremap <leader>zz <cmd>Telekasten follow_link<cr>
      nnoremap <leader>zn <cmd>Telekasten new_note<cr>
      nnoremap <leader>zb <cmd>Telekasten show_backlinks<cr>
      
      " Diagnostic keybindings
      nnoremap <leader>e <cmd>lua vim.diagnostic.open_float()<CR>
      nnoremap [d <cmd>lua vim.diagnostic.goto_prev()<CR>
      nnoremap ]d <cmd>lua vim.diagnostic.goto_next()<CR>
    '';
    
    plugins = with pkgs.vimPlugins; [
      dracula-nvim          
      nvim-tree-lua
      telekasten-nvim
      nvim-web-devicons  
      lualine-nvim      
      indent-blankline-nvim
      telescope-nvim
      plenary-nvim  
      render-markdown-nvim
      nvim-autopairs
      vim-commentary
      vim-lastplace
      
      nvim-treesitter.withAllGrammars
      
      # Completion plugins
      nvim-cmp
      cmp-nvim-lsp
      cmp-buffer
      luasnip
      cmp_luasnip
    ];
    
    extraPackages = with pkgs; [
      # Language servers
      pyright          # Python
      nimlsp           # Nim
      clang-tools      # C/C++ (provides clangd)
    ];
  };
}
