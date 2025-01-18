local nvim_notify = require("notify")

nvim_notify.setup {
  stages = "fade_in_slide_out",
  timeout = 1000,
  background_colour = "#2E3440",
}

vim.notify = nvim_notify
