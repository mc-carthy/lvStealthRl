FirstLevelState = Class{ __includes = BaseState}

function FirstLevelState.update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
end

function FirstLevelState.draw()
    love.graphics.print('Level 1!', SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2)
end