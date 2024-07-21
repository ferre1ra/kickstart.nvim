local set = vim.keymap.set

return {
  'nvim-telescope/telescope.nvim',
  event = 'VimEnter',
  branch = '0.1.x',
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

    -- Useful for getting pretty icons, but requires a Nerd Font.
    {
      'nvim-tree/nvim-web-devicons',
      enabled = vim.g.have_nerd_font,
      event = { 'VeryLazy' },
      dependencies = {
        'Allianaab2m/nvim-material-icon-v3',
      },
      config = function()
        require('nvim-web-devicons').setup {
          override = require('nvim-material-icon').get_icons(),
        }
      end,
    },
  },
  config = function()
    -- Telescope is a fuzzy finder that comes with a lot of different things that
    -- it can fuzzy find! It's more than just a "file finder", it can search
    -- many different aspects of Neovim, your workspace, LSP, and more!
    --
    -- The easiest way to use Telescope, is to start by doing something like:
    --  :Telescope help_tags
    --
    -- After running this command, a window will open up and you're able to
    -- type in the prompt window. You'll see a list of `help_tags` options and
    -- a corresponding preview of the help.
    --
    -- Two important keymaps to use while in Telescope are:
    --  - Insert mode: <c-/>
    --  - Normal mode: ?
    --
    -- This opens a window that shows you all of the keymaps for the current
    -- Telescope picker. This is really useful to discover what Telescope can
    -- do as well as how to actually do it!
    --

    local select_one_or_multi = function(prompt_bufnr)
      local picker = require('telescope.actions.state').get_current_picker(prompt_bufnr)
      local multi = picker:get_multi_selection()
      if not vim.tbl_isempty(multi) then
        require('telescope.actions').close(prompt_bufnr)
        for _, j in pairs(multi) do
          if j.path ~= nil then
            if j.lnum ~= nil then
              vim.cmd(string.format('%s +%s %s', 'edit', j.lnum, j.path))
            else
              vim.cmd(string.format('%s %s', 'edit', j.path))
            end
          end
        end
      else
        require('telescope.actions').select_default(prompt_bufnr)
      end
    end

    -- [[ Configure Telescope ]]
    -- See `:help telescope` and `:help telescope.setup()`
    require('telescope').setup {
      -- You can put your default mappings / updates / etc. in here
      --  All the info you're looking for is in `:help telescope.setup()`
      --
      defaults = {
        mappings = {
          i = {
            ['<c-enter>'] = 'to_fuzzy_refine',
            ['<c-q>'] = 'send_to_qflist',
            ['<cr>'] = select_one_or_multi,
          },
        },
        layout_strategy = 'horizontal',
        layout_config = {
          horizontal = {
            prompt_position = 'top',
          },
        },
        sorting_strategy = 'ascending',
      },
      -- pickers = {}
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
    set('n', '<leader>sh', builtin.help_tags, { desc = '[S]earch [H]elp' })
    set('n', '<leader>sk', builtin.keymaps, { desc = '[S]earch [K]eymaps' })
    set('n', '<leader>sf', builtin.find_files, { desc = '[S]earch [F]iles' })
    set('n', '<leader>ss', builtin.builtin, { desc = '[S]earch [S]elect Telescope' })
    set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
    set('n', '<leader>sg', builtin.live_grep, { desc = '[S]earch by [G]rep' })
    set('n', '<leader>sd', builtin.diagnostics, { desc = '[S]earch [D]iagnostics' })
    set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
    set('n', '<leader>s.', builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
    set('n', '<leader><leader>', builtin.buffers, { desc = '[ ] Find existing buffers' })

    -- Slightly advanced example of overriding default behavior and theme
    set('n', '<leader>/', function()
      -- You can pass additional configuration to Telescope to change the theme, layout, etc.
      builtin.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
      })
    end, { desc = '[/] Fuzzily search in current buffer' })

    -- It's also possible to pass additional configuration options.
    --  See `:help telescope.builtin.live_grep()` for information about particular keys
    set('n', '<leader>s/', function()
      builtin.live_grep {
        grep_open_files = true,
        prompt_title = 'Live Grep in Open Files',
      }
    end, { desc = '[S]earch [/] in Open Files' })

    -- Shortcut for searching your Neovim configuration files
    set('n', '<leader>sn', function()
      builtin.find_files { cwd = vim.fn.stdpath 'config' }
    end, { desc = '[S]earch [N]eovim files' })
  end,
}
