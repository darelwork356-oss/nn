-- HAWKINS LABORATORY - COMPLETE WITH INTERACTIVE DOOR
-- Colocar en ServerScriptService

local TweenService = game:GetService("TweenService")

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
    
    -- EDIFICIO PRINCIPAL MÁS GRANDE (200x50x150 studs)
    local mainFloor = part("MainFloor", Vector3.new(200, 4, 150), BASE + Vector3.new(0, 2, 0), "Dark stone grey")
    
    -- Paredes exteriores
    local frontWall = part("FrontWall", Vector3.new(200, 50, 8), BASE + Vector3.new(0, 27, -71), "Medium stone grey")
    local backWall = part("BackWall", Vector3.new(200, 50, 8), BASE + Vector3.new(0, 27, 71), "Medium stone grey")
    local leftWall = part("LeftWall", Vector3.new(8, 50, 150), BASE + Vector3.new(-96, 27, 0), "Medium stone grey")
    local rightWall = part("RightWall", Vector3.new(8, 50, 150), BASE + Vector3.new(96, 27, 0), "Medium stone grey")
    
    -- Techo
    local roof = part("Roof", Vector3.new(200, 4, 150), BASE + Vector3.new(0, 52, 0), "Dark stone grey")
    
    -- ==================== PUERTA DE ENTRADA REALISTA ====================
    
    -- Marco de la puerta
    local doorFrame = part("DoorFrame", Vector3.new(20, 28, 4), BASE + Vector3.new(0, 16, -73), "Dark stone grey", Enum.Material.Metal)
    
    -- Puerta izquierda (se abre)
    local doorLeft = part("DoorLeft", Vector3.new(9, 24, 2), BASE + Vector3.new(-5, 14, -73), "Really black", Enum.Material.Metal)
    doorLeft.Anchored = false
    
    -- Puerta derecha (se abre)
    local doorRight = part("DoorRight", Vector3.new(9, 24, 2), BASE + Vector3.new(5, 14, -73), "Really black", Enum.Material.Metal)
    doorRight.Anchored = false
    
    -- Bisagras izquierda
    for i = 1, 3 do
        local hinge = part("HingeLeft" .. i, Vector3.new(1, 2, 1), BASE + Vector3.new(-9.5, 6 + (i * 6), -73), "Dark stone grey", Enum.Material.Metal)
    end
    
    -- Bisagras derecha
    for i = 1, 3 do
        local hinge = part("HingeRight" .. i, Vector3.new(1, 2, 1), BASE + Vector3.new(9.5, 6 + (i * 6), -73), "Dark stone grey", Enum.Material.Metal)
    end
    
    -- Ventanas en las puertas
    local windowLeft = part("WindowLeft", Vector3.new(6, 8, 1), BASE + Vector3.new(-5, 18, -73), "Light blue", Enum.Material.Glass)
    windowLeft.Transparency = 0.3
    windowLeft.Anchored = false
    
    local windowRight = part("WindowRight", Vector3.new(6, 8, 1), BASE + Vector3.new(5, 18, -73), "Light blue", Enum.Material.Glass)
    windowRight.Transparency = 0.3
    windowRight.Anchored = false
    
    -- Soldar ventanas a puertas
    local weldWinLeft = Instance.new("WeldConstraint")
    weldWinLeft.Part0 = doorLeft
    weldWinLeft.Part1 = windowLeft
    weldWinLeft.Parent = doorLeft
    
    local weldWinRight = Instance.new("WeldConstraint")
    weldWinRight.Part0 = doorRight
    weldWinRight.Part1 = windowRight
    weldWinRight.Parent = doorRight
    
    -- Panel de control de la puerta
    local controlPanel = part("ControlPanel", Vector3.new(3, 4, 1), BASE + Vector3.new(12, 14, -72), "Dark stone grey", Enum.Material.Metal)
    
    -- Pantalla del panel
    local panelScreen = part("PanelScreen", Vector3.new(2, 2, 0.2), BASE + Vector3.new(12, 15, -71.5), "Bright green", Enum.Material.Neon)
    
    -- Botones del panel
    for i = 1, 3 do
        local button = part("PanelButton" .. i, Vector3.new(0.5, 0.5, 0.3), BASE + Vector3.new(12, 13 - (i * 0.7), -71.5), "Bright red", Enum.Material.Neon)
        button.Shape = Enum.PartType.Cylinder
    end
    
    -- Luces de advertencia sobre la puerta
    for i = -1, 1 do
        local warningLight = part("WarningLight" .. i, Vector3.new(2, 2, 2), BASE + Vector3.new(i * 8, 28, -72), "Bright red", Enum.Material.Neon)
        warningLight.Shape = Enum.PartType.Ball
        
        spawn(function()
            while warningLight.Parent do
                wait(0.5)
                warningLight.Transparency = (warningLight.Transparency == 0) and 0.5 or 0
            end
        end)
    end
    
    -- Letrero HAWKINS NATIONAL LABORATORY
    local sign1 = part("SignTop", Vector3.new(60, 4, 2), BASE + Vector3.new(0, 32, -74), "Institutional white")
    local signText1 = part("SignText1", Vector3.new(58, 3, 1), BASE + Vector3.new(0, 32, -74.5), "Really black", Enum.Material.Neon)
    
    -- PROXIMIDAD PROMPT PARA ABRIR PUERTA
    local doorTrigger = part("DoorTrigger", Vector3.new(8, 8, 8), BASE + Vector3.new(0, 8, -68), "Bright green")
    doorTrigger.Transparency = 1
    doorTrigger.CanCollide = false
    
    local proximityPrompt = Instance.new("ProximityPrompt")
    proximityPrompt.ActionText = "Abrir Puerta"
    proximityPrompt.ObjectText = "Entrada del Laboratorio"
    proximityPrompt.HoldDuration = 1
    proximityPrompt.MaxActivationDistance = 10
    proximityPrompt.Parent = doorTrigger
    
    -- Variables de estado de la puerta
    local doorOpen = false
    local doorAnimating = false
    
    -- Función para abrir/cerrar puerta
    proximityPrompt.Triggered:Connect(function(player)
        if doorAnimating then return end
        doorAnimating = true
        
        if not doorOpen then
            -- ABRIR PUERTA
            proximityPrompt.ActionText = "Cerrando..."
            
            -- Sonido de apertura (opcional)
            local openSound = Instance.new("Sound")
            openSound.SoundId = "rbxasset://sounds/door_open.mp3"
            openSound.Volume = 0.5
            openSound.Parent = doorLeft
            openSound:Play()
            
            -- Animar puerta izquierda
            local tweenLeft = TweenService:Create(doorLeft, 
                TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {CFrame = doorLeft.CFrame * CFrame.Angles(0, math.rad(-90), 0) * CFrame.new(-4.5, 0, 0)}
            )
            
            -- Animar puerta derecha
            local tweenRight = TweenService:Create(doorRight,
                TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
                {CFrame = doorRight.CFrame * CFrame.Angles(0, math.rad(90), 0) * CFrame.new(4.5, 0, 0)}
            )
            
            tweenLeft:Play()
            tweenRight:Play()
            
            doorOpen = true
            
            tweenLeft.Completed:Wait()
            proximityPrompt.ActionText = "Cerrar Puerta"
            doorAnimating = false
            
        else
            -- CERRAR PUERTA
            proximityPrompt.ActionText = "Abriendo..."
            
            -- Resetear posiciones
            doorLeft.CFrame = CFrame.new(BASE + Vector3.new(-5, 14, -73))
            doorRight.CFrame = CFrame.new(BASE + Vector3.new(5, 14, -73))
            
            doorOpen = false
            proximityPrompt.ActionText = "Abrir Puerta"
            doorAnimating = false
        end
    end)
    
    -- ==================== RECEPCIÓN ====================
    local receptionFloor = part("ReceptionFloor", Vector3.new(40, 1, 30), BASE + Vector3.new(0, 4.5, -50), "Institutional white")
    
    -- Mostrador de recepción
    local desk = part("ReceptionDesk", Vector3.new(20, 5, 4), BASE + Vector3.new(0, 6.5, -45), "Dark stone grey")
    local deskTop = part("DeskTop", Vector3.new(20, 1, 4), BASE + Vector3.new(0, 9, -45), "Black")
    
    -- Computadora de recepción
    local computer = part("ReceptionComputer", Vector3.new(3, 2, 2), BASE + Vector3.new(0, 10, -45), "Black")
    local screen = part("ComputerScreen", Vector3.new(2.5, 1.5, 0.2), BASE + Vector3.new(0, 10.5, -46), "Bright blue", Enum.Material.Neon)
    
    -- ==================== PASILLO PRINCIPAL ====================
    local hallwayFloor = part("HallwayFloor", Vector3.new(20, 1, 120), BASE + Vector3.new(0, 4.5, 0), "Institutional white")
    
    -- Luces del pasillo
    for z = -50, 50, 15 do
        local light = part("HallLight", Vector3.new(6, 2, 6), BASE + Vector3.new(0, 50, z), "Bright yellow", Enum.Material.Neon)
        spawn(function()
            while light.Parent do
                wait(math.random(10, 20))
                light.Transparency = math.random(0, 20)/100
                wait(0.05)
            end
        end)
    end
    
    -- Líneas amarillas en el piso
    for z = -60, 60, 5 do
        part("FloorLine", Vector3.new(1, 0.2, 2), BASE + Vector3.new(-8, 4.6, z), "Bright yellow", Enum.Material.Neon)
        part("FloorLine", Vector3.new(1, 0.2, 2), BASE + Vector3.new(8, 4.6, z), "Bright yellow", Enum.Material.Neon)
    end
    
    -- ==================== SALA DEL TANQUE SENSORIAL ====================
    local tankRoomFloor = part("TankRoomFloor", Vector3.new(50, 1, 50), BASE + Vector3.new(0, 4.5, 40), "Black")
    
    -- Paredes de la sala - Negras
    part("TankWall1", Vector3.new(50, 20, 3), BASE + Vector3.new(0, 14, 15), "Black")
    part("TankWall2", Vector3.new(50, 20, 3), BASE + Vector3.new(0, 14, 65), "Black")
    part("TankWall3", Vector3.new(3, 20, 50), BASE + Vector3.new(-23, 14, 40), "Black")
    part("TankWall4", Vector3.new(3, 20, 50), BASE + Vector3.new(23, 14, 40), "Black")
    
    -- Puerta de la sala del tanque con ProximityPrompt
    local tankDoor = part("TankDoor", Vector3.new(12, 16, 2), BASE + Vector3.new(0, 12, 15), "Really black", Enum.Material.Metal)
    tankDoor.Anchored = false
    
    local tankPrompt = Instance.new("ProximityPrompt")
    tankPrompt.ActionText = "Abrir Sala del Tanque"
    tankPrompt.HoldDuration = 1
    tankPrompt.MaxActivationDistance = 8
    tankPrompt.Parent = tankDoor
    
    tankPrompt.Triggered:Connect(function()
        local tween = TweenService:Create(tankDoor,
            TweenInfo.new(1.5, Enum.EasingStyle.Quad),
            {CFrame = tankDoor.CFrame * CFrame.new(0, 16, 0)}
        )
        tween:Play()
        wait(5)
        tankDoor.CFrame = CFrame.new(BASE + Vector3.new(0, 12, 15))
    end)
    
    -- TANQUE SENSORIAL
    local tankBase = part("TankBase", Vector3.new(20, 3, 12), BASE + Vector3.new(0, 6.5, 40), "Dark stone grey", Enum.Material.Metal)
    
    local tankWalls = part("TankWalls", Vector3.new(20, 8, 12), BASE + Vector3.new(0, 11, 40), "Black", Enum.Material.Glass)
    tankWalls.Transparency = 0.2
    
    -- Agua del tanque
    local tankWater = part("TankWater", Vector3.new(19, 7, 11), BASE + Vector3.new(0, 11, 40), "Teal", Enum.Material.Glass)
    tankWater.Transparency = 0.4
    tankWater.CanCollide = false
    
    -- Escalera al tanque
    for i = 1, 6 do
        part("TankStep" .. i, Vector3.new(8, 1, 3), BASE + Vector3.new(-14, 5 + i, 40 - (i * 2)), "Dark stone grey")
    end
    
    -- Luces alrededor del tanque
    for i = 1, 8 do
        local angle = (i / 8) * math.pi * 2
        local x = math.cos(angle) * 15
        local z = math.sin(angle) * 10
        local tankLight = part("TankLight" .. i, Vector3.new(2, 2, 2), BASE + Vector3.new(x, 15, 40 + z), "Bright red", Enum.Material.Neon)
        tankLight.Shape = Enum.PartType.Ball
    end
    
    -- ==================== LABORATORIOS ====================
    -- Laboratorio Izquierdo
    local leftLabFloor = part("LeftLabFloor", Vector3.new(70, 1, 100), BASE + Vector3.new(-55, 4.5, 0), "Light stone grey")
    
    for z = -40, 40, 20 do
        for x = -80, -40, 15 do
            local table = part("LabTable", Vector3.new(10, 5, 5), BASE + Vector3.new(x, 7, z), "Light stone grey")
            local microscope = part("Microscope", Vector3.new(2, 4, 2), BASE + Vector3.new(x - 2, 10, z), "Dark stone grey")
            local computer = part("Computer", Vector3.new(4, 3, 3), BASE + Vector3.new(x + 2, 10, z), "Black")
            local screen = part("Screen", Vector3.new(3, 2, 0.3), BASE + Vector3.new(x + 2, 11, z - 1.5), "Bright green", Enum.Material.Neon)
        end
    end
    
    -- Laboratorio Derecho
    local rightLabFloor = part("RightLabFloor", Vector3.new(70, 1, 100), BASE + Vector3.new(55, 4.5, 0), "Light stone grey")
    
    for z = -40, 40, 20 do
        for x = 40, 80, 15 do
            local table = part("LabTable", Vector3.new(10, 5, 5), BASE + Vector3.new(x, 7, z), "Light stone grey")
            local microscope = part("Microscope", Vector3.new(2, 4, 2), BASE + Vector3.new(x - 2, 10, z), "Dark stone grey")
            local computer = part("Computer", Vector3.new(4, 3, 3), BASE + Vector3.new(x + 2, 10, z), "Black")
            local screen = part("Screen", Vector3.new(3, 2, 0.3), BASE + Vector3.new(x + 2, 11, z - 1.5), "Bright blue", Enum.Material.Neon)
        end
    end
    
    -- ==================== SALA DE CONTROL ====================
    local controlFloor = part("ControlFloor", Vector3.new(60, 1, 30), BASE + Vector3.new(0, 4.5, -30), "Really black")
    
    -- Ventana de observación
    local obsWindow = part("ObservationWindow", Vector3.new(30, 12, 2), BASE + Vector3.new(0, 16, 10), "Light blue", Enum.Material.Glass)
    obsWindow.Transparency = 0.3
    
    -- Consolas
    for x = -25, 25, 12 do
        local console = part("Console", Vector3.new(10, 6, 5), BASE + Vector3.new(x, 8, -30), "Dark stone grey")
        
        for i = 1, 4 do
            local screen = part("ControlScreen", Vector3.new(2, 2, 0.2), BASE + Vector3.new(x - 4 + (i * 2), 10, -32.5), "Bright blue", Enum.Material.Neon)
        end
    end
    
    -- ==================== GENERADOR ====================
    local generator = part("Generator", Vector3.new(15, 25, 15), BASE + Vector3.new(-70, 16.5, 50), "Really black", Enum.Material.Metal)
    
    for y = 10, 25, 5 do
        for i = 1, 6 do
            local light = part("GenLight", Vector3.new(1.5, 1.5, 1.5), BASE + Vector3.new(-70 + (i-3.5)*2, y, 50), "Bright red", Enum.Material.Neon)
            light.Shape = Enum.PartType.Ball
            spawn(function()
                while light.Parent do
                    wait(0.2)
                    light.Transparency = (light.Transparency == 0) and 0.7 or 0
                end
            end)
        end
    end
    
    print("=== HAWKINS LABORATORY COMPLETO ===")
    print("Dimensiones: 200x50x150 studs")
    print("- Puerta interactiva con ProximityPrompt")
    print("- Animación de apertura de puertas")
    print("- Tanque sensorial con sala dedicada")
    print("- Laboratorios completos")
    print("- Sala de control")
    print("- Generador con luces")
    print("===================================")
    
    return labModel
end

createHawkinsLab()
