return {
  'f-person/git-blame.nvim',
  init = function()
    vim.keymap.set('n', '<leader>to', '<cmd>GitBlameOpenCommitURL<cr>', { desc = 'Open Commit Url', silent = true })
    vim.keymap.set('n', '<leader>tc', '<cmd>GitBlameCopyCommitURL<cr>', { desc = 'Copy Commit Url', silent = true })
    vim.keymap.set('n', '<leader>tb', '<cmd>GitBlameToggle<cr>', { desc = 'Toggle Blame', silent = true })
  end,
  cmd = {
    'GitBlameToggle',
    'GitBlameOpenCommitURL',
    'GitBlameCopyCommitURL',
  },
  opts = {},
}
