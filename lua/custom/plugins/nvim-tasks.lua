return {
  'Shatur/neovim-tasks',
  dependencies = { 'nvim-lua/plenary.nvim' },
  -- Hier übergeben wir die festen Parameter direkt an das Plugin,
  -- ohne die neovim.json-Generierung zu verwirren.
  opts = {
    default_params = {
      cmake = {
        cmd = 'cmake',
        -- Zwingt neovim-tasks, stur dein CMakePresets-Verzeichnis zu nutzen
        build_dir = vim.fs.normalize(vim.fn.getcwd() .. '/build/debug'),
        -- Standard-DAP-Adapter für dieses Modul definieren
        dap_name = 'codelldb',
        dap_open_command = false,
      },
    },
  },
  config = function(_, opts)
    local tasks = require 'tasks'
    tasks.setup(opts)

    -- =====================================================================
    -- WINDOWS EXEC PATH CONFIG
    -- Wir klinken uns direkt in nvim-dap ein, um den übergebenen Pfad
    -- für Windows glattzubügeln, falls neovim-tasks ihn fehlerhaft übergibt.
    -- =====================================================================
    if vim.fn.has 'win32' == 1 then
      local dap = require 'dap'
      -- Wenn die C++ Konfiguration geladen wird, zwingen wir das Target
      -- auf Backslashes und stellen die .exe Endung sicher.
      dap.listeners.before.event_initialized['neovim-tasks-fix'] = function(session)
        if session.config and session.config.program then
          session.config.program = vim.fs.normalize(session.config.program):gsub('/', '\\')
          if not session.config.program:match '%.exe$' then
            session.config.program = session.config.program .. '.exe'
          end
        end
      end
    end
    -- =====================================================================

    local cmake_utils = require 'tasks.cmake_utils.cmake_utils'
    local cmake_presets = require 'tasks.cmake_utils.cmake_presets'
    local ProjectConfig = require 'tasks.project_config'

    -- Keymaps
    vim.keymap.set('n', '<leader>cC', ':Task start cmake configure<CR>', { silent = true, desc = 'CMake: configure' })
    vim.keymap.set('n', '<leader>cD', ':Task start cmake configureDebug<CR>', { silent = true, desc = 'CMake: configure Debug' })
    vim.keymap.set('n', '<leader>cP', ':Task start cmake reconfigure<CR>', { silent = true, desc = 'CMake: reconfigure' })
    vim.keymap.set('n', '<leader>cT', ':Task start cmake ctest<CR>', { silent = true, desc = 'CMake: run tests (ctest)' })
    vim.keymap.set('n', '<leader>cK', ':Task start cmake clean<CR>', { silent = true, desc = 'CMake: clean build' })
    vim.keymap.set('n', '<leader>ct', ':Task set_module_param cmake target<CR>', { silent = true, desc = 'CMake: select target' })
    vim.keymap.set('n', '<leader>cr', ':Task start cmake run<CR>', { silent = true, desc = 'CMake: run executable' })
    vim.keymap.set('n', '<leader>cd', ':Task start cmake debug<CR>', { silent = true, desc = 'CMake: start debugger' })
    vim.keymap.set('n', '<leader>cb', ':Task start cmake build<CR>', { silent = true, desc = 'CMake: build' })
    vim.keymap.set('n', '<leader>cB', ':Task start cmake build_all<CR>', { silent = true, desc = 'CMake: build all targets' })

    local function openCCMake()
      local build_dir = tostring(require('tasks.cmake_utils.cmake_utils').getBuildDir())
      vim.cmd([[bo sp term://ccmake ]] .. build_dir)
    end
    vim.keymap.set('n', '<leader>cm', openCCMake, { silent = true, desc = 'CMake: open ccmake' })

    local function selectPreset()
      local availablePresets = cmake_presets.parse 'buildPresets'

      vim.ui.select(availablePresets, { prompt = 'Select build preset' }, function(choice, idx)
        if not idx then
          return
        end
        local projectConfig = ProjectConfig:new()
        if not projectConfig['cmake'] then
          projectConfig['cmake'] = {}
        end

        projectConfig['cmake']['build_preset'] = choice

        -- autoselect will invoke projectConfig:write()
        cmake_utils.autoselectConfigurePresetFromCurrentBuildPreset(projectConfig)
      end)
    end

    local function selectBuildKitOrPreset()
      if cmake_utils.shouldUsePresets() then
        selectPreset()
      else
        tasks.set_module_param('cmake', 'build_kit')
      end
    end

    vim.keymap.set('n', '<leader>ck', selectBuildKitOrPreset, { silent = true })

    local function selectBuildTypeOrPreset()
      if cmake_utils.shouldUsePresets() then
        selectPreset()
      else
        tasks.set_module_param('cmake', 'build_type')
      end
    end

    vim.keymap.set('n', '<leader>cv', selectBuildTypeOrPreset, { silent = true })
  end,
}
