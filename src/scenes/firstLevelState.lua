FirstLevelState = Class{ __includes = BaseState}

function FirstLevelState.draw()
    love.graphics.print('Level 1!', SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2)
end