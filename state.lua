--[[
    Keeps track of various game state objects.
    Every item is initialized with defaults in case save data
    does not load correctly.
]]

local state = {}

state.mouseX = 100
state.mouseY = 100

--[[
    Keybinds used for various user input situations.
    Keybinds are implemented using scancodes.
    https://love2d.org/wiki/Scancode
]]--
state.keybind = {
    move_up = 'w',
    move_down = 's',
    move_left = 'a',
    move_right = 'd',
    pause = 'p',
    quit = 'escape',
    debug = 'b',
    rotate_right = 'e',
    rotate_left = 'q',
}

-- Gameboard status (10x20)
state.board = {
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
    {0, 0, 0, 0, 0, 0, 0, 0, 0, 0},
}

state.active_piece = {
    pos = {
        x = 0,
        y = 0
    },
    type = 1,
    rotation = 1,
}

state.piece_bag = {1, 2, 3, 4, 5, 6, 7}

-- Stores global timer
state.timeSinceTick = 0
state.tick = 0

-- Debug enabled flag
state.debug = true


return state