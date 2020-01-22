-- Switches and labels
return {
    addSwitches = function(display, widget, mainGroup, letterboxHeight)
        local switchGroup = display.newGroup()
        mainGroup:insert( switchGroup )

        local label1 = display.newText( switchGroup, "On touch:", 0, 0, appFont, 15 )
        label1:setFillColor( 0.8 )
        label1.anchorX = 1

        local switch1 = widget.newSwitch(
        {
            x = label1.x+26,
            y = 0,
            style = "radio",
            initialSwitchState = true,
            onEvent = function( event )
                Runtime:removeEventListener( "enterFrame", enterFrame )
                display.remove( box )
                box = nil
                if event.phase == "began" then
                    touchBehavior = "move"
                end
            end
        })
        switchGroup:insert( switch1 )

        local label2 = display.newText( switchGroup, "move/flick", switch1.x+22, 0, appFont, 15 )
        label2.anchorX = 0

        local switch2 = widget.newSwitch(
        {
            x = label2.contentBounds.xMax+28,
            y = 0,
            style = "radio",
            initialSwitchState = false,
            onEvent = function( event )
                Runtime:removeEventListener( "enterFrame", enterFrame )
                display.remove( box )
                box = nil

                if event.phase == "began" then
                    touchBehavior = "destroy"
                end
            end
        })
        switchGroup:insert( switch2 )

        local label3 = display.newText( switchGroup, "destroy", switch2.x+22, 0, appFont, 15 )
        label3.anchorX = 0

        switchGroup.anchorChildren = true
        switchGroup.x = display.contentCenterX
        switchGroup.y = 80 - letterboxHeight
    end
}
