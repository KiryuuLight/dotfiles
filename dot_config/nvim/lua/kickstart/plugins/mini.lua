return {
  {
    'echasnovski/mini.nvim',
    config = function()
      require('mini.ai').setup { n_lines = 500 }
    end,
  },
}
-- vim: ts=2 sts=2 sw=2 et
