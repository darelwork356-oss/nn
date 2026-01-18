-- High School Simulator 2024 - Script Completo del Servidor
-- Coloca este script en ServerScriptService

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService("DataStoreService")
local Lighting = game:GetService("Lighting")

-- ============================================
-- CONFIGURACIÓN DEL JUEGO
-- ============================================

local Config = {
    Classes = {"Matemáticas", "Ciencias", "Historia", "Inglés", "Ed. Física", "Arte", "Música", "Informática"},
    ClassDuration = 180,
    BreakDuration = 60,
    StartingMoney = 100
}

-- ============================================
-- CONSTRUCCIÓN DEL MAPA
-- ============================================

local function BuildMap()
    workspace:ClearAllChildren()
    
    -- Spawn
    local spawn = Instance.new("SpawnLocation")
    spawn.Size = Vector3.new(10, 1, 10)
    spawn.Position = Vector3.new(0, 0.5, 0)
    spawn.BrickColor = BrickColor.new("Bright green")
    spawn.Anchored = true
    spawn.Parent = workspace
    
    -- Crear aulas
    for i, className in ipairs(Config.Classes) do
        local angle = (i - 1) * (360 / #Config.Classes)
        local rad = math.rad(angle)
        local distance = 60
        local x = math.cos(rad) * distance
        local z = math.sin(rad) * distance
        
        -- Suelo del aula
        local floor = Instance.new("Part")
        floor.Name = "Floor_" .. className
        floor.Size = Vector3.new(25, 1, 20)
        floor.Position = Vector3.new(x, 0.5, z)
        floor.BrickColor = BrickColor.new("Dark stone grey")
        floor.Anchored = true
        floor.Parent = workspace
        
        -- Paredes
        for j = 1, 4 do
            local wall = Instance.new("Part")
            wall.Size = j % 2 == 0 and Vector3.new(25, 10, 1) or Vector3.new(1, 10, 20)
            wall.Position = floor.Position + (j == 1 and Vector3.new(0, 5, 10) or j == 2 and Vector3.new(12.5, 5, 0) or j == 3 and Vector3.new(0, 5, -10) or Vector3.new(-12.5, 5, 0))
            wall.BrickColor = BrickColor.new("Light stone grey")
            wall.Anchored = true
            wall.Parent = workspace
        end
        
        -- Puerta
        local door = Instance.new("Part")
        door.Name = "Door_" .. className
        door.Size = Vector3.new(5, 8, 0.5)
        door.Position = Vector3.new(x, 4, z + 10)
        door.BrickColor = BrickColor.new("Brown")
        door.Anchored = true
        door.Parent = workspace
        
        local click = Instance.new("ClickDetector")
        click.MaxActivationDistance = 15
        click.Parent = door
        
        -- Letrero
        local sign = Instance.new("SurfaceGui")
        sign.Face = Enum.NormalId.Front
        sign.Parent = door
        
        local text = Instance.new("TextLabel")
        text.Size = UDim2.new(1, 0, 1, 0)
        text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        text.Text = className
        text.TextScaled = true
        text.Font = Enum.Font.GothamBold
        text.Parent = sign
        
        -- Escritorio profesor
        local desk = Instance.new("Part")
        desk.Size = Vector3.new(6, 3, 3)
        desk.Position = Vector3.new(x, 1.5, z - 7)
        desk.BrickColor = BrickColor.new("Brown")
        desk.Anchored = true
        desk.Parent = workspace
        
        -- Pupitres estudiantes
        for row = 1, 3 do
            for col = 1, 4 do
                local studentDesk = Instance.new("Part")
                studentDesk.Size = Vector3.new(2, 2, 1.5)
                studentDesk.Position = Vector3.new(x - 8 + col * 4, 1, z - 3 + row * 3)
                studentDesk.BrickColor = BrickColor.new("Medium brown")
                studentDesk.Anchored = true
                studentDesk.Parent = workspace
            end
        end
    end
    
    -- Cafetería
    local cafeteria = Instance.new("Part")
    cafeteria.Name = "Cafeteria"
    cafeteria.Size = Vector3.new(40, 1, 30)
    cafeteria.Position = Vector3.new(-80, 0.5, 0)
    cafeteria.BrickColor = BrickColor.new("Tan")
    cafeteria.Anchored = true
    cafeteria.Parent = workspace
    
    -- Mesas cafetería
    for i = 1, 6 do
        for j = 1, 3 do
            local table = Instance.new("Part")
            table.Size = Vector3.new(4, 3, 6)
            table.Position = Vector3.new(-95 + i * 6, 1.5, -10 + j * 8)
            table.BrickColor = BrickColor.new("Brown")
            table.Anchored = true
            table.Parent = workspace
        end
    end
    
    -- Gimnasio
    local gym = Instance.new("Part")
    gym.Name = "Gymnasium"
    gym.Size = Vector3.new(50, 1, 35)
    gym.Position = Vector3.new(80, 0.5, 0)
    gym.BrickColor = BrickColor.new("Bright orange")
    gym.Material = Enum.Material.Wood
    gym.Anchored = true
    gym.Parent = workspace
    
    -- Canastas
    for i = 1, 2 do
        local basket = Instance.new("Part")
        basket.Size = Vector3.new(1, 6, 1)
        basket.Position = Vector3.new(80 + (i == 1 and -20 or 20), 8, 0)
        basket.BrickColor = BrickColor.new("Really red")
        basket.Anchored = true
        basket.Parent = workspace
    end
    
    -- Iluminación
    Lighting.Brightness = 2
    Lighting.Ambient = Color3.fromRGB(100, 100, 100)
    
    print("✅ Mapa construido: " .. #Config.Classes .. " aulas, cafetería y gimnasio")
end

-- ============================================
-- SISTEMA DE DATOS
-- ============================================

local PlayerDataStore = DataStoreService:GetDataStore("HighSchoolData")
local PlayerData = {}

local function GetDefaultData()
    return {
        Level = 1,
        Money = Config.StartingMoney,
        Experience = 0,
        Stats = {Popularidad = 50, Inteligencia = 50, Atletismo = 50, Creatividad = 50},
        Grades = {},
        Friends = {},
        CurrentClass = nil
    }
end

local function LoadData(player)
    local success, data = pcall(function()
        return PlayerDataStore:GetAsync(player.UserId)
    end)
    
    PlayerData[player.UserId] = success and data or GetDefaultData()
    
    -- Leaderstats
    local stats = Instance.new("Folder")
    stats.Name = "leaderstats"
    stats.Parent = player
    
    local level = Instance.new("IntValue")
    level.Name = "Nivel"
    level.Value = PlayerData[player.UserId].Level
    level.Parent = stats
    
    local money = Instance.new("IntValue")
    money.Name = "Dinero"
    money.Value = PlayerData[player.UserId].Money
    money.Parent = stats
end

local function SaveData(player)
    if PlayerData[player.UserId] then
        pcall(function()
            PlayerDataStore:SetAsync(player.UserId, PlayerData[player.UserId])
        end)
    end
end

-- ============================================
-- SISTEMA DE CLASES
-- ============================================

local ActiveClasses = {}

local function StartClass(className)
    ActiveClasses[className] = {
        Name = className,
        Students = {},
        StartTime = tick()
    }
    
    for _, player in pairs(Players:GetPlayers()) do
        local gui = player:FindFirstChild("PlayerGui")
        if gui then
            local event = ReplicatedStorage:FindFirstChild("ClassNotify")
            if event then
                event:FireClient(player, "Clase de " .. className .. " disponible!")
            end
        end
    end
end

local function JoinClass(player, className)
    if not ActiveClasses[className] then
        StartClass(className)
    end
    
    table.insert(ActiveClasses[className].Students, player)
    PlayerData[player.UserId].CurrentClass = className
    
    -- Teletransportar al aula
    local door = workspace:FindFirstChild("Door_" .. className)
    if door and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = door.CFrame + Vector3.new(0, 0, -5)
    end
    
    -- Completar clase después de duración
    task.wait(Config.ClassDuration)
    
    if PlayerData[player.UserId] and PlayerData[player.UserId].CurrentClass == className then
        local exp = math.random(20, 50)
        local moneyEarned = math.random(10, 30)
        
        PlayerData[player.UserId].Experience = PlayerData[player.UserId].Experience + exp
        PlayerData[player.UserId].Money = PlayerData[player.UserId].Money + moneyEarned
        PlayerData[player.UserId].CurrentClass = nil
        
        -- Actualizar stats
        if className == "Matemáticas" or className == "Ciencias" then
            PlayerData[player.UserId].Stats.Inteligencia = math.min(100, PlayerData[player.UserId].Stats.Inteligencia + 3)
        elseif className == "Ed. Física" then
            PlayerData[player.UserId].Stats.Atletismo = math.min(100, PlayerData[player.UserId].Stats.Atletismo + 3)
        elseif className == "Arte" or className == "Música" then
            PlayerData[player.UserId].Stats.Creatividad = math.min(100, PlayerData[player.UserId].Stats.Creatividad + 3)
        end
        
        -- Actualizar leaderstats
        if player:FindFirstChild("leaderstats") then
            player.leaderstats.Dinero.Value = PlayerData[player.UserId].Money
        end
        
        -- Notificar
        local event = ReplicatedStorage:FindFirstChild("ClassNotify")
        if event then
            event:FireClient(player, "¡Clase completada! +" .. exp .. " XP, +$" .. moneyEarned)
        end
    end
end

-- ============================================
-- EVENTOS REMOTOS
-- ============================================

local function SetupRemotes()
    local classNotify = Instance.new("RemoteEvent")
    classNotify.Name = "ClassNotify"
    classNotify.Parent = ReplicatedStorage
    
    local joinClass = Instance.new("RemoteEvent")
    joinClass.Name = "JoinClass"
    joinClass.Parent = ReplicatedStorage
    
    local updateStats = Instance.new("RemoteEvent")
    updateStats.Name = "UpdateStats"
    updateStats.Parent = ReplicatedStorage
    
    joinClass.OnServerEvent:Connect(function(player, className)
        if table.find(Config.Classes, className) then
            task.spawn(function()
                JoinClass(player, className)
            end)
        end
    end)
    
    updateStats.OnServerEvent:Connect(function(player)
        if PlayerData[player.UserId] then
            updateStats:FireClient(player, PlayerData[player.UserId])
        end
    end)
end

-- ============================================
-- GUI DEL CLIENTE
-- ============================================

local function CreateGUI(player)
    local gui = Instance.new("ScreenGui")
    gui.Name = "HighSchoolGUI"
    gui.ResetOnSpawn = false
    gui.Parent = player:WaitForChild("PlayerGui")
    
    -- Frame principal
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 350, 0, 450)
    frame.Position = UDim2.new(0, 10, 0.5, -225)
    frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    frame.BorderSizePixel = 0
    frame.Parent = gui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 12)
    corner.Parent = frame
    
    -- Título
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 45)
    title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    title.Text = "🏫 High School"
    title.TextColor3 = Color3.white
    title.TextSize = 20
    title.Font = Enum.Font.GothamBold
    title.Parent = frame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 12)
    titleCorner.Parent = title
    
    -- Scroll de clases
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -20, 1, -120)
    scroll.Position = UDim2.new(0, 10, 0, 55)
    scroll.BackgroundTransparency = 1
    scroll.ScrollBarThickness = 6
    scroll.Parent = frame
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.Parent = scroll
    
    -- Botones de clases
    for _, className in ipairs(Config.Classes) do
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(1, 0, 0, 45)
        btn.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
        btn.Text = "📚 " .. className
        btn.TextColor3 = Color3.white
        btn.TextSize = 16
        btn.Font = Enum.Font.Gotham
        btn.Parent = scroll
        
        local btnCorner = Instance.new("UICorner")
        btnCorner.CornerRadius = UDim.new(0, 8)
        btnCorner.Parent = btn
        
        btn.MouseButton1Click:Connect(function()
            ReplicatedStorage.JoinClass:FireServer(className)
        end)
    end
    
    -- Stats
    local statsFrame = Instance.new("Frame")
    statsFrame.Size = UDim2.new(1, -20, 0, 60)
    statsFrame.Position = UDim2.new(0, 10, 1, -70)
    statsFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    statsFrame.Parent = frame
    
    local statsCorner = Instance.new("UICorner")
    statsCorner.CornerRadius = UDim.new(0, 8)
    statsCorner.Parent = statsFrame
    
    local statsText = Instance.new("TextLabel")
    statsText.Size = UDim2.new(1, -10, 1, -10)
    statsText.Position = UDim2.new(0, 5, 0, 5)
    statsText.BackgroundTransparency = 1
    statsText.Text = "📊 Stats\nInteligencia: 50 | Atletismo: 50\nPopularidad: 50 | Creatividad: 50"
    statsText.TextColor3 = Color3.white
    statsText.TextSize = 12
    statsText.Font = Enum.Font.Gotham
    statsText.TextWrapped = true
    statsText.Parent = statsFrame
    
    -- Actualizar stats
    task.spawn(function()
        while task.wait(2) do
            if PlayerData[player.UserId] then
                local s = PlayerData[player.UserId].Stats
                statsText.Text = string.format("📊 Stats\nInteligencia: %d | Atletismo: %d\nPopularidad: %d | Creatividad: %d", 
                    s.Inteligencia, s.Atletismo, s.Popularidad, s.Creatividad)
            end
        end
    end)
    
    scroll.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
    
    -- Notificaciones
    ReplicatedStorage.ClassNotify.OnClientEvent:Connect(function(message)
        local notif = Instance.new("Frame")
        notif.Size = UDim2.new(0, 300, 0, 60)
        notif.Position = UDim2.new(0.5, -150, 0, -70)
        notif.BackgroundColor3 = Color3.fromRGB(70, 180, 70)
        notif.Parent = gui
        
        local notifCorner = Instance.new("UICorner")
        notifCorner.CornerRadius = UDim.new(0, 10)
        notifCorner.Parent = notif
        
        local notifText = Instance.new("TextLabel")
        notifText.Size = UDim2.new(1, -10, 1, -10)
        notifText.Position = UDim2.new(0, 5, 0, 5)
        notifText.BackgroundTransparency = 1
        notifText.Text = message
        notifText.TextColor3 = Color3.white
        notifText.TextSize = 14
        notifText.Font = Enum.Font.GothamBold
        notifText.TextWrapped = true
        notifText.Parent = notif
        
        notif:TweenPosition(UDim2.new(0.5, -150, 0, 20), "Out", "Quad", 0.5, true)
        task.wait(3)
        notif:TweenPosition(UDim2.new(0.5, -150, 0, -70), "In", "Quad", 0.5, true)
        task.wait(0.5)
        notif:Destroy()
    end)
