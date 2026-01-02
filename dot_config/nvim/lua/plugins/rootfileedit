return {
    "lambdalisue/suda.vim",
    config = function()
        -- Auto run :SudaRead if the file requires sudo
        vim.api.nvim_create_autocmd("BufReadPost", {
            callback = function()
                local buf = vim.api.nvim_get_current_buf()
                local file = vim.api.nvim_buf_get_name(buf)

                -- Skip if it's not a file path
                if file == '' or vim.fn.filereadable(file) == 0 then return end

                -- Use libuv to stat the file
                local stat = vim.loop.fs_stat(file)
                if not stat then return end

                -- Check for root ownership and non-writable file
                local needs_sudo = stat.uid == 0 and vim.fn.filewritable(file) == 0

                if needs_sudo then
                    vim.schedule(function()
                        vim.cmd("SudaRead")
                    end)
                end
            end
        })
    end
}
