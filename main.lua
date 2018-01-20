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

local tempX, tempY = 0, 0
local zoom = 1

function love.load()
    love.graphics.setBackgroundColor(255, 255, 255, 255)

    entityManager = EntityManager.create()
    entityManager:addEntity(Grid.create(entityManager))
    entityManager:addEntity(Player.create(entityManager, 1200, 1200))
    entityManager:addEntity(Enemy.create(entityManager, 1000, 1000))
end

function love.update(dt)
    if love.keyboard.isDown("escape") then
        love.event.quit()
    end

    local player = entityManager:getPlayer()
    Camera:centerOnPosition(player:getPosition())
    
    -- debugCamControl(dt)


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

function debugCamControl(dt)
    if love.keyboard.isDown("up") then
        tempY = tempY - Camera.panSpeed * dt
    end

    if love.keyboard.isDown("down") then
        tempY = tempY + Camera.panSpeed * dt
    end
    
    if love.keyboard.isDown("left") then
        tempX = tempX - Camera.panSpeed * dt
    end

    if love.keyboard.isDown("right") then
        tempX = tempX + Camera.panSpeed * dt
    end
    if love.keyboard.isDown("z") then
        zoom = zoom + Camera.zoomSpeed * dt
    end
    if love.keyboard.isDown("x") then
        zoom = zoom - Camera.zoomSpeed * dt
    end

    Camera:setScale(zoom, zoom)
    Camera:setPosition(tempX, tempY)
end