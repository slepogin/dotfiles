-- ESP-IDF cross-compile support for clangd:
-- --query-driver whitelists the xtensa gcc so clangd may query it for its
-- system include paths (sys/features.h etc live in the toolchain, not on
-- the host). It is a whitelist, not a redirect — host projects whose
-- compile commands use cc/clang never match the glob and are unaffected.
--
-- Appended via function-form opts so LazyVim's default clangd args stay
-- whatever the clangd extra ships, instead of a hardcoded copy.
return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      local clangd = opts.servers.clangd or {}
      opts.servers.clangd = clangd
      clangd.cmd = clangd.cmd or { "clangd" }
      table.insert(clangd.cmd,
        "--query-driver=" .. vim.env.HOME .. "/.espressif/tools/**/xtensa-esp32-elf-gcc")
    end,
  },
}
