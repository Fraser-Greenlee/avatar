
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
local configMaker = require('game-config')
local config = configMaker.new(display)
local bendingBoxSize = 20
local maxBendingBoxCount = 5
local bendingCoefficient = 1

local crateSize = 32

-- Local variables and forward declarations
local letterbox = {
	width = math.abs(display.screenOriginX),
	height = math.abs(display.screenOriginY)
}
local touchBehavior = "move"
local previousTime = 0
local previousX = 0
local previousY = 0
local touchX = 0
local touchY = 0
local velocityX = 0
local velocityY = 0

bendingBoxes = {}
local bendingBoxIndex = 0

for y=0,config.bending.pixel.per.column do
	for x=0,config.bending.pixel.per.row do
		x = x - 2
		local bendingPixel = display.newRect( mainGroup, x*bendingPixelSize, y*bendingPixelSize, bendingPixelSize, bendingPixelSize )
		bendingPixel.strokeWidth = 2
		bendingPixel:setStrokeColor( 1, 0.4, 0.25 )
		bendingPixel:setFillColor( 1, 0.4, 0.25, 0.2 )
		bendingBoxes[tostring(x) .. tostring(y)] = bendingPixel
	end
end

local level = require('level')
level.make(display, physics, mainGroup, letterbox)

-- Create the particle system
local particleManager = require('particles')
local particleSystem = particleManager.makeParticleSystem(physics)
mainGroup:insert( particleSystem )
local particleParams = particleManager.makeParticleParams(letterbox)

-- Generate particles on repeating timer
local function onTimer( event )
	particleSystem:createParticle( particleParams.red )
	particleSystem:createParticle( particleParams.blue )
end
timer.performWithDelay( 10, onTimer, 0 )

-- make crate
local crate
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
switches.addSwitches(display, widget, mainGroup, letterbox.height)
