local Channels = require("intellij-on-vim.channels")
local RPC = require('intellij-on-vim.rpc')
local M = {}
local buf_enter_timer = nil
local cursor_move_timer = nil

M.is_vim_focused = true

M.setup = function()
  vim.api.nvim_create_autocmd("BufEnter", {
		callback = function(event)
      if M.is_vim_focused then
        if buf_enter_timer ~= nil then
          vim.fn.timer_stop(buf_enter_timer)
        end
        buf_enter_timer = vim.fn.timer_start(200, function ()
          local buf_id = vim.api.nvim_get_current_buf()
          local buf_path = vim.api.nvim_buf_get_name(0)

          RPC.notify_buffer_enter(buf_id, buf_path)

          buf_enter_timer = nil
        end)
      end
    end,
		group = vim.api.nvim_create_augroup("intellij_on_vim_buf_enter", {clear = true})
	})

  vim.api.nvim_create_autocmd("CursorMoved", {
    callback = function()
      if M.is_vim_focused then
        if cursor_move_timer ~= nil then
          vim.fn.timer_stop(cursor_move_timer)
        end
        cursor_move_timer = vim.fn.timer_start(200, function ()
          local file = vim.fn.expand("%:p")
          local offset = vim.fn.line2byte(vim.fn.line('.')) + vim.fn.col('.') - 2

          RPC.request_sync_cursor(file, offset)

          cursor_move_timer = nil
        end)
      end
    end
  })

  vim.api.nvim_create_autocmd("FocusGained", {
    callback = function(event)
      M.is_vim_focused =  true
    end,
    group = vim.api.nvim_create_augroup("intellij_on_vim_focus_gained", {clear = true})
  })

  vim.api.nvim_create_autocmd("FocusLost", {
    callback = function(event)
      M.is_vim_focused =  false
    end,
    group = vim.api.nvim_create_augroup("intellij_on_vim_focus_lost", {clear = true})
  })

  vim.api.nvim_create_autocmd("FocusLost", {
    callback = function(event)
      vim.cmd("w")
    end,
    group = vim.api.nvim_create_augroup("intellij_on_vim_focus_lost_kotlin_file", {clear = true}),
    pattern = {"*.kt","*.kts"}
  })
end


return M
