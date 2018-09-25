Shotgun = Class{}

function Shotgun:init(params)
    self.tag = TAG.WEAPON
    self.x = params.x
    self.y = params.y
    self.rot = 0
    self.fireRate = 1
    self.coolDown = 0
    self.canFire = true
    self.noiseRad = 450
    self.shotAccuracyInRad = math.rad(30)
end

function Shotgun:update(dt)
    if self.canFire == false then
        self.coolDown = self.coolDown - dt
        if self.coolDown <= 0 then
            self.canFire = true
        end
    end
end

function Shotgun:fire()
    if self.canFire then
        -- TODO: Get different SFX for different weapons
        SFX['shot']:stop()
        SFX['shot']:play()

        local n = Noise({
            x = self.x,
            y = self.y,
            rad = self.noiseRad,
            -- TODO: This should not be hard-coded to a player-specific value
            -- Consider being aware of the weapon owner and setting it accordingly
            type = 'playerGunshotNoise'
        })
        self.em:add(n)

        self.em.camera:setShakeTranslation(45)
        self.em.camera:setShakeRotation(0.1)
        self.em.camera:setShakeScale(0.15)
        self.em.camera:setShakeShear(3.5)

        for i = 1, 5 do
            local b = Bullet({
                x = self.x,
                y = self.y,
                rot = self.rot + ((math.random() - 0.5) * self.shotAccuracyInRad)
            })
            self.em:add(b)
        end

        self.canFire = false
        self.coolDown = 1
    end
end