Pistol = Class{}

function Pistol:init(params)
    self.tag = TAG.WEAPON
    self.x = params.x
    self.y = params.y
    self.rot = 0
    self.fireRate = 1
    self.coolDown = 0
    self.canFire = false
    self.noiseRad = 300
    self.shotAccuracyInRad = math.rad(5)
    print('Pistol init')
end

function Pistol:update(dt)
    if self.canFire == false then
        self.coolDown = self.coolDown - dt
        if self.coolDown <= 0 then
            self.canFire = true
        end
    end
end

function Pistol:fire()
    print('Pistol fire')
    if self.canFire then
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

        self.em.camera:setShakeTranslation(30)
        self.em.camera:setShakeRotation(0.075)
        self.em.camera:setShakeScale(0.1)
        self.em.camera:setShakeShear(2.5)

        local b = Bullet({
            x = self.x,
            y = self.y,
            rot = self.rot + ((math.random() - 0.5) * self.shotAccuracyInRad)
        })
        self.em:add(b)
        self.canFire = false
        self.coolDown = 1
    end
end