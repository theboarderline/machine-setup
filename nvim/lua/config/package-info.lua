local package_info = require("package-info")

package_info.setup({
    colors = {
        up_to_date = "#3C4048",
        outdated = "#f03a3a",
    },
    icons = {
        enable = true,
        style = {
            up_to_date = "|  ",
            outdated = "|  ",
        },
    },
    autostart = true,
    hide_up_to_date = true,
    hide_unstable_versions = false,
    package_manager = 'yarn'
})

