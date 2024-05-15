--@name  Ash's Lovely Little Fireflies!
--@author Zarashigal
--@shared
--@model "models/bull/gates/capacitor_nano.mdl"

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
    Fli.Siz        =   0.1
    Fli.Rad        =   200
    Fli.Count      =   55
    Fli.Fullbright =   true
    
    -- Movement path setup.
    for xo = 1, Fli.Count do
        Fli.Goals[xo] = OriPos
    end

    -- We make fireflies!
    for xo = 1, Fli.Count do

        -- But only if we can spawn any, that is!
        if not hologram.canSpawn then return end

        -- However, if we can spawn any, we...
        -- Insert the fly to the fly table, so we can do stuff with them.
        table.insert(Fli.Flies, hologram.create(OriPos + Vector(math.rand(-Fli.Rad, Fli.Rad), math.rand(-Fli.Rad, Fli.Rad), math.rand(Fli.Rad, Fli.Rad*2) / 1.5), OriAng, "models/holograms/icosphere.mdl", Vector(1, 1, 1) * Fli.Siz))

        -- Set their color and make fullbright if wanted.
        Fli.Flies[xo]:setColor(Fli.Col)
        Fli.Flies[xo]:suppressEngineLighting(Fli.Fullbright)

    end

    -- We make the light source of the fireflies. xD
    Fli.LightSource = light.create(OriPos, 100*Fli.Rad/2, 0.001, Fli.Col)

    -- Visual FX!
    function Fli.VFX()

        -- We draw the light source.
        Fli.LightSource:draw()

    end

    -- Movement logic for our fireflies.
    function Fli.Logic()

        -- Select random goal for the fireflies to fly towards.
        for xo = 1, Fli.Count do

            -- We do dat and store them in a tabley. :3
            Fli.Goals[xo] = OriPos + Vector(math.rand(-Fli.Rad, Fli.Rad), math.rand(-Fli.Rad, Fli.Rad), math.rand(-Fli.Rad, Fli.Rad*2) / 1.5)

        end

    end

    -- The movement itself.
    function Fli.Movement()

        -- Animate every lovely little firefly!
        for xo = 1, Fli.Count do

                -- Fly to movement goal.
                Fli.Flies[xo]:setPos(math.lerpVector(0.98, Fli.Goals[xo], Fli.Flies[xo]:getPos()))
                Fli.Flies[xo]:setColor(Fli.Col * math.rand(0, 1))

        end

    end
    
    -- Movement logic.
    timer.create("Ash_Logi_Fireflies", 1, 0, Fli.Logic)
    timer.start("Ash_Logi_Fireflies")

    -- Movement anims.
    timer.create("Ash_Move_Fireflies", 0.035, 0, Fli.Movement)
    timer.start("Ash_Move_Fireflies")
    
    -- VFX
    timer.create("Ash_VFX_Fireflies", 0.5, 0, Fli.VFX)
    timer.start("Ash_VFX_Fireflies")

end
