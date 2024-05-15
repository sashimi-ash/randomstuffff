--@name  Ash's Lovely Little Fireflies!
--@author Zarashigal
--@shared
--@model models/hunter/plates/plate.mdl

-- This runs Clientside!
if CLIENT then

    -- Init table!!
    local Fli =  {...}

    -- Helpers.
    local Ori    =  chip()
    local OriPos =  chip():getPos()
    local OriAng =  chip():getAngles()
    
    -- Store fireflies! :3
    Fli.Flies =  {}
    Fli.Goals =  {}

    -- Configurayshunn.
    Fli.Col        =   Color(100, 255, 100)
    Fli.Siz        =   0.08
    Fli.Rad        =   255
    Fli.Count      =   25
    Fli.Fullbright =   true
    Fli.SeekRand   =   0

    -- Movement path setup.
    for xo = 1, Fli.Count do

        -- At first every position is initialized with a random one.
        Fli.Goals[xo] = OriPos + Vector(math.rand(-Fli.Rad, Fli.Rad), math.rand(-Fli.Rad, Fli.Rad), math.rand(Fli.Rad, Fli.Rad*2) / 1.5
    
    end

    -- We make fireflies!
    for xo = 1, Fli.Count do

        -- But only if we can spawn any, that is!
        if not hologram.canSpawn then return end

        -- However, if we can spawn any, we...
        -- Insert the fly to the fly table, so we can do stuff with them.
        table.insert(Fli.Flies, hologram.create(OriPos + Fli.Goals[xo], OriAng, "models/holograms/icosphere.mdl", Vector(1, 1, 1) * Fli.Siz))

        -- Set their color and make fullbright if wanted.
        Fli.Flies[xo]:setColor(Fli.Col)
        Fli.Flies[xo]:suppressEngineLighting(Fli.Fullbright)

    end

    -- We make the light source of the fireflies. xD
    Fli.LightSource = light.create(OriPos, 100*Fli.Rad/4, .00000001, Fli.Col)

    -- Visual FX!
    function Fli.VFX()

        -- We draw the light source.
        Fli.LightSource:draw()

    end

    -- Movement logic for our fireflies.
    function Fli.Logic(xo)

            -- Select random goal for the fireflies to fly towards.
            -- We do dat and store them in a tabley. :3
            Fli.Goals[xo] = OriPos + Vector(math.rand(-Fli.Rad, Fli.Rad), math.rand(-Fli.Rad, Fli.Rad), math.rand(-Fli.Rad, Fli.Rad*2) / 1.5)

    end

    -- The movement itself.
    function Fli.Movement()
        -- Get time for blinking!
        local curtime = timer.curtime()

        -- Animate every lovely little firefly!
        for xo = 1, Fli.Count do

                -- Fly to movement goal.
                Fli.Flies[xo]:setPos(math.lerpVector(0.95, Fli.Goals[xo], Fli.Flies[xo]:getPos()))

                -- Scale flicker. Gives it more liveliness! uwu
                Fli.Flies[xo]:setScale(Vector(Fli.Siz * math.max(math.sin(curtime * (3+xo*0.1)), 0.25)))

        end

    end
    
    -- Movement logic.
    for xo = 1, Fli.Count do

        -- Randomize it alittle.
        timer.create("Ash_Logi_Fireflies_ID_" .. xo, 0.3+math.rand(0.15,0.25), 0, function() Fli.Logic(xo) end)
        timer.start("Ash_Logi_Fireflies_ID_" .. xo)

    end

    -- Movement anims.
    timer.create("Ash_Move_Fireflies", 0.05, 0, Fli.Movement)
    timer.start("Ash_Move_Fireflies")
    
    -- VFX
    hook.add("think", "Ash_VFX_Fireflies", Fli.VFX)

end
