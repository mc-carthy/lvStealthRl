local Grid = require("src.map.Grid")
local EntityManager = require("src.entities.EntityManager")
local Camera = require("src.utils.Camera")
local Player = require("src.entities.Player")
local Enemy = require("src.entities.Enemy")
local Gamera = require("src.utils.gamera")

DEBUG = false

gamera = Gamera.new(0, 0, 4200, 4200)

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
    entityManager:addEntity(Player.create(entityManager, 1210, 1210))
    entityManager:addEntity(Enemy.create(entityManager, 1000, 1000))
end

function love.update(dt)
    if love.keyboard.isDown("escape") then
        love.event.quit()
    end

    local player = entityManager:getPlayer()
    -- Camera:centerOnPosition(player:getPosition())
    gamera:setPosition(player:getPosition())
    -- debugCamControl(dt)


    entityManager:update(dt)
end

function love.draw()
    love.graphics.setBackgroundColor(0, 0, 0, 255)
    gamera:draw(function(l, t, w, h)
        -- TODO: Add sorting layer function to control which items get drawn in front
            -- Camera:set()
            entityManager:draw()
            -- Camera:unset()
    end)
    love.graphics.setColor(255, 255, 255, 255)
    entityManager:debugDraw()
    love.graphics.print(love.timer.getFPS(), 10, 10)
end

function debugCamControl(dt)
    if love.keyboard.isDown("up") then
        tempY = tempY - Camera.panSpeed * dt / zoom
    end
    
    if love.keyboard.isDown("down") then
        tempY = tempY + Camera.panSpeed * dt / zoom
    end
    
    if love.keyboard.isDown("left") then
        tempX = tempX - Camera.panSpeed * dt / zoom
    end

    if love.keyboard.isDown("right") then
        tempX = tempX + Camera.panSpeed * dt / zoom
    end
    if love.keyboard.isDown("z") then
        zoom = zoom + Camera.zoomSpeed * dt
    end
    if love.keyboard.isDown("x") then
        zoom = zoom - Camera.zoomSpeed * dt
    end

    gamera:setScale(zoom)
    gamera:setPosition(tempX, tempY)
    -- Camera:setScale(zoom, zoom)
    -- Camera:setPosition(tempX, tempY)
end