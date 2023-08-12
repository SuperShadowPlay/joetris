state = require('state')
movingPiece = require('movingPiece')

--[[
    Anything to do with the actual game board.
]]

gameboard = {
    block_size   = 35,
    board_width  = 10,
    board_height = 20,
}

gameboard.draw = function(anchor_x, anchor_y)
    -- Draw gameboard. The two anchor arguments specify the location of the topleft corner of the board.


    -- Center coordinates on anchor
    love.graphics.push()
    love.graphics.translate(anchor_x, anchor_y)

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
            color_const = block_val * 5 / 100
            print(color_const, block_val)
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
    movingPiece.update(dt)
end

return gameboard