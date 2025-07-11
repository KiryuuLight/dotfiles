local augroup = vim.api.nvim_create_augroup('LspFormatting', {})

return {
  'nvimtools/none-ls.nvim',
  dependencies = {
    { 'nvimtools/none-ls-extras.nvim' },
  },
  ft = { 'python' },
  opts = function()
    local null_ls = require 'null-ls'
    require('null-ls').setup {
      sources = {
        require 'none-ls.formatting.ruff',
        require 'none-ls.formatting.ruff_format',
        null_ls.builtins.formatting.black,
        null_ls.builtins.formatting.isort,
        null_ls.builtins.formatting.gofumpt,
        null_ls.builtins.formatting.goimports_reviser,
      },
    }
  end,
  on_attach = function(client, bufnr)
    if client.supports_method 'textDocument/formatting' then
      vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = augroup,
        buffer = bufnr,
        callback = function()
          vim.lsp.buf.format { bufnr = bufnr }
        end,
      })
    end
  end,
}
