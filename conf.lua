function love.conf(t)
    t.window.width = 1280
    t.window.height = 720
    -- t.window.width = 640
    -- t.window.height = 360
    t.window.title = "LÖVE stealth RL prototype"
    t.window.icon = "assets/img/footprints.png"
    t.window.vsync = true

    t.modules.audio = true
    t.modules.event = true
    t.modules.graphics = true
    t.modules.image = true
    t.modules.joystick = true
    t.modules.keyboard = true
    t.modules.math = true
    t.modules.mouse = true
    t.modules.physics = false
    t.modules.sound = true
    t.modules.system = true
    t.modules.timer = true
    t.modules.touch = false
    t.modules.video = true
    t.modules.window = true
    t.modules.thread = true
end