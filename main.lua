function love.load()
    SCREEN_WIDTH, SCREEN_HEIGHT = love.graphics.getDimensions()
end

function love.update(dt)

end

function love.draw()
    love.graphics.print('Hello World!', SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2)
end