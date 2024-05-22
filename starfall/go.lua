--@name Zarashigal's Go (An Ancient Board Game)
--@author Zarashigal
--@shared
--@model models/sprops/rectangles/size_6/rect_96x96x3.mdl

-- Helpers!
c = chip()
c:setColor(Color(0,0,0,0))

-- Initialisayshun
Go = {}
Go.Conf = {Rows = 9, Cols = 9, GridColor = Color(0, 0, 0)}

-- Pieces
Go.Pieces  = {}
Go.Markers = {}

-- Subtable for each player. TODO: Logic!
Go.Pieces.Ply1 = {}
Go.Pieces.Ply2 = {}

-- Server stuffery!
if SERVER then
    
    -- Color Naming for easy switchinggg!
    Black = "phoenix_storms/black_brushes"
    White = "models/debug/debugwhite"
    
    -- Switch around as wished!
    Ply1Col = Black
    Ply2Col = White
    
    -- Get players.
    Ply1 = find.playersByName("name1", false)[1]
    Ply2 = find.playersByName("name2", false)[1]
    
    -- Init input.
    Ply1KeyTrigger = false
    Ply2KeyTrigger = false
    
    -- Board. 48x48 is 9x9
    Go.Board = hologram.create(c:getPos(), c:getAngles(), "models/sprops/rectangles/size_5/rect_48x48x3.mdl", Vector(2))
    Go.Board:setMaterial("phoenix_storms/fender_wood")
    Go.Board:setParent(c)
    
    -- Grid generation
    Go.Rows = {}
    Go.Cols = {}
    Go.Intersections = {}
    
    -- Grid generation!
    for i=1, Go.Conf.Rows do
        
        -- Rows! Messy, but it works.
        Go.Rows[i] = hologram.create(
            c:localToWorld(Vector(-c:getModelBounds()[1]*12, 0, 0) + Vector(-(i-1)*10.5, 0, 0)), 
            c:getAngles(), 
            "models/sprops/rectangles/size_5/rect_48x48x3.mdl", 
            Vector(0.01, 2, 2.1)
        )  
    
        -- Columns! Messy, but it works.
        Go.Cols[i] = hologram.create(
            c:localToWorld(Vector(0, -c:getModelBounds()[2]*12, 0) + Vector(0, -(i-1)*10.5, 0)), 
            c:getAngles(), 
            "models/sprops/rectangles/size_5/rect_48x48x3.mdl", 
            Vector(2, 0.01, 2.1)
        )
            
        -- Intersections.     
        for x=1, Go.Conf.Rows do
            

            -- Make point in the intersection.
            table.insert(Go.Intersections, hologram.create(
                c:localToWorld(Vector(-c:getModelBounds()[1]*12, -c:getModelBounds()[2]*12, 0) + Vector(-(i-1)*10.5, -(x-1)*10.5, 0)),
                c:getAngles(),
                "models/sprops/geometry/sphere_3.mdl",
                Vector(2, 2, 2.25)
                
            ))
            
                        
            -- ALSO paint our columns and rows in one "go" badum tss.
            Go.Rows[i]:setColor(Go.Conf.GridColor)
            Go.Cols[i]:setColor(Go.Conf.GridColor)
            Go.Rows[i]:setMaterial("models/debug/debugwhite")
            Go.Cols[i]:setMaterial("models/debug/debugwhite")
            
            -- Parent to the board so we can pick it up!
            Go.Rows[i]:setParent(c)
            Go.Cols[i]:setParent(c)

        end
    
    end
    
    -- Paint them with grid color.
    for i=1, #Go.Intersections do
        
        -- Grid paint.
        Go.Intersections[i]:setColor(Go.Conf.GridColor)
        Go.Intersections[i]:setMaterial("models/debug/debugwhite")
        
        -- Parent to the board, so we can pick it up!
        Go.Intersections[i]:setParent(c)
        
    end
    
    -- Selection and placement
    timer.create("ash_go_logic", 0.065, 0, function()
        
        -- TODO: Optimize this.
        for i=1, #Go.Intersections do
            
            -- Reset Color!
            Go.Intersections[i]:setColor(Go.Conf.GridColor)
            Go.Intersections[i]:setScale(Vector(2, 2, 2.25))
            
            
            -- If no one looks at this, don't bother, save CPU ops!
            if Ply1:getEyeTrace().HitPos:getDistance(c:getPos()) >= 60 and Ply2:getEyeTrace().HitPos:getDistance(c:getPos()) >= 60 then
                return
            end
            
            -- Selector Player 1
            if Ply1:getEyeTrace().HitPos:getDistance(Go.Intersections[i]:getPos()) < 5 then
                
                -- Placement for Player 1!
                if Ply1KeyTrigger then
                    
                    -- Remove if there's one already.
                    if isValid(Go.Markers[tostring(Go.Intersections[i])]) then
                        
                        Go.Markers[tostring(Go.Intersections[i])]:remove()
                        
                    -- Otherwise we place one!    
                    else
                    
                        table.insert(Go.Pieces.Ply1,  hologram.create(
                    
                            -- Position
                            Go.Intersections[i]:localToWorld(Vector(0, 0, 3)),
                            
                            -- Ang
                            Go.Intersections[i]:getAngles(),
                            
                            -- Model
                            "models/sprops/geometry/sphere_6.mdl",
                            
                            -- Size
                            Vector(1)
                        
                        ))
                        
                        -- Color Player 2 Piece
                        Go.Pieces.Ply1[#Go.Pieces.Ply1]:setMaterial(Ply1Col)
                        
                        -- Parent to the board, so we can pick it up!
                        Go.Pieces.Ply1[#Go.Pieces.Ply1]:setParent(c)
                        
                        -- Log marker into table!
                        Go.Markers[tostring(Go.Intersections[i])] = Go.Pieces.Ply1[#Go.Pieces.Ply1]
                        
                    end
                    
                    -- Prevent spam...
                    Ply1KeyTrigger = false
                    
                    -- Sound.
                    Go.Intersections[i]:emitSound("physics/plaster/ceiling_tile_step4.wav")
                    
                end
                
            end
            
            -- Selector Player 2
            if Ply2:getEyeTrace().HitPos:getDistance(Go.Intersections[i]:getPos()) < 5 then
                
                -- Placement for Player 2!
                if Ply2KeyTrigger then
                    
                    -- Remove if there's one already.
                    if isValid(Go.Markers[tostring(Go.Intersections[i])]) then
                        
                        Go.Markers[tostring(Go.Intersections[i])]:remove()
                        
                    -- Otherwise we place one!    
                    else
                    
                        table.insert(Go.Pieces.Ply2,  hologram.create(
                    
                            -- Position
                            Go.Intersections[i]:localToWorld(Vector(0, 0, 3)),
                            
                            -- Ang
                            Go.Intersections[i]:getAngles(),
                            
                            -- Model
                            "models/sprops/geometry/sphere_6.mdl",
                            
                            -- Size
                            Vector(1)
                        
                        ))
                        
                        -- Color Player 2 Piece
                        Go.Pieces.Ply2[#Go.Pieces.Ply2]:setMaterial(Ply2Col)
                        
                        -- Parent to the board, so we can pick it up!
                        Go.Pieces.Ply2[#Go.Pieces.Ply2]:setParent(c)
                        
                        -- Log marker into table
                        Go.Markers[tostring(Go.Intersections[i])] = Go.Pieces.Ply2[#Go.Pieces.Ply2]
                        
                    end
                    
                    -- Prevent spam...
                    Ply2KeyTrigger = false
                    
                    -- Sound.
                    Go.Intersections[i]:emitSound("physics/plaster/ceiling_tile_step4.wav")
                    
                end
                
            end
            
            if Ply1:getEyeTrace().HitPos:getDistance(Go.Intersections[i]:getPos()) < 5 or Ply2:getEyeTrace().HitPos:getDistance(Go.Intersections[i]:getPos()) < 5 then
                
                -- Selection indicator!
                Go.Intersections[i]:setColor(Color(255, 111, 111, 155))
                Go.Intersections[i]:setScale(Vector(2, 2, 2.25)*1.25)
                
            end
            
        end
    
    end)   
    
    -- Keys: 32 corresponds to "e" key.. :3
    
    -- Player pressing keys.
    hook.add("KeyPress", "ash_go_inputOn", function(ply, key)
        
        -- Player 1
        if key == 32 && ply == Ply1 then
            Ply1KeyTrigger = true
        end
        
        -- Player 2
        if key == 32 && ply == Ply2 then
            Ply2KeyTrigger = true
        end
        
    end)
    
    -- Player releasing keys.
    hook.add("keyRelease", "ash_go_inputOff", function(ply, key)
        
        -- Player 1
        if key == 32 && ply == Ply1 then
            Ply1KeyTrigger = false
        end
        
        -- Player 2
        if key == 32 && ply == Ply2 then
            Ply2KeyTrigger = false
        end
        
    end)

end
