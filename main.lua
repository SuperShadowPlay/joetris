local keyboard = require('keyboard')
local state = require('state')
local gameboard = require('gameboard')

-- Debug
local debugInfo = require('debugInfo')
local inspect = require('lib/inspect')

-- Called on game load
function love.load()
    -- Configure window
    love.window.updateMode(800, 800)
    love.graphics.setDefaultFilter('nearest', 'nearest') -- Enable pixel-perfect graphics

    gameboard.load()

    world = love.physics.newWorld() -- Generate box2D physics world
end


-- Called whenever a key is pressed
-- (Only used for single-press actions like pause, quit, etc.)
function love.keypressed(_, scancode)
    if keyboard.keypressed_list[scancode] then
        keyboard.keypressed_list[scancode]()
    end
end


-- Called whenever a mouse button is pressed
function love.mousepressed(x, y, button)

end


-- Sets camera width every time the window is resized (although that is currently disabled)
function love.reize(width, height)

end


-- Runs save function every time the game quits
function love.quit()
    
end

-- Called on every draw cycle. Draws all graphics. Paints the pixels. Colors the landscape. You want graphics? It's yours my friend.
function love.draw()
    -- TODO: look into https://love2d.org/wiki/SUIT for GUI
    local Graphics = love.graphics

    gameboard.draw(225, 50)

    -- Draw debug info if requested
    if state.debug == true then
        debugInfo.draw()
    end
end


-- Called quite often, used to control game logic on the moment to moment basis.
-- `dt` is the delta time provided by love.
function love.update(dt)
    local mouse_x, mouse_y = love.mouse.getPosition()

    gameboard.update(dt)
    
    world:update(dt)
end
