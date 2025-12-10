return {
  {
    'nvim-telescope/telescope.nvim',
    event = 'VimEnter',
    -- branch = '0.1.x',
    commit = 'b4da76be54691e854d3e0e02c36b0245f945c2c7',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        'nvim-telescope/telescope-fzf-native.nvim',

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = 'make',

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable 'make' == 1
        end,
      },
      { 'nvim-telescope/telescope-ui-select.nvim' },
      { 'nvim-tree/nvim-web-devicons', enabled = vim.g.have_nerd_font },
    },
    config = function()
      local actions = require 'telescope.actions'
      require('telescope').setup {
        defaults = {
          layout_strategy = 'flex',
          layout_config = {
            flex = {
              flip_columns = 120, -- below this width it switches to vertical
            },
            horizontal = {
              preview_width = 0.6,
              prompt_position = 'bottom',
            },
            vertical = {
              preview_height = 0.6,
              prompt_position = 'bottom',
            },
          },
          mappings = {
            i = {
              ['<esc>'] = actions.close,
              ['<C-u>'] = false,
            },
          },
        },
        extensions = {
          ['ui-select'] = {
            require('telescope.themes').get_dropdown(),
          },
        },
      }

      -- Enable Telescope extensions if they are installed
      pcall(require('telescope').load_extension, 'fzf')
      pcall(require('telescope').load_extension, 'ui-select')

      -- See `:help telescope.builtin`
      local builtin = require 'telescope.builtin'
      vim.keymap.set('n', '<leader>fs', builtin.find_files, { desc = 'Search files' })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Search by grep' })
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find existing buffers' })
      vim.keymap.set('n', '<leader>fw', builtin.grep_string, { desc = 'Search current word' })
      vim.keymap.set('v', '<leader>fw', function()
        local saved_reg = vim.fn.getreg 'v'
        vim.cmd [[noautocmd sil norm "vy]]
        local selection = vim.fn.getreg 'v'
        vim.fn.setreg('v', saved_reg)
        builtin.grep_string { search = selection }
      end, { desc = 'Search selected text' })
      vim.keymap.set('n', '<leader>fd', builtin.diagnostics, { desc = 'Search Diagnostics' })
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Search Help' })

      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set('n', '<leader>/', function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
          winblend = 10,
          previewer = false,
        })
      end, { desc = '[/] Fuzzily search in current buffer' })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set('n', '<leader>s/', function()
        builtin.live_grep {
          grep_open_files = true,
          prompt_title = 'Live Grep in Open Files',
        }
      end, { desc = '[S]earch [/] in Open Files' })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set('n', '<leader>fn', function()
        builtin.find_files { cwd = vim.fn.stdpath 'config' }
      end, { desc = 'Search Neovim files' })

      -- Shortcut for searching your envs
      vim.keymap.set('n', '<leader>fv', function()
        builtin.find_files {
          find_command = { 'rg', '--files', '--iglob', '.env*' },
        }
      end, { desc = 'Search environment variables' })

      -- Shorcut to list obsidian notes from current day
      local function find_daily_notes()
        local vault_path = '~/vaults/'
        local telescope = require 'telescope.builtin'
        local today = os.date '%Y-%m-%d'

        telescope.find_files {
          prompt_title = 'Daily Notes',
          cwd = vault_path,
          search_file = today,
        }
      end

      vim.keymap.set('n', '<leader>ft', find_daily_notes, { desc = 'Search notes from today', noremap = true, silent = true })
    end,
  },
}
