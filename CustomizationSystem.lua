-- High School Simulator 2024
-- Sistema de Personalización de Personajes

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local MarketplaceService = game:GetService("MarketplaceService")

-- Configuración de personalización
local CustomizationConfig = {
    Uniforms = {
        {Name = "Uniforme Clásico", Color = Color3.fromRGB(0, 0, 139), Price = 0},
        {Name = "Uniforme Moderno", Color = Color3.fromRGB(25, 25, 112), Price = 50},
        {Name = "Uniforme Deportivo", Color = Color3.fromRGB(220, 20, 60), Price = 75},
        {Name = "Uniforme Elegante", Color = Color3.fromRGB(72, 61, 139), Price = 100}
    },
    
    Hairstyles = {
        {Name = "Cabello Corto", MeshId = "rbxasset://avatar/hair/hair_01.mesh", Price = 0},
        {Name = "Cabello Largo", MeshId = "rbxasset://avatar/hair/hair_02.mesh", Price = 25},
        {Name = "Cabello Rizado", MeshId = "rbxasset://avatar/hair/hair_03.mesh", Price = 30},
        {Name = "Cabello Punk", MeshId = "rbxasset://avatar/hair/hair_04.mesh", Price = 50}
    },
    
    Accessories = {
        {Name = "Gafas Normales", Type = "Glasses", Price = 20},
        {Name = "Gafas de Sol", Type = "Sunglasses", Price = 35},
        {Name = "Mochila Escolar", Type = "Backpack", Price = 40},
        {Name = "Reloj Deportivo", Type = "Watch", Price = 60},
        {Name = "Auriculares", Type = "Headphones", Price = 45}
    },
    
    SkinTones = {
        Color3.fromRGB(255, 220, 177), -- Claro
        Color3.fromRGB(245, 222, 179), -- Medio claro
        Color3.fromRGB(222, 188, 153), -- Medio
        Color3.fromRGB(198, 134, 66),  -- Medio oscuro
        Color3.fromRGB(129, 69, 19)    -- Oscuro
    }
}

-- Eventos remotos para personalización
local CustomizationEvents = Instance.new("Folder")
CustomizationEvents.Name = "CustomizationEvents"
CustomizationEvents.Parent = ReplicatedStorage

local ChangeAppearance = Instance.new("RemoteEvent")
ChangeAppearance.Name = "ChangeAppearance"
ChangeAppearance.Parent = CustomizationEvents

local BuyCustomization = Instance.new("RemoteEvent")
BuyCustomization.Name = "BuyCustomization"
BuyCustomization.Parent = CustomizationEvents

-- Sistema de personalización
local CustomizationSystem = {}

function CustomizationSystem:ApplyUniform(player, uniformData)
    local character = player.Character
    if not character then return end
    
    -- Cambiar color de la camisa y pantalones
    local shirt = character:FindFirstChild("Shirt")
    local pants = character:FindFirstChild("Pants")
    
    if not shirt then
        shirt = Instance.new("Shirt")
        shirt.Parent = character
    end
    
    if not pants then
        pants = Instance.new("Pants")
        pants.Parent = character
    end
    
    -- IDs de texturas de uniformes (estos serían IDs reales en un juego publicado)
    local uniformTextures = {
        ["Uniforme Clásico"] = {
            ShirtTemplate = "rbxasset://textures/face.png",
            PantsTemplate = "rbxasset://textures/face.png"
        },
        ["Uniforme Moderno"] = {
            ShirtTemplate = "rbxasset://textures/face.png",
            PantsTemplate = "rbxasset://textures/face.png"
        },
        ["Uniforme Deportivo"] = {
            ShirtTemplate = "rbxasset://textures/face.png",
            PantsTemplate = "rbxasset://textures/face.png"
        },
        ["Uniforme Elegante"] = {
            ShirtTemplate = "rbxasset://textures/face.png",
            PantsTemplate = "rbxasset://textures/face.png"
        }
    }
    
    local textures = uniformTextures[uniformData.Name]
    if textures then
        shirt.ShirtTemplate = textures.ShirtTemplate
        pants.PantsTemplate = textures.PantsTemplate
    end
    
    -- Cambiar colores de las partes del cuerpo
    for _, part in pairs(character:GetChildren()) do
        if part:IsA("BasePart") and part.Name ~= "Head" then
            if part.Name == "Torso" or part.Name == "UpperTorso" then
                part.BrickColor = BrickColor.new(uniformData.Color)
            elseif part.Name == "Left Leg" or part.Name == "Right Leg" or 
                   part.Name == "LeftUpperLeg" or part.Name == "RightUpperLeg" or
                   part.Name == "LeftLowerLeg" or part.Name == "RightLowerLeg" then
                part.BrickColor = BrickColor.new(uniformData.Color)
            end
        end
    end
