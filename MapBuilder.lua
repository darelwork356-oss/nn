-- High School Simulator 2024
-- Constructor de Mapa Escolar

local workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Limpiar workspace existente
for _, obj in pairs(workspace:GetChildren()) do
    if obj.Name ~= "Camera" and obj.Name ~= "Terrain" then
        obj:Destroy()
    end
end

-- Configuración del mapa
local MapConfig = {
    SchoolSize = Vector3.new(200, 50, 200),
    ClassroomSize = Vector3.new(30, 15, 25),
    HallwayWidth = 10,
    Colors = {
        Walls = Color3.fromRGB(180, 180, 180),
        Floor = Color3.fromRGB(120, 120, 120),
        Ceiling = Color3.fromRGB(200, 200, 200),
        Doors = Color3.fromRGB(139, 69, 19),
        Windows = Color3.fromRGB(173, 216, 230)
    }
}

-- Función para crear partes básicas
local function CreatePart(name, size, position, color, material, parent)
    local part = Instance.new("Part")
    part.Name = name
    part.Size = size
    part.Position = position
    part.Color = color
    part.Material = material or Enum.Material.Plastic
    part.Anchored = true
    part.Parent = parent or workspace
    return part
end

-- Función para crear aula
local function CreateClassroom(name, position, subject)
    local classroom = Instance.new("Model")
    classroom.Name = name
    classroom.Parent = workspace
    
    local size = MapConfig.ClassroomSize
    
    -- Suelo
    local floor = CreatePart("Floor", size, position, MapConfig.Colors.Floor, Enum.Material.Concrete, classroom)
    
    -- Paredes
    local wallThickness = 1
    
    -- Pared frontal
    local frontWall = CreatePart("FrontWall", 
        Vector3.new(size.X, size.Y, wallThickness), 
        position + Vector3.new(0, size.Y/2, size.Z/2), 
        MapConfig.Colors.Walls, Enum.Material.Brick, classroom)
    
    -- Pared trasera
    local backWall = CreatePart("BackWall", 
        Vector3.new(size.X, size.Y, wallThickness), 
        position + Vector3.new(0, size.Y/2, -size.Z/2), 
        MapConfig.Colors.Walls, Enum.Material.Brick, classroom)
    
    -- Pared izquierda
    local leftWall = CreatePart("LeftWall", 
        Vector3.new(wallThickness, size.Y, size.Z), 
        position + Vector3.new(-size.X/2, size.Y/2, 0), 
        MapConfig.Colors.Walls, Enum.Material.Brick, classroom)
    
    -- Pared derecha
    local rightWall = CreatePart("RightWall", 
        Vector3.new(wallThickness, size.Y, size.Z), 
        position + Vector3.new(size.X/2, size.Y/2, 0), 
        MapConfig.Colors.Walls, Enum.Material.Brick, classroom)
    
    -- Techo
    local ceiling = CreatePart("Ceiling", 
        size, 
        position + Vector3.new(0, size.Y, 0), 
        MapConfig.Colors.Ceiling, Enum.Material.Plastic, classroom)
    
    -- Puerta
    local doorSize = Vector3.new(6, 12, wallThickness + 0.5)
    local door = CreatePart("Door", doorSize, 
        position + Vector3.new(size.X/2 - 3, doorSize.Y/2, size.Z/2), 
        MapConfig.Colors.Doors, Enum.Material.Wood, classroom)
    
    -- Hacer la puerta clickeable
    local clickDetector = Instance.new("ClickDetector")
    clickDetector.MaxActivationDistance = 10
    clickDetector.Parent = door
    
    -- Ventanas
    for i = 1, 3 do
        local window = CreatePart("Window" .. i, 
            Vector3.new(8, 6, wallThickness + 0.2), 
            position + Vector3.new(-size.X/2 + (i * 8), size.Y/2 + 2, 0), 
            MapConfig.Colors.Windows, Enum.Material.Glass, classroom)
        window.Transparency = 0.5
    end
    
    -- Escritorio del profesor
    local teacherDesk = CreatePart("TeacherDesk", 
        Vector3.new(8, 4, 4), 
        position + Vector3.new(0, 2, size.Z/2 - 5), 
        Color3.fromRGB(139, 69, 19), Enum.Material.Wood, classroom)
    
    -- Pizarra
    local blackboard = CreatePart("Blackboard", 
        Vector3.new(15, 8, 0.5), 
        position + Vector3.new(0, 8, size.Z/2 - 1), 
        Color3.fromRGB(20, 20, 20), Enum.Material.Plastic, classroom)
    
    -- Pupitres de estudiantes
    for row = 1, 4 do
        for col = 1, 5 do
            local deskPos = position + Vector3.new(
                -size.X/2 + 5 + (col * 5), 
                2, 
                -size.Z/2 + 5 + (row * 5)
            )
            
            local studentDesk = CreatePart("StudentDesk" .. row .. "_" .. col, 
                Vector3.new(3, 4, 2), deskPos, 
                Color3.fromRGB(160, 82, 45), Enum.Material.Wood, classroom)
            
            local chair = CreatePart("Chair" .. row .. "_" .. col, 
                Vector3.new(2, 6, 2), deskPos + Vector3.new(0, 1, -2), 
                Color3.fromRGB(100, 100, 100), Enum.Material.Plastic, classroom)
        end
    end
    
    -- Letrero de la materia
    local sign = Instance.new("SurfaceGui")
    sign.Face = Enum.NormalId.Front
    sign.Parent = door
    
    local signText = Instance.new("TextLabel")
    signText.Size = UDim2.new(1, 0, 1, 0)
    signText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    signText.Text = subject
    signText.TextColor3 = Color3.fromRGB(0, 0, 0)
    signText.TextScaled = true
    signText.Font = Enum.Font.GothamBold
    signText.Parent = sign
    
    return classroom
