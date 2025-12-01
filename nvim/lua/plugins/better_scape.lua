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
          },
          t = { j = { false } }, --lazygit navigation fix
          v = { j = { k = false } }, -- visual select fix
        },
      }
    end,
  },
}