end

function CustomizationSystem:ApplyHairstyle(player, hairstyleData)
    local character = player.Character
    if not character then return end
    
    local head = character:FindFirstChild("Head")
    if not head then return end
    
    -- Remover cabello existente
    for _, child in pairs(head:GetChildren()) do
        if child.Name:find("Hair") or child:IsA("Accessory") then
            child:Destroy()
        end
    end
    
    -- Crear nuevo cabello
    local hair = Instance.new("Accessory")
    hair.Name = hairstyleData.Name
    
    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(1, 1, 1)
    handle.Transparency = 1
    handle.CanCollide = false
    handle.Parent = hair
    
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshType = Enum.MeshType.FileMesh
    mesh.MeshId = hairstyleData.MeshId
    mesh.Parent = handle
    
    local weld = Instance.new("Weld")
    weld.Part0 = head
    weld.Part1 = handle
    weld.C0 = CFrame.new(0, 0.5, 0)
    weld.Parent = handle
    
    hair.Parent = character
end

function CustomizationSystem:ApplySkinTone(player, skinColor)
    local character = player.Character
    if not character then return end
    
    -- Cambiar color de piel de todas las partes del cuerpo
    local bodyParts = {"Head", "Torso", "Left Arm", "Right Arm", "Left Leg", "Right Leg"}
    
    -- Para R15
    local r15Parts = {"Head", "UpperTorso", "LowerTorso", "LeftUpperArm", "LeftLowerArm", 
                      "RightUpperArm", "RightLowerArm", "LeftHand", "RightHand",
                      "LeftUpperLeg", "LeftLowerLeg", "RightUpperLeg", "RightLowerLeg",
                      "LeftFoot", "RightFoot"}
    
    for _, partName in pairs(bodyParts) do
        local part = character:FindFirstChild(partName)
        if part then
            part.BrickColor = BrickColor.new(skinColor)
        end
    end
    
    for _, partName in pairs(r15Parts) do
        local part = character:FindFirstChild(partName)
        if part then
            part.BrickColor = BrickColor.new(skinColor)
        end
    end
end

function CustomizationSystem:AddAccessory(player, accessoryData)
    local character = player.Character
    if not character then return end
    
    local accessory = Instance.new("Accessory")
    accessory.Name = accessoryData.Name
    
    local handle = Instance.new("Part")
    handle.Name = "Handle"
    handle.Size = Vector3.new(1, 1, 1)
    handle.Transparency = 0.5
    handle.CanCollide = false
    handle.BrickColor = BrickColor.new("Really black")
    handle.Parent = accessory
    
    -- Posición basada en el tipo de accesorio
    local attachmentCFrame = CFrame.new(0, 0, 0)
    
    if accessoryData.Type == "Glasses" or accessoryData.Type == "Sunglasses" then
        attachmentCFrame = CFrame.new(0, 0, -0.5)
        handle.Size = Vector3.new(2, 0.5, 0.2)
    elseif accessoryData.Type == "Backpack" then
        attachmentCFrame = CFrame.new(0, 0, 1)
        handle.Size = Vector3.new(1.5, 2, 0.8)
        handle.BrickColor = BrickColor.new("Really red")
    elseif accessoryData.Type == "Watch" then
        attachmentCFrame = CFrame.new(0, -1, 0)
        handle.Size = Vector3.new(0.3, 0.3, 0.3)
        handle.BrickColor = BrickColor.new("Really blue")
    elseif accessoryData.Type == "Headphones" then
        attachmentCFrame = CFrame.new(0, 0.5, 0)
        handle.Size = Vector3.new(2, 1, 1)
        handle.BrickColor = BrickColor.new("Really black")
    end
    
    local attachment = Instance.new("Attachment")
    attachment.Name = "HatAttachment"
    attachment.CFrame = attachmentCFrame
    attachment.Parent = handle
    
    accessory.Parent = character