end

-- Función para crear pasillo
local function CreateHallway(startPos, endPos, width)
    local hallway = Instance.new("Model")
    hallway.Name = "Hallway"
    hallway.Parent = workspace
    
    local length = (endPos - startPos).Magnitude
    local direction = (endPos - startPos).Unit
    local center = (startPos + endPos) / 2
    
    -- Suelo del pasillo
    local floor = CreatePart("HallwayFloor", 
        Vector3.new(length, 1, width), 
        center, 
        MapConfig.Colors.Floor, Enum.Material.Concrete, hallway)
    
    -- Techo del pasillo
    local ceiling = CreatePart("HallwayCeiling", 
        Vector3.new(length, 1, width), 
        center + Vector3.new(0, 15, 0), 
        MapConfig.Colors.Ceiling, Enum.Material.Plastic, hallway)
    
    return hallway
end

-- Función para crear cafetería
local function CreateCafeteria(position)
    local cafeteria = Instance.new("Model")
    cafeteria.Name = "Cafeteria"
    cafeteria.Parent = workspace
    
    local size = Vector3.new(50, 15, 40)
    
    -- Estructura básica
    local floor = CreatePart("Floor", size, position, MapConfig.Colors.Floor, Enum.Material.Concrete, cafeteria)
    local ceiling = CreatePart("Ceiling", size, position + Vector3.new(0, size.Y, 0), MapConfig.Colors.Ceiling, Enum.Material.Plastic, cafeteria)
    
    -- Paredes
    CreatePart("FrontWall", Vector3.new(size.X, size.Y, 1), position + Vector3.new(0, size.Y/2, size.Z/2), MapConfig.Colors.Walls, Enum.Material.Brick, cafeteria)
    CreatePart("BackWall", Vector3.new(size.X, size.Y, 1), position + Vector3.new(0, size.Y/2, -size.Z/2), MapConfig.Colors.Walls, Enum.Material.Brick, cafeteria)
    CreatePart("LeftWall", Vector3.new(1, size.Y, size.Z), position + Vector3.new(-size.X/2, size.Y/2, 0), MapConfig.Colors.Walls, Enum.Material.Brick, cafeteria)
    CreatePart("RightWall", Vector3.new(1, size.Y, size.Z), position + Vector3.new(size.X/2, size.Y/2, 0), MapConfig.Colors.Walls, Enum.Material.Brick, cafeteria)
    
    -- Mesas de cafetería
    for i = 1, 8 do
        for j = 1, 4 do
            local tablePos = position + Vector3.new(-size.X/2 + 5 + (i * 5), 2, -size.Z/2 + 5 + (j * 8))
            local table = CreatePart("Table" .. i .. "_" .. j, Vector3.new(4, 4, 6), tablePos, Color3.fromRGB(139, 69, 19), Enum.Material.Wood, cafeteria)
            
            -- Sillas alrededor de la mesa
            for k = 1, 4 do
                local chairOffset = {Vector3.new(3, 1, 0), Vector3.new(-3, 1, 0), Vector3.new(0, 1, 4), Vector3.new(0, 1, -4)}
                local chair = CreatePart("Chair" .. i .. "_" .. j .. "_" .. k, Vector3.new(2, 6, 2), tablePos + chairOffset[k], Color3.fromRGB(100, 100, 100), Enum.Material.Plastic, cafeteria)
            end
        end
    end
    
    -- Contador de comida
    local counter = CreatePart("FoodCounter", Vector3.new(20, 6, 4), position + Vector3.new(0, 3, size.Z/2 - 5), Color3.fromRGB(200, 200, 200), Enum.Material.Marble, cafeteria)
    
    return cafeteria
