return {
  "stevearc/conform.nvim",
  opts = function(_, opts)
    opts.formatters_by_ft = opts.formatters_by_ft or {}
    opts.formatters = opts.formatters or {}

    -- Use kdlfmt for KDL files
    opts.formatters_by_ft.kdl = { "kdlfmt" }

    opts.formatters.kdlfmt = {
      command = "kdlfmt",
      args = { "format", "--stdin" },
      stdin = true,
    }
  end,
}
