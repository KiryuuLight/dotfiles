return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    dependencies = {
      "windwp/nvim-ts-autotag",
    },
    main = 'nvim-treesitter.configs',
    config = function()
      local treesitter = require("nvim-treesitter.configs")

      require('nvim-ts-autotag').setup({
        enable = true,
        filetypes = { "html", "xml", "tsx", "typescript" },
      })
      -- configure treesitter
      treesitter.setup({ -- enable syntax highlighting
        ensure_installed = {
          'bash',
          'c',
          'diff',
          'lua',
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
          'rust'
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
      })
    end,
    opts = {
    },
    -- There are additional nvim-treesitter modules that you can use to interact
    -- with nvim-treesitter. You should go explore a few and see what interests you:
    --
    --    - Incremental selection: Included, see `:help nvim-treesitter-incremental-selection-mod`
    --    - Show your current context: https://github.com/nvim-treesitter/nvim-treesitter-context
    --    - Treesitter + textobjects: https://github.com/nvim-treesitter/nvim-treesitter-textobjects
  },
}
-- vim: ts=2 sts=2 sw=2 et
