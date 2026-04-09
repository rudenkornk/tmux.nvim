---@diagnostic disable: duplicate-set-field
describe("resize", function()
    -- local resize

    local layout
    local options
    local tmux

    setup(function()
        require("spec.tmux.mocks.log_mock").setup()
        require("spec.tmux.mocks.tmux_mock").setup("3.2a")

        -- resize = require("tmux.resize")

        layout = require("tmux.layout")
        options = require("tmux.configuration.options")
        tmux = require("tmux.wrapper.tmux")
    end)

    it("check is_tmux false", function()
        tmux.is_tmux = false
    end)

    it("check is_zoomed true", function()
        tmux.is_tmux = true
        tmux.is_zoomed = function()
            return true
        end
        layout.is_border = function(_)
            return false
        end

        options.navigation.persist_zoom = true
    end)

    it("check is_border false", function()
        tmux.is_tmux = true
        tmux.is_zoomed = function()
            return false
        end
        layout.is_border = function(_)
            return false
        end
    end)

    it("check is_border true", function()
        tmux.is_tmux = true
        tmux.is_zoomed = function()
            return false
        end
        layout.is_border = function(_)
            return true
        end

        options.navigation.cycle_navigation = false
    end)
end)

describe("resize.to", function()
    local resize

    setup(function()
        require("spec.tmux.mocks.log_mock").setup()
        require("spec.tmux.mocks.tmux_mock").setup("3.2a")

        _G.vim = { api = { nvim_set_keymap = function() end } }

        resize = require("tmux.resize")
    end)

    before_each(function()
        resize.to_left = stub(resize, "to_left")
        resize.to_right = stub(resize, "to_right")
        resize.to_top = stub(resize, "to_top")
        resize.to_bottom = stub(resize, "to_bottom")
    end)

    it("left calls to_left", function()
        resize.to("left")
        assert.stub(resize.to_left).was.called_with(nil)
        assert.stub(resize.to_right).was_not.called()
        assert.stub(resize.to_top).was_not.called()
        assert.stub(resize.to_bottom).was_not.called()
    end)

    it("right calls to_right", function()
        resize.to("right")
        assert.stub(resize.to_right).was.called_with(nil)
        assert.stub(resize.to_left).was_not.called()
        assert.stub(resize.to_top).was_not.called()
        assert.stub(resize.to_bottom).was_not.called()
    end)

    it("top calls to_top", function()
        resize.to("top")
        assert.stub(resize.to_top).was.called_with(nil)
        assert.stub(resize.to_left).was_not.called()
        assert.stub(resize.to_right).was_not.called()
        assert.stub(resize.to_bottom).was_not.called()
    end)

    it("bottom calls to_bottom", function()
        resize.to("bottom")
        assert.stub(resize.to_bottom).was.called_with(nil)
        assert.stub(resize.to_left).was_not.called()
        assert.stub(resize.to_right).was_not.called()
        assert.stub(resize.to_top).was_not.called()
    end)

    it("forwards step argument", function()
        resize.to("left", 5)
        assert.stub(resize.to_left).was.called_with(5)
    end)

    it("invalid direction does not call any to_* function", function()
        resize.to("invalid")
        assert.stub(resize.to_left).was_not.called()
        assert.stub(resize.to_right).was_not.called()
        assert.stub(resize.to_top).was_not.called()
        assert.stub(resize.to_bottom).was_not.called()
    end)
end)
