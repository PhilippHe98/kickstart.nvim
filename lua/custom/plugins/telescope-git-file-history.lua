return {
  'isak102/telescope-git-file-history.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'tpope/vim-fugitive',
    'nvim-telescope/telescope.nvim',
  },
  keys = {
    {
      '<leader>gh',
      function()
        require('telescope').extensions.git_file_history.git_file_history()
      end,
      desc = 'Git: File History',
    },
  },
}
