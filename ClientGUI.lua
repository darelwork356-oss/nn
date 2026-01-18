-- High School Simulator 2024
-- Cliente GUI

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Esperar eventos remotos
local RemoteEvents = ReplicatedStorage:WaitForChild("RemoteEvents")
local UpdatePlayerData = RemoteEvents:WaitForChild("UpdatePlayerData")
local ClassSystem = RemoteEvents:WaitForChild("ClassSystem")
local SocialSystem = RemoteEvents:WaitForChild("SocialSystem")

-- Crear GUI Principal
local MainGui = Instance.new("ScreenGui")
MainGui.Name = "HighSchoolGUI"
MainGui.Parent = playerGui

-- Panel Principal
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 400, 0, 500)
MainFrame.Position = UDim2.new(0, 20, 0, 20)
MainFrame.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
MainFrame.BorderSizePixel = 0
MainFrame.Parent = MainGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- Título
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 50)
Title.Position = UDim2.new(0, 0, 0, 0)
Title.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
Title.Text = "🏫 High School Simulator"
Title.TextColor3 = Color3.white
Title.TextScaled = true
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

-- Pestañas
local TabFrame = Instance.new("Frame")
TabFrame.Name = "TabFrame"
TabFrame.Size = UDim2.new(1, -20, 0, 40)
TabFrame.Position = UDim2.new(0, 10, 0, 60)
TabFrame.BackgroundTransparency = 1
TabFrame.Parent = MainFrame

local TabLayout = Instance.new("UIListLayout")
TabLayout.FillDirection = Enum.FillDirection.Horizontal
TabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
TabLayout.Padding = UDim.new(0, 5)
TabLayout.Parent = TabFrame

-- Contenido de Pestañas
local ContentFrame = Instance.new("Frame")
ContentFrame.Name = "ContentFrame"
ContentFrame.Size = UDim2.new(1, -20, 1, -120)
ContentFrame.Position = UDim2.new(0, 10, 0, 110)
ContentFrame.BackgroundTransparency = 1
ContentFrame.Parent = MainFrame

-- Sistema de Pestañas
local TabSystem = {}
TabSystem.ActiveTab = nil
TabSystem.Tabs = {}

function TabSystem:CreateTab(name, icon)
    local tab = Instance.new("TextButton")
    tab.Name = name .. "Tab"
    tab.Size = UDim2.new(0, 80, 1, 0)
    tab.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    tab.Text = icon .. " " .. name
    tab.TextColor3 = Color3.white
    tab.TextScaled = true
    tab.Font = Enum.Font.Gotham
    tab.Parent = TabFrame
    
    local tabCorner = Instance.new("UICorner")
    tabCorner.CornerRadius = UDim.new(0, 5)
    tabCorner.Parent = tab
    
    local content = Instance.new("ScrollingFrame")
    content.Name = name .. "Content"
    content.Size = UDim2.new(1, 0, 1, 0)
    content.BackgroundTransparency = 1
    content.ScrollBarThickness = 5
    content.Visible = false
    content.Parent = ContentFrame
    
    local contentLayout = Instance.new("UIListLayout")
    contentLayout.Padding = UDim.new(0, 10)
    contentLayout.Parent = content
    
    tab.MouseButton1Click:Connect(function()
        self:SwitchTab(name)
    end)
    
    self.Tabs[name] = {
        Button = tab,
        Content = content
    }
    
    return content
end

function TabSystem:SwitchTab(tabName)
    if self.ActiveTab then
        self.Tabs[self.ActiveTab].Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        self.Tabs[self.ActiveTab].Content.Visible = false
    end
    
    if self.Tabs[tabName] then
        self.ActiveTab = tabName
        self.Tabs[tabName].Button.BackgroundColor3 = Color3.fromRGB(80, 120, 200)
        self.Tabs[tabName].Content.Visible = true
    end
end

-- Crear Pestañas
local StatsTab = TabSystem:CreateTab("Stats", "📊")
local ClassesTab = TabSystem:CreateTab("Clases", "📚")
local SocialTab = TabSystem:CreateTab("Social", "👥")
local ShopTab = TabSystem:CreateTab("Tienda", "🛒")

