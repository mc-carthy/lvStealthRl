local Grid = require("src.map.Grid")
local EntityManager = require("src.entities.EntityManager")
local Camera = require("src.utils.Camera")
local Player = require("src.entities.Player")
local Enemy = require("src.entities.Enemy")

DEBUG = false


local grid
local entityManager
local player
local enemy

function love.load()
    love.graphics.setBackgroundColor(255, 255, 255, 255)

    entityManager = EntityManager.create()
    entityManager:addEntity(Grid.create(entityManager))
    entityManager:addEntity(Player.create(entityManager, 200, 200))
    entityManager:addEntity(Enemy.create(entityManager, 300, 200))
end

function love.update(dt)
    if love.keyboard.isDown("escape") then
        love.event.quit()
    end

    local player = entityManager:getPlayer()
    Camera:centerOnPosition(player:getPosition())

    entityManager:update(dt)
end

function love.draw()
    love.graphics.setBackgroundColor(0, 0, 0, 255)
    -- TODO: Add sorting layer function to control which items get drawn in front
    Camera:set()
    entityManager:draw()
    Camera:unset()
    love.graphics.setColor(255, 255, 255, 255)
    love.graphics.print(love.timer.getFPS(), 20, 20)
end
