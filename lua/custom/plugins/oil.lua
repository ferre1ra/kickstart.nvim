return {
  'stevearc/oil.nvim',
  opts = {
    skip_confirm_for_simple_edits = true,

    -- see help: oil-columns
    columns = {
      'permissions',
      'icon',
    },
    keymaps = {
      ['<Esc>'] = 'actions.close',
      ['q'] = 'actions.close',
      ['<leader>ff'] = {
        function()
          require('telescope.builtin').find_files {
            cwd = require('oil').get_current_dir(),
          }
        end,
        mode = 'n',
        nowait = true,
        desc = 'Find files in the current directory',
      },
    },
    float = {
      padding = 4,
      border = 'single',
    },
  },
  -- Optional dependencies
  dependencies = { 'nvim-tree/nvim-web-devicons' },
}
