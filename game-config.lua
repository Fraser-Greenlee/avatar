local startConfig = {
    bending = {
        pixel = {
            per = {
                row = 40
            }
        },
        radius = {
            px = 20
        }
    },
    crateSize = 32
}

return {
    new = function(display)
        startConfig.bending.pixel.size = math.floor(
            display.actualContentWidth / startConfig.bending.pixel.per.row
        )
        startConfig.bending.pixel.per.column = math.floor(
            display.actualContentHeight / startConfig.bending.pixel.size
        )
        startConfig.bending.radius.bendingPX = math.floor(
            startConfig.bending.radius.px / startConfig.bending.pixel.size
        )
        return startConfig
    end
}
