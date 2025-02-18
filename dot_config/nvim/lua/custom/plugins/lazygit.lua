return {
  'kdheepak/lazygit.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  config = function()
    vim.keymap.set('n', '<leader>lg', '<cmd>LazyGit<CR>i', { noremap = true, silent = true, desc = '[L]azyGit' })
  end,
}
