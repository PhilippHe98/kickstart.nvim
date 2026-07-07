return {
  'ThePrimeagen/git-worktree.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
  },
  config = function()
    require('git-worktree').setup {
      update_on_change = true,
      update_on_change_command = 'e .',
      clearjumps_on_change = true,
      autopush = false,
    }

    -- Monkey-patch to fix Windows backslash paths at call time
    local git_worktree = require 'git-worktree'
    local orig_switch = git_worktree.switch_worktree
    git_worktree.switch_worktree = function(path)
      path = path:gsub('\\', '/')
      return orig_switch(path)
    end

    require('telescope').load_extension 'git_worktree'
  end,
  keys = {
    {
      '<leader>gwl',
      function()
        require('telescope').extensions.git_worktree.git_worktrees()
      end,
      desc = 'Git Worktrees: List / Switch',
    },
    {
      '<leader>gwc',
      function()
        require('telescope').extensions.git_worktree.create_git_worktree()
      end,
      desc = 'Git Worktrees: Create',
    },
  },
}
