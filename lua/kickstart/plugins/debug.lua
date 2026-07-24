-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    -- 'rcarriga/nvim-dap-ui',
    'theHamsta/nvim-dap-virtual-text',

    -- Required dependency for nvim-dap-ui
    -- 'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'mason-org/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
  },
  keys = {
    -- Basic debugging keymaps, feel free to change to your liking!
    {
      '<leader>ds',
      function()
        require('dap').continue()
      end,
      desc = 'Debug: [S]tart/Continue',
    },
    {
      '<F1>',
      function()
        require('dap').step_into()
      end,
      desc = 'Debug: Step Into',
    },
    {
      '<F2>',
      function()
        require('dap').step_over()
      end,
      desc = 'Debug: Step Over',
    },
    {
      '<F3>',
      function()
        require('dap').step_out()
      end,
      desc = 'Debug: Step Out',
    },
    {
      '<leader>db',
      function()
        require('dap').toggle_breakpoint()
      end,
      desc = 'Debug: Toggle [B]reakpoint',
    },
    {
      '<leader>dB',
      function()
        require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end,
      desc = 'Debug: Set [B]reakpoint',
    },
    {
      '<leader>dc',
      function()
        require('dap').run_to_cursor()
      end,
      desc = 'Debug: Debug: Run to [C]ursor',
    },
  },
  config = function()
    local dap = require 'dap'
    local is_windows = vim.fn.has 'win32' == 1

    -- =====================================================================
    -- REPL-FENSTER DEAKTIVIEREN
    -- Verhindert, dass neovim-tasks oder dap das REPL-Fenster erzwingen
    -- =====================================================================
    dap.repl.open = function()
      -- Absichtlich leer, um das automatische Öffnen komplett zu blockieren
    end
    -- =====================================================================

    require('nvim-dap-virtual-text').setup()

    -- Mason-nvim-dap sorgt NUR für die automatische Installation
    require('mason-nvim-dap').setup {
      automatic_installation = true,
      ensure_installed = {
        'delve',
        'netcoredbg',
        'codelldb',
      },
    }

    -- C# (.NET) Debugger Adapter direkt und fehlerfrei definieren
    -- Windows nutzt eine tiefere Verschachtelung im Mason-Ordner
    local netcoredbg_path = ''
    if is_windows then
      netcoredbg_path = vim.fs.normalize(vim.fn.stdpath 'data' .. '/mason/packages/netcoredbg/netcoredbg/netcoredbg.exe')
    else
      netcoredbg_path = vim.fs.normalize(vim.fn.stdpath 'data' .. '/mason/packages/netcoredbg/netcoredbg')
    end

    local netcoredbg_adapter = {
      type = 'executable',
      command = netcoredbg_path,
      args = { '--interpreter=vscode' },
    }

    -- Beide Bezeichner registrieren, damit checkhealth UND deine Konfigurationen glücklich sind
    dap.adapters.netcoredbg = netcoredbg_adapter
    dap.adapters.coreclr = netcoredbg_adapter

    -- C# (.NET) Configurations
    dap.configurations.cs = {
      {
        type = 'coreclr',
        name = 'launch - netcoredbg',
        request = 'launch',
        program = function()
          return vim.fn.input('Path to dll: ', vim.fn.getcwd() .. '/bin/Debug/net9.0/', 'file')
        end,
      },
    }

    -- =====================================================================
    -- C++ (codelldb) Adapter-Registrierung
    -- =====================================================================
    local codelldb_path = vim.fs.normalize(vim.fn.stdpath 'data' .. '/mason/bin/codelldb.CMD')
    if is_windows then
      codelldb_path = codelldb_path:gsub('/', '\\')
    end

    dap.configurations.cpp = {
      {
        name = 'cpp',
        type = 'codelldb',
        request = 'launch',
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = true,
        expressions = 'native',
        sourceLanguages = { 'cpp' },
        initCommands = { 'settings set target.prefer-dynamic-value run-target' },
      },
    }

    dap.adapters.codelldb = {
      type = 'server',
      port = '${port}',
      executable = {
        command = codelldb_path,
        args = { '--port', '${port}' },
        -- Verhindert das Aufpoppen extra CMD-Fenster unter Windows
        detached = false,
      },
    }
    -- =====================================================================

    dap.configurations.c = dap.configurations.cpp

    -- Change breakpoint icons
    vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
    vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
    local breakpoint_icons = vim.g.have_nerd_font
        and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
      or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
    for type, icon in pairs(breakpoint_icons) do
      local tp = 'Dap' .. type
      local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
      vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
    end

    -- Install golang specific config
    require('dap-go').setup {
      delve = {
        detached = vim.fn.has 'win32' == 0,
      },
    }
  end,
}
