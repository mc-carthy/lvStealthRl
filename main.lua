local Grid = require("src.map.Grid")
local EntityManager = require("src.entities.EntityManager")
local Player = require("src.entities.Player")
local Enemy = require("src.entities.Enemy")

DEBUG = true


local grid
local entityManager
local player
local enemy

function love.load()
    love.graphics.setBackgroundColor(255, 255, 255, 255)

    entityManager = EntityManager.create()
    entityManager:addEntity(Grid.create(entityManager))
    entityManager:addEntity(Player.create(entityManager, 50, 50))
    entityManager:addEntity(Enemy.create(entityManager, 100, 50))
end

function love.update(dt)
    if love.keyboard.isDown("escape") then
        love.event.quit()
    end

    entityManager:update(dt)
end

function love.draw()
    -- TODO: Add sorting layer function to control which items get drawn in front
    entityManager:draw()
end
