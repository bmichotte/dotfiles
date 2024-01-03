return {
    "vuki656/package-info.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    config = function()
        require('package-info').setup()

        vim.keymap.set({ "n" }, "<leader>ns", require("package-info").show,
            { silent = true, noremap = true, desc = "Show dependency versions" })
        vim.keymap.set({ "n" }, "<leader>nc", require("package-info").hide,
            { silent = true, noremap = true, desc = "Hide dependency versions" })
        vim.keymap.set({ "n" }, "<leader>nt", require("package-info").toggle,
            { silent = true, noremap = true, desc = "Toggle dependency versions" })
        vim.keymap.set({ "n" }, "<leader>nu", require("package-info").update,
            { silent = true, noremap = true, desc = "Update dependency on the line" })
        vim.keymap.set({ "n" }, "<leader>nd", require("package-info").delete,
            { silent = true, noremap = true, desc = "Delete dependency on the line" })
        vim.keymap.set({ "n" }, "<leader>ni", require("package-info").install,
            { silent = true, noremap = true, desc = "Install a new dependency" })
        vim.keymap.set({ "n" }, "<leader>np", require("package-info").change_version,
            { silent = true, noremap = true, desc = "Install a different dependency version" })
    end
}
