FONTS = {
    ['alarmClock16'] = love.graphics.newFont('assets/fonts/alarmClock.ttf', 16),
    ['blackRain16'] = love.graphics.newFont('assets/fonts/blackRain.ttf', 16),
    ['bladeRunner16'] = love.graphics.newFont('assets/fonts/bladeRunner.ttf', 16),
    ['chintzy16'] = love.graphics.newFont('assets/fonts/chintzy.ttf', 16),
    ['chintzys16'] = love.graphics.newFont('assets/fonts/chintzys.ttf', 16),
    ['hackedCrt16'] = love.graphics.newFont('assets/fonts/hackedCrt.ttf', 16),
    ['lineBeam16'] = love.graphics.newFont('assets/fonts/lineBeam.ttf', 16),
    ['sewer16'] = love.graphics.newFont('assets/fonts/sewer.ttf', 16),
    ['alarmClock32'] = love.graphics.newFont('assets/fonts/alarmClock.ttf', 32),
    ['blackRain32'] = love.graphics.newFont('assets/fonts/blackRain.ttf', 32),
    ['bladeRunner32'] = love.graphics.newFont('assets/fonts/bladeRunner.ttf', 32),
    ['chintzy32'] = love.graphics.newFont('assets/fonts/chintzy.ttf', 32),
    ['chintzys32'] = love.graphics.newFont('assets/fonts/chintzys.ttf', 32),
    ['hackedCrt32'] = love.graphics.newFont('assets/fonts/hackedCrt.ttf', 32),
    ['lineBeam32'] = love.graphics.newFont('assets/fonts/lineBeam.ttf', 32),
    ['sewer32'] = love.graphics.newFont('assets/fonts/sewer.ttf', 32),
}

SFX = {
    ['shot'] = love.audio.newSource('assets/audio/sfx/shot.wav', 'static'),
    ['bulletImpact'] = love.audio.newSource('assets/audio/sfx/bulletImpact.wav', 'static'),
    ['enemyHit'] = love.audio.newSource('assets/audio/sfx/enemyHit.wav', 'static')
}

SPRITES = {
    ['player'] = love.graphics.newImage("assets/img/entities/player.png"),
    ['enemy'] = love.graphics.newImage("assets/img/entities/enemy.png"),
    ['dirtTile'] = love.graphics.newImage("assets/img/tiles/dirt.png"),
    ['grassTile'] = love.graphics.newImage("assets/img/tiles/grass.png"),
    ['sandTile'] = love.graphics.newImage("assets/img/tiles/sand.png"),
    ['stoneTile'] = love.graphics.newImage("assets/img/tiles/stone.png"),
}