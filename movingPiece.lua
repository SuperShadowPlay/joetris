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
    [1] = {
        {
            {1, 0, 0, 0},
            {0, 1, 1, 0},
            {0, 1, 1, 0},
            {0, 0, 0, 0}
        },
        {
            {0, 0, 0, 1},
            {0, 1, 1, 0},
            {0, 1, 1, 0},
            {0, 0, 0, 0}
        },
        {
            {0, 0, 0, 0},
            {0, 1, 1, 0},
            {0, 1, 1, 0},
            {0, 0, 0, 1}
        },
        {
            {0, 0, 0, 0},
            {0, 1, 1, 0},
            {0, 1, 1, 0},
            {1, 0, 0, 0}
        }
    }
}

movingPiece.create_next = function(board_width)
    state.active_piece = {
        pos = {
            x = board_width / 2,
            y = 0
        },
        type = state.piece_bag[1],
        rotation = 1,
    }
    table.remove(state.piece_bag, 1)
end

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

movingPiece.update = function(dt)
    state.active_piece.pos.y = state.active_piece.pos.y + (dt)
end

movingPiece.rotate_right = function()
    state.active_piece.rotation = state.active_piece.rotation + 1
    if state.active_piece.rotation == 5 then
        state.active_piece.rotation = 1
    end
end

movingPiece.rotate_left = function()
    state.active_piece.rotation = state.active_piece.rotation - 1
    if state.active_piece.rotation == 0 then
        state.active_piece.rotation = 4
    end
end

return movingPiece