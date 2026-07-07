return {
  'GustavEikaas/easy-dotnet.nvim',
  dependencies = { 'nvim-lua/plenary.nvim', 'mfussenegger/nvim-dap', 'nvim-telescope/telescope.nvim' },
  config = function()
    local dotnet = require 'easy-dotnet'
    dotnet.setup {
      lsp = {
        preload_roslyn = false,
        auto_refresh_codelens = false,
      },
      test_runner = {
        viewmode = 'float',
      },
    }

    local sln = require 'easy-dotnet.current_solution'
    vim.keymap.set('n', '<leader>dS', function()
      sln.pick_solution(function(path)
        if path then
          sln.set_solution(path)
          vim.notify('Solution: ' .. vim.fn.fnamemodify(path, ':t') .. ' -- LSP neu starten mit :LspRestart', vim.log.levels.INFO)
        end
      end)
    end, { desc = '[D]otnet [S]olution wechseln' })
  end,
}
