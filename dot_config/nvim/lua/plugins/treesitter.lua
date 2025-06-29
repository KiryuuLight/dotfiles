return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
      'windwp/nvim-ts-autotag',
    },
    main = 'nvim-treesitter.configs',
    config = function()
      local treesitter = require 'nvim-treesitter.configs'

      require('nvim-ts-autotag').setup {
        enable = true,
        filetypes = { 'html', 'xml', 'tsx', 'typescript' },
      }
      treesitter.setup {
        ensure_installed = {
          'bash',
          'c',
          'diff',
          'lua',
          'python',
          'luadoc',
          'markdown',
          'markdown_inline',
          'query',
          'vim',
          'vimdoc',
          'html',
          'typescript',
          'javascript',
          'tsx',
          'rust',
          'go',
        },
        -- matchup = {
        --   enable = true,
        -- },
        autotag = {
          enable = false,
        },
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = { 'ruby' },
        },
        indent = { enable = true, disable = { 'ruby' } },
      }
    end,
    opts = {},
  },
}
