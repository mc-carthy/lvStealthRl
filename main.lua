local Grid = require("src.map.Grid")
local EntityManager = require("src.entities.EntityManager")
local Camera = require("src.utils.Camera")
local Player = require("src.entities.Player")
local Enemy = require("src.entities.Enemy")
local EnemyManager = require("src.entities.enemyManager")
local AudioBreadcrumb = require("src.entities.audioBreadcrumb")
local VisualBreadcrumb = require("src.entities.VisualBreadcrumb")
local Gamera = require("src.utils.gamera")

DEBUG = false

gamera = Gamera.new(0, 0, 100, 100)

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
    local playerX, playerY = entityManager:getGrid().lowestPeakX, entityManager:getGrid().lowestPeakY;
    entityManager:addEntity(Player.create(entityManager, playerX, playerY))
    entityManager:addEntity(EnemyManager.create(entityManager))
end

function love.update(dt)
    if love.keyboard.isDown("escape") then
        love.event.quit()
    end

    local player = entityManager:getPlayer()
    -- Camera:centerOnPosition(player:getPosition())
    debugCamControl(dt)
    gamera:setPosition(player:getPosition())


    entityManager:update(dt)
end

function love.draw()
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

-- TODO: Only for breadcrumb testing
function love.mousepressed(x, y, button, isTouch)
    -- if love.keyboard.isDown("lshift") or love.keyboard.isDown("rshift") then
    --     if button == 1 then
    --         mouseX, mouseY = gamera:toWorld(love.mouse.getPosition())
    --         entityManager:addEntity(AudioBreadcrumb.create(entityManager, mouseX, mouseY))
    --     end
    --     if button == 2 then
    --         mouseX, mouseY = gamera:toWorld(love.mouse.getPosition())
    --         entityManager:addEntity(VisualBreadcrumb.create(entityManager, mouseX, mouseY))
    --     end
    -- end
end