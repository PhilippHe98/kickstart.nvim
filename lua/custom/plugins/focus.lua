return {
  'nvim-focus/focus.nvim',
  version = '0.7',
  opts = {
    enable = true,
    commands = true,
    autoresize = {
      enable = true,
    },
  },
  config = function(_, opts)
    require('focus').setup(opts)

    -- Toggle maximized window (nimmt ganzen Platz ein)
    vim.keymap.set('n', '<leader>z', '<cmd>FocusMaxOrEqual<CR>', { desc = 'Maximize current window' })
  end,
}
