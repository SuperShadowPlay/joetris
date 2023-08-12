state = require('state')

--[[
    Keyboardly things are done here
]]--

local movingPiece = require('movingPiece')

local keyboard = {}

-- Called whenever a key is pressed
-- (Only used for single-press actions like pause, quit, etc.)
keyboard.keypressed_list = {
    -- Quit the game
    [state.keybind.quit] = function()
        love.event.quit()
    end,

    -- Toggle debug info
    [state.keybind.debug] = function()
        state.debug = not state.debug
    end,

    [state.keybind.rotate_right] = function()
        movingPiece.rotate_right()
    end,

    [state.keybind.rotate_left] = function()
        movingPiece.rotate_left()
    end,
}

return keyboard