return {
  {
    'max397574/better-escape.nvim',
    event = 'VeryLazy',
    config = function()
      require('better_escape').setup {
        timeout = 200,
        default_mappings = true,
        mappings = {
          i = {
            k = {
              j = '<Esc>',
            },
            j = {
              k = '<Esc>',
              j = false,
            },
          },
          c = {
            j = {
              k = '<Esc>',
              j = false,
            },
            k = {
              j = '<Esc>',
            },
          },
          t = {
            j = {
              k = '<C-\\><C-n>',
            },
            k = {
              j = '<Esc>',
            },
          },
          v = {
            j = {
              k = '<Esc>',
            },
            k = {
              j = '<Esc>',
            },
          },
          s = {
            j = {
              k = '<Esc>',
            },
            k = {
              j = '<Esc>',
            },
          },
        },
      }
    end,
  },
}
