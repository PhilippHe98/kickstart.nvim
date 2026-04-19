return {
  {
    'igorlfs/nvim-dap-view',
    -- let the plugin lazy load itself
    lazy = false,
    version = '1.*',
    ---@module 'dap-view'
    ---@type dapview.Config
    opts = {
      windows = {
        position = 'right',
        size = 0.5,
        terminal = {
          size = 0.25,
          position = 'left',
          -- List of debug adapters for which the terminal should be ALWAYS hidden
          hide = {},
        },
      },
      virtual_text = {
        -- Control with `DapViewVirtualTextToggle`
        enabled = true,
        format = function(variable, _, _)
          -- Strip out excessive whitespace
          return ' ' .. variable.value:gsub('%s+', ' ')
        end,
      },
    },
    config = function(_, opts)
      local dapview = require 'dap-view'
      dapview.setup(opts)

      local dap = require 'dap'
      dap.listeners.after.event_initialized['dapview_config'] = function()
        dapview.open()
      end
      dap.listeners.before.event_terminated['dapview_config'] = function()
        dapview.close()
      end
      dap.listeners.before.event_exited['dapview_config'] = function()
        dapview.close()
      end
    end,
  },
}
