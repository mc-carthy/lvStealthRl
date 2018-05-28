local level1 = {}

local Camera = require("src.utils.Camera")
local Gamera = require("src.utils.gamera")
local EntityManager = require("src.entities.EntityManager")
local Grid = require("src.map.Grid")
local Player = require("src.entities.Player")
local EnemyManager = require("src.entities.enemyManager")
local Keycard = require("src.entities.keycard")

local grid
local entityManager
local player

local tempX, tempY = 0, 0
local zoom = 1
local paused = false

function level1.load()
    gamera = Gamera.new(0, 0, 100, 100)
    entityManager = EntityManager.create()
    entityManager:addEntity(Grid.create(entityManager))
    local playerX, playerY = entityManager:getGrid().lowestPeakX, entityManager:getGrid().lowestPeakY;
    entityManager:addEntity(Player.create(entityManager, playerX, playerY))
    entityManager:addEntity(Keycard.create(entityManager, playerX, playerY - 20))
    entityManager:addEntity(EnemyManager.create(entityManager))
end

function level1.update(dt)
    local player = entityManager:getPlayer()
    -- Camera:centerOnPosition(player:getPosition())
    _debugCamControl(dt)
    gamera:setPosition(player:getPosition())

    if not paused then
        entityManager:update(dt)
    end
end

function level1.draw()
    gamera:draw(function(l, t, w, h)
        -- TODO: Add sorting layer function to control which items get drawn in front
            -- Camera:set()
            entityManager:draw()
            -- Camera:unset()
    end)
    love.graphics.setColor(255, 255, 255, 255)
    entityManager:drawScreenSpace()
    love.graphics.print(love.timer.getFPS(), 10, 10)
end

function _debugCamControl(dt)
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

return level1