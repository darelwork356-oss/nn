-- High School Simulator 2024
-- Servidor Principal

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local DataStoreService = game:GetService("DataStoreService")
local TweenService = game:GetService("TweenService")

-- DataStore
local PlayerDataStore = DataStoreService:GetDataStore("PlayerData")

-- Eventos Remotos
local RemoteEvents = Instance.new("Folder")
RemoteEvents.Name = "RemoteEvents"
RemoteEvents.Parent = ReplicatedStorage

local UpdatePlayerData = Instance.new("RemoteEvent")
UpdatePlayerData.Name = "UpdatePlayerData"
UpdatePlayerData.Parent = RemoteEvents

local ClassSystem = Instance.new("RemoteEvent")
ClassSystem.Name = "ClassSystem"
ClassSystem.Parent = RemoteEvents

local SocialSystem = Instance.new("RemoteEvent")
SocialSystem.Name = "SocialSystem"
SocialSystem.Parent = RemoteEvents

-- Configuración del Juego
local GameConfig = {
    Classes = {
        "Matemáticas", "Ciencias", "Historia", "Inglés", 
        "Educación Física", "Arte", "Música", "Informática"
    },
    ClassDuration = 300, -- 5 minutos
    BreakDuration = 120,  -- 2 minutos
    SchoolHours = {
        Start = 8,
        End = 15
    },
    Grades = {"A+", "A", "B+", "B", "C+", "C", "D", "F"},
    SocialStats = {
        "Popularidad", "Inteligencia", "Atletismo", "Creatividad"
    }
}

-- Datos por defecto del jugador
local DefaultPlayerData = {
    Level = 1,
    Experience = 0,
    Money = 100,
    Stats = {
        Popularidad = 50,
        Inteligencia = 50,
        Atletismo = 50,
        Creatividad = 50
    },
    Grades = {},
    Friends = {},
    Inventory = {},
    Customization = {
        Skin = "Default",
        Hair = "Default",
        Clothes = "Uniform"
    },
    CurrentClass = nil,
    Schedule = {}
}

-- Sistema de Datos del Jugador
local PlayerData = {}

local function LoadPlayerData(player)
    local success, data = pcall(function()
        return PlayerDataStore:GetAsync(player.UserId)
    end)
    
    if success and data then
        PlayerData[player.UserId] = data
    else
        PlayerData[player.UserId] = DefaultPlayerData
    end
    
    -- Crear leaderstats
    local leaderstats = Instance.new("Folder")
    leaderstats.Name = "leaderstats"
    leaderstats.Parent = player
    
    local level = Instance.new("IntValue")
    level.Name = "Nivel"
    level.Value = PlayerData[player.UserId].Level
    level.Parent = leaderstats
    
    local money = Instance.new("IntValue")
    money.Name = "Dinero"
    money.Value = PlayerData[player.UserId].Money
    money.Parent = leaderstats
end

local function SavePlayerData(player)
    if PlayerData[player.UserId] then
        pcall(function()
            PlayerDataStore:SetAsync(player.UserId, PlayerData[player.UserId])
        end)
    end
end

-- Sistema de Clases
local ClassManager = {}
ClassManager.ActiveClasses = {}
ClassManager.ClassRooms = {}

function ClassManager:StartClass(className, teacher, room)
    local classData = {
        Name = className,
        Teacher = teacher,
        Room = room,
        Students = {},
        StartTime = tick(),
        Duration = GameConfig.ClassDuration
    }
    
    self.ActiveClasses[className] = classData
    
    -- Notificar a todos los jugadores
    for _, player in pairs(Players:GetPlayers()) do
        ClassSystem:FireClient(player, "ClassStarted", classData)
    end
end

function ClassManager:JoinClass(player, className)
    if self.ActiveClasses[className] then
        table.insert(self.ActiveClasses[className].Students, player)
        PlayerData[player.UserId].CurrentClass = className
        
        ClassSystem:FireClient(player, "JoinedClass", className)
        return true
    end
    return false
end

