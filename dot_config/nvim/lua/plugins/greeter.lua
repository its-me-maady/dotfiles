return {
    'goolord/alpha-nvim',
    config = function()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")

        -- 🎨 Custom ASCII Banner (modify as you like)
        dashboard.section.header.val = {
            [[ ███╗   ███╗ █████╗  █████╗ ██████╗ ██╗   ██╗    ███████╗            ██╗   ██╗██╗███╗   ███╗  ]],
            [[ ████╗ ████║██╔══██╗██╔══██╗██╔══██╗╚██╗ ██╔╝    ██╔════╝            ██║   ██║██║████╗ ████║  ]],
            [[ ██╔████╔██║███████║███████║██║  ██║ ╚████╔╝     ███████╗            ██║   ██║██║██╔████╔██║  ]],
            [[ ██║╚██╔╝██║██╔══██║██╔══██║██║  ██║  ╚██╔╝      ╚════██║            ╚██╗ ██╔╝██║██║╚██╔╝██║  ]],
            [[ ██║ ╚═╝ ██║██║  ██║██║  ██║██████╔╝   ██║       ███████║             ╚████╔╝ ██║██║ ╚═╝ ██║  ]],
            [[ ╚═╝     ╚═╝╚═╝  ╚═╝╚═╝  ╚═╝╚═════╝    ╚═╝       ╚══════╝              ╚═══╝  ╚═╝╚═╝     ╚═╝  ]],
        }

        -- 🧩 Leave space for your custom keymaps/buttons here
        dashboard.section.buttons.val = {
            dashboard.button("f", " Find File", ":Telescope find_files<CR>"),
            dashboard.button("n", " New File", ":ene <BAR> startinsert <CR>"),
            dashboard.button("g", " Find Text", ":Telescope live_grep<CR>"),
            dashboard.button("r", " Recent Files", ":Telescope oldfiles<CR>"),
            dashboard.button("L", "󰒲 Lazy", ":Lazy<CR>"),
            dashboard.button("q", " Quit", ":qa<CR>"),
        }

        -- 🧼 Footer (optional)
        dashboard.section.footer.val = {
            " Tip: Press 'SPC' to open Lazy or keymaps!",
        }

        -- Apply setup
        alpha.setup(dashboard.config)
    end
};
