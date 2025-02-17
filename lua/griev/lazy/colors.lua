function SetColorScheme(color)
	color = color or "kanagawa"
	vim.cmd.colorscheme(color)

    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
end

return {
    {
        "nyoom-engineering/oxocarbon.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            SetColorScheme("oxocarbon")
        end
    },
    {
        "rebelot/kanagawa.nvim",
        name = "kanagawa",
        config = function()
            require('kanagawa').setup({
                transparent = true
            })
        end
    },
    {
        "nyoom-engineering/oxocarbon.nvim",
        name = "oxocarbon",
        opts = {},
    }
}
