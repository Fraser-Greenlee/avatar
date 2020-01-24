
local function bendingPixelXY(config, x, y)
	pixelX = math.floor(x / config.bending.pixel.size)
	pixelY = math.floor(y / config.bending.pixel.size)
	return pixelX, pixelY
end

local function getBendingPixel(config, x, y)
    return config.bending.boxes[tostring(x) .. tostring(y)]
end

local function newPixel(config, x, y)
    return {
        xDir=0,
        
    }
end

local function debugRect(config, x, y)
    local bendingPixel = config.display.newRect( config.mainGroup, x*config.bending.pixel.size, y*config.bending.pixel.size, config.bending.pixel.size, config.bending.pixel.size )
    bendingPixel.strokeWidth = 1
    bendingPixel:setStrokeColor( 1, 0.4, 0.25 )
    bendingPixel:setFillColor( 1, 0.4, 0.25, 0.2 )
    return bendingPixel
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

    run = function(config, particleSystem, x, y)
        centreX, centreY = bendingPixelXY(config, x, y)

        for y = centreY - config.bending.radius.px, centreY + config.bending.radius.px do
            for x = centreX - config.bending.radius.px, centreX + config.bending.radius.px do
    
                local relX = x - centreX
                local relY = y - centreY
                local distance = math.sqrt(relX*relX + relY*relY)
    
                if distance <= config.bending.radius.px then
                    local pixel = getBendingPixel(config, x, y)
                    if pixel == nil then
                        pixel = {}
                    end
                    -- TODO set pixel value, then render
                    pixel.deltaVX = relX
                    pixel.deltaVY = relY
                end
            end
        end

        

        local region = particleSystem:queryRegion(
			box.x - bendingBoxSize/2,
			box.y - bendingBoxSize/2,
			box.x + bendingBoxSize/2,
			box.y + bendingBoxSize/2,
			{ deltaVelocityX=velocityX*bendingCoefficient, deltaVelocityY=velocityY*bendingCoefficient }
		)
    end
}