-- Contenido de Stats
local function CreateStatBar(parent, statName, value)
    local statFrame = Instance.new("Frame")
    statFrame.Size = UDim2.new(1, 0, 0, 30)
    statFrame.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    statFrame.Parent = parent
    
    local statCorner = Instance.new("UICorner")
    statCorner.CornerRadius = UDim.new(0, 5)
    statCorner.Parent = statFrame
    
    local statLabel = Instance.new("TextLabel")
    statLabel.Size = UDim2.new(0.3, 0, 1, 0)
    statLabel.BackgroundTransparency = 1
    statLabel.Text = statName
    statLabel.TextColor3 = Color3.white
    statLabel.TextScaled = true
    statLabel.Font = Enum.Font.Gotham
    statLabel.Parent = statFrame
    
    local statBar = Instance.new("Frame")
    statBar.Size = UDim2.new(0.6, 0, 0.6, 0)
    statBar.Position = UDim2.new(0.35, 0, 0.2, 0)
    statBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    statBar.Parent = statFrame
    
    local statBarCorner = Instance.new("UICorner")
    statBarCorner.CornerRadius = UDim.new(0, 3)
    statBarCorner.Parent = statBar
    
    local statFill = Instance.new("Frame")
    statFill.Size = UDim2.new(value / 100, 0, 1, 0)
    statFill.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
    statFill.Parent = statBar
    
    local statFillCorner = Instance.new("UICorner")
    statFillCorner.CornerRadius = UDim.new(0, 3)
    statFillCorner.Parent = statFill
    
    local statValue = Instance.new("TextLabel")
    statValue.Size = UDim2.new(0.1, 0, 1, 0)
    statValue.Position = UDim2.new(0.9, 0, 0, 0)
    statValue.BackgroundTransparency = 1
    statValue.Text = tostring(value)
    statValue.TextColor3 = Color3.white
    statValue.TextScaled = true
    statValue.Font = Enum.Font.Gotham
    statValue.Parent = statFrame
    
    return statFill, statValue
end

-- Inicializar Stats
CreateStatBar(StatsTab, "Popularidad", 50)
CreateStatBar(StatsTab, "Inteligencia", 50)
CreateStatBar(StatsTab, "Atletismo", 50)
CreateStatBar(StatsTab, "Creatividad", 50)

-- Contenido de Clases
local function CreateClassButton(parent, className)
    local classButton = Instance.new("TextButton")
    classButton.Size = UDim2.new(1, 0, 0, 40)
    classButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
    classButton.Text = "📖 " .. className
    classButton.TextColor3 = Color3.white
    classButton.TextScaled = true
    classButton.Font = Enum.Font.Gotham
    classButton.Parent = parent
    
    local classCorner = Instance.new("UICorner")
    classCorner.CornerRadius = UDim.new(0, 5)
    classCorner.Parent = classButton
    
    classButton.MouseButton1Click:Connect(function()
        ClassSystem:FireServer("JoinClass", className)
    end)
    
    return classButton
end

-- Crear botones de clases
local classes = {"Matemáticas", "Ciencias", "Historia", "Inglés", "Educación Física", "Arte", "Música", "Informática"}
for _, className in ipairs(classes) do
    CreateClassButton(ClassesTab, className)
end

-- Contenido Social
local friendsList = Instance.new("TextLabel")
friendsList.Size = UDim2.new(1, 0, 0, 200)
friendsList.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
friendsList.Text = "👥 Lista de Amigos\n\n(Vacía)"
friendsList.TextColor3 = Color3.white
friendsList.TextScaled = false
friendsList.TextWrapped = true
friendsList.Font = Enum.Font.Gotham
friendsList.Parent = SocialTab

local friendCorner = Instance.new("UICorner")
friendCorner.CornerRadius = UDim.new(0, 5)
friendCorner.Parent = friendsList

