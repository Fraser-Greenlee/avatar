return {

    makeParticleSystem = function(physics)
        return physics.newParticleSystem({
            filename = "waterParticle.png",
            colorMixingStrength = 0.2,
            radius = 1.5,
            imageRadius = 4.5,
            surfaceTensionPressureStrength=0.2,
            surfaceTensionNormalStrength=0.2
        })
    end,

    makeParticleParams = function(letterbox)
        return {
            red = {
                x = 0-letterbox.width,
                y = 300-letterbox.height,
                velocityX = 110,
                velocityY = 80,
                color = { 1, 0, 0.2, 1 },
                lifetime = 48,
                flags = { "water", "colorMixing" }
            },
            blue = {
                x = 320+letterbox.width,
                y = 300-letterbox.height,
                velocityX = -110,
                velocityY = 80,
                color = { 0.2, 0.4, 1, 1 },
                lifetime = 48,
                flags = { "water", "colorMixing" }
            }
        }
    end

}