end

-- Función para crear gimnasio
local function CreateGym(position)
    local gym = Instance.new("Model")
    gym.Name = "Gymnasium"
    gym.Parent = workspace
    
    local size = Vector3.new(60, 20, 40)
    
    -- Estructura básica
    local floor = CreatePart("GymFloor", size, position, Color3.fromRGB(139, 69, 19), Enum.Material.Wood, gym)
    local ceiling = CreatePart("GymCeiling", size, position + Vector3.new(0, size.Y, 0), MapConfig.Colors.Ceiling, Enum.Material.Plastic, gym)
    
    -- Paredes
    CreatePart("FrontWall", Vector3.new(size.X, size.Y, 1), position + Vector3.new(0, size.Y/2, size.Z/2), MapConfig.Colors.Walls, Enum.Material.Brick, gym)
    CreatePart("BackWall", Vector3.new(size.X, size.Y, 1), position + Vector3.new(0, size.Y/2, -size.Z/2), MapConfig.Colors.Walls, Enum.Material.Brick, gym)
    CreatePart("LeftWall", Vector3.new(1, size.Y, size.Z), position + Vector3.new(-size.X/2, size.Y/2, 0), MapConfig.Colors.Walls, Enum.Material.Brick, gym)
    CreatePart("RightWall", Vector3.new(1, size.Y, size.Z), position + Vector3.new(size.X/2, size.Y/2, 0), MapConfig.Colors.Walls, Enum.Material.Brick, gym)
    
    -- Canastas de baloncesto
    for i = 1, 2 do
        local basketPos = position + Vector3.new((-1)^i * (size.X/2 - 2), 12, 0)
        local basket = CreatePart("Basket" .. i, Vector3.new(2, 8, 2), basketPos, Color3.fromRGB(255, 165, 0), Enum.Material.Metal, gym)
        
        local backboard = CreatePart("Backboard" .. i, Vector3.new(0.5, 6, 8), basketPos + Vector3.new((-1)^i * 1, 0, 0), Color3.fromRGB(255, 255, 255), Enum.Material.Plastic, gym)
    end
    
    -- Líneas de la cancha
    local centerLine = CreatePart("CenterLine", Vector3.new(1, 0.1, size.Z - 10), position + Vector3.new(0, size.Y/2 + 0.1, 0), Color3.fromRGB(255, 255, 255), Enum.Material.Neon, gym)
    
    return gym
end

-- Función para crear biblioteca
local function CreateLibrary(position)
    local library = Instance.new("Model")
    library.Name = "Library"
    library.Parent = workspace
    
    local size = Vector3.new(40, 15, 30)
    
    -- Estructura básica
    local floor = CreatePart("LibraryFloor", size, position, MapConfig.Colors.Floor, Enum.Material.Concrete, library)
    local ceiling = CreatePart("LibraryCeiling", size, position + Vector3.new(0, size.Y, 0), MapConfig.Colors.Ceiling, Enum.Material.Plastic, library)
    
    -- Paredes
    CreatePart("FrontWall", Vector3.new(size.X, size.Y, 1), position + Vector3.new(0, size.Y/2, size.Z/2), MapConfig.Colors.Walls, Enum.Material.Brick, library)
    CreatePart("BackWall", Vector3.new(size.X, size.Y, 1), position + Vector3.new(0, size.Y/2, -size.Z/2), MapConfig.Colors.Walls, Enum.Material.Brick, library)
    CreatePart("LeftWall", Vector3.new(1, size.Y, size.Z), position + Vector3.new(-size.X/2, size.Y/2, 0), MapConfig.Colors.Walls, Enum.Material.Brick, library)
    CreatePart("RightWall", Vector3.new(1, size.Y, size.Z), position + Vector3.new(size.X/2, size.Y/2, 0), MapConfig.Colors.Walls, Enum.Material.Brick, library)
    
    -- Estanterías
    for i = 1, 6 do
        for j = 1, 3 do
            local shelfPos = position + Vector3.new(-size.X/2 + 5 + (i * 6), 4, -size.Z/2 + 5 + (j * 8))
            local shelf = CreatePart("Bookshelf" .. i .. "_" .. j, Vector3.new(5, 8, 2), shelfPos, Color3.fromRGB(139, 69, 19), Enum.Material.Wood, library)
        end
    end
    
    -- Mesas de estudio
    for i = 1, 4 do
        local tablePos = position + Vector3.new(-10 + (i * 7), 2, size.Z/2 - 8)
        local studyTable = CreatePart("StudyTable" .. i, Vector3.new(6, 4, 3), tablePos, Color3.fromRGB(160, 82, 45), Enum.Material.Wood, library)
        
        -- Sillas
        for k = 1, 2 do
            local chair = CreatePart("LibraryChair" .. i .. "_" .. k, Vector3.new(2, 6, 2), tablePos + Vector3.new(0, 1, (-1)^k * 3), Color3.fromRGB(100, 100, 100), Enum.Material.Plastic, library)
        end
    end
    
    return library
