return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown" },
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "echasnovski/mini.icons",
    },
    opts = {
      file_types = { "markdown" },
      completions = {
        lsp = { enabled = true },
      },
    },
    keys = {
      {
        "<leader>mp",
        function()
          require("render-markdown").toggle()
        end,
        ft = "markdown",
        desc = "Toggle Markdown preview",
      },
    },
  },
}