function ClassManager:CompleteClass(player, className, performance)
    if PlayerData[player.UserId].CurrentClass == className then
        local grade = GameConfig.Grades[math.random(1, #GameConfig.Grades)]
        local exp = math.random(10, 50)
        
        -- Actualizar datos del jugador
        PlayerData[player.UserId].Experience = PlayerData[player.UserId].Experience + exp
        PlayerData[player.UserId].Grades[className] = grade
        PlayerData[player.UserId].CurrentClass = nil
        
        -- Actualizar stats basado en la clase
        if className == "Matemáticas" or className == "Ciencias" then
            PlayerData[player.UserId].Stats.Inteligencia = 
                math.min(100, PlayerData[player.UserId].Stats.Inteligencia + 2)
        elseif className == "Educación Física" then
            PlayerData[player.UserId].Stats.Atletismo = 
                math.min(100, PlayerData[player.UserId].Stats.Atletismo + 2)
        elseif className == "Arte" or className == "Música" then
            PlayerData[player.UserId].Stats.Creatividad = 
                math.min(100, PlayerData[player.UserId].Stats.Creatividad + 2)
        end
        
        ClassSystem:FireClient(player, "ClassCompleted", {
            Grade = grade,
            Experience = exp,
            Class = className
        })
    end
end

-- Sistema Social
local SocialManager = {}

function SocialManager:AddFriend(player1, player2)
    if PlayerData[player1.UserId] and PlayerData[player2.UserId] then
        table.insert(PlayerData[player1.UserId].Friends, player2.Name)
        table.insert(PlayerData[player2.UserId].Friends, player1.Name)
        
        -- Aumentar popularidad
        PlayerData[player1.UserId].Stats.Popularidad = 
            math.min(100, PlayerData[player1.UserId].Stats.Popularidad + 1)
        PlayerData[player2.UserId].Stats.Popularidad = 
            math.min(100, PlayerData[player2.UserId].Stats.Popularidad + 1)
        
        SocialSystem:FireClient(player1, "FriendAdded", player2.Name)
        SocialSystem:FireClient(player2, "FriendAdded", player1.Name)
    end
end

-- Eventos de Jugadores
Players.PlayerAdded:Connect(function(player)
    LoadPlayerData(player)
    
    -- Teletransportar al spawn después de cargar
    wait(1)
    if workspace:FindFirstChild("SpawnLocation") then
        player.Character.HumanoidRootPart.CFrame = workspace.SpawnLocation.CFrame + Vector3.new(0, 5, 0)
    end
end)

Players.PlayerRemoving:Connect(function(player)
    SavePlayerData(player)
    PlayerData[player.UserId] = nil
end)

-- Eventos Remotos
UpdatePlayerData.OnServerEvent:Connect(function(player, action, data)
    if action == "UpdateStats" and PlayerData[player.UserId] then
        for stat, value in pairs(data) do
            if PlayerData[player.UserId].Stats[stat] then
                PlayerData[player.UserId].Stats[stat] = math.min(100, math.max(0, value))
            end
        end
    elseif action == "BuyItem" and PlayerData[player.UserId] then
        if PlayerData[player.UserId].Money >= data.Price then
            PlayerData[player.UserId].Money = PlayerData[player.UserId].Money - data.Price
            table.insert(PlayerData[player.UserId].Inventory, data.Item)
            
            -- Actualizar leaderstats
            player.leaderstats.Dinero.Value = PlayerData[player.UserId].Money
        end
    end
end)

ClassSystem.OnServerEvent:Connect(function(player, action, data)
    if action == "JoinClass" then
        ClassManager:JoinClass(player, data)
    elseif action == "CompleteClass" then
        ClassManager:CompleteClass(player, data.Class, data.Performance)
    end
end)

SocialSystem.OnServerEvent:Connect(function(player, action, data)
    if action == "AddFriend" then
        local targetPlayer = Players:FindFirstChild(data)
        if targetPlayer then
            SocialManager:AddFriend(player, targetPlayer)
        end
    end
end)

-- Sistema de Horarios Automático
spawn(function()
    while true do
        wait(GameConfig.ClassDuration)
        
        -- Iniciar clases automáticamente
        for i, className in ipairs(GameConfig.Classes) do
            if math.random() > 0.5 then -- 50% de probabilidad
                ClassManager:StartClass(className, "Profesor " .. className, "Aula " .. i)
            end
        end
        
        wait(GameConfig.BreakDuration)
    end
end)

print("High School Simulator - Servidor iniciado correctamente")