end

-- Crear el edificio principal de la escuela
print("Construyendo High School Simulator...")

-- Crear spawn point
local spawnLocation = Instance.new("SpawnLocation")
spawnLocation.Size = Vector3.new(10, 1, 10)
spawnLocation.Position = Vector3.new(0, 1, 0)
spawnLocation.BrickColor = BrickColor.new("Bright green")
spawnLocation.Material = Enum.Material.Grass
spawnLocation.Parent = workspace

-- Crear aulas
local classrooms = {
    {name = "Aula_Matematicas", pos = Vector3.new(-60, 7.5, 40), subject = "📊 Matemáticas"},
    {name = "Aula_Ciencias", pos = Vector3.new(-60, 7.5, 0), subject = "🔬 Ciencias"},
    {name = "Aula_Historia", pos = Vector3.new(-60, 7.5, -40), subject = "📜 Historia"},
    {name = "Aula_Ingles", pos = Vector3.new(60, 7.5, 40), subject = "📝 Inglés"},
    {name = "Aula_Arte", pos = Vector3.new(60, 7.5, 0), subject = "🎨 Arte"},
    {name = "Aula_Musica", pos = Vector3.new(60, 7.5, -40), subject = "🎵 Música"},
    {name = "Aula_Informatica", pos = Vector3.new(0, 7.5, 60), subject = "💻 Informática"},
    {name = "Aula_EdFisica", pos = Vector3.new(0, 7.5, -80), subject = "🏃 Ed. Física"}
}

for _, classroom in ipairs(classrooms) do
    CreateClassroom(classroom.name, classroom.pos, classroom.subject)
end

-- Crear pasillos principales
CreateHallway(Vector3.new(-80, 0.5, 0), Vector3.new(80, 0.5, 0), 15)
CreateHallway(Vector3.new(0, 0.5, -60), Vector3.new(0, 0.5, 80), 15)

-- Crear áreas especiales
CreateCafeteria(Vector3.new(-100, 7.5, 0))
CreateGym(Vector3.new(100, 10, 0))
CreateLibrary(Vector3.new(0, 7.5, -120))

-- Crear patio exterior
local courtyard = CreatePart("Courtyard", Vector3.new(80, 1, 80), Vector3.new(0, 0.5, 120), Color3.fromRGB(34, 139, 34), Enum.Material.Grass)

-- Añadir algunos árboles decorativos
for i = 1, 10 do
    local treePos = Vector3.new(
        math.random(-35, 35), 
        5, 
        math.random(85, 155)
    )
    local tree = CreatePart("Tree" .. i, Vector3.new(3, 10, 3), treePos, Color3.fromRGB(139, 69, 19), Enum.Material.Wood)
    local leaves = CreatePart("Leaves" .. i, Vector3.new(8, 8, 8), treePos + Vector3.new(0, 8, 0), Color3.fromRGB(34, 139, 34), Enum.Material.Grass)
    leaves.Shape = Enum.PartType.Ball
end

-- Crear iluminación
local lighting = game:GetService("Lighting")
lighting.Brightness = 2
lighting.Ambient = Color3.fromRGB(100, 100, 100)
lighting.ColorShift_Bottom = Color3.fromRGB(255, 255, 255)
lighting.ColorShift_Top = Color3.fromRGB(255, 255, 255)

-- Añadir skybox escolar
local sky = Instance.new("Sky")
sky.SkyboxBk = "rbxasset://textures/sky/sky512_bk.jpg"
sky.SkyboxDn = "rbxasset://textures/sky/sky512_dn.jpg"
sky.SkyboxFt = "rbxasset://textures/sky/sky512_ft.jpg"
sky.SkyboxLf = "rbxasset://textures/sky/sky512_lf.jpg"
sky.SkyboxRt = "rbxasset://textures/sky/sky512_rt.jpg"
sky.SkyboxUp = "rbxasset://textures/sky/sky512_up.jpg"
sky.Parent = lighting

print("High School Simulator - Mapa construido exitosamente!")
print("Aulas creadas: " .. #classrooms)
print("Áreas especiales: Cafetería, Gimnasio, Biblioteca, Patio")