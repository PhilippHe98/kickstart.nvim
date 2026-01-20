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

    -- Keymap: Fenster maximieren
    vim.keymap.set('n', '<leader>z', '<cmd>FocusMaxOrEqual<CR>', {
      desc = 'Maximize current window',
    })

    ------------------------------------------------------------------
    -- Disable focus for certain filetypes / buftypes (e.g. neo-tree)
    ------------------------------------------------------------------

    local ignore_filetypes = { 'neo-tree' }
    local ignore_buftypes = { 'nofile', 'prompt', 'popup' }

    local augroup = vim.api.nvim_create_augroup('FocusDisable', { clear = true })

    -- Disable focus per window (buftype)
    vim.api.nvim_create_autocmd('WinEnter', {
      group = augroup,
      callback = function()
        if vim.tbl_contains(ignore_buftypes, vim.bo.buftype) then
          vim.w.focus_disable = true
        else
          vim.w.focus_disable = false
        end
      end,
      desc = 'Disable focus autoresize for BufType',
    })

    -- Disable focus per buffer (filetype)
    vim.api.nvim_create_autocmd('FileType', {
      group = augroup,
      callback = function()
        if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
          vim.b.focus_disable = true
          vim.w.focus_disable = true -- extra robust für neo-tree
        else
          vim.b.focus_disable = false
        end
      end,
      desc = 'Disable focus autoresize for FileType',
    })
  end,
}
