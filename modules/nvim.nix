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
        -- Set custom Dracula colors before loading theme
        vim.g.dracula_colorterm = 0
        
        -- Load Dracula
        vim.cmd([[colorscheme dracula]])
        
        -- Override background color
        vim.api.nvim_set_hl(0, "Normal", { bg = "#14121c" })
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#14121c" })
        vim.api.nvim_set_hl(0, "SignColumn", { bg = "#14121c" })
        vim.api.nvim_set_hl(0, "NvimTreeNormal", { bg = "#14121c" })
        
        -- Plugin setup
        require("nvim-tree").setup()
        require('nvim-autopairs').setup({})
        require('ibl').setup({})
        require('render-markdown').setup({})
        require('lualine').setup {
          options = {
            theme = 'iceberg_dark',
            icons_enabled = true,
          }
        }
        require('telekasten').setup({
          home = vim.fn.expand("~/.nb/difinal"),
        })
        
        -- Tree-sitter setup
        -- WHY: This tells Tree-sitter which languages to enable highlighting for
        -- Tree-sitter provides semantic understanding of code structure
        require('nvim-treesitter.configs').setup({
          highlight = {
            enable = true,  -- Enable Tree-sitter based highlighting
            additional_vim_regex_highlighting = false,  -- Disable old regex highlighting
          },
          -- You can add other Tree-sitter features here like:
          -- indent = { enable = true },
          -- incremental_selection = { enable = true },
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
      
      (nvim-treesitter.withPlugins (p: [
        p.tree-sitter-nim
        # You can add other languages here too, like:
        # p.tree-sitter-nix
        # p.tree-sitter-lua
        # p.tree-sitter-python
      ]))
    ];
  };
}

