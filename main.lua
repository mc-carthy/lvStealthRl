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
end

function love.update(dt)
    stateMachine:update(dt)
end

function love.draw()
    stateMachine:draw()
end