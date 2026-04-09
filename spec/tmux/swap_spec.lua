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
        swap._to = stub(swap, "_to")
    end)

    it("left maps to h", function()
        swap.to("left")
        assert.stub(swap._to).was.called_with("h")
    end)

    it("right maps to l", function()
        swap.to("right")
        assert.stub(swap._to).was.called_with("l")
    end)

    it("top maps to k", function()
        swap.to("top")
        assert.stub(swap._to).was.called_with("k")
    end)

    it("bottom maps to j", function()
        swap.to("bottom")
        assert.stub(swap._to).was.called_with("j")
    end)

    it("invalid direction does not call _to", function()
        swap.to("invalid")
        assert.stub(swap._to).was_not.called()
    end)
end)
