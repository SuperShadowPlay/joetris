state = require('state')

--[[
    Toss whatever information you want drawn on the screen in here.
]]--

local round = function(num)
    return math.floor(num * 100) / 100
end

debugInfo = {}

debugInfo.draw = function(playerObj)
    if not playerObj then -- Don't do anything if player object not loaded from server
        return
    end
    local SCALE_FACTOR = 2

    local globalX, globalY = love.graphics.inverseTransformPoint(love.mouse.getX(), love.mouse.getY())

    -- Any strings in here will be drawn when debug is enabled
    local stringsToPrint = {
    'Debug debug',
    }
    
    -- Red debug text
    love.graphics.setColor(1, 0, 0, 0.7)
    love.graphics.print('DEBUG MODE', 0, 0, 0, SCALE_FACTOR)

    -- Iterate through requested debug info and print
    love.graphics.setColor(1, 0.4, 0.2, 0.7)
    for index, value in pairs(stringsToPrint) do
        love.graphics.print(value, 0, 25 * index, 0, SCALE_FACTOR)
    end
    love.graphics.setColor(1, 1, 1, 1)
end

return debugInfo