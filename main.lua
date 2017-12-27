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
    entityManager:addEntity(Player.create(entityManager, 50, 50))
    entityManager:addEntity(Enemy.create(100, 50))
    grid = Grid.create()
end

function love.update(dt)
    if love.keyboard.isDown("escape") then
        love.event.quit()
    end

    entityManager:update(dt)
    grid:update(dt, entityManager:getPlayer())
end

function love.draw()
    grid:draw()
    entityManager:draw()
end
