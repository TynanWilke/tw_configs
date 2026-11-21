-- init.lua - Modern Neovim configuration with Claude integration

-- Basic settings
vim.opt.compatible = false            -- disable compatibility to old-time vi
vim.opt.complete = ".,w,b,u,t"
vim.opt.history = 1000
vim.opt.showmatch = true              -- show matching brackets
vim.opt.smartcase = true
vim.opt.ruler = true
vim.opt.hlsearch = true               -- highlight search results
vim.opt.incsearch = true              -- incremental search
vim.opt.tabstop = 4                   -- number of columns occupied by a tab
vim.opt.softtabstop = 4               -- see multiple spaces as tabstops
vim.opt.expandtab = true              -- converts tabs to white space
vim.opt.shiftwidth = 4                -- width for autoindents
vim.opt.shiftround = true
vim.opt.cindent = true
vim.opt.cinoptions = ""
vim.opt.smartindent = true
vim.opt.backspace = "indent,eol,start"
vim.opt.autoindent = true             -- indent a new line the same amount as the line just typed
vim.opt.copyindent = true
vim.opt.number = true                 -- add line numbers
vim.opt.wildmode = "list:longest"     -- command-line completion mode
vim.opt.wildmenu = true
vim.opt.wildignore = "*.swp,*.bak,*.pyc,*.pyo,*.class"
vim.opt.errorbells = false
vim.opt.timeoutlen = 1000
vim.opt.ttimeoutlen = 0
vim.opt.autoread = true
vim.opt.hlsearch = true
vim.opt.clipboard = "unnamedplus"     -- using system clipboard
vim.opt.lazyredraw = true
vim.opt.ttyfast = true                -- Speed up scrolling in Vim

-- Ensure Neovim's undo/backup/swap directories exist
for _, dir in ipairs({
  vim.fn.expand("~/.config/nvim/undodir"),
  vim.fn.expand("~/.vim-tmp"),
  vim.fn.expand("~/.tmp"),
}) do
  vim.fn.mkdir(dir, "p")
end

vim.opt.backupdir = "~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp"
vim.opt.directory = "~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp"
vim.opt.mouse = ""                   -- disable mouse

-- New Stuff for Testing
vim.opt.cursorline = true
vim.opt.cursorcolumn = false
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', extends = '›', precedes = '‹', nbsp = '␣' }
vim.opt.scrolloff = 8  -- Keep 8 lines above/below cursor
vim.opt.sidescrolloff = 8  -- Keep 8 columns left/right of cursor
vim.opt.undofile = true
vim.opt.undodir = vim.fn.expand('~/.config/nvim/undodir')
vim.opt.foldenable = false       -- Disable folding completely
vim.opt.foldmethod = "manual"    -- Only create folds manually

-- Better visual feedback
vim.opt.signcolumn = "yes"       -- Always show sign column to prevent text shifting
vim.opt.updatetime = 250         -- Faster gitgutter updates
vim.opt.relativenumber = false   -- Absolute line numbers only
vim.opt.numberwidth = 4          -- Wider number column for better alignment
vim.opt.wrap = false             -- No line wrapping
vim.opt.linebreak = true         -- If wrap is enabled, break at word boundaries

-- Better command line
vim.opt.showcmd = true           -- Show partial commands in status line
vim.opt.cmdheight = 1            -- Height of command line
vim.opt.showmode = true          -- Show current mode

-- Better search
vim.opt.ignorecase = true        -- Ignore case when searching (already have smartcase)
vim.opt.wrapscan = true          -- Wrap search around file

-- Performance
vim.opt.hidden = true            -- Allow switching buffers without saving

-- Split behavior
vim.opt.splitright = true
vim.opt.splitbelow = true

-- File finding settings
vim.opt.path = vim.fn.expand("$PWD") .. "/**"
vim.opt.wildignore:append("**/.git/**")
vim.opt.wildignore:append("**/build_*/**")
vim.opt.wildignore:append("**/install/**")

-- Colors and syntax
vim.opt.termguicolors = true         -- true color support
vim.cmd("syntax enable")             -- enable syntax highlighting
vim.cmd("colorscheme default")       -- set colorscheme

-- Better split window separators - match tmux style
vim.opt.fillchars = {
  vert = '│',      -- Vertical split character
  fold = '·',      -- Fill character for fold text
  diff = '─',      -- Deleted lines in diff mode
}

-- File type detection
vim.cmd("filetype plugin indent on")  -- allow auto-indenting depending on file type

