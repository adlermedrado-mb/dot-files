local parsers = {
  "lua",
  "python",
  "javascript",
  "typescript",
  "go",
  "gomod",
  "gosum",
  "c",
  "bash",
  "markdown",
  "markdown_inline",
  "json",
  "yaml",
  "vim",
  "vimdoc",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    lazy = false,
    build = function()
      require("nvim-treesitter").install(parsers):wait(300000)
    end,
    config = function()
      local treesitter = require("nvim-treesitter")
      local install_dir = vim.fn.stdpath("data") .. "/site"

      treesitter.setup({ install_dir = install_dir })

      local enabled = {}
      for _, lang in ipairs(parsers) do
        enabled[lang] = true
      end

      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
        callback = function(args)
          local ft = vim.bo[args.buf].filetype
          local lang = vim.treesitter.language.get_lang(ft)

          if lang and enabled[lang] then
            pcall(vim.treesitter.start, args.buf, lang)
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })

      vim.keymap.set({ "n", "x" }, "<C-space>", function()
        vim.treesitter.select("parent", vim.v.count1)
      end, { desc = "Expand selection" })

      vim.keymap.set("x", "<bs>", function()
        vim.treesitter.select("child", vim.v.count1)
      end, { desc = "Shrink selection" })
    end,
  },
}
