return {
  'ThePrimeagen/harpoon',
  config = function()
    require('harpoon').setup {}
    local mark = require 'harpoon.mark'
    local ui = require 'harpoon.ui'

    -- Keybindings
    vim.keymap.set('n', '<leader>a', mark.add_file, { desc = 'Harpoon: Add current file' })
    vim.keymap.set('n', '<leader>q', ui.toggle_quick_menu, { desc = 'Harpoon: Toggle quick menu' })
    vim.keymap.set('n', '<leader>1', function()
      ui.nav_file(1)
    end, { desc = 'Harpoon: Go to file 1' })
    vim.keymap.set('n', '<leader>2', function()
      ui.nav_file(2)
    end, { desc = 'Harpoon: Go to file 2' })
    vim.keymap.set('n', '<leader>3', function()
      ui.nav_file(3)
    end, { desc = 'Harpoon: Go to file 3' })
    vim.keymap.set('n', '<leader>4', function()
      ui.nav_file(4)
    end, { desc = 'Harpoon: Go to file 4' })
    vim.keymap.set('n', '<leader>r1', function()
      mark.rm_file(1)
    end, { desc = 'Harpoon: Remove file 1' })

    vim.keymap.set('n', '<leader>r1', function()
      mark.rm_file(1)
    end, { desc = 'Harpoon: Remove file 1' })

    vim.keymap.set('n', '<leader>r2', function()
      mark.rm_file(2)
    end, { desc = 'Harpoon: Remove file 2' })

    vim.keymap.set('n', '<leader>r3', function()
      mark.rm_file(3)
    end, { desc = 'Harpoon: Remove file 3' })

    vim.keymap.set('n', '<leader>r4', function()
      mark.rm_file(4)
    end, { desc = 'Harpoon: Remove file 4' })
  end,
}
