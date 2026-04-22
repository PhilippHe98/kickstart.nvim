return {
  'coder/claudecode.nvim',
  dependencies = { 'folke/snacks.nvim' },
  config = true,
  opts = {
    terminal = {
      provider = 'none', -- no UI actions; server + tools remain available
    },
  },
  keys = {
    { '<leader>C', nil, desc = 'AI/[C]laude Code' },
    {
      '<leader>Cc',
      function()
        local claudecode = require 'claudecode'
        local port = claudecode.state.port

        if not port then
          -- Try to start the server if it's not running
          local success, result = claudecode.start()
          if success then
            port = result
          else
            vim.notify('Failed to start Claude Code server', vim.log.levels.ERROR)
            return
          end
        end

        -- Show the command to run
        local cmd = string.format('$env:CLAUDE_CODE_SSE_PORT="%s"; $env:ENABLE_IDE_INTEGRATION="true"; claude', port)
        vim.notify('Claude Code server running on port ' .. port .. '\nRun in your terminal: ' .. cmd, vim.log.levels.INFO)

        -- Copy command to clipboard
        vim.fn.setreg('+', cmd)
        vim.notify('Command copied to clipboard!', vim.log.levels.INFO)
      end,
      desc = 'Show [C]laude command with IDE integration',
    },
    { '<leader>Cf', '<cmd>ClaudeCodeFocus<cr>', desc = 'Focus [C]laude' },
    { '<leader>Cr', '<cmd>ClaudeCode --resume<cr>', desc = 'Resume [C]laude' },
    { '<leader>CC', '<cmd>ClaudeCode --continue<cr>', desc = 'Continue [C]laude' },
    { '<leader>Cm', '<cmd>ClaudeCodeSelectModel<cr>', desc = 'Select [C]laude model' },
    { '<leader>Cb', '<cmd>ClaudeCodeAdd %<cr>', desc = 'Add current buffer' },
    { '<leader>Cs', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = 'Send to [C]laude' },
    {
      '<leader>Cs',
      '<cmd>ClaudeCodeTreeAdd<cr>',
      desc = 'Add file',
      ft = { 'NvimTree', 'neo-tree', 'oil', 'minifiles', 'netrw' },
    },
    -- Diff management
    { '<leader>Ca', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Accept diff' },
    { '<leader>Cd', '<cmd>ClaudeCodeDiffDeny<cr>', desc = 'Deny diff' },
  },
}