end

-- Crear GUI de personalización
local function CreateCustomizationGUI(player)
    local playerGui = player:WaitForChild("PlayerGui")
    
    local customGui = Instance.new("ScreenGui")
    customGui.Name = "CustomizationGUI"
    customGui.Parent = playerGui
    
    local mainFrame = Instance.new("Frame")
    mainFrame.Name = "MainFrame"
    mainFrame.Size = UDim2.new(0, 500, 0, 600)
    mainFrame.Position = UDim2.new(0.5, -250, 0.5, -300)
    mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    mainFrame.BorderSizePixel = 0
    mainFrame.Visible = false
    mainFrame.Parent = customGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 15)
    corner.Parent = mainFrame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, 0, 0, 50)
    title.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    title.Text = "👤 Personalización de Personaje"
    title.TextColor3 = Color3.white
    title.TextScaled = true
    title.Font = Enum.Font.GothamBold
    title.Parent = mainFrame
    
    local titleCorner = Instance.new("UICorner")
    titleCorner.CornerRadius = UDim.new(0, 15)
    titleCorner.Parent = title
    
    -- Botón de cerrar
    local closeButton = Instance.new("TextButton")
    closeButton.Size = UDim2.new(0, 30, 0, 30)
    closeButton.Position = UDim2.new(1, -35, 0, 10)
    closeButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    closeButton.Text = "✕"
    closeButton.TextColor3 = Color3.white
    closeButton.TextScaled = true
    closeButton.Font = Enum.Font.GothamBold
    closeButton.Parent = mainFrame
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 5)
    closeCorner.Parent = closeButton
    
    closeButton.MouseButton1Click:Connect(function()
        mainFrame.Visible = false
    end)
    
    -- Scroll frame para opciones
    local scrollFrame = Instance.new("ScrollingFrame")
    scrollFrame.Size = UDim2.new(1, -20, 1, -70)
    scrollFrame.Position = UDim2.new(0, 10, 0, 60)
    scrollFrame.BackgroundTransparency = 1
    scrollFrame.ScrollBarThickness = 8
    scrollFrame.Parent = mainFrame
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 10)
    layout.Parent = scrollFrame
    
    -- Sección de uniformes
    local uniformSection = Instance.new("Frame")
    uniformSection.Size = UDim2.new(1, 0, 0, 200)
    uniformSection.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    uniformSection.Parent = scrollFrame
    
    local uniformCorner = Instance.new("UICorner")
    uniformCorner.CornerRadius = UDim.new(0, 10)
    uniformCorner.Parent = uniformSection
    
    local uniformTitle = Instance.new("TextLabel")
    uniformTitle.Size = UDim2.new(1, 0, 0, 30)
    uniformTitle.BackgroundTransparency = 1
    uniformTitle.Text = "👔 Uniformes"
    uniformTitle.TextColor3 = Color3.white
    uniformTitle.TextScaled = true
    uniformTitle.Font = Enum.Font.GothamBold
    uniformTitle.Parent = uniformSection
    
    -- Crear botones de uniformes
    for i, uniform in ipairs(CustomizationConfig.Uniforms) do
        local uniformButton = Instance.new("TextButton")
        uniformButton.Size = UDim2.new(0.45, 0, 0, 40)
        uniformButton.Position = UDim2.new(((i-1) % 2) * 0.5 + 0.025, 0, 0, 30 + math.floor((i-1) / 2) * 50)
        uniformButton.BackgroundColor3 = uniform.Color
        uniformButton.Text = uniform.Name .. " ($" .. uniform.Price .. ")"
        uniformButton.TextColor3 = Color3.white
        uniformButton.TextScaled = true
        uniformButton.Font = Enum.Font.Gotham
        uniformButton.Parent = uniformSection
        
        local buttonCorner = Instance.new("UICorner")
        buttonCorner.CornerRadius = UDim.new(0, 5)
        buttonCorner.Parent = uniformButton
        
        uniformButton.MouseButton1Click:Connect(function()
            BuyCustomization:FireServer("Uniform", uniform)
        end)
    end
    
    -- Sección de tonos de piel
    local skinSection = Instance.new("Frame")
    skinSection.Size = UDim2.new(1, 0, 0, 120)
    skinSection.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    skinSection.Parent = scrollFrame
    
    local skinCorner = Instance.new("UICorner")
    skinCorner.CornerRadius = UDim.new(0, 10)
    skinCorner.Parent = skinSection
    
    local skinTitle = Instance.new("TextLabel")
    skinTitle.Size = UDim2.new(1, 0, 0, 30)
    skinTitle.BackgroundTransparency = 1
    skinTitle.Text = "🎨 Tono de Piel"
    skinTitle.TextColor3 = Color3.white
    skinTitle.TextScaled = true
    skinTitle.Font = Enum.Font.GothamBold
    skinTitle.Parent = skinSection
    
    -- Crear botones de tonos de piel
    for i, skinColor in ipairs(CustomizationConfig.SkinTones) do
        local skinButton = Instance.new("TextButton")
        skinButton.Size = UDim2.new(0, 60, 0, 60)
        skinButton.Position = UDim2.new(0, 20 + (i-1) * 80, 0, 40)
        skinButton.BackgroundColor3 = skinColor
        skinButton.Text = ""
        skinButton.Parent = skinSection
        
        local skinButtonCorner = Instance.new("UICorner")
        skinButtonCorner.CornerRadius = UDim.new(0, 30)
        skinButtonCorner.Parent = skinButton
        
        skinButton.MouseButton1Click:Connect(function()
            ChangeAppearance:FireServer("SkinTone", skinColor)
        end)
    end
    
    -- Actualizar tamaño del scroll frame
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrollFrame.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y)
    end)
    
    return customGui
