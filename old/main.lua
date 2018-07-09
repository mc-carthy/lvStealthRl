local level = require('src.scenes.level1')

DEBUG = false
currentLevel = nil
LOADING = false

local alarmClock = love.graphics.newFont('assets/fonts/alarm clock.ttf', 64)
local blackRain = love.graphics.newFont('assets/fonts/BLACK RAIN.ttf', 64)
local bladeRunner = love.graphics.newFont('assets/fonts/BLADRMF_.ttf', 64)
local chintzy = love.graphics.newFont('assets/fonts/chintzy.ttf', 64)
local chintzys = love.graphics.newFont('assets/fonts/chintzys.ttf', 64)
local crt = love.graphics.newFont('assets/fonts/Hacked CRT.ttf', 64)
local lineBeam = love.graphics.newFont('assets/fonts/Linebeam.ttf', 64)
local sewer = love.graphics.newFont('assets/fonts/sewer.ttf', 64)
local mainFont = lineBeam
local subFont = alarmClock

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
    local defaultFont = love.graphics.getFont()
    if currentLevel and currentLevel.draw then
        currentLevel.draw()
    elseif currentLevel == nil then
        love.graphics.setFont(mainFont)
        love.graphics.setColor(0, 191, 191, 255)
        local titleText = 'WORKING TITLE'
        local titleTextWidth = mainFont:getWidth(titleText)
        local titleTextHeight = mainFont:getHeight()
        love.graphics.printf(titleText, love.graphics.getWidth() / 2 - titleTextWidth / 2, love.graphics.getHeight() / 2 - 200 - titleTextHeight / 2, titleTextWidth, 'left')
        
        love.graphics.setFont(subFont)
        love.graphics.setColor(191, 0, 191, 255)
        local subtitleText = 'PRESS SPACE TO BEGIN'
        local subtitleTextWidth = subFont:getWidth(subtitleText)
        local subtitleTextHeight = subFont:getHeight()
        love.graphics.printf(subtitleText, love.graphics.getWidth() / 2 - subtitleTextWidth / 4, love.graphics.getHeight() / 2 - subtitleTextHeight / 4, subtitleTextWidth, 'left', 0, 0.5, 0.5)
    end
    love.graphics.setFont(defaultFont)
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