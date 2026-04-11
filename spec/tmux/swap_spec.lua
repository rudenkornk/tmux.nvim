---@diagnostic disable: duplicate-set-field
describe("swap.to", function()
    local swap

    setup(function()
        require("spec.tmux.mocks.log_mock").setup()
        require("spec.tmux.mocks.tmux_mock").setup("3.2a")

        _G.vim = { api = { nvim_set_keymap = function() end } }

        swap = require("tmux.swap")
    end)

    before_each(function()
        swap.to = stub(swap, "to")
    end)

    it("left maps to h", function()
        swap.to("left")
        assert.stub(swap.to).was.called_with("left")
    end)

    it("right maps to l", function()
        swap.to("right")
        assert.stub(swap.to).was.called_with("right")
    end)

    it("top maps to k", function()
        swap.to("top")
        assert.stub(swap.to).was.called_with("top")
    end)

    it("bottom maps to j", function()
        swap.to("bottom")
        assert.stub(swap.to).was.called_with("bottom")
    end)
end)
