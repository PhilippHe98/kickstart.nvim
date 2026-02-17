return {
  'TheLeoP/powershell.nvim',
  ---@type powershell.user_config
  opts = {
    bundle_path = vim.fn.stdpath 'data' .. '/mason/packages/powershell-editor-services',
    vim.keymap.set('n', '<leader>P', function()
      require('powershell').toggle_term()
    end),
  },
}
