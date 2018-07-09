require('src.utils.dependencies')

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    math.randomseed(os.time())
    
    SCREEN_WIDTH, SCREEN_HEIGHT = love.graphics.getDimensions()

    stateMachine = StateMachine {
        ['mainMenu'] = function() return MainMenuState() end,
        ['firstLevel'] = function() return FirstLevelState() end
    }

    stateMachine:change('mainMenu')

    love.keyboard.keysPressed = {}
end

function love.update(dt)
    stateMachine:update(dt)
    love.keyboard.keysPressed = {}
end

function love.draw()
    stateMachine:draw()
end

function love.keypressed(key)
    love.keyboard.keysPressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end