return {
  {
    'echasnovski/mini.nvim',
    config = function()
      local spec_treesitter = require('mini.ai').gen_spec.treesitter
      require('mini.ai').setup {
        n_lines = 500,
        custom_textobjects = {
          t = { '<([%p%w]-)%f[^<%w][^<>]->.-</%1>', '^<.->().*()</[^/]->$' },
          o = spec_treesitter {
            a = { '@block.outer', '@conditional.outer', '@loop.outer' },
            i = { '@block.inner', '@conditional.inner', '@loop.inner' },
          },
          f = spec_treesitter { a = '@function.outer', i = '@function.inner' },
          c = spec_treesitter { a = '@class.outer', i = '@class.inner' },
        },
      }
    end,
  },
}
