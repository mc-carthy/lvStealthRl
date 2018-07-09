MainMenuState = Class{ __includes = BaseState}

function MainMenuState.draw()
    love.graphics.print('Welcome to the main menu!', SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2)
    love.graphics.print('Press Start!', SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2 + 40)
end