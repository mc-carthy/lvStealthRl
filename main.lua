local Grid = require("src.map.Grid")
local Player = require("src.entities.Player")
local Enemy = require("src.entities.Enemy")

DEBUG = true


local grid
local player
local enemy

function love.load()
    love.graphics.setBackgroundColor(255, 255, 255, 255)

    player = Player.create(50, 50)
    enemy = Enemy.create(100, 50)
    grid = Grid.create()
end

function love.update(dt)
    if love.keyboard.isDown("escape") then
        love.event.quit()
    end

    enemy:update(dt)
    player:update(dt)
    grid:update(dt, player)
end

function love.draw()
    grid:draw()
    enemy:draw()
    player:draw()
end
