-- HAWKINS LABORATORY - REALISTIC DESIGN
-- Colocar en ServerScriptService

local function createHawkinsLab()
    local labModel = Instance.new("Model")
    labModel.Name = "HawkinsLaboratory"
    labModel.Parent = workspace
    
    local BASE = Vector3.new(0, 0, 0)
    
    -- FUNCIÓN HELPER
    local function part(name, size, pos, color, material)
        local p = Instance.new("Part")
        p.Name = name
        p.Size = size
        p.Position = pos
        p.BrickColor = BrickColor.new(color)
        p.Material = material or Enum.Material.Plastic
        p.TopSurface = Enum.SurfaceType.Studs
        p.BottomSurface = Enum.SurfaceType.Studs
        p.LeftSurface = Enum.SurfaceType.Studs
        p.RightSurface = Enum.SurfaceType.Studs
        p.FrontSurface = Enum.SurfaceType.Studs
        p.BackSurface = Enum.SurfaceType.Studs
        p.Anchored = true
        p.Parent = labModel
        return p
    end
    
    -- EDIFICIO PRINCIPAL (120x40x100 studs)
    -- Piso base
    local mainFloor = part("MainFloor", Vector3.new(120, 4, 100), BASE + Vector3.new(0, 2, 0), "Dark stone grey")
    
    -- Paredes exteriores - Concreto gris
    local frontWall = part("FrontWall", Vector3.new(120, 40, 6), BASE + Vector3.new(0, 22, -47), "Medium stone grey")
    local backWall = part("BackWall", Vector3.new(120, 40, 6), BASE + Vector3.new(0, 22, 47), "Medium stone grey")
    local leftWall = part("LeftWall", Vector3.new(6, 40, 100), BASE + Vector3.new(-57, 22, 0), "Medium stone grey")
    local rightWall = part("RightWall", Vector3.new(6, 40, 100), BASE + Vector3.new(57, 22, 0), "Medium stone grey")
    
    -- Techo
    local roof = part("Roof", Vector3.new(120, 4, 100), BASE + Vector3.new(0, 42, 0), "Dark stone grey")
    
    -- ENTRADA PRINCIPAL CON SEGURIDAD
    local entranceDoor = part("EntranceDoor", Vector3.new(12, 20, 2), BASE + Vector3.new(0, 12, -48), "Really black", Enum.Material.Metal)
    
    -- Ventanas de seguridad en entrada
    for i = -1, 1 do
        local window = part("SecurityWindow", Vector3.new(6, 8, 1), BASE + Vector3.new(i * 20, 25, -48), "Light blue", Enum.Material.Glass)
        window.Transparency = 0.3
    end
    
    -- Letrero del laboratorio
    local sign = part("HawkinsLabSign", Vector3.new(40, 6, 2), BASE + Vector3.new(0, 35, -49), "Institutional white")
    local signText = part("SignText", Vector3.new(38, 4, 1), BASE + Vector3.new(0, 35, -49.5), "Really black", Enum.Material.Neon)
    
    -- PASILLO PRINCIPAL (Centro)
    local hallwayFloor = part("HallwayFloor", Vector3.new(12, 1, 90), BASE + Vector3.new(0, 4.5, 0), "Institutional white")
    
    -- Luces del pasillo
    for z = -40, 40, 10 do
        local light = part("HallLight", Vector3.new(4, 1, 4), BASE + Vector3.new(0, 40, z), "Bright yellow", Enum.Material.Neon)
        spawn(function()
            while light.Parent do
                wait(math.random(5, 15))
                light.Transparency = math.random(0, 20)/100
                wait(0.05)
            end
        end)
    end
    
    -- SALA DEL TANQUE SENSORIAL (Centro-Atrás)
    local tankRoomFloor = part("TankRoomFloor", Vector3.new(30, 1, 30), BASE + Vector3.new(0, 4.5, 20), "Black")
    
    -- Paredes de la sala del tanque - Negras
    part("TankWall1", Vector3.new(30, 15, 2), BASE + Vector3.new(0, 12, 5), "Black")
    part("TankWall2", Vector3.new(30, 15, 2), BASE + Vector3.new(0, 12, 35), "Black")
    part("TankWall3", Vector3.new(2, 15, 30), BASE + Vector3.new(-14, 12, 20), "Black")
    part("TankWall4", Vector3.new(2, 15, 30), BASE + Vector3.new(14, 12, 20), "Black")
    
    -- Puerta de la sala del tanque
    local tankDoor = part("TankDoor", Vector3.new(8, 12, 1), BASE + Vector3.new(0, 10, 5), "Really black", Enum.Material.Metal)
    
    -- TANQUE SENSORIAL
    local tankBase = part("TankBase", Vector3.new(16, 2, 10), BASE + Vector3.new(0, 6, 20), "Dark stone grey")
    local tankWalls = part("TankWalls", Vector3.new(16, 6, 10), BASE + Vector3.new(0, 9, 20), "Black", Enum.Material.Glass)
    tankWalls.Transparency = 0.2
    
    -- Agua salada del tanque
    local tankWater = part("TankWater", Vector3.new(15, 5, 9), BASE + Vector3.new(0, 9, 20), "Teal", Enum.Material.Glass)
    tankWater.Transparency = 0.4
    
    -- Escalera al tanque
    for i = 1, 4 do
        part("TankStep" .. i, Vector3.new(6, 1, 2), BASE + Vector3.new(-10, 5 + i, 20 - (i * 2)), "Dark stone grey")
    end
    
    -- LABORATORIOS LATERALES
    -- Laboratorio Izquierdo
    local leftLabFloor = part("LeftLabFloor", Vector3.new(40, 1, 80), BASE + Vector3.new(-30, 4.5, 0), "Light stone grey")
    
    -- Divisiones de laboratorio
    for z = -30, 30, 20 do
        part("LabDivider", Vector3.new(40, 12, 2), BASE + Vector3.new(-30, 10, z), "Institutional white")
    end
    
    -- Mesas de laboratorio con equipos
    for z = -35, 35, 15 do
        for x = -45, -20, 12 do
            local table = part("LabTable", Vector3.new(8, 4, 4), BASE + Vector3.new(x, 6.5, z), "Light stone grey")
            
            -- Microscopio
            local microscope = part("Microscope", Vector3.new(2, 3, 2), BASE + Vector3.new(x - 2, 9, z), "Dark stone grey")
            
            -- Computadora
            local computer = part("Computer", Vector3.new(3, 2, 2), BASE + Vector3.new(x + 2, 9, z), "Black")
            local screen = part("Screen", Vector3.new(2.5, 1.5, 0.2), BASE + Vector3.new(x + 2, 9.5, z - 1), "Bright blue", Enum.Material.Neon)
        end
    end
    
    -- Laboratorio Derecho (espejo)
    local rightLabFloor = part("RightLabFloor", Vector3.new(40, 1, 80), BASE + Vector3.new(30, 4.5, 0), "Light stone grey")
    
    for z = -30, 30, 20 do
        part("LabDivider", Vector3.new(40, 12, 2), BASE + Vector3.new(30, 10, z), "Institutional white")
    end
    
    for z = -35, 35, 15 do
        for x = 20, 45, 12 do
            local table = part("LabTable", Vector3.new(8, 4, 4), BASE + Vector3.new(x, 6.5, z), "Light stone grey")
            local microscope = part("Microscope", Vector3.new(2, 3, 2), BASE + Vector3.new(x - 2, 9, z), "Dark stone grey")
            local computer = part("Computer", Vector3.new(3, 2, 2), BASE + Vector3.new(x + 2, 9, z), "Black")
            local screen = part("Screen", Vector3.new(2.5, 1.5, 0.2), BASE + Vector3.new(x + 2, 9.5, z - 1), "Bright green", Enum.Material.Neon)
        end
    end
    
    -- SALA DE CONTROL (Frente)
    local controlFloor = part("ControlFloor", Vector3.new(50, 1, 20), BASE + Vector3.new(0, 4.5, -25), "Really black")
    
    -- Ventana de observación al tanque
    local observationWindow = part("ObservationWindow", Vector3.new(20, 10, 2), BASE + Vector3.new(0, 12, -5), "Light blue", Enum.Material.Glass)
    observationWindow.Transparency = 0.3
    
    -- Consolas de control
    for x = -20, 20, 10 do
        local console = part("ControlConsole", Vector3.new(8, 5, 4), BASE + Vector3.new(x, 7, -25), "Dark stone grey")
        
        -- Pantallas múltiples
        for i = 1, 3 do
            local screen = part("ControlScreen", Vector3.new(2, 2, 0.2), BASE + Vector3.new(x - 3 + (i * 2), 9, -27), "Bright blue", Enum.Material.Neon)
        end
        
        -- Botones
        for i = 1, 4 do
            local button = part("Button", Vector3.new(0.5, 0.5, 0.5), BASE + Vector3.new(x - 2 + i, 7.5, -23), "Bright red", Enum.Material.Neon)
            button.Shape = Enum.PartType.Cylinder
        end
    end
    
    -- CELDAS DE CONTENCIÓN (Derecha-Atrás)
    for i = 0, 2 do
        local cellFloor = part("CellFloor" .. i, Vector3.new(10, 1, 10), BASE + Vector3.new(40, 4.5, -30 + (i * 15)), "Dark stone grey")
        
        -- Paredes de celda
        part("CellWallBack", Vector3.new(10, 12, 2), BASE + Vector3.new(40, 10, -35 + (i * 15)), "Mid gray")
        part("CellWallLeft", Vector3.new(2, 12, 10), BASE + Vector3.new(35, 10, -30 + (i * 15)), "Mid gray")
        part("CellWallRight", Vector3.new(2, 12, 10), BASE + Vector3.new(45, 10, -30 + (i * 15)), "Mid gray")
        
        -- Pared frontal de vidrio
        local cellGlass = part("CellGlass", Vector3.new(10, 12, 1), BASE + Vector3.new(40, 10, -25 + (i * 15)), "Light blue", Enum.Material.Glass)
        cellGlass.Transparency = 0.5
        
        -- Cama
        part("CellBed", Vector3.new(6, 1, 3), BASE + Vector3.new(42, 5.5, -32 + (i * 15)), "Institutional white")
        
        -- Inodoro
        part("CellToilet", Vector3.new(2, 2, 2), BASE + Vector3.new(38, 6, -28 + (i * 15)), "Institutional white")
    end
    
    -- GENERADOR PRINCIPAL (Izquierda-Atrás)
    local generator = part("MainGenerator", Vector3.new(12, 20, 12), BASE + Vector3.new(-40, 14, 30), "Really black", Enum.Material.Metal)
    
    -- Luces del generador
    for y = 8, 20, 4 do
        for i = 1, 4 do
            local light = part("GenLight", Vector3.new(1, 1, 1), BASE + Vector3.new(-40 + (i-2.5)*3, y, 30), "Bright red", Enum.Material.Neon)
            light.Shape = Enum.PartType.Ball
            spawn(function()
                while light.Parent do
                    wait(0.3)
                    light.Transparency = (light.Transparency == 0) and 0.7 or 0
                end
            end)
        end
    end
    
    -- Cables del generador
    for i = 1, 6 do
        local cable = part("PowerCable", Vector3.new(2, 2, 40), BASE + Vector3.new(-40 + (i * 3), 4, 10), "Black")
        cable.Shape = Enum.PartType.Cylinder
        cable.Orientation = Vector3.new(0, 90, 0)
    end
    
    -- SISTEMA DE VENTILACIÓN
    for x = -50, 50, 25 do
        for z = -40, 40, 20 do
            local vent = part("AirVent", Vector3.new(3, 3, 3), BASE + Vector3.new(x, 40, z), "Dark stone grey")
        end
    end
    
    -- SEÑALES DE EMERGENCIA
    local exitSign1 = part("ExitSign", Vector3.new(6, 3, 1), BASE + Vector3.new(-50, 15, 0), "Bright red", Enum.Material.Neon)
    local exitSign2 = part("ExitSign", Vector3.new(6, 3, 1), BASE + Vector3.new(50, 15, 0), "Bright red", Enum.Material.Neon)
    
    -- ESCALERAS DE EMERGENCIA
    for i = 1, 15 do
        part("EmergencyStair", Vector3.new(10, 1, 4), BASE + Vector3.new(-50, 4 + (i * 2), -40 + (i * 2)), "Dark stone grey")
    end
    
    print("=== HAWKINS LABORATORY ===")
    print("Dimensiones: 120x40x100 studs")
    print("- Tanque sensorial con agua")
    print("- 2 laboratorios completos")
    print("- Sala de control con consolas")
    print("- 3 celdas de contención")
    print("- Generador principal")
    print("- Sistema de ventilación")
    print("==========================")
    
    return labModel
end

createHawkinsLab()
