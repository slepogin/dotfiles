-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Treesitter-based folding instead of LazyVim's indent default:
-- with tab-indented languages (Go) and shiftwidth=2, indent folding jumps
-- 4 fold levels per indent step, which breaks one-level zo/zc nesting.
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
