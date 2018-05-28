local level = require('src.scenes.level1')

DEBUG = false
currentLevel = nil

function love.load()
    love.graphics.setBackgroundColor(0, 0, 0, 0)
    love.mouse.setVisible(false)
end

function love.update(dt)
    if love.keyboard.isDown("escape") then
        love.event.quit()
    end
    if currentLevel and currentLevel.update then
        currentLevel.update(dt)
    end
end

function love.draw()
    if currentLevel and currentLevel.draw then
        currentLevel.draw()
    end
    if currentLevel == nil then
        love.graphics.printf(text (string), x (number), y (number), limit (number), align (AlignMode), r (number), sx (number), sy (number), ox (number), oy (number), kx (number), ky (number))
    end
end

function love.mousepressed(x, y, button, isTouch)
end

function love.keypressed(key)
    if key == 'space' then
        if currentLevel == nil then
            currentLevel = level
            level.load()
        end
    end
end