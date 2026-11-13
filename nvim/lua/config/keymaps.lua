-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Calls made inside the current function, as a quickfix list in THIS file.
-- Not vim.lsp.buf.outgoing_calls: its default handler pairs the callee's
-- filename with the caller's fromRanges line numbers (still broken in the
-- 0.12 runtime, handlers.lua make_call_hierarchy_handler), which lands
-- entries in the wrong files.
vim.keymap.set("n", "<leader>sO", function()
  local bufnr = vim.api.nvim_get_current_buf()
  local client = vim.lsp.get_clients({ bufnr = bufnr, method = "callHierarchy/outgoingCalls" })[1]
  if not client then
    return vim.notify("No LSP client with call hierarchy support", vim.log.levels.WARN)
  end

  -- Find the enclosing function via treesitter so the cursor can be anywhere
  -- in the body, not only on the function name.
  local fn_types = {
    function_declaration = true, -- Go
    method_declaration = true, -- Go
    func_literal = true, -- Go closures
    function_definition = true, -- lua/python/...
  }
  local node = vim.treesitter.get_node()
  while node and not fn_types[node:type()] do
    node = node:parent()
  end

  local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
  if node then
    local name = node:field("name")[1]
    if name then
      local row, col = name:start()
      params.position = { line = row, character = col }
    end
  end

  client:request("textDocument/prepareCallHierarchy", params, function(err, result)
    if err or not result or not result[1] then
      return vim.notify("No function found for call hierarchy", vim.log.levels.WARN)
    end
    local item = result[1]
    client:request("callHierarchy/outgoingCalls", { item = item }, function(err2, calls)
      if err2 or not calls or #calls == 0 then
        return vim.notify("No outgoing calls in " .. item.name, vim.log.levels.INFO)
      end
      -- fromRanges are positions in the CALLER (this function), so every
      -- quickfix entry belongs to the caller's file.
      local fname = vim.uri_to_fname(item.uri)
      local qf = {}
      for _, call in ipairs(calls) do
        for _, range in ipairs(call.fromRanges) do
          qf[#qf + 1] = {
            filename = fname,
            lnum = range.start.line + 1,
            col = range.start.character + 1,
            text = call.to.name,
          }
        end
      end
      table.sort(qf, function(a, b)
        return a.lnum == b.lnum and a.col < b.col or a.lnum < b.lnum
      end)
      vim.fn.setqflist({}, " ", { title = "Calls in " .. item.name, items = qf })
      vim.cmd("botright copen")
    end, bufnr)
  end, bufnr)
end, { desc = "Calls inside current function" })
