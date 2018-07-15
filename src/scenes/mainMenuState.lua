MainMenuState = Class{ __includes = BaseState }

function MainMenuState.update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        stateMachine:change('firstLevel', {
            -- map = ImageMap('assets/maps/testMap0.png')
            map = CelAutMap({
                xSize = 70,
                ySize = 40,
                percentFill = 0.45,
                smoothingIterations = 5,
                mapScale = 2
            })
        })
    end
end

function MainMenuState.draw()
    love.graphics.print('Welcome to the main menu!', SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2)
    love.graphics.print('Press Start!', SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2 + 40)
end