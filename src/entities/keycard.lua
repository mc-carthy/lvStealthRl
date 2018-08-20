Keycard = Class{}

function Keycard:init(params)
    assert(type(params) == 'table', 'Params table required')
    assert(type(params.x) == 'number', 'Parameter "x" must be a number, not ' .. type(params.x))
    self.tag = 'keycard'
    self.depth = 900
    self.x = params.x
    self.y = params.y
    self.w = 10
    self.h = 6
    self.level = params.level
    self.ringRad = 15
end

function Keycard:draw()
    if self.level == 'exit' then
        love.graphics.setColor(TileDictionary[self.level].drawColour)
    else
        love.graphics.setColor(TileDictionary["doorLevel" .. self.level].drawColour)
    end
    love.graphics.setLineWidth(1)
    love.graphics.circle("line", self.x, self.y, self.ringRad)
    love.graphics.rectangle('fill', self.x - self.w / 2, self.y - self.h / 2, self.w, self.h)
    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.setLineWidth(2)
    love.graphics.rectangle('line', self.x - self.w / 2, self.y - self.h / 2, self.w, self.h)
    love.graphics.setLineWidth(1)
end