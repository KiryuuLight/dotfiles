local augroup = vim.api.nvim_create_augroup('LspFormatting', {})

Cwd = vim.fn.getcwd()
local execute = vim.fn.executable
local function get_python_path(params)
  -- Get the root directory of the current Python project
  local root_dir = require('lspconfig')['pyright'].get_root_dir(params.bufname)

  -- Check if the `.venv` directory exists inside the root directory
  if vim.fn.isdirectory(root_dir .. '/.venv') == 1 then
    return root_dir .. '/.venv/bin/python' -- Assuming you're using a Unix-like OS
  else
    return root_dir -- Fallback to root directory if no .venv found
  end
end

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
        null_ls.builtins.diagnostics.mypy.with {
          extra_args = function(params)
            local PythonPath = get_python_path(params)
            return {
              '--python-executable',
              PythonPath, -- Use the path to the Python executable from the .venv
            }
          end,
        },
        require 'none-ls.formatting.ruff',
        require 'none-ls.formatting.ruff_format',
        null_ls.builtins.formatting.black,
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
