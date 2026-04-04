return {
  'sindrets/diffview.nvim',
  cmd = { 'DiffviewOpen', 'DiffviewFileHistory', 'DiffviewClose' },
  keys = {
    { '<leader>gd', '<cmd>DiffviewOpen<cr>', desc = 'Git diff all changes' },
    { '<leader>gh', '<cmd>DiffviewFileHistory %<cr>', desc = 'Git file history' },
    { '<leader>gq', '<cmd>DiffviewClose<cr>', desc = 'Close diffview' },
  },
  opts = {},
}
