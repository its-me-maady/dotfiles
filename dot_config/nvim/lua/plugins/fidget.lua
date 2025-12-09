return {
    "j-hui/fidget.nvim",
    opts = {
        notification = {
            window = {
                winblend = 0,
            },
        },
    },
    config = function ()
        require("telescope").load_extension("fidget")
    end
}
