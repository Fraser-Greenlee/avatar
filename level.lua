return {
    make = function(display, physics, mainGroup, letterbox)
        -- Create "walls and floor" around screen
        local wallL = display.newRect( mainGroup, 0-letterbox.width, display.contentCenterY+150, 20, display.actualContentHeight-150 )
        wallL.anchorX = 1
        physics.addBody( wallL, "static", { bounce=1, friction=0.1 } )
        
        local wallR = display.newRect( mainGroup, 320+letterbox.width, display.contentCenterY+150, 20, display.actualContentHeight-150 )
        wallR.anchorX = 0
        physics.addBody( wallR, "static", { bounce=1, friction=0.1 } )
        
        local floor = display.newRect( mainGroup, display.contentCenterX, 480+letterbox.height, display.actualContentWidth, 20 )
        floor.anchorY = 0
        physics.addBody( floor, "static", { bounce=0.4, friction=0.6 } )
    end
}