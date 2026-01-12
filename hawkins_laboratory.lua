-- HAWKINS LABORATORY - COMPLETE BUILD
-- Colocar en ServerScriptService

local function createHawkinsLab()
    local labModel = Instance.new("Model")
    labModel.Name = "HawkinsLaboratory"
    labModel.Parent = workspace
    
    -- CONFIGURACIÓN
    local BASE_POS = Vector3.new(0, 0, 0)
    
    -- FUNCIÓN PARA CREAR PARTES CON STUDS
    local function createPart(name, size, position, color, parent)
        local part = Instance.new("Part")
        part.Name = name
        part.Size = size
        part.Position = position
        part.BrickColor = BrickColor.new(color)
        part.Material = Enum.Material.Plastic
        part.TopSurface = Enum.SurfaceType.Studs
        part.BottomSurface = Enum.SurfaceType.Studs
        part.LeftSurface = Enum.SurfaceType.Studs
        part.RightSurface = Enum.SurfaceType.Studs
        part.FrontSurface = Enum.SurfaceType.Studs
        part.BackSurface = Enum.SurfaceType.Studs
        part.Anchored = true
        part.Parent = parent
        return part
    end
    
    -- PISO DEL LABORATORIO (80x80)
    local floor = createPart("Floor", Vector3.new(80, 2, 80), BASE_POS + Vector3.new(0, 1, 0), "Dark stone grey", labModel)
    
    -- PAREDES EXTERIORES
    -- Pared frontal con entrada
    local frontWallLeft = createPart("FrontWallLeft", Vector3.new(25, 20, 4), BASE_POS + Vector3.new(-27.5, 11, -38), "Institutional white", labModel)
    local frontWallRight = createPart("FrontWallRight", Vector3.new(25, 20, 4), BASE_POS + Vector3.new(27.5, 11, -38), "Institutional white", labModel)
    local frontWallTop = createPart("FrontWallTop", Vector3.new(20, 8, 4), BASE_POS + Vector3.new(0, 17, -38), "Institutional white", labModel)
    
    -- Puerta de entrada
    local door = createPart("Door", Vector3.new(18, 10, 2), BASE_POS + Vector3.new(0, 7, -39), "Really black", labModel)
    
    -- Letrero HAWKINS LAB
    local sign = createPart("LabSign", Vector3.new(30, 4, 1), BASE_POS + Vector3.new(0, 18, -40), "Really red", labModel)
    sign.Material = Enum.Material.Neon
    
    -- Paredes laterales
    local leftWall = createPart("LeftWall", Vector3.new(4, 20, 80), BASE_POS + Vector3.new(-38, 11, 0), "Institutional white", labModel)
    local rightWall = createPart("RightWall", Vector3.new(4, 20, 80), BASE_POS + Vector3.new(38, 11, 0), "Institutional white", labModel)
    
    -- Pared trasera
    local backWall = createPart("BackWall", Vector3.new(80, 20, 4), BASE_POS + Vector3.new(0, 11, 38), "Institutional white", labModel)
    
    -- TECHO
    local roof = createPart("Roof", Vector3.new(80, 2, 80), BASE_POS + Vector3.new(0, 21, 0), "Dark stone grey", labModel)
    
    -- SALA DE TANQUE SENSORIAL (CENTRO)
    local tankRoomFloor = createPart("TankRoomFloor", Vector3.new(20, 1, 20), BASE_POS + Vector3.new(0, 2.5, 0), "Black", labModel)
    
    -- Paredes de la sala del tanque
    local tankWall1 = createPart("TankWall1", Vector3.new(20, 8, 2), BASE_POS + Vector3.new(0, 6, -9), "Really black", labModel)
    local tankWall2 = createPart("TankWall2", Vector3.new(20, 8, 2), BASE_POS + Vector3.new(0, 6, 9), "Really black", labModel)
    local tankWall3 = createPart("TankWall3", Vector3.new(2, 8, 20), BASE_POS + Vector3.new(-9, 6, 0), "Really black", labModel)
    local tankWall4 = createPart("TankWall4", Vector3.new(2, 8, 20), BASE_POS + Vector3.new(9, 6, 0), "Really black", labModel)
    
    -- TANQUE SENSORIAL
    local tank = createPart("SensoryTank", Vector3.new(12, 4, 8), BASE_POS + Vector3.new(0, 4, 0), "Dark blue", labModel)
    tank.Material = Enum.Material.Glass
    tank.Transparency = 0.3
    
    -- Agua del tanque
    local water = createPart("TankWater", Vector3.new(11, 3, 7), BASE_POS + Vector3.new(0, 4, 0), "Teal", labModel)
    water.Material = Enum.Material.Glass
    water.Transparency = 0.5
    
    -- LABORATORIOS LATERALES
    -- Laboratorio izquierdo
    local leftLabFloor = createPart("LeftLabFloor", Vector3.new(25, 1, 30), BASE_POS + Vector3.new(-20, 2.5, -20), "Mid gray", labModel)
    
    -- Mesas de laboratorio izquierda
    for i = 1, 3 do
        local table = createPart("LabTable" .. i, Vector3.new(8, 4, 3), BASE_POS + Vector3.new(-20, 4, -30 + (i * 8)), "Light stone grey", labModel)
        
        -- Equipos en las mesas
        local equipment = createPart("Equipment" .. i, Vector3.new(2, 2, 2), BASE_POS + Vector3.new(-20, 7, -30 + (i * 8)), "Bright green", labModel)
        equipment.Material = Enum.Material.Neon
    end
    
    -- Laboratorio derecho
    local rightLabFloor = createPart("RightLabFloor", Vector3.new(25, 1, 30), BASE_POS + Vector3.new(20, 2.5, -20), "Mid gray", labModel)
    
    -- Mesas de laboratorio derecha
    for i = 1, 3 do
        local table = createPart("LabTable" .. (i+3), Vector3.new(8, 4, 3), BASE_POS + Vector3.new(20, 4, -30 + (i * 8)), "Light stone grey", labModel)
        
        -- Equipos en las mesas
        local equipment = createPart("Equipment" .. (i+3), Vector3.new(2, 2, 2), BASE_POS + Vector3.new(20, 7, -30 + (i * 8)), "Bright red", labModel)
        equipment.Material = Enum.Material.Neon
    end
    
    -- SALA DE CONTROL (ATRÁS)
    local controlRoomFloor = createPart("ControlRoomFloor", Vector3.new(30, 1, 20), BASE_POS + Vector3.new(0, 2.5, 25), "Really black", labModel)
    
    -- Consolas de control
    for i = 1, 4 do
        local console = createPart("Console" .. i, Vector3.new(6, 5, 3), BASE_POS + Vector3.new(-15 + (i * 10), 4.5, 25), "Dark stone grey", labModel)
        
        -- Pantallas
        local screen = createPart("Screen" .. i, Vector3.new(5, 3, 0.5), BASE_POS + Vector3.new(-15 + (i * 10), 6, 23.5), "Bright blue", labModel)
        screen.Material = Enum.Material.Neon
    end
    
    -- CELDAS DE CONTENCIÓN (DERECHA ATRÁS)
    for i = 1, 2 do
        -- Paredes de celda
        local cellFloor = createPart("CellFloor" .. i, Vector3.new(8, 1, 8), BASE_POS + Vector3.new(25, 2.5, 15 + (i * 12)), "Dark stone grey", labModel)
        
        local cellWallFront = createPart("CellWallFront" .. i, Vector3.new(8, 8, 1), BASE_POS + Vector3.new(25, 6, 11 + (i * 12)), "Mid gray", labModel)
        cellWallFront.Material = Enum.Material.Glass
        cellWallFront.Transparency = 0.5
        
        local cellWallBack = createPart("CellWallBack" .. i, Vector3.new(8, 8, 1), BASE_POS + Vector3.new(25, 6, 19 + (i * 12)), "Mid gray", labModel)
        local cellWallLeft = createPart("CellWallLeft" .. i, Vector3.new(1, 8, 8), BASE_POS + Vector3.new(21, 6, 15 + (i * 12)), "Mid gray", labModel)
        local cellWallRight = createPart("CellWallRight" .. i, Vector3.new(1, 8, 8), BASE_POS + Vector3.new(29, 6, 15 + (i * 12)), "Mid gray", labModel)
        
        -- Cama en celda
        local bed = createPart("Bed" .. i, Vector3.new(6, 1, 3), BASE_POS + Vector3.new(25, 3.5, 16 + (i * 12)), "Institutional white", labModel)
    end
    
    -- LUCES DEL TECHO
    for x = -30, 30, 15 do
        for z = -30, 30, 15 do
            local light = createPart("Light", Vector3.new(2, 1, 2), BASE_POS + Vector3.new(x, 20, z), "Bright yellow", labModel)
            light.Material = Enum.Material.Neon
            
            -- Efecto de parpadeo
            spawn(function()
                while light.Parent do
                    wait(math.random(3, 8))
                    light.Transparency = math.random(0, 30)/100
                    wait(0.1)
                end
            end)
        end
    end
    
    -- GENERADOR DE ENERGÍA (IZQUIERDA ATRÁS)
    local generator = createPart("Generator", Vector3.new(8, 10, 8), BASE_POS + Vector3.new(-25, 7, 25), "Really black", labModel)
    
    -- Luces del generador
    for i = 1, 4 do
        local genLight = createPart("GenLight" .. i, Vector3.new(1, 1, 1), BASE_POS + Vector3.new(-25 + (i-2.5)*2, 10, 25), "Bright red", labModel)
        genLight.Material = Enum.Material.Neon
        genLight.Shape = Enum.PartType.Ball
        
        -- Parpadeo
        spawn(function()
            while genLight.Parent do
                wait(0.5)
                genLight.Transparency = (genLight.Transparency == 0) and 0.5 or 0
            end
        end)
    end
    
    -- TUBOS DE VENTILACIÓN
    for i = 1, 4 do
        local pipe = createPart("Pipe" .. i, Vector3.new(2, 20, 2), BASE_POS + Vector3.new(-30 + (i * 20), 11, -30), "Dark stone grey", labModel)
        pipe.Shape = Enum.PartType.Cylinder
        pipe.Orientation = Vector3.new(0, 0, 90)
    end
    
    -- SEÑALES DE ADVERTENCIA
    local warningSign1 = createPart("WarningSign1", Vector3.new(4, 4, 0.5), BASE_POS + Vector3.new(-35, 10, 0), "Bright yellow", labModel)
    warningSign1.Material = Enum.Material.Neon
    
    local warningSign2 = createPart("WarningSign2", Vector3.new(4, 4, 0.5), BASE_POS + Vector3.new(35, 10, 0), "Bright yellow", labModel)
    warningSign2.Material = Enum.Material.Neon
    
    -- ESCALERAS A SEGUNDO PISO (OPCIONAL)
    for i = 1, 10 do
        local step = createPart("Step" .. i, Vector3.new(8, 1, 3), BASE_POS + Vector3.new(-30, 2 + (i * 1), -10 - (i * 1)), "Dark stone grey", labModel)
    end
    
    print("Laboratorio de Hawkins creado exitosamente!")
    print("Dimensiones: 80x20x80 studs")
    print("Incluye: Tanque sensorial, laboratorios, sala de control, celdas, generador")
    
    return labModel
end

-- Crear el laboratorio
createHawkinsLab()
