return {
  'epwalsh/obsidian.nvim',
  version = '*',
  ft = 'markdown',
  dependencies = {
    'nvim-lua/plenary.nvim',
  },
  opts = {
    dir = '~/vaults/personal',
    notes_subdir = 'notes',
    mappings = {
      ['gf'] = {
        action = function()
          return require('obsidian').util.gf_passthrough()
        end,
        opts = { noremap = false, expr = true, buffer = true },
      },
    },
    daily_notes = {
      folder = 'notes/dailies',
      date_format = '%Y-%m-%d',
      alias_format = '%B %-d, %Y',
      default_tags = { 'daily-notes' },
      template = 'note',
    },
    new_notes_location = 'notes_subdir',
    templates = {
      folder = 'templates',
      date_format = '%Y-%m-%d-%a',
      time_format = '%H:%M',
      substitutions = {
        tasks_from_yesterday = function()
          local yesterday = os.date('%Y-%m-%d', os.time() - 24 * 60 * 60)
          local vault_path = vim.fn.expand '~/vaults/personal/notes/dailies'
          local yesterday_note_path = string.format('%s/%s.md', vault_path, yesterday)

          if vim.fn.filereadable(yesterday_note_path) == 0 then
            return 'No notes from yesterday'
          end

          local lines = vim.fn.readfile(yesterday_note_path)

          local tasks = {}
          local current_task = nil

          for _, line in ipairs(lines) do
            if line:match '^%s*%- %[ %]' then
              -- Start a new task
              if current_task then
                table.insert(tasks, table.concat(current_task, '\n'))
              end
              current_task = { line }
            elseif current_task and line:match '^%s+' then
              -- Continuation of previous task
              table.insert(current_task, line)
            else
              -- End of a task block
              if current_task then
                table.insert(tasks, table.concat(current_task, '\n'))
                current_task = nil
              end
            end
          end

          -- Catch the last task block
          if current_task then
            table.insert(tasks, table.concat(current_task, '\n'))
          end

          return #tasks > 0 and table.concat(tasks, '\n') or 'No unchecked tasks from yesterday.'
        end,
      },
    },
    ui = {
      enable = false,
    },
    ---@param title string|?
    ---@return string
    note_id_func = function(title)
      local suffix = ''
      if title ~= nil then
        suffix = title:gsub(' ', '-'):gsub('[^A-Za-z0-9-]', ''):lower()
      else
        for _ = 1, 4 do
          suffix = suffix .. string.char(math.random(65, 90))
        end
      end
      return tostring(os.time()) .. '-' .. suffix
    end,
  },
}