-- Plugins
-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Plugin configuration
require("lazy").setup({
  -- Theme
  { 
    "gruvbox-community/gruvbox",
    config = function() 
      vim.cmd("colorscheme gruvbox")
    end
  },
  
  -- Copilot.lua with Claude backend
  { 
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require("copilot").setup({
        suggestion = {
          enabled = true,
          auto_trigger = true,
          debounce = 75,
          keymap = {
            accept = "<C-a>",
            accept_word = false,
            accept_line = false,
            next = "<M-]>",
            prev = "<M-[>",
            dismiss = "<C-]>",
          },
        },
        panel = { enabled = false },
        filetypes = {
          yaml = true,
          markdown = true,
          help = false,
          gitcommit = true,
          gitrebase = false,
          hgcommit = false,
          svn = false,
          cvs = false,
          ["."] = false,
        },
      })
    end
  },
  
  -- CopilotChat with Claude backend
  {
    "CopilotC-Nvim/CopilotChat.nvim",
    branch = "canary",
    dependencies = {
      { "zbirenbaum/copilot.lua" },
      { "nvim-lua/plenary.nvim" },
    },
    opts = {
      model = "claude-3.5-sonnet",
      debug = false,
    },
    keys = {
      { "<leader>cc", "<cmd>CopilotChatToggle<cr>", desc = "Toggle Copilot Chat" },
      { "<leader>ce", "<cmd>CopilotChatExplain<cr>", desc = "Explain code" },
      { "<leader>ct", "<cmd>CopilotChatTests<cr>", desc = "Generate tests" },
      { "<leader>cf", "<cmd>CopilotChatFix<cr>", desc = "Fix code" },
      { "<leader>co", "<cmd>CopilotChatOptimize<cr>", desc = "Optimize code" },
      { "<leader>cd", "<cmd>CopilotChatDocs<cr>", desc = "Generate docs" },
    },
  },
  
  -- nvim-cmp for completion
  { 
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
    },
    config = function()
      local cmp = require('cmp')
      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ['<C-n>'] = cmp.mapping.select_next_item(),
          ['<C-p>'] = cmp.mapping.select_prev_item(),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<CR>'] = cmp.mapping.confirm({
            select = false,
            behavior = cmp.ConfirmBehavior.Insert,
          }),
        }),
        sources = cmp.config.sources({
          { name = 'buffer' },
          { name = 'path' },
          { name = 'cmdline' },
        }),
        preselect = cmp.PreselectMode.None,
        completion = {
          completeopt = 'menu,menuone,noinsert,noselect'
        },
      })
    end
  },
  
  -- Git integration (gitgutter only; signify would duplicate the signs)
  {
    "airblade/vim-gitgutter",
    config = function()
      vim.g.gitgutter_max_signs = -1
      vim.g.gitgutter_sign_allow_clobber = 1
      vim.g.gitgutter_map_keys = 1
      vim.g.gitgutter_sign_added = '+'
      vim.g.gitgutter_sign_modified = '~'
      vim.g.gitgutter_sign_removed = '_'
      vim.g.gitgutter_sign_removed_first_line = '‾'
      vim.g.gitgutter_sign_modified_removed = '~_'
    end
  },
  
  -- Code commenting
  { 
    "tpope/vim-commentary",
    config = function()
      vim.g.commentary_startofline = 1
    end
  },
  
  -- Status line
  { 
    "vim-airline/vim-airline",
    dependencies = { "vim-airline/vim-airline-themes" },
    config = function()
      vim.g.airline_extensions = {}
      vim.g.airline_section_x = ''
      vim.g.airline_section_y = ''
      vim.g.airline_section_z = ''
      vim.g.airline_theme = 'dark'
    end
  },
  
  -- Switch between header and implementation files
  { "vim-scripts/a.vim" },
  
  -- Syntax highlighting
  { 
    "nvim-treesitter/nvim-treesitter",
    branch = "master", -- the configs API below only exists on master
    build = ":TSUpdate",
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = { "c", "cpp", "lua", "python", "bash", "yaml", "json", "html", "css", "javascript", "typescript" },
        highlight = {
          enable = true,
        },
      }
    end
  },
  
  -- Rainbow parentheses
  { 
    "frazrepo/vim-rainbow",
    config = function()
      vim.cmd([[
        au FileType c,cpp,objc,objcpp,cs,csharp call rainbow#load()
      ]])
    end
  },
  
  -- Prettier code formatting
  { 
    "prettier/vim-prettier",
    build = "npm install",
    ft = {"javascript", "typescript", "css", "json", "yaml", "html"}
  },

})

-- Post Plugin Configuration
vim.cmd([[
  au FileType c,cpp,objc,objcpp,cs,csharp call rainbow#load()
]])

-- Airline configuration
vim.g.airline_extensions = {'branch', 'hunks'}
vim.g.airline_section_a = 'mode'
vim.g.airline_section_b = 'branch'
vim.g.airline_section_c = '%<%F%m'
vim.g.airline_section_x = ''
vim.g.airline_section_y = '%{&fileformat} %{&fileencoding?&fileencoding:&encoding}'
vim.g.airline_section_z = '%3p%% %3l:%3c'
vim.g.airline_theme = 'gruvbox'
vim.g['airline#extensions#whitespace#enabled'] = 1
vim.g['airline#extensions#whitespace#symbol'] = '!'
vim.g['airline#extensions#hunks#enabled'] = 1
vim.g['airline#extensions#branch#enabled'] = 1

