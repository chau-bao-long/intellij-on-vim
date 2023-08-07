local M = {}

M.get_channel = function()
  local channels = vim.api.nvim_list_chans()

  for i, channel in ipairs(channels) do
    if channel.stream == "socket" then
      return channel
    end
  end
  
  return nil
end

return M
