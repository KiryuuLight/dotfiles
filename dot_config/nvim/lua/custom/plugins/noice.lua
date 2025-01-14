return {
  'folke/noice.nvim',
  enabled = true,
  event = 'VeryLazy',
  opts = {},
  dependencies = {
    'MunifTanjim/nui.nvim',
    'rcarriga/nvim-notify',
  },
  config = function()
    local noice = require 'noice'
    noice.setup {
      notify = {
        enabled = true,
        level = 'ERROR',
      },
      routes = {
        { filter = { event = "msg_show", find = "%d+B written$" },              view = "mini" },
        { filter = { event = "msg_show", find = "%d+L, %d+B$" },                view = "mini" },
        { filter = { event = "msg_show", find = "%-%-No lines in buffer%-%-" }, view = "mini" },
        { filter = { event = "msg_show", find = "change" },                     view = "mini" },
        { filter = { event = "msg_show", find = "more line" },                  view = "mini" },
        { filter = { event = "msg_show", find = "fewer lines" },                view = "mini" },
        { filter = { event = "msg_show", find = "line less" },                  view = "mini" },
      },
      lsp = {
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true, -- requires hrsh7th/nvim-cmp
        },
      },
      presets = {
        bottom_search = false,        -- use a classic bottom cmdline for search
        command_palette = true,       -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false,           -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false,       -- add a border to hover docs and signature help
      },
    }
  end,
}
