MainMenuState = Class{ __includes = BaseState }

local mainMenuFont

function MainMenuState:enter()
    mainMenuFont = FONTS['lineBeam32']
    defaultFont = love.graphics.getFont()
end

function MainMenuState.update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then
        stateMachine:change('firstLevel', {
            --[[ 
            map = {
                type = 'ImageMap',
                filePath = 'assets/maps/testMap0.png'
            }
            ]]--
            map = {
                type = 'CelAutMap',
                xSize = 70,
                ySize = 40,
                percentFill = 0.45,
                smoothingIterations = 5,
                mapScale = 2
            }
        })
    end
end

function MainMenuState.draw()
    love.graphics.setColor(1, 0, 1, 1)
    love.graphics.setFont(mainMenuFont)
    love.graphics.printf('WELCOME TO THE MAIN MENU!', 0, SCREEN_HEIGHT / 2, SCREEN_WIDTH, 'center')
    love.graphics.printf('PRESS ENTER!', 0, SCREEN_HEIGHT / 2 + 40, SCREEN_WIDTH, 'center')
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.setFont(defaultFont)
end