return {

    makeParticleSystem = function(physics)
        return physics.newParticleSystem({
            filename = "waterParticle.png",
            colorMixingStrength = 0.2,
            radius = 2.5,
            imageRadius = 7
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
                x = 320+letterbox.width,
                y = 300-letterbox.height,
                velocityX = -300,
                velocityY = 80,
                color = { 0.3, 0.4, 1, 1 },
                lifetime = 48,
                flags = { "water" }
            }
        }
    end

}
