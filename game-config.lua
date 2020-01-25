local startConfig = {
    bending = {
        pixel = {
            per = {
                row = 30
            }
        },
        radius = {
            px = 3
        },
        boxes = {},
        renderDelay = 0.1,
        staticDelay = 0.5,
        power = 200,
        maxAge = 1,
        playerVstatic = 0.2,
        playerVmultiplier = 0,

        debugLine = false,
        debugPrint = false,
    },
    crateSize = 32,
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
