
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
config.mainGroup = mainGroup
config.display = display

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

local bend = require('bend')
--bend.drawGrid(display, mainGroup, config)

local level = require('level')
level.make(display, physics, mainGroup, letterbox)

-- Create the particle system
local particleManager = require('particles')
local particleSystem = particleManager.makeParticleSystem(physics)
mainGroup:insert( particleSystem )
local particleParams = particleManager.makeParticleParams(letterbox)

-- Generate particles on repeating timer
local function onTimer( event )
	-- particleSystem:createParticle( particleParams.red )
	particleSystem:createParticle( particleParams.blue )
end
timer.performWithDelay( 100, onTimer, 0 )

-- make crate
local crate
local function makeCrate( event )
	crate = display.newRect( mainGroup, 30, 30, crateSize, crateSize )
	physics.addBody( crate, "dynamic", { density=1 } )
end
timer.performWithDelay( 20, makeCrate, 1 )

local staticBend = function()
	if (previousTime + config.bending.staticDelay < system.getTimer()) then
		bend.run(config, particleSystem, system.getTimer(), touchX, touchY, velocityX, velocityY)
	end
end

-- Function to create/move/remove "touch box"
local function onTouch(event)

	local timeDelta = ( event.time / 1000 ) - previousTime
	if timeDelta > 0 then
		touchX = event.x
		touchY = event.y
		previousTime = ( event.time / 1000 )
		local positionDeltaX = touchX - previousX
		local positionDeltaY = touchY - previousY
		previousX = touchX
		previousY = touchY
		velocityX = ( positionDeltaX / timeDelta )
		velocityY = ( positionDeltaY / timeDelta )

		bend.run(config, particleSystem, event.time, touchX, touchY, velocityX, velocityY)

		if config.bending.debugPrint then
			if ( "began" == event.phase ) then
				print('began')
				local staticTimer = timer.performWithDelay( 1, staticBend, -1 )
			elseif ( "moved" == event.phase ) then
				print('moved')
			elseif ( "ended" == event.phase or "cancelled" == event.phase ) then
				print('end')
				timer.cancel( staticTimer )
			end
		end
	end

	return true
end
Runtime:addEventListener( "touch", onTouch )

local switches = require('switches')
switches.addSwitches(display, widget, mainGroup, letterbox.height)

local runRender = function() return bend.render(config, particleSystem) end
timer.performWithDelay(config.bending.renderDelay, runRender, -1)
