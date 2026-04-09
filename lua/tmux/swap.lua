local keymaps = require("tmux.keymaps")
local options = require("tmux.configuration.options")
local layout = require("tmux.layout")
local nvim = require("tmux.wrapper.nvim")
local tmux = require("tmux.wrapper.tmux")

local M = {}

function M.setup()
    if options.swap.enable_default_keybindings then
        keymaps.register("n", {
            ["<C-A-h>"] = [[<cmd>lua require'tmux'.swap_left()<cr>]],
            ["<C-A-j>"] = [[<cmd>lua require'tmux'.swap_bottom()<cr>]],
            ["<C-A-k>"] = [[<cmd>lua require'tmux'.swap_top()<cr>]],
            ["<C-A-l>"] = [[<cmd>lua require'tmux'.swap_right()<cr>]],
        })
    end
end

function M._to(direction)
    local is_nvim_border = nvim.is_nvim_border(direction)
    local persist_zoom = true -- tmux swap-pane when zoomed causes error
    local has_tmux_target = layout.has_tmux_target(direction, persist_zoom, options.swap.cycle_navigation)
    if (nvim.is_nvim_float() or is_nvim_border) and has_tmux_target then
        tmux.swap(direction)
    elseif is_nvim_border and options.swap.cycle_navigation then
        nvim.swap(nvim.opposite_direction(direction), 999)
    elseif not is_nvim_border then
        nvim.swap(direction, vim.v.count)
    end
end

function M.to_left()
    M._to("h")
end

function M.to_bottom()
    M._to("j")
end

function M.to_top()
    M._to("k")
end

function M.to_right()
    M._to("l")
end

-- Note: this function is exposed to public API and uses "left/right/top/bottom" as direction,
-- instead of "h/j/k/l".
function M.to(direction)
    local direction_map = { left = "h", right = "l", top = "k", bottom = "j" }
    local res_direction = direction_map[direction]
    if res_direction then
        M._to(res_direction)
    else
        print("Invalid direction: " .. tostring(direction))
    end
end

return M
