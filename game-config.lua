local startConfig = {
    bending = {
        pixel = {
            per = {
                row = 30
            }
        },
        radius = {
            px = 2.5
        },
        boxes = {},
        renderDelay = 1,
        staticDelay = 1,
        power = 100,
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
