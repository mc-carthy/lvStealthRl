local Player = require("src.entities.Player")

DEBUG = true

local xSize
local ySize
local cellSize = 40
local border = 2
local cellDrawSize = cellSize - border
local currentGrid

local player

function love.load()
    xSize = love.graphics.getWidth() / cellSize
    ySize = love.graphics.getHeight() / cellSize
    love.graphics.setBackgroundColor(255, 255, 255, 255)

    player = Player.create(50, 50)

    grid = {}
    for x = 1, xSize do
        grid[x] = {}
        for y = 1, ySize do
            grid[x][y] = false
        end
    end
end

function worldSpaceToGrid(x, y)
    gridx = math.floor(x / cellSize) + 1
    gridy = math.floor(y / cellSize) + 1
    return gridx, gridy
end

function drawGrid()
    for x = 1, xSize do
        for y = 1, ySize do
            if x == grid_x and y == grid_y then
                love.graphics.setColor(0, 255, 0, 255)
            else
                love.graphics.setColor(220, 220, 220)
            end
            if DEBUG then
                love.graphics.rectangle('fill', (x - 1) * cellSize, (y - 1) * cellSize, cellDrawSize, cellDrawSize)
            end
        end
    end
end

function love.update(dt)
    if love.keyboard.isDown("escape") then
        love.event.quit()
    end

    player:update(dt)

    grid_x, grid_y = worldSpaceToGrid(player.x, player.y)
end

function love.draw()
    drawGrid()
    player:draw()
end
