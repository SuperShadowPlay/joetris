state = require('state')

local movingPiece = {}

--[[
    Piece type numbers:
        1: Block
        2: Line
        3: L
        4: J
        5: T
        6: S
        7: Z
    Each shape has a number, and each shape number has a table of tables of
    how each block should be formed based on how it is being rotationed.
]]


local piece_shape = {
    [1] = {              -- Block
        {
            {0, 0, 0, 0},
            {0, 1, 1, 0},
            {0, 1, 1, 0},
            {0, 0, 0, 0},
        },
        {
            {0, 0, 0, 0},
            {0, 1, 1, 0},
            {0, 1, 1, 0},
            {0, 0, 0, 0}
        },
        {
            {0, 0, 0, 0},
            {0, 1, 1, 0},
            {0, 1, 1, 0},
            {0, 0, 0, 0}
        },
        {
            {0, 0, 0, 0},
            {0, 1, 1, 0},
            {0, 1, 1, 0},
            {0, 0, 0, 0}
        }
    },
    [2] = {              -- Line
        {
            {0, 1, 0, 0},
            {0, 1, 0, 0},
            {0, 1, 0, 0},
            {0, 1, 0, 0}
        },
        {
            {0, 0, 0, 0},
            {0, 0, 0, 0},
            {0, 0, 0, 0},
            {1, 1, 1, 1}
        },
        {
            {0, 1, 0, 0},
            {0, 1, 0, 0},
            {0, 1, 0, 0},
            {0, 1, 0, 0}
        },
        {
            {0, 0, 0, 0},
            {0, 0, 0, 0},
            {0, 0, 0, 0},
            {1, 1, 1, 1}
        },
    }
}

movingPiece.create_next = function(board_width)
    state.active_piece = {
        pos = {
            x = (board_width / 2) - 1,
            y = 0
        },
        type = state.piece_bag[1],
        rotation = 1,
        last_held = 0,
        restrict_right = false,
        restrict_left = false,
    }
    table.remove(state.piece_bag, 1)
end


local key_held_delay = 0.3 -- How long you have to hold a movement key for it to repeat the action


movingPiece.draw = function(block_size)
    love.graphics.setColor(1, 0, 0, 1)
    
    for y, shape_row in pairs(piece_shape[state.active_piece.type][state.active_piece.rotation]) do
        for x, active in pairs(shape_row) do
            if active == 1 then
                love.graphics.rectangle('fill',
                (state.active_piece.pos.x + x - 1) * block_size,
                (state.active_piece.pos.y + y - 1) * block_size,
                block_size, block_size)
            end
        end
    end
end

movingPiece.update = function(dt, block_size, speed)
    -- Speed up if keybind.move_down is held, otherwise just the current speed.
    -- TODO: Move this check to the keyboard file (maybe?)
    if love.keyboard.isScancodeDown(state.keybind.move_down) then
        speed = 12
    end
    state.active_piece.pos.y = state.active_piece.pos.y + (dt * speed)

    -- Detect move left or right
    local left_down = love.keyboard.isScancodeDown(state.keybind.move_left)
    local right_down = love.keyboard.isScancodeDown(state.keybind.move_right)

    if left_down and (not right_down) then
        movingPiece.move(-1)
    elseif right_down and (not left_down) then
        movingPiece.move(1)
    else
        state.active_piece.last_held = 0
    end
    
    -- Detect if the active piece should collide and become stationary, and check if movement would result in an out-of-bounds position.
    -- TODO: Detect collision. Out-of-bounds is implemented already
    state.active_piece.restrict_right, state.active_piece.restrict_left = false -- First, assume no border is close

    -- Then iterate thru the table of the current shape/rotation.
    for row_num, row_array in pairs(piece_shape[state.active_piece.type][state.active_piece.rotation]) do
        for col_num, block_val in pairs(row_array) do
            -- Check if any active portions of the piece are next to the border.
            local pos_test_val = state.active_piece.pos.x + col_num

            if (block_val == 1) and (pos_test_val >= 10) then
                state.active_piece.restrict_right = true
            elseif (block_val == 1) and (pos_test_val <= 1) then 
                state.active_piece.restrict_left = true
            end
        end
    end
end

movingPiece.move = function(direction)
    -- Check if on the border of the gameboard
    if (direction == -1) and state.active_piece.restrict_left then
        return
    elseif (direction == 1) and state.active_piece.restrict_right then
        return
    end

    -- If movement not restricted, move every tap or 0.5 seconds (if holding the key)
    if ((state.global_seconds - state.active_piece.last_held) > 0.5) then
        state.active_piece.pos.x = state.active_piece.pos.x + direction
        state.active_piece.last_held = state.global_seconds
    end
end


-- TODO: Combine rotation into one function and account for illegal/out-of-bounds rotation.
movingPiece.rotate_right = function()
    -- When called, increment thru the array of shapes for the current block type.
    state.active_piece.rotation = state.active_piece.rotation + 1
    if state.active_piece.rotation == 5 then
        state.active_piece.rotation = 1
    end
end

movingPiece.rotate_left = function()
    -- When called, decrement thru the array of shapes for the current block type.
    state.active_piece.rotation = state.active_piece.rotation - 1
    if state.active_piece.rotation == 0 then
        state.active_piece.rotation = 4
    end
end

return movingPiece