end

-- ============================================
-- EVENTOS DE JUGADORES
-- ============================================

Players.PlayerAdded:Connect(function(player)
    LoadData(player)
    
    player.CharacterAdded:Connect(function(character)
        task.wait(1)
        CreateGUI(player)
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    SaveData(player)
    PlayerData[player.UserId] = nil
end)

-- Conectar puertas
workspace.ChildAdded:Connect(function(child)
    if child.Name:match("^Door_") then
        local click = child:FindFirstChildOfClass("ClickDetector")
        if click then
            click.MouseClick:Connect(function(player)
                local className = child.Name:gsub("Door_", "")
                if table.find(Config.Classes, className) then
                    task.spawn(function()
                        JoinClass(player, className)
                    end)
                end
            end)
        end
    end
end)

-- ============================================
-- INICIALIZACIÓN
-- ============================================

BuildMap()
SetupRemotes()

-- Sistema automático de clases
task.spawn(function()
    while task.wait(Config.ClassDuration + Config.BreakDuration) do
        local randomClass = Config.Classes[math.random(1, #Config.Classes)]
        StartClass(randomClass)
    end
end)

print("✅ High School Simulator 2024 - Servidor iniciado correctamente")
print("📚 Clases disponibles: " .. table.concat(Config.Classes, ", "))