end

-- Eventos del servidor
ChangeAppearance.OnServerEvent:Connect(function(player, changeType, data)
    if changeType == "Uniform" then
        CustomizationSystem:ApplyUniform(player, data)
    elseif changeType == "Hairstyle" then
        CustomizationSystem:ApplyHairstyle(player, data)
    elseif changeType == "SkinTone" then
        CustomizationSystem:ApplySkinTone(player, data)
    elseif changeType == "Accessory" then
        CustomizationSystem:AddAccessory(player, data)
    end
end)

BuyCustomization.OnServerEvent:Connect(function(player, itemType, itemData)
    -- Aquí verificarías si el jugador tiene suficiente dinero
    -- Por simplicidad, aplicamos directamente el cambio
    
    if itemType == "Uniform" then
        CustomizationSystem:ApplyUniform(player, itemData)
    elseif itemType == "Hairstyle" then
        CustomizationSystem:ApplyHairstyle(player, itemData)
    elseif itemType == "Accessory" then
        CustomizationSystem:AddAccessory(player, itemData)
    end
end)

-- Crear GUI cuando el jugador se une
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        wait(1) -- Esperar a que el personaje se cargue completamente
        CreateCustomizationGUI(player)
        
        -- Aplicar personalización por defecto
        CustomizationSystem:ApplyUniform(player, CustomizationConfig.Uniforms[1])
    end)
end)

-- Comando para abrir GUI de personalización
game.Players.PlayerAdded:Connect(function(player)
    player.Chatted:Connect(function(message)
        if message:lower() == "/customize" or message:lower() == "/personalizar" then
            local gui = player.PlayerGui:FindFirstChild("CustomizationGUI")
            if gui then
                gui.MainFrame.Visible = not gui.MainFrame.Visible
            end
        end
    end)
end)

print("Sistema de Personalización - Iniciado correctamente")