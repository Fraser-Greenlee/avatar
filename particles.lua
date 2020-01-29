return {

    makeParticleSystem = function(physics)
        return physics.newParticleSystem({
            filename = "square.png",
            colorMixingStrength = 0.2,
            radius=7,
            imageRadius=9,
            density=1.3,
            gravityScale=4,
            pressureStrength=0.1,

        })
    end,

    makeParticleParams = function(letterbox)
        return {
            red = {
                x = 0-letterbox.width,
                y = 300-letterbox.height,
                velocityX = 300, -- 300 seems to be the max possible velocity
                velocityY = 0,
                color = { 1, 0, 0.2, 1 },
                lifetime = 48,
                flags = { "water" }
            },
            blue = {
                x = 300+letterbox.width,
                y = 300-letterbox.height,
                velocityX = -350,
                velocityY = -30,
                color = { 0.3, 0.4, 1, 1 },
                lifetime = 48,
                flags = { "water" }
            }
        }
    end

}