-- Commentary configuration
vim.g.commentary_startofline = 1

-- Disable copilot for large files
vim.cmd([[
  autocmd BufReadPre *
    \ let f=getfsize(expand("<afile>"))
    \ | if f > 300000 || f == -2
    \ | let b:copilot_enabled = v:false
    \ | endif
]])

-- Automatically create C++ header guards
vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = { "*.h", "*.hpp" },
  callback = function()
    local name = vim.fn.expand("%:t"):upper():gsub("%.", "_")
    vim.api.nvim_buf_set_lines(0, 0, -1, false, {
      "#ifndef " .. name,
      "#define " .. name,
      "",
      "",
      "",
      "#endif /* " .. name .. " */",
    })
    vim.api.nvim_win_set_cursor(0, { 4, 0 })
  end,
})

-- Bash script template
vim.api.nvim_create_autocmd("BufNewFile", {
  pattern = "*.sh",
  callback = function()
    vim.api.nvim_buf_set_lines(0, 0, -1, false, {
      "#!/usr/bin/env bash",
      "",
      "set -o errexit",
      "set -o nounset",
      "set -o pipefail",
      "",
      'if [[ "${TRACE-0}" == "1" ]]; then',
      "    set -o xtrace",
      "fi",
      "",
      'if [[ "${1-}" =~ ^-*h(elp)?$ ]]; then',
      "    echo 'Usage: ./script.sh arg-one arg-two'",
      "    echo",
      "    echo 'This is an awesome bash script to make your life better.'",
      "    echo",
      "    exit",
      "fi",
      "",
      'cd "$(dirname "$0")"',
      "",
      "main() {",
      "    echo do awesome stuff",
      "}",
      "",
      'main "$@"',
    })
  end,
})

-- SCons syntax highlighting
vim.cmd([[
  autocmd BufReadPre Sconstruct set filetype=python
  autocmd BufReadPre SConscript set filetype=python
]])

-- Key mappings
vim.keymap.set('', 'Q', '<Nop>', { noremap = true })
vim.keymap.set('n', 'Q', '<Nop>', { noremap = true })

-- Session management
vim.keymap.set('', '<F2>', ':mksession! ~/vim_session<CR>', { noremap = true })
vim.keymap.set('', '<F3>', ':source ~/vim_session<CR>', { noremap = true })

-- Disable F1 help
vim.keymap.set('n', '<F1>', '<Esc>', { noremap = true })
vim.keymap.set('i', '<F1>', '<Esc>', { noremap = true })
vim.keymap.set('v', '<F1>', '<Esc>', { noremap = true })
vim.keymap.set('c', '<F1>', '<Esc>', { noremap = true })

-- Quick find
vim.keymap.set('n', '<F4>', ':find ', { noremap = true })

-- Autocommands for whitespace cleanup
vim.cmd([[
  augroup TrimWhitespace
    autocmd!
    autocmd BufWritePre *.py :%s/\s\+$//e
  augroup END
]])

-- Set the window-local working directory to the current file's directory
vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    local dir = vim.fn.expand("%:p:h")
    if dir ~= "" then
      vim.cmd("lcd " .. vim.fn.fnameescape(dir))
    end
  end,
})

-- Enhanced visual styling to coordinate with tmux
vim.cmd([[
  highlight VertSplit guifg=#3c3836 guibg=NONE ctermbg=NONE
  highlight CursorLine guibg=#3c3836 ctermbg=237
  highlight CursorLineNr guifg=#fabd2f guibg=#3c3836 gui=bold ctermfg=yellow ctermbg=237
  highlight SignColumn guibg=NONE ctermbg=NONE
  highlight GitGutterAdd guifg=#b8bb26 ctermfg=green
  highlight GitGutterChange guifg=#fabd2f ctermfg=yellow
  highlight GitGutterDelete guifg=#fb4934 ctermfg=red
  highlight Search guibg=#fabd2f guifg=#282828 gui=bold ctermbg=yellow ctermfg=black
  highlight IncSearch guibg=#fe8019 guifg=#282828 gui=bold ctermbg=208 ctermfg=black
  highlight Visual guibg=#504945 gui=NONE ctermbg=239
  highlight Whitespace guifg=#504945 ctermfg=239
  highlight NonText guifg=#504945 ctermfg=239
  highlight Pmenu guibg=#3c3836 guifg=#ebdbb2 ctermbg=237 ctermfg=223
  highlight PmenuSel guibg=#83a598 guifg=#282828 gui=bold ctermbg=109 ctermfg=235
  highlight PmenuSbar guibg=#504945 ctermbg=239
  highlight PmenuThumb guibg=#7c6f64 ctermbg=243
]])

-- Display helpful info when entering Vim
vim.cmd([[
  augroup WelcomeMessage
    autocmd!
    autocmd VimEnter * echo "Nvim + Claude AI | Session: " . v:this_session
  augroup END
]])
