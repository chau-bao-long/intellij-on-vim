local api = vim.api
local M = {}

M.setup = function(opt)
  dump(api.nvim_list_chans)
end

return M
