
local function bendingPixelXY( x, y )
	pixelX = math.floor(x / bendingPixelSize)
	pixelY = math.floor(y / bendingPixelSize)
	return pixelX, pixelY
end

local function getBendingPixel( x, y )
	return bendingBoxes[tostring(x) .. tostring(y)]
end


return {
    drawGrid = function(display, mainGroup, bendingPixelSize)
        for y=0,bendingPixelsPerColumn do
            for x=0,bendingPixelsPerRow do
                x = x - 2
                local bendingPixel = display.newRect( mainGroup, x*bendingPixelSize, y*bendingPixelSize, bendingPixelSize, bendingPixelSize )
                bendingPixel.strokeWidth = 2
                bendingPixel:setStrokeColor( 1, 0.4, 0.25 )
                bendingPixel:setFillColor( 1, 0.4, 0.25, 0.2 )
                bendingBoxes[tostring(x) .. tostring(y)] = bendingPixel
            end
        end
    end,

    run = function(event)
        centreX, centreY = bendingPixelXY(event.x, event.y)

        for y = centreY - bendingPixelRadius, centreY + bendingPixelRadius do
            for x = centreX - bendingPixelRadius, centreX + bendingPixelRadius do
    
                local relX = x - centreX
                local relY = y - centreY
                local distance = math.sqrt(relX*relX + relY*relY)
    
                if distance <= bendingPixelRadius then
                    local centrePixel = getBendingPixel(x, y)
                    centrePixel:setStrokeColor( 0.25, 0.4, 1 )
                    centrePixel:setFillColor( 0.25, 0.4, 1, 1 )
    
                    display.newLine(
                        mainGroup,
                        x * bendingPixelSize,
                        y * bendingPixelSize,
                        centreX * bendingPixelSize,
                        centreY * bendingPixelSize
                    )
                end
            end
        end
    end
}