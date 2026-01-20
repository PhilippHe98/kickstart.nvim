return {
  'Shatur/neovim-tasks',
  dependencies = { 'nvim-lua/plenary.nvim' },
  opts = {
    default_params = {
      cmake = {},
    },
  },
  config = function()
    local tasks = require 'tasks'
    local cmake_utils = require 'tasks.cmake_utils.cmake_utils'
    local cmake_presets = require 'tasks.cmake_utils.cmake_presets'
    local ProjectConfig = require 'tasks.project_config'

    vim.keymap.set('n', '<leader>cC', ':Task start cmake configure<CR>', { silent = true, desc = 'CMake: configure' })
    vim.keymap.set('n', '<leader>cD', ':Task start cmake configureDebug<CR>', { silent = true, desc = 'CMake: configure Debug' })
    vim.keymap.set('n', '<leader>cP', ':Task start cmake reconfigure<CR>', { silent = true, desc = 'CMake: reconfigure' })
    vim.keymap.set('n', '<leader>cT', ':Task start cmake ctest<CR>', { silent = true, desc = 'CMake: run tests (ctest)' })
    vim.keymap.set('n', '<leader>cK', ':Task start cmake clean<CR>', { silent = true, desc = 'CMake: clean build' })
    vim.keymap.set('n', '<leader>ct', ':Task set_module_param cmake target<CR>', { silent = true, desc = 'CMake: select target' })
    vim.keymap.set('n', '<leader>cr', ':Task start cmake run<CR>', { silent = true, desc = 'CMake: run executable' })
    vim.keymap.set('n', '<F7>', ':Task start cmake debug<CR>', { silent = true, desc = 'CMake: start debugger' })
    vim.keymap.set('n', '<leader>cb', ':Task start cmake build<CR>', { silent = true, desc = 'CMake: build' })
    vim.keymap.set('n', '<leader>cB', ':Task start cmake build_all<CR>', { silent = true, desc = 'CMake: build all targets' })

    local function openCCMake()
      local build_dir = tostring(cmake_utils.getBuildDir())
      vim.cmd('bo sp term://ccmake ' .. build_dir)
    end
    vim.keymap.set('n', '<leader>cm', openCCMake, { silent = true, desc = 'CMake: open ccmake' })

    local function selectPreset()
      local presets = cmake_presets.parse 'buildPresets'

      vim.ui.select(presets, { prompt = 'Select build preset' }, function(choice)
        if not choice then
          return
        end

        local projectConfig = ProjectConfig:new()
        projectConfig.cmake = projectConfig.cmake or {}
        projectConfig.cmake.build_preset = choice

        cmake_utils.autoselectConfigurePresetFromCurrentBuildPreset(projectConfig)
      end)
    end

    vim.keymap.set('n', '<leader>ck', function()
      if cmake_utils.shouldUsePresets() then
        selectPreset()
      else
        tasks.set_module_param('cmake', 'build_kit')
      end
    end, { silent = true, desc = 'CMake: select kit/preset' })

    vim.keymap.set('n', '<leader>cv', function()
      if cmake_utils.shouldUsePresets() then
        selectPreset()
      else
        tasks.set_module_param('cmake', 'build_type')
      end
    end, { silent = true, desc = 'CMake: select build type/preset' })
  end,
}
