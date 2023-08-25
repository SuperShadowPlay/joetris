local state = require('state')
local piece_shape = require('pieceTemplates')

local movingPiece = {}

--[[
    Governs how the active, moving piece will operate.
    Moves it, places it, rotates it, etc.
]]

local key_held_delay = 0.3 -- How long you have to hold a movement key for it to repeat the action

movingPiece.create_next = function(board_width, board_height)
    movingPiece.active = {
        pos = {
            x = (board_width / 2) - 1,
            y = -4
        },
        type = state.piece_bag[1],
        rotation = 1,
        last_held = 0,
        restrict_right = false,
        restrict_left = false,
        ready_to_place = false,
        board_width = board_width,
        board_height = board_height,
    }
    table.remove(state.piece_bag, 1)
end


movingPiece.draw = function(block_size)
    love.graphics.setColor(1, 0, 0, 1)
    
    for y, shape_row in pairs(piece_shape[movingPiece.active.type][movingPiece.active.rotation]) do
        for x, active in pairs(shape_row) do
            if active == 1 then
                love.graphics.rectangle('fill',
                (movingPiece.active.pos.x + x - 1) * block_size,
                (movingPiece.active.pos.y + y - 1) * block_size,
                block_size, block_size)
            end
        end
    end
end


movingPiece.update = function(dt, block_size, speed, board_height)
    movingPiece.progress_downward(dt, speed, board_height)

    -- Detect move left or right
    local left_down = love.keyboard.isScancodeDown(state.keybind.move_left)
    local right_down = love.keyboard.isScancodeDown(state.keybind.move_right)

    if left_down and (not right_down) then
        movingPiece.move(-1)
    elseif right_down and (not left_down) then
        movingPiece.move(1)
    else
        movingPiece.active.last_held = 0
    end
    
    -- Detect collision for both the border and other pieces.
    movingPiece.detect_collision(board_height)
end


movingPiece.move = function(direction)
    -- Check if on the border of the gameboard
    if (direction == -1) and movingPiece.active.restrict_left then
        return
    elseif (direction == 1) and movingPiece.active.restrict_right then
        return
    end

    -- If movement not restricted, move every tap or 0.5 seconds (if holding the key)
    if ((state.global_seconds - movingPiece.active.last_held) > 0.5) then
        movingPiece.active.pos.x = movingPiece.active.pos.x + direction
        movingPiece.active.last_held = state.global_seconds
    end
end


-- TODO: Combine rotation into one function and account for illegal/out-of-bounds rotation.
movingPiece.rotate_right = function()
    -- When called, increment thru the array of shapes for the current block type.
    local last_rotation = movingPiece.active.rotation
    movingPiece.active.rotation = movingPiece.active.rotation + 1
    if movingPiece.active.rotation == 5 then
        movingPiece.active.rotation = 1
    end

    movingPiece.verify_rotation_allowed(last_rotation)
end


movingPiece.rotate_left = function()
    -- When called, decrement thru the array of shapes for the current block type.
    local last_rotation = movingPiece.active.rotation
    movingPiece.active.rotation = movingPiece.active.rotation - 1
    if movingPiece.active.rotation == 0 then
        movingPiece.active.rotation = 4
    end

    movingPiece.verify_rotation_allowed(last_rotation)
end


movingPiece.verify_rotation_allowed = function(last_rotation)
    -- If at any point a rotated block would overlap with a placed block, disallow the rotation.
    -- TODO: ERRORS OUT HERE SOMEHWERE
    for row_num, row_array in pairs(piece_shape[movingPiece.active.type][movingPiece.active.rotation]) do
        for col_num, block_val in pairs(row_array) do
            -- As we loop through the current shape, we may find the position on the board of each one in the following:
            local current_y = row_num + math.floor(movingPiece.active.pos.y)
            local current_x = col_num + movingPiece.active.pos.x

            -- Check if locations are outside of the play area
            local piece_outside_y_bounds = (current_y < 1 or current_y > movingPiece.active.board_height)
            local piece_outside_x_bounds = (current_x < 1 or current_x > movingPiece.active.board_width)
            -- If not outside the play area, check if there is a block in the way
            if not (piece_outside_y_bounds or piece_outside_x_bounds) then
                local board_has_block_at = state.board[current_y][current_x] == 1
                if (board_has_block_at) and (block_val == 1) then
                    movingPiece.active.rotation = last_rotation
                end
            end
        end
    end
end


movingPiece.progress_downward = function(dt, speed, board_height)
    -- Speed up if keybind.move_down is held, otherwise just the current speed.
    -- TODO: Move this check to the keyboard file (maybe?)
    if love.keyboard.isScancodeDown(state.keybind.move_down) then
        speed = 12
    end

    if movingPiece.active.ready_to_place == false then
        movingPiece.active.pos.y = movingPiece.active.pos.y + (dt * speed)
    else
        movingPiece.active.pos.y = math.floor(movingPiece.active.pos.y) -- Snap piece position to grid before placing.
    end
end


movingPiece.detect_collision = function(board_height)
    -- Detect if the active piece should collide and become stationary, and check if movement would result in an out-of-bounds position.
    movingPiece.active.restrict_right, movingPiece.active.restrict_left = false -- First, assume no border is near

    -- Then iterate thru the table of the current shape/rotation.
    -- In here, we will check each individual active block for collision.
    for row_num, row_array in pairs(piece_shape[movingPiece.active.type][movingPiece.active.rotation]) do
        for col_num, block_val in pairs(row_array) do

            -- As it heads down, check if the block should collide with another and be placed down.
            local current_y = row_num + math.floor(movingPiece.active.pos.y)
            local current_x = col_num + movingPiece.active.pos.x

            -- Determine if the next block is filled or the next block is the bottom of the board. If either true, end this piece.
            if (current_y >= board_height) then
                movingPiece.active.ready_to_place = true
            elseif (current_y) >= 0 then
                next_block = state.board[current_y + 1][current_x]
                -- If next block is filled then end this piece.
                if ((next_block == 1) and (block_val == 1)) then
                    movingPiece.active.ready_to_place = true
                end
            end

            -- Check if any active portions of the piece are next to the border, and if so restrict movement in that direction.
            local pos_test_val = movingPiece.active.pos.x + col_num
            if (block_val == 1) and (pos_test_val >= 10) then
                movingPiece.active.restrict_right = true
            elseif (block_val == 1) and (pos_test_val <= 1) then 
                movingPiece.active.restrict_left = true
            end

            -- TODO: Check if rotation for pieces would result in out-of-bounds or a collision
        end
    end
end


return movingPiece