
-- Abstract: Liquid Fun - Color Faucet
-- Version: 2.0
-- Sample code is MIT licensed; see https://www.coronalabs.com/links/code/license
---------------------------------------------------------------------------------------

display.setStatusBar( display.HiddenStatusBar )

------------------------------
-- RENDER THE SAMPLE CODE UI
------------------------------
local sampleUI = require( "sampleUI.sampleUI" )
sampleUI:newUI( { theme="darkgrey", title="Color Faucet", showBuildNum=false } )

------------------------------
-- CONFIGURE STAGE
------------------------------
display.getCurrentStage():insert( sampleUI.backGroup )
local mainGroup = display.newGroup()
display.getCurrentStage():insert( sampleUI.frontGroup )

----------------------
-- BEGIN SAMPLE CODE
----------------------

-- Set app font
local appFont = sampleUI.appFont

-- Require libraries/plugins
local widget = require( "widget" )
widget.setTheme( "widget_theme_ios7" )
local physics = require( "physics" )
physics.start()

-- Config variables
local config = require('game-config')
local bendingBoxSize = 20
local maxBendingBoxCount = 5
local bendingCoefficient = 1
local bendingRadius = 20
local bendingPixelsPerRow = 40

local crateSize = 32

-- Local variables and forward declarations
local letterboxWidth = math.abs(display.screenOriginX)
local letterboxHeight = math.abs(display.screenOriginY)
local touchBehavior = "move"
local previousTime = 0
local previousX = 0
local previousY = 0
local touchX = 0
local touchY = 0
local velocityX = 0
local velocityY = 0

local bendingPixelSize = math.floor(display.actualContentWidth / bendingPixelsPerRow)
local bendingPixelsPerColumn = math.floor(display.actualContentHeight / bendingPixelSize)
local bendingPixelRadius = math.floor(bendingRadius / bendingPixelSize)

bendingBoxes = {}
local bendingBoxIndex = 0

function bendingPixelXY( x, y )
	pixelX = math.floor(x / bendingPixelSize)
	pixelY = math.floor(y / bendingPixelSize)
	return pixelX, pixelY
end

function getBendingPixel( x, y )
	return bendingBoxes[tostring(x) .. tostring(y)]
end

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

local crate

-- Create "walls and floor" around screen
local wallL = display.newRect( mainGroup, 0-letterboxWidth, display.contentCenterY+150, 20, display.actualContentHeight-150 )
wallL.anchorX = 1
physics.addBody( wallL, "static", { bounce=1, friction=0.1 } )

local wallR = display.newRect( mainGroup, 320+letterboxWidth, display.contentCenterY+150, 20, display.actualContentHeight-150 )
wallR.anchorX = 0
physics.addBody( wallR, "static", { bounce=1, friction=0.1 } )

local floor = display.newRect( mainGroup, display.contentCenterX, 480+letterboxHeight, display.actualContentWidth, 20 )
floor.anchorY = 0
physics.addBody( floor, "static", { bounce=0.4, friction=0.6 } )

-- Create the particle system
local particleSystem = physics.newParticleSystem(
{
	filename = "waterParticle.png",
	colorMixingStrength = 0.2,
	radius = 1.5,
	imageRadius = 4.5,
	surfaceTensionPressureStrength=0.2,
	surfaceTensionNormalStrength=0.2
})
mainGroup:insert( particleSystem )

-- Parameters for red particle faucet
local particleParamsRed = {
	x = 0-letterboxWidth,
	y = 300-letterboxHeight,
	velocityX = 110,
	velocityY = 80,
	color = { 1, 0, 0.2, 1 },
	lifetime = 48,
	flags = { "water", "colorMixing" }
}

-- Parameters for blue particle faucet
local particleParamsBlue =
{
	x = 320+letterboxWidth,
	y = 300-letterboxHeight,
	velocityX = -110,
	velocityY = 80,
	color = { 0.2, 0.4, 1, 1 },
	lifetime = 48,
	flags = { "water", "colorMixing" }
}

-- Generate particles on repeating timer
local function onTimer( event )
	particleSystem:createParticle( particleParamsRed )
	particleSystem:createParticle( particleParamsBlue )
end
timer.performWithDelay( 10, onTimer, 0 )

-- make crate
local function makeCrate( event )
	crate = display.newRect( mainGroup, 30, 30, crateSize, crateSize )
	physics.addBody( crate, "dynamic", { density=1.5 } )
end
timer.performWithDelay( 20, makeCrate, 1 )

-- Function to query region or destroy particles in particle system
local function enterFrame( event )

	if ( touchBehavior == "move" ) then
		local region = particleSystem:queryRegion(
			box.x - bendingBoxSize/2,
			box.y - bendingBoxSize/2,
			box.x + bendingBoxSize/2,
			box.y + bendingBoxSize/2,
			{ deltaVelocityX=velocityX*bendingCoefficient, deltaVelocityY=velocityY*bendingCoefficient }
		)
	elseif ( touchBehavior == "destroy" ) then
		local region = particleSystem:destroyParticles(
		{
			x = box.x,
			y = box.y,
			halfWidth = bendingBoxSize/2,
			halfHeight = bendingBoxSize/2
		})
	end
end


local function pixelBend( event )
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

-- Function to create/move/remove "touch box"
local function onTouch( event )

	local timeDelta = ( event.time / 1000 ) - previousTime
	if ( timeDelta > 0 ) then
		touchX = event.x
		touchY = event.y
		previousTime = ( event.time / 1000 )
		local positionDeltaX = touchX - previousX
		local positionDeltaY = touchY - previousY
		previousX = touchX
		previousY = touchY
		velocityX = ( positionDeltaX / timeDelta )
		velocityY = ( positionDeltaY / timeDelta )
	end

	if ( "began" == event.phase ) then

		Runtime:addEventListener( "enterFrame", enterFrame )
		velocityX = 0.0
		velocityY = 0.0
		box = display.newRect( mainGroup, event.x, event.y, bendingBoxSize, bendingBoxSize )
		box.strokeWidth = 2
		box:setStrokeColor( 1, 0.4, 0.25 )
		box:setFillColor( 1, 0.4, 0.25, 0.2 )

		pixelBend(event)

	elseif ( "moved" == event.phase ) then

		-- if moved min distance (& min time?)
			-- add new box

		if box then
			box.x = event.x
			box.y = event.y
		end

	elseif ( "ended" == event.phase or "cancelled" == event.phase ) then

		Runtime:removeEventListener( "enterFrame", enterFrame )
		display.remove( box )
		box = nil
	end
	return true
end
Runtime:addEventListener( "touch", onTouch )

local switches = require('switches')
switches.addSwitches(display, widget, mainGroup, letterboxHeight)