-- Contenido de Tienda
local function CreateShopItem(parent, itemName, price, description)
    local itemFrame = Instance.new("Frame")
    itemFrame.Size = UDim2.new(1, 0, 0, 60)
    itemFrame.BackgroundColor3 = Color3.fromRGB(55, 55, 55)
    itemFrame.Parent = parent
    
    local itemCorner = Instance.new("UICorner")
    itemCorner.CornerRadius = UDim.new(0, 5)
    itemCorner.Parent = itemFrame
    
    local itemLabel = Instance.new("TextLabel")
    itemLabel.Size = UDim2.new(0.6, 0, 0.5, 0)
    itemLabel.BackgroundTransparency = 1
    itemLabel.Text = itemName
    itemLabel.TextColor3 = Color3.white
    itemLabel.TextScaled = true
    itemLabel.Font = Enum.Font.GothamBold
    itemLabel.Parent = itemFrame
    
    local itemDesc = Instance.new("TextLabel")
    itemDesc.Size = UDim2.new(0.6, 0, 0.5, 0)
    itemDesc.Position = UDim2.new(0, 0, 0.5, 0)
    itemDesc.BackgroundTransparency = 1
    itemDesc.Text = description
    itemDesc.TextColor3 = Color3.fromRGB(200, 200, 200)
    itemDesc.TextScaled = true
    itemDesc.Font = Enum.Font.Gotham
    itemDesc.Parent = itemFrame
    
    local buyButton = Instance.new("TextButton")
    buyButton.Size = UDim2.new(0.3, 0, 0.8, 0)
    buyButton.Position = UDim2.new(0.65, 0, 0.1, 0)
    buyButton.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
    buyButton.Text = "💰 $" .. price
    buyButton.TextColor3 = Color3.white
    buyButton.TextScaled = true
    buyButton.Font = Enum.Font.Gotham
    buyButton.Parent = itemFrame
    
    local buyCorner = Instance.new("UICorner")
    buyCorner.CornerRadius = UDim.new(0, 5)
    buyCorner.Parent = buyButton
    
    buyButton.MouseButton1Click:Connect(function()
        UpdatePlayerData:FireServer("BuyItem", {Item = itemName, Price = price})
    end)
end

-- Crear items de tienda
CreateShopItem(ShopTab, "🎒 Mochila Cool", 50, "Aumenta tu estilo")
CreateShopItem(ShopTab, "📱 Teléfono Nuevo", 100, "Mejora tu popularidad")
CreateShopItem(ShopTab, "👟 Zapatos Deportivos", 75, "Aumenta atletismo")
CreateShopItem(ShopTab, "🎨 Kit de Arte", 60, "Mejora creatividad")

-- Activar primera pestaña
TabSystem:SwitchTab("Stats")

-- Eventos del servidor
ClassSystem.OnClientEvent:Connect(function(action, data)
    if action == "ClassStarted" then
        -- Mostrar notificación de clase
        local notification = Instance.new("Frame")
        notification.Size = UDim2.new(0, 300, 0, 60)
        notification.Position = UDim2.new(0.5, -150, 0, -70)
        notification.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
        notification.Parent = MainGui
        
        local notifCorner = Instance.new("UICorner")
        notifCorner.CornerRadius = UDim.new(0, 10)
        notifCorner.Parent = notification
        
        local notifText = Instance.new("TextLabel")
        notifText.Size = UDim2.new(1, 0, 1, 0)
        notifText.BackgroundTransparency = 1
        notifText.Text = "📚 Clase de " .. data.Name .. " disponible!"
        notifText.TextColor3 = Color3.white
        notifText.TextScaled = true
        notifText.Font = Enum.Font.Gotham
        notifText.Parent = notification
        
        -- Animar entrada
        notification:TweenPosition(UDim2.new(0.5, -150, 0, 20), "Out", "Quad", 0.5, true)
        
        -- Remover después de 3 segundos
        wait(3)
        notification:TweenPosition(UDim2.new(0.5, -150, 0, -70), "In", "Quad", 0.5, true)
        wait(0.5)
        notification:Destroy()
    elseif action == "ClassCompleted" then
        -- Mostrar resultados de clase
        print("Clase completada: " .. data.Class .. " - Calificación: " .. data.Grade)
    end
end)

-- Minimizar/Maximizar GUI
local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -35, 0, 5)
minimizeButton.BackgroundColor3 = Color3.fromRGB(200, 100, 100)
minimizeButton.Text = "−"
minimizeButton.TextColor3 = Color3.white
minimizeButton.TextScaled = true
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.Parent = MainFrame

local minimizeCorner = Instance.new("UICorner")
minimizeCorner.CornerRadius = UDim.new(0, 5)
minimizeCorner.Parent = minimizeButton

local isMinimized = false
minimizeButton.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        MainFrame:TweenSize(UDim2.new(0, 400, 0, 50), "Out", "Quad", 0.3, true)
        minimizeButton.Text = "+"
    else
        MainFrame:TweenSize(UDim2.new(0, 400, 0, 500), "Out", "Quad", 0.3, true)
        minimizeButton.Text = "−"
    end
end)

print("High School Simulator - Cliente iniciado correctamente")