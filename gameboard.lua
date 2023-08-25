state = require('state')
movingPiece = require('movingPiece')

--[[
    Anything to do with the actual game board.
]]

gameboard = {
    block_size   = 35,
    board_width  = 10,
    board_height = 20,

    -- Filled upon calling gameboard.load()
    anchor_x = nil,
    anchor_y = nil,
    block_heights = nil,
}


-- Private functions
local bottom_of_piece_pos = function(central_piece_pos_y, block_size)
    return central_piece_pos_y + (block_size / 2)
end

local bottom_of_board_pos = function()
    return {
        x = gameboard.anchor_x,
        y = gameboard.anchor_y * gameboard.block_size * board_height
    }
end

local gen_possible_block_top_heights = function()
    -- Generates a table of y coordinates that correspond to each level of the gameboard's actual position on screen.
    -- These values are used for collison detection.
    local possible = {}
    for height_level, _ in pairs(state.board) do
        table.insert(possible, gameboard.anchor_y + gameboard.block_size * height_level)
    end
    return possible
end

-- Public functions

gameboard.load = function(anchor_x, anchor_y)
    -- Call upon loading a new gameboard
    gameboard.anchor_x = anchor_x
    gameboard.anchor_y = anchor_y
    gameboard.block_heights = gen_possible_block_top_heights()
    movingPiece.create_next(gameboard.board_width, gameboard.board_height)
end

gameboard.draw = function()
    -- Draw gameboard. The two anchor arguments specify the location of the topleft corner of the board.


    -- Center coordinates on anchor
    love.graphics.push()
    love.graphics.translate(gameboard.anchor_x, gameboard.anchor_y)

    -- Background
    love.graphics.setColor(0.75, 0.75, 0.75, 1)
    love.graphics.rectangle('fill', 0, 0, gameboard.block_size * gameboard.board_width, gameboard.block_size * gameboard.board_height)

    -- Draw blocks
    for row_num, row_array in pairs(state.board) do
        for col_num, block_val in pairs(row_array) do
            local displacement = {
                y = (gameboard.block_size * (row_num - 1)),
                x = (gameboard.block_size * (col_num - 1)),
            }
            local color_const = block_val * 5 / 100
            love.graphics.setColor(row_num * color_const, col_num * color_const, 1, block_val)
            love.graphics.rectangle('fill', displacement.x, displacement.y, gameboard.block_size, gameboard.block_size)
        end
    end

    -- Active piece
    movingPiece.draw(gameboard.block_size)

    -- Cleanup
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.pop()
end

gameboard.update = function(dt)
    state.global_seconds = state.global_seconds + dt
    local fall_speed = 1 -- TODO: Change to be dynamic with game progrssion
    movingPiece.update(dt, gameboard.block_size, fall_speed, 20)
end

return gameboard