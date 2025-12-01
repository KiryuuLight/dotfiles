local lspconfig = require 'lspconfig'

local servers = {
  ['eslint-lsp'] = {
    settings = {
      workingDirectories = { mode = 'auto' },
    },
  },
  ts_ls = {},
  lua_ls = {
    settings = {
      Lua = {
        completion = {
          callSnippet = 'Replace',
        },
      },
    },
  },
  gopls = {
    cmd = { 'gopls' },
    filetypes = { 'go', 'gomod', 'gowork', 'gotmpl' },
    root_dir = lspconfig.util.root_pattern('go.work', 'go.mod', '.git'),
    settings = {
      gopls = {
        completeUnimported = true,
        usePlaceholders = true,
        analyses = {
          unusedparams = true,
          nilness = true,
          shadow = true,
          unusedwrite = true,
        },
      },
    },
  },
}

return servers
