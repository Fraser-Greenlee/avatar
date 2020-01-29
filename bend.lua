
local function bendingPixelXY(config, x, y)
	local pixelX = math.floor(x / config.bending.pixel.size)
	local pixelY = math.floor(y / config.bending.pixel.size)
	return pixelX, pixelY
end

local function staticDeltaV(config, XorY)
    --[[
        TODO
        - gradually ramp up deltaV until at 80% bending radius
        - then gradually decrease till last 10% radius
        - put 0 force there
    ]]
    local bendingCoeff = ( (XorY / config.bending.radius.px) - 0.1 )
    return - config.bending.power * bendingCoeff
end

local function setDeltaV(config, XorY, playerVX_or_Y)
    return staticDeltaV(config, XorY) * (1 - config.bending.playerVstatic)
end

local function showDebug(config, pixel)
    -- NOTE this will dramatically slow down the game
    if config.bending.debugLine then
        local line = config.display.newLine(
            config.mainGroup,
            pixel.x, pixel.y, pixel.x + pixel.deltaVX/10, pixel.y + pixel.deltaVY/10
        )
        line:setStrokeColor( math.random(), math.random(), math.random(), 1 )
        line.strokeWidth = 1
    end
end


return {
    drawGrid = function(config)
        for y=0,config.bending.pixel.per.column do
            for x=0,config.bending.pixel.per.row do
                x = x - 2
                local bendingPixel = config.config.display.newRect( config.mainGroup, x*config.bending.pixel.size, y*config.bending.pixel.size, config.bending.pixel.size, config.bending.pixel.size )
                bendingPixel.strokeWidth = 1
                bendingPixel:setStrokeColor( 1, 0.4, 0.25 )
                bendingPixel:setFillColor( 1, 0.4, 0.25, 0.2 )
                config.bending.boxes[tostring(x) .. tostring(y)] = bendingPixel
            end
        end
    end,

    run = function(config, particleSystem, eventTime, globalX, globalY, playerVX, playerVY)
        centreX, centreY = bendingPixelXY(config, globalX, globalY)

        for y = centreY - config.bending.radius.px, centreY + config.bending.radius.px do
            for x = centreX - config.bending.radius.px, centreX + config.bending.radius.px do
    
                local relX = x - centreX
                local relY = y - centreY
                local distance = math.sqrt(relX*relX + relY*relY)
    
                if distance <= config.bending.radius.px then
                    local pixel = config.bending.boxes[tostring(x) .. ',' .. tostring(y)]
                    if pixel == nil then
                        pixel = {}
                    end
                    pixel.deltaVX = setDeltaV(config, relX, playerVX)
                    pixel.deltaVY = setDeltaV(config, relY, playerVY)
                    pixel.x = x * config.bending.pixel.size
                    pixel.y = y * config.bending.pixel.size
                    pixel.madeAt = eventTime
                    config.bending.boxes[tostring(x) .. ',' .. tostring(y)] = pixel

                    showDebug(config, pixel)
                end
            end
        end
    end,

    render = function(config, particleSystem)
        for coords, pixel in pairs(config.bending.boxes) do
            if (pixel ~= nil) then
                local age = (system.getTimer() - pixel.madeAt) / 1000
                if (age >= config.bending.maxAge) then
                    config.bending.boxes[coords] = nil
                else
                    local ageRatio = 1 - (age / config.bending.maxAge)

                    local region = particleSystem:queryRegion(
                        pixel.x - config.bending.pixel.size/2,
                        pixel.y - config.bending.pixel.size/2,
                        pixel.x + config.bending.pixel.size/2,
                        pixel.y + config.bending.pixel.size/2,
                        { deltaVelocityX=pixel.deltaVX * ageRatio, deltaVelocityY=pixel.deltaVY * ageRatio }
                    )
                end
            end
        end
    end
}