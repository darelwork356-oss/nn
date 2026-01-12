-- ⚡ STRANGER THINGS ULTIMATE INTRO - LocalScript ⚡
-- Colocar en StarterPlayerScripts

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Debris = game:GetService("Debris")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- PREVENIR REINICIO AL MORIR
local introShown = false
if _G.StrangerThingsIntroShown then
    return -- Ya se mostró, no volver a ejecutar
end
_G.StrangerThingsIntroShown = true

-- Crear ScreenGui principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "StrangerThingsIntro"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 999
screenGui.Parent = playerGui

-- Frame principal con efectos atmosféricos
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(1, 0, 1, 0)
mainFrame.Position = UDim2.new(0, 0, 0, 0)
mainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Fondo con textura de ruido
local noiseTexture = Instance.new("ImageLabel")
noiseTexture.Size = UDim2.new(1, 0, 1, 0)
noiseTexture.BackgroundTransparency = 1
noiseTexture.Image = "rbxassetid://8560915132" -- Textura de ruido
noiseTexture.ImageTransparency = 0.9
noiseTexture.Parent = mainFrame

-- Gradiente atmosférico mejorado
local bgGradient = Instance.new("UIGradient")
bgGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0.05)),
    ColorSequenceKeypoint.new(0.3, Color3.new(0.1, 0, 0.1)),
    ColorSequenceKeypoint.new(0.7, Color3.new(0.05, 0, 0.05)),
    ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))
}
bgGradient.Rotation = 90
bgGradient.Parent = mainFrame

-- Rayos azules naturales de fondo
local lightningContainer = Instance.new("Frame")
lightningContainer.Size = UDim2.new(1, 0, 1, 0)
lightningContainer.BackgroundTransparency = 1
lightningContainer.Parent = mainFrame

local function createLightning()
    for i = 1, 3 do
        local lightning = Instance.new("ImageLabel")
        lightning.Size = UDim2.new(0, math.random(200, 400), 0, math.random(300, 600))
        lightning.Position = UDim2.new(math.random(), 0, math.random(-0.2, 0.2), 0)
        lightning.BackgroundTransparency = 1
        lightning.Image = "rbxassetid://4483431961" -- Textura de rayo
        lightning.ImageColor3 = Color3.new(0.3, 0.6, 1) -- Azul natural
        lightning.ImageTransparency = 0.8
        lightning.Rotation = math.random(-30, 30)
        lightning.Parent = lightningContainer
        
        -- Animación de parpadeo
        spawn(function()
            while lightning.Parent do
                wait(math.random(2, 8))
                if lightning.Parent then
                    TweenService:Create(lightning, TweenInfo.new(0.1), {ImageTransparency = 0.3}):Play()
                    wait(0.1)
                    TweenService:Create(lightning, TweenInfo.new(0.3), {ImageTransparency = 0.9}):Play()
                end
            end
        end)
    end
end
createLightning()

-- Sistema de partículas avanzado
local particleContainer = Instance.new("Frame")
particleContainer.Name = "ParticleContainer"
particleContainer.Size = UDim2.new(1, 0, 1, 0)
particleContainer.BackgroundTransparency = 1
particleContainer.Parent = mainFrame

-- Crear partículas flotantes mejoradas
local function createParticles()
    -- Partículas azules (electricidad)
    for i = 1, 25 do
        local particle = Instance.new("Frame")
        particle.Size = UDim2.new(0, math.random(1, 3), 0, math.random(1, 3))
        particle.Position = UDim2.new(math.random(), 0, math.random(), 0)
        particle.BackgroundColor3 = Color3.new(0.2, 0.5, 1)
        particle.BackgroundTransparency = math.random(60, 85) / 100
        particle.BorderSizePixel = 0
        particle.Parent = particleContainer
        
        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = particle
        
        -- Efecto de brillo
        local glow = Instance.new("UIStroke")
        glow.Color = Color3.new(0.4, 0.7, 1)
        glow.Thickness = 1
        glow.Transparency = 0.5
        glow.Parent = particle
        
        -- Animación flotante
        local floatTween = TweenService:Create(particle, 
            TweenInfo.new(math.random(4, 12), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
            {Position = UDim2.new(math.random(), 0, math.random(), 0)}
        )
        floatTween:Play()
        
        -- Parpadeo eléctrico
        spawn(function()
            while particle.Parent do
                wait(math.random(1, 4))
                if particle.Parent then
                    TweenService:Create(particle, TweenInfo.new(0.1), {BackgroundTransparency = 0.2}):Play()
                    wait(0.1)
                    TweenService:Create(particle, TweenInfo.new(0.5), {BackgroundTransparency = 0.8}):Play()
                end
            end
        end)
    end
    
    -- Partículas de humo/niebla
    for i = 1, 10 do
        local smoke = Instance.new("ImageLabel")
        smoke.Size = UDim2.new(0, math.random(50, 150), 0, math.random(50, 150))
        smoke.Position = UDim2.new(math.random(), 0, math.random(), 0)
        smoke.BackgroundTransparency = 1
        smoke.Image = "rbxassetid://241650934" -- Textura de humo
        smoke.ImageColor3 = Color3.new(0.1, 0.1, 0.2)
        smoke.ImageTransparency = 0.9
        smoke.Rotation = math.random(0, 360)
        smoke.Parent = particleContainer
        
        -- Movimiento lento de humo
        local smokeTween = TweenService:Create(smoke,
            TweenInfo.new(math.random(15, 25), Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, true),
            {Position = UDim2.new(math.random(), 0, math.random(), 0), Rotation = smoke.Rotation + 360}
        )
        smokeTween:Play()
    end
end
createParticles()

-- Sonido ambiente
local ambientSound = Instance.new("Sound")
ambientSound.SoundId = "rbxassetid://142376088" -- Sonido atmosférico
ambientSound.Volume = 0.3
ambientSound.Looped = true
ambientSound.Parent = screenGui
ambientSound:Play()

-- FASE 1: PANTALLA DE CARGA CINEMATOGRÁFICA
local loadingFrame = Instance.new("Frame")
loadingFrame.Name = "LoadingFrame"
loadingFrame.Size = UDim2.new(1, 0, 1, 0)
loadingFrame.BackgroundTransparency = 1
loadingFrame.Parent = mainFrame

-- Efecto de interferencia TV
local tvStatic = Instance.new("ImageLabel")
tvStatic.Size = UDim2.new(1, 0, 1, 0)
tvStatic.BackgroundTransparency = 1
tvStatic.Image = "rbxassetid://8560915132"
tvStatic.ImageTransparency = 0.95
tvStatic.Parent = loadingFrame

-- Animación de interferencia
spawn(function()
    while tvStatic.Parent do
        tvStatic.ImageTransparency = math.random(90, 98) / 100
        wait(0.1)
    end
end)

-- Logo inicial que aparece
local initialLogo = Instance.new("TextLabel")
initialLogo.Size = UDim2.new(0, 600, 0, 80)
initialLogo.Position = UDim2.new(0.5, -300, 0.3, 0)
initialLogo.BackgroundTransparency = 1
initialLogo.Text = "HAWKINS LABORATORY"
initialLogo.TextColor3 = Color3.new(0.3, 0.6, 1)
initialLogo.TextScaled = true
initialLogo.Font = Enum.Font.Code
initialLogo.TextStrokeTransparency = 0.5
initialLogo.TextStrokeColor3 = Color3.new(0.1, 0.3, 0.8)
initialLogo.TextTransparency = 1
initialLogo.Parent = loadingFrame

-- Texto "INICIANDO SISTEMA..."
local initText = Instance.new("TextLabel")
initText.Name = "InitText"
initText.Size = UDim2.new(0, 500, 0, 40)
initText.Position = UDim2.new(0.5, -250, 0.45, 0)
initText.BackgroundTransparency = 1
initText.Text = "INICIANDO PROTOCOLO..."
initText.TextColor3 = Color3.new(0.8, 0.9, 1)
initText.TextScaled = true
initText.Font = Enum.Font.Code
initText.TextTransparency = 1
initText.Parent = loadingFrame

-- Sistema de carga holográfico
local loadingBarBG = Instance.new("Frame")
loadingBarBG.Name = "LoadingBarBG"
loadingBarBG.Size = UDim2.new(0, 600, 0, 16)
loadingBarBG.Position = UDim2.new(0.5, -300, 0.55, -8)
loadingBarBG.BackgroundColor3 = Color3.new(0.02, 0.05, 0.1)
loadingBarBG.BorderSizePixel = 0
loadingBarBG.Parent = loadingFrame

-- Borde holográfico
local holoStroke = Instance.new("UIStroke")
holoStroke.Color = Color3.new(0.2, 0.5, 1)
holoStroke.Thickness = 2
holoStroke.Transparency = 0.3
holoStroke.Parent = loadingBarBG

local bgCorner = Instance.new("UICorner")
bgCorner.CornerRadius = UDim.new(0, 8)
bgCorner.Parent = loadingBarBG

-- Barra de carga azul eléctrica
local loadingBar = Instance.new("Frame")
loadingBar.Name = "LoadingBar"
loadingBar.Size = UDim2.new(0, 0, 1, 0)
loadingBar.Position = UDim2.new(0, 0, 0, 0)
loadingBar.BackgroundColor3 = Color3.new(0.2, 0.6, 1)
loadingBar.BorderSizePixel = 0
loadingBar.Parent = loadingBarBG

local barCorner = Instance.new("UICorner")
barCorner.CornerRadius = UDim.new(0, 8)
barCorner.Parent = loadingBar

-- Gradiente eléctrico
local barGradient = Instance.new("UIGradient")
barGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.new(0.1, 0.3, 0.8)),
    ColorSequenceKeypoint.new(0.5, Color3.new(0.3, 0.7, 1)),
    ColorSequenceKeypoint.new(1, Color3.new(0.2, 0.5, 0.9))
}
barGradient.Parent = loadingBar

-- Efecto de flujo eléctrico
local flowEffect = Instance.new("Frame")
flowEffect.Size = UDim2.new(0.3, 0, 1, 0)
flowEffect.Position = UDim2.new(-0.3, 0, 0, 0)
flowEffect.BackgroundColor3 = Color3.new(1, 1, 1)
flowEffect.BackgroundTransparency = 0.7
flowEffect.BorderSizePixel = 0
flowEffect.Parent = loadingBar

local flowCorner = Instance.new("UICorner")
flowCorner.CornerRadius = UDim.new(0, 8)
flowCorner.Parent = flowEffect

-- Animación de flujo
local flowTween = TweenService:Create(flowEffect,
    TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
    {Position = UDim2.new(1, 0, 0, 0)}
)
flowTween:Play()

-- Múltiples efectos de resplandor azul
local glowEffect1 = Instance.new("Frame")
glowEffect1.Name = "GlowEffect1"
glowEffect1.Size = UDim2.new(1, 40, 1, 40)
glowEffect1.Position = UDim2.new(0, -20, 0, -20)
glowEffect1.BackgroundColor3 = Color3.new(0.2, 0.6, 1)
glowEffect1.BackgroundTransparency = 0.85
glowEffect1.BorderSizePixel = 0
glowEffect1.Parent = loadingBar

local glow1Corner = Instance.new("UICorner")
glow1Corner.CornerRadius = UDim.new(0, 16)
glow1Corner.Parent = glowEffect1

local glowEffect2 = Instance.new("Frame")
glowEffect2.Name = "GlowEffect2"
glowEffect2.Size = UDim2.new(1, 80, 1, 80)
glowEffect2.Position = UDim2.new(0, -40, 0, -40)
glowEffect2.BackgroundColor3 = Color3.new(0.3, 0.7, 1)
glowEffect2.BackgroundTransparency = 0.92
glowEffect2.BorderSizePixel = 0
glowEffect2.Parent = loadingBar

local glow2Corner = Instance.new("UICorner")
glow2Corner.CornerRadius = UDim.new(0, 24)
glow2Corner.Parent = glowEffect2

-- Pulso eléctrico
local pulseTween1 = TweenService:Create(glowEffect1,
    TweenInfo.new(0.8, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
    {BackgroundTransparency = 0.6}
)
pulseTween1:Play()

local pulseTween2 = TweenService:Create(glowEffect2,
    TweenInfo.new(1.2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
    {BackgroundTransparency = 0.8}
)
pulseTween2:Play()

-- Porcentaje de carga holográfico
local percentText = Instance.new("TextLabel")
percentText.Name = "PercentText"
percentText.Size = UDim2.new(0, 120, 0, 35)
percentText.Position = UDim2.new(0.5, -60, 0.55, 30)
percentText.BackgroundTransparency = 1
percentText.Text = "0%"
percentText.TextColor3 = Color3.new(0.3, 0.7, 1)
percentText.TextScaled = true
percentText.Font = Enum.Font.Code
percentText.TextStrokeTransparency = 0.5
percentText.TextStrokeColor3 = Color3.new(0.1, 0.4, 0.8)
percentText.Parent = loadingFrame

-- Estado del sistema
local statusText = Instance.new("TextLabel")
statusText.Size = UDim2.new(0, 400, 0, 25)
statusText.Position = UDim2.new(0.5, -200, 0.65, 0)
statusText.BackgroundTransparency = 1
statusText.Text = "CONECTANDO A LA RED..."
statusText.TextColor3 = Color3.new(0.6, 0.8, 1)
statusText.TextScaled = true
statusText.Font = Enum.Font.Code
statusText.TextTransparency = 1
statusText.Parent = loadingFrame

-- FASE 2: SISTEMA DE ESCANEO FUTURISTA
local scanFrame = Instance.new("Frame")
scanFrame.Name = "ScanFrame"
scanFrame.Size = UDim2.new(1, 0, 1, 0)
scanFrame.BackgroundTransparency = 1
scanFrame.Visible = false
scanFrame.Parent = mainFrame

-- Grid holográfico de fondo
local gridContainer = Instance.new("Frame")
gridContainer.Size = UDim2.new(1, 0, 1, 0)
gridContainer.BackgroundTransparency = 1
gridContainer.Parent = scanFrame

-- Crear grid
for i = 0, 20 do
    local vLine = Instance.new("Frame")
    vLine.Size = UDim2.new(0, 1, 1, 0)
    vLine.Position = UDim2.new(i/20, 0, 0, 0)
    vLine.BackgroundColor3 = Color3.new(0.2, 0.5, 1)
    vLine.BackgroundTransparency = 0.9
    vLine.BorderSizePixel = 0
    vLine.Parent = gridContainer
    
    local hLine = Instance.new("Frame")
    hLine.Size = UDim2.new(1, 0, 0, 1)
    hLine.Position = UDim2.new(0, 0, i/20, 0)
    hLine.BackgroundColor3 = Color3.new(0.2, 0.5, 1)
    hLine.BackgroundTransparency = 0.9
    hLine.BorderSizePixel = 0
    hLine.Parent = gridContainer
end

-- Líneas de escaneo mejoradas
local scanLines = {}
for i = 1, 12 do
    local line = Instance.new("Frame")
    line.Size = UDim2.new(1, 0, 0, 2)
    line.Position = UDim2.new(0, 0, i/15, 0)
    line.BackgroundColor3 = Color3.new(0.3, 0.7, 1)
    line.BackgroundTransparency = 0.6
    line.BorderSizePixel = 0
    line.Parent = scanFrame
    
    -- Gradiente en las líneas
    local lineGradient = Instance.new("UIGradient")
    lineGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.new(0.1, 0.3, 0.8)),
        ColorSequenceKeypoint.new(0.5, Color3.new(0.4, 0.8, 1)),
        ColorSequenceKeypoint.new(1, Color3.new(0.1, 0.3, 0.8))
    }
    lineGradient.Parent = line
    
    table.insert(scanLines, line)
end

-- Imagen de perfil con efectos
local profileContainer = Instance.new("Frame")
profileContainer.Name = "ProfileContainer"
profileContainer.Size = UDim2.new(0, 200, 0, 200)
profileContainer.Position = UDim2.new(0.5, -100, 0.5, -120)
profileContainer.BackgroundTransparency = 1
profileContainer.Parent = scanFrame

local profileImage = Instance.new("ImageLabel")
profileImage.Name = "ProfileImage"
profileImage.Size = UDim2.new(0, 160, 0, 160)
profileImage.Position = UDim2.new(0.5, -80, 0.5, -80)
profileImage.BackgroundTransparency = 1
profileImage.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
profileImage.Parent = profileContainer

local imageCorner = Instance.new("UICorner")
imageCorner.CornerRadius = UDim.new(0, 12)
imageCorner.Parent = profileImage

-- Marco hexagonal simulado
local hexFrame = Instance.new("Frame")
hexFrame.Name = "HexFrame"
hexFrame.Size = UDim2.new(0, 180, 0, 180)
hexFrame.Position = UDim2.new(0.5, -90, 0.5, -90)
hexFrame.BackgroundTransparency = 1
hexFrame.Parent = profileContainer

local hexStroke = Instance.new("UIStroke")
hexStroke.Color = Color3.new(0.9, 0.1, 0.1)
hexStroke.Thickness = 3
hexStroke.Parent = hexFrame

local hexCorner = Instance.new("UICorner")
hexCorner.CornerRadius = UDim.new(0, 15)
hexCorner.Parent = hexFrame

-- Múltiples anillos de escaneo
local rings = {}
for i = 1, 3 do
    local ring = Instance.new("Frame")
    ring.Size = UDim2.new(0, 200 + (i * 30), 0, 200 + (i * 30))
    ring.Position = UDim2.new(0.5, -(100 + (i * 15)), 0.5, -(100 + (i * 15)))
    ring.BackgroundTransparency = 1
    ring.Parent = profileContainer
    
    local ringStroke = Instance.new("UIStroke")
    ringStroke.Color = Color3.new(0.8, 0.1, 0.1)
    ringStroke.Thickness = 2
    ringStroke.Transparency = 0.3 + (i * 0.2)
    ringStroke.Parent = ring
    
    local ringCorner = Instance.new("UICorner")
    ringCorner.CornerRadius = UDim.new(1, 0)
    ringCorner.Parent = ring
    
    table.insert(rings, ring)
end

-- HUD de información del jugador
local playerInfo = Instance.new("Frame")
playerInfo.Name = "PlayerInfo"
playerInfo.Size = UDim2.new(0, 500, 0, 250)
playerInfo.Position = UDim2.new(0.5, -250, 0.5, 120)
playerInfo.BackgroundTransparency = 1
playerInfo.Parent = scanFrame

-- Panel de información con borde holográfico
local infoPanel = Instance.new("Frame")
infoPanel.Size = UDim2.new(1, 0, 1, 0)
infoPanel.BackgroundColor3 = Color3.new(0.02, 0.05, 0.1)
infoPanel.BackgroundTransparency = 0.3
infoPanel.BorderSizePixel = 0
infoPanel.Parent = playerInfo

local panelCorner = Instance.new("UICorner")
panelCorner.CornerRadius = UDim.new(0, 10)
panelCorner.Parent = infoPanel

local panelStroke = Instance.new("UIStroke")
panelStroke.Color = Color3.new(0.2, 0.5, 1)
panelStroke.Thickness = 2
panelStroke.Transparency = 0.4
panelStroke.Parent = infoPanel

-- Información del jugador mejorada
local infoTexts = {
    "SUJETO: " .. player.Name,
    "ID: #" .. string.format("%06d", player.UserId % 1000000),
    "ESTADO: ESCANEANDO...",
    "CLASIFICACIÓN: NIVEL-" .. math.random(1, 5),
    "UBICACIÓN: HAWKINS, INDIANA",
    "PROTOCOLO: ACTIVO"
}

for i, text in ipairs(infoTexts) do
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(1, -20, 0, 30)
    infoLabel.Position = UDim2.new(0, 10, 0, (i-1) * 35 + 10)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Text = text
    infoLabel.TextColor3 = Color3.new(0.6, 0.8, 1)
    infoLabel.TextScaled = true
    infoLabel.Font = Enum.Font.Code
    infoLabel.TextXAlignment = Enum.TextXAlignment.Left
    infoLabel.TextTransparency = 1
    infoLabel.Parent = infoPanel
end

-- Texto principal de escaneo
local scanText = Instance.new("TextLabel")
scanText.Name = "ScanText"
scanText.Size = UDim2.new(0, 500, 0, 80)
scanText.Position = UDim2.new(0.5, -250, 0.15, 0)
scanText.BackgroundTransparency = 1
scanText.Text = "ANALIZANDO SUJETO"
scanText.TextColor3 = Color3.new(0.3, 0.7, 1)
scanText.TextScaled = true
scanText.Font = Enum.Font.Code
scanText.TextStrokeTransparency = 0.3
scanText.TextStrokeColor3 = Color3.new(0.1, 0.4, 0.8)
scanText.Parent = scanFrame

-- FASE 3: ACCESO CONCEDIDO ÉPICO
local accessFrame = Instance.new("Frame")
accessFrame.Name = "AccessFrame"
accessFrame.Size = UDim2.new(1, 0, 1, 0)
accessFrame.BackgroundTransparency = 1
accessFrame.Visible = false
accessFrame.Parent = mainFrame

-- Flash holográfico
local flashFrame = Instance.new("Frame")
flashFrame.Name = "FlashFrame"
flashFrame.Size = UDim2.new(1, 0, 1, 0)
flashFrame.BackgroundColor3 = Color3.new(0.2, 0.6, 1)
flashFrame.BackgroundTransparency = 1
flashFrame.BorderSizePixel = 0
flashFrame.Parent = accessFrame

-- Texto de acceso concedido
local accessText = Instance.new("TextLabel")
accessText.Name = "AccessText"
accessText.Size = UDim2.new(0, 700, 0, 150)
accessText.Position = UDim2.new(0.5, -350, 0.5, -75)
accessText.BackgroundTransparency = 1
accessText.Text = "ACCESO AUTORIZADO"
accessText.TextColor3 = Color3.new(0.2, 0.8, 0.3)
accessText.TextScaled = true
accessText.Font = Enum.Font.Code
accessText.TextStrokeTransparency = 0.2
accessText.TextStrokeColor3 = Color3.new(0.1, 0.6, 0.2)
accessText.TextTransparency = 1
accessText.Parent = accessFrame

-- Efectos de energía verde
local energyLines = {}
for i = 1, 8 do
    local line = Instance.new("Frame")
    line.Size = UDim2.new(0, math.random(150, 400), 0, 3)
    line.Position = UDim2.new(math.random(), 0, math.random(), 0)
    line.BackgroundColor3 = Color3.new(0.2, 0.8, 0.3)
    line.BackgroundTransparency = 0.4
    line.BorderSizePixel = 0
    line.Rotation = math.random(0, 360)
    line.Parent = accessFrame
    
    local lineGlow = Instance.new("UIStroke")
    lineGlow.Color = Color3.new(0.3, 1, 0.4)
    lineGlow.Thickness = 2
    lineGlow.Transparency = 0.6
    lineGlow.Parent = line
    
    table.insert(energyLines, line)
end

-- FASE 4: LOGO CINEMATOGRÁFICO FINAL
local logoFrame = Instance.new("Frame")
logoFrame.Name = "LogoFrame"
logoFrame.Size = UDim2.new(1, 0, 1, 0)
logoFrame.BackgroundTransparency = 1
logoFrame.Visible = false
logoFrame.Parent = mainFrame

-- Fondo con profundidad
local depthBG = Instance.new("Frame")
depthBG.Size = UDim2.new(1, 0, 1, 0)
depthBG.BackgroundColor3 = Color3.new(0, 0, 0)
depthBG.BackgroundTransparency = 0.2
depthBG.BorderSizePixel = 0
depthBG.Parent = logoFrame

local depthGradient = Instance.new("UIGradient")
depthGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0.1)),
    ColorSequenceKeypoint.new(0.5, Color3.new(0.05, 0, 0.05)),
    ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))
}
depthGradient.Rotation = 45
depthGradient.Parent = depthBG

-- Logo principal
local logoText = Instance.new("TextLabel")
logoText.Name = "LogoText"
logoText.Size = UDim2.new(0, 900, 0, 180)
logoText.Position = UDim2.new(0.5, -450, 0.5, -90)
logoText.BackgroundTransparency = 1
logoText.Text = "STRANGER THINGS"
logoText.TextColor3 = Color3.new(0.9, 0.2, 0.2)
logoText.TextScaled = true
logoText.Font = Enum.Font.Code
logoText.TextStrokeTransparency = 0.1
logoText.TextStrokeColor3 = Color3.new(0.6, 0.1, 0.1)
logoText.TextTransparency = 1
logoText.Parent = logoFrame

-- Múltiples capas de resplandor
local logoGlow1 = Instance.new("Frame")
logoGlow1.Size = UDim2.new(0, 950, 0, 230)
logoGlow1.Position = UDim2.new(0.5, -475, 0.5, -115)
logoGlow1.BackgroundColor3 = Color3.new(1, 0.1, 0.1)
logoGlow1.BackgroundTransparency = 0.88
logoGlow1.BorderSizePixel = 0
logoGlow1.Parent = logoFrame

local glow1Corner = Instance.new("UICorner")
glow1Corner.CornerRadius = UDim.new(0, 35)
glow1Corner.Parent = logoGlow1

-- Rayos de energía rotativos
local lightRays = {}
for i = 1, 12 do
    local ray = Instance.new("Frame")
    ray.Size = UDim2.new(0, 6, 0, 800)
    ray.Position = UDim2.new(0.5, -3, 0.5, -400)
    ray.BackgroundColor3 = Color3.new(0.8, 0.1, 0.1)
    ray.BackgroundTransparency = 0.85
    ray.BorderSizePixel = 0
    ray.Rotation = i * 30
    ray.Parent = logoFrame
    
    local rayGradient = Instance.new("UIGradient")
    rayGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.new(0.8, 0.1, 0.1)),
        ColorSequenceKeypoint.new(0.5, Color3.new(1, 0.3, 0.3)),
        ColorSequenceKeypoint.new(1, Color3.new(0.8, 0.1, 0.1))
    }
    rayGradient.Rotation = 90
    rayGradient.Parent = ray
    
    table.insert(lightRays, ray)
end

-- FUNCIONES DE ANIMACIÓN AVANZADAS
local function fadeIn(object, duration, property)
    property = property or "TextTransparency"
    local props = {}
    props[property] = 0
    local tween = TweenService:Create(object, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props)
    tween:Play()
    return tween
end

local function fadeOut(object, duration, property)
    property = property or "TextTransparency"
    local props = {}
    props[property] = 1
    local tween = TweenService:Create(object, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props)
    tween:Play()
    return tween
end

local function scaleIn(object, duration, targetSize)
    object.Size = UDim2.new(0, 0, 0, 0)
    local tween = TweenService:Create(object, TweenInfo.new(duration, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = targetSize
    })
    tween:Play()
    return tween
end

local function glitchEffect(object, duration)
    local originalPos = object.Position
    spawn(function()
        for i = 1, 15 do
            wait(duration/15)
            if object.Parent then
                object.Position = UDim2.new(originalPos.X.Scale + math.random(-8, 8)/1000, originalPos.X.Offset, 
                                           originalPos.Y.Scale + math.random(-8, 8)/1000, originalPos.Y.Offset)
            end
        end
        if object.Parent then
            object.Position = originalPos
        end
    end)
end

-- SECUENCIA ÉPICA MEJORADA
local function startIntro()
    -- Fase 1: Carga cinematográfica
    fadeIn(initialLogo, 1.5)
    wait(1)
    fadeIn(initText, 0.8)
    fadeIn(statusText, 1)
    wait(1.5)
    
    local loadProgress = 0
    local loadTween = TweenService:Create(loadingBar, TweenInfo.new(5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(1, 0, 1, 0)
    })
    loadTween:Play()
    
    -- Animación del porcentaje y estados
    local statusMessages = {
        "CONECTANDO A LA RED...",
        "VERIFICANDO CREDENCIALES...",
        "ACCEDIENDO A BASE DE DATOS...",
        "CARGANDO PROTOCOLOS...",
        "INICIANDO SISTEMA..."
    }
    
    spawn(function()
        local messageIndex = 1
        while loadProgress < 100 do
            loadProgress = loadProgress + math.random(1, 4)
            if loadProgress > 100 then loadProgress = 100 end
            percentText.Text = loadProgress .. "%"
            
            if loadProgress > messageIndex * 20 and messageIndex <= #statusMessages then
                statusText.Text = statusMessages[messageIndex]
                glitchEffect(statusText, 0.3)
                messageIndex = messageIndex + 1
            end
            
            wait(0.08)
        end
    end)
    
    loadTween.Completed:Connect(function()
        fadeOut(initialLogo, 0.8)
        fadeOut(initText, 0.8)
        fadeOut(statusText, 0.8)
        wait(1.2)
        
        -- Fase 2: Escaneo futurista
        loadingFrame.Visible = false
        scanFrame.Visible = true
        
        -- Animaciones de líneas de escaneo
        for i, line in ipairs(scanLines) do
            spawn(function()
                wait(i * 0.08)
                local moveTween = TweenService:Create(line, 
                    TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
                    {Position = UDim2.new(0, 0, 1.2, 0)}
                )
                moveTween:Play()
            end)
        end
        
        -- Aparición del perfil
        scaleIn(profileContainer, 1.5, UDim2.new(0, 200, 0, 200))
        
        -- Animación de anillos
        for i, ring in ipairs(rings) do
            spawn(function()
                wait(i * 0.4)
                local rotateTween = TweenService:Create(ring,
                    TweenInfo.new(4, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
                    {Rotation = 360}
                )
                rotateTween:Play()
            end)
        end
        
        -- Información del jugador
        for i, label in ipairs(infoPanel:GetChildren()) do
            if label:IsA("TextLabel") then
                spawn(function()
                    wait(i * 0.3)
                    fadeIn(label, 1)
                    glitchEffect(label, 0.4)
                end)
            end
        end
        
        -- Texto de escaneo
        fadeIn(scanText, 1.2)
        spawn(function()
            local scanDots = ""
            for i = 1, 20 do
                wait(0.15)
                if #scanDots < 3 then
                    scanDots = scanDots .. "."
                else
                    scanDots = ""
                end
                if scanText.Parent then
                    scanText.Text = "ANALIZANDO SUJETO" .. scanDots
                end
            end
        end)
        
        wait(5)
        
        -- Fase 3: Acceso autorizado
        scanFrame.Visible = false
        accessFrame.Visible = true
        
        -- Flash holográfico
        local flashTween = TweenService:Create(flashFrame, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
            BackgroundTransparency = 0.3
        })
        flashTween:Play()
        flashTween.Completed:Connect(function()
            TweenService:Create(flashFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
                BackgroundTransparency = 1
            }):Play()
        end)
        
        -- Texto de acceso
        fadeIn(accessText, 0.8)
        glitchEffect(accessText, 0.6)
        
        -- Líneas de energía
        for i, line in ipairs(energyLines) do
            spawn(function()
                wait(i * 0.1)
                local expandTween = TweenService:Create(line, TweenInfo.new(1.2, Enum.EasingStyle.Quad), {
                    Size = UDim2.new(0, line.Size.X.Offset * 1.5, 0, 6)
                })
                expandTween:Play()
                expandTween.Completed:Connect(function()
                    TweenService:Create(line, TweenInfo.new(0.8, Enum.EasingStyle.Quad), {
                        BackgroundTransparency = 1
                    }):Play()
                end)
            end)
        end
        
        wait(2.5)
        fadeOut(accessText, 1)
        wait(1.5)
        
        -- Fase 4: Logo cinematográfico final
        accessFrame.Visible = false
        logoFrame.Visible = true
        
        -- Rayos rotativos
        for i, ray in ipairs(lightRays) do
            spawn(function()
                local rotateTween = TweenService:Create(ray,
                    TweenInfo.new(12, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
                    {Rotation = ray.Rotation + 360}
                )
                rotateTween:Play()
            end)
        end
        
        -- Logo con zoom épico
        logoText.Size = UDim2.new(0, 30, 0, 6)
        logoText.Position = UDim2.new(0.5, -15, 0.5, -3)
        logoText.TextTransparency = 0
        
        local logoZoom = TweenService:Create(logoText, TweenInfo.new(4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 900, 0, 180),
            Position = UDim2.new(0.5, -450, 0.5, -90)
        })
        logoZoom:Play()
        
        -- Efectos de resplandor
        spawn(function()
            wait(2)
            local glowTween = TweenService:Create(logoGlow1,
                TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
                {BackgroundTransparency = 0.7}
            )
            glowTween:Play()
        end)
        
        logoZoom.Completed:Connect(function()
            wait(4)
            
            -- Fade out épico final
            ambientSound:Stop()
            local finalFade = TweenService:Create(mainFrame, TweenInfo.new(3, Enum.EasingStyle.Quad), {
                BackgroundTransparency = 1
            })
            local logoFade = fadeOut(logoText, 3)
            
            finalFade:Play()
            
            finalFade.Completed:Connect(function()
                screenGui:Destroy()
            end)
        end)
    end)
end

-- Iniciar la introducción épica
startIntro() = UDim2.new(0, 400, 0, 200)
playerInfo.Position = UDim2.new(0.5, -200, 0.5, 100)
playerInfo.BackgroundTransparency = 1
playerInfo.Parent = scanFrame

local infoTexts = {
    "USUARIO: " .. player.Name,
    "ID: " .. player.UserId,
    "ESTADO: ESCANEANDO...",
    "NIVEL DE ACCESO: CLASIFICADO"
}

for i, text in ipairs(infoTexts) do
    local infoLabel = Instance.new("TextLabel")
    infoLabel.Size = UDim2.new(1, 0, 0, 25)
    infoLabel.Position = UDim2.new(0, 0, 0, (i-1) * 30)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Text = text
    infoLabel.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    infoLabel.TextScaled = true
    infoLabel.Font = Enum.Font.Code
    infoLabel.TextXAlignment = Enum.TextXAlignment.Left
    infoLabel.TextTransparency = 1
    infoLabel.Parent = playerInfo
end

-- Texto principal de escaneo
local scanText = Instance.new("TextLabel")
scanText.Name = "ScanText"
scanText.Size = UDim2.new(0, 400, 0, 60)
scanText.Position = UDim2.new(0.5, -200, 0.2, 0)
scanText.BackgroundTransparency = 1
scanText.Text = "ESCANEANDO SUJETO"
scanText.TextColor3 = Color3.new(0.9, 0.1, 0.1)
scanText.TextScaled = true
scanText.Font = Enum.Font.Code
scanText.TextStrokeTransparency = 0.5
scanText.TextStrokeColor3 = Color3.new(0.9, 0.1, 0.1)
scanText.Parent = scanFrame

-- FASE 3: ACCESO CONCEDIDO ÉPICO
local accessFrame = Instance.new("Frame")
accessFrame.Name = "AccessFrame"
accessFrame.Size = UDim2.new(1, 0, 1, 0)
accessFrame.BackgroundTransparency = 1
accessFrame.Visible = false
accessFrame.Parent = mainFrame

-- Flash de pantalla
local flashFrame = Instance.new("Frame")
flashFrame.Name = "FlashFrame"
flashFrame.Size = UDim2.new(1, 0, 1, 0)
flashFrame.BackgroundColor3 = Color3.new(0.9, 0.1, 0.1)
flashFrame.BackgroundTransparency = 1
flashFrame.BorderSizePixel = 0
flashFrame.Parent = accessFrame

-- Texto principal
local accessText = Instance.new("TextLabel")
accessText.Name = "AccessText"
accessText.Size = UDim2.new(0, 600, 0, 120)
accessText.Position = UDim2.new(0.5, -300, 0.5, -60)
accessText.BackgroundTransparency = 1
accessText.Text = "ACCESO CONCEDIDO"
accessText.TextColor3 = Color3.new(0.9, 0.1, 0.1)
accessText.TextScaled = true
accessText.Font = Enum.Font.Code
accessText.TextStrokeTransparency = 0.3
accessText.TextStrokeColor3 = Color3.new(1, 0.3, 0.3)
accessText.TextTransparency = 1
accessText.Parent = accessFrame

-- Efectos de resplandor múltiples
local accessGlow1 = Instance.new("Frame")
accessGlow1.Size = UDim2.new(0, 650, 0, 170)
accessGlow1.Position = UDim2.new(0.5, -325, 0.5, -85)
accessGlow1.BackgroundColor3 = Color3.new(0.9, 0.1, 0.1)
accessGlow1.BackgroundTransparency = 0.9
accessGlow1.BorderSizePixel = 0
accessGlow1.Parent = accessFrame

local accessGlowCorner1 = Instance.new("UICorner")
accessGlowCorner1.CornerRadius = UDim.new(0, 25)
accessGlowCorner1.Parent = accessGlow1

-- Líneas de energía
local energyLines = {}
for i = 1, 6 do
    local line = Instance.new("Frame")
    line.Size = UDim2.new(0, math.random(100, 300), 0, 2)
    line.Position = UDim2.new(math.random(), 0, math.random(), 0)
    line.BackgroundColor3 = Color3.new(0.9, 0.1, 0.1)
    line.BackgroundTransparency = 0.5
    line.BorderSizePixel = 0
    line.Rotation = math.random(0, 360)
    line.Parent = accessFrame
    table.insert(energyLines, line)
end

-- FASE 4: LOGO CINEMATOGRÁFICO ÉPICO
local logoFrame = Instance.new("Frame")
logoFrame.Name = "LogoFrame"
logoFrame.Size = UDim2.new(1, 0, 1, 0)
logoFrame.BackgroundTransparency = 1
logoFrame.Visible = false
logoFrame.Parent = mainFrame

-- Fondo con efecto de profundidad
local depthBG = Instance.new("Frame")
depthBG.Size = UDim2.new(1, 0, 1, 0)
depthBG.BackgroundColor3 = Color3.new(0, 0, 0)
depthBG.BackgroundTransparency = 0.3
depthBG.BorderSizePixel = 0
depthBG.Parent = logoFrame

local depthGradient = Instance.new("UIGradient")
depthGradient.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.new(0, 0, 0)),
    ColorSequenceKeypoint.new(0.5, Color3.new(0.1, 0, 0)),
    ColorSequenceKeypoint.new(1, Color3.new(0, 0, 0))
}
depthGradient.Rotation = 90
depthGradient.Parent = depthBG

-- Logo principal con múltiples efectos
local logoText = Instance.new("TextLabel")
logoText.Name = "LogoText"
logoText.Size = UDim2.new(0, 800, 0, 150)
logoText.Position = UDim2.new(0.5, -400, 0.5, -75)
logoText.BackgroundTransparency = 1
logoText.Text = "STRANGER THINGS"
logoText.TextColor3 = Color3.new(1, 0.2, 0.2)
logoText.TextScaled = true
logoText.Font = Enum.Font.Code
logoText.TextStrokeTransparency = 0.2
logoText.TextStrokeColor3 = Color3.new(0.8, 0.1, 0.1)
logoText.TextTransparency = 1
logoText.Parent = logoFrame

-- Múltiples capas de resplandor
local logoGlow1 = Instance.new("Frame")
logoGlow1.Size = UDim2.new(0, 850, 0, 200)
logoGlow1.Position = UDim2.new(0.5, -425, 0.5, -100)
logoGlow1.BackgroundColor3 = Color3.new(1, 0.1, 0.1)
logoGlow1.BackgroundTransparency = 0.85
logoGlow1.BorderSizePixel = 0
logoGlow1.Parent = logoFrame

local glow1Corner = Instance.new("UICorner")
glow1Corner.CornerRadius = UDim.new(0, 30)
glow1Corner.Parent = logoGlow1

local logoGlow2 = Instance.new("Frame")
logoGlow2.Size = UDim2.new(0, 900, 0, 250)
logoGlow2.Position = UDim2.new(0.5, -450, 0.5, -125)
logoGlow2.BackgroundColor3 = Color3.new(0.9, 0.05, 0.05)
logoGlow2.BackgroundTransparency = 0.92
logoGlow2.BorderSizePixel = 0
logoGlow2.Parent = logoFrame

local glow2Corner = Instance.new("UICorner")
glow2Corner.CornerRadius = UDim.new(0, 40)
glow2Corner.Parent = logoGlow2

-- Rayos de luz
local lightRays = {}
for i = 1, 8 do
    local ray = Instance.new("Frame")
    ray.Size = UDim2.new(0, 4, 0, 600)
    ray.Position = UDim2.new(0.5, -2, 0.5, -300)
    ray.BackgroundColor3 = Color3.new(0.9, 0.1, 0.1)
    ray.BackgroundTransparency = 0.8
    ray.BorderSizePixel = 0
    ray.Rotation = i * 45
    ray.Parent = logoFrame
    
    local rayGradient = Instance.new("UIGradient")
    rayGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.new(0.9, 0.1, 0.1)),
        ColorSequenceKeypoint.new(0.5, Color3.new(1, 0.3, 0.3)),
        ColorSequenceKeypoint.new(1, Color3.new(0.9, 0.1, 0.1))
    }
    rayGradient.Rotation = 90
    rayGradient.Parent = ray
    
    table.insert(lightRays, ray)
end

-- Partículas de energía alrededor del logo
local logoParticles = {}
for i = 1, 20 do
    local particle = Instance.new("Frame")
    particle.Size = UDim2.new(0, math.random(3, 8), 0, math.random(3, 8))
    particle.Position = UDim2.new(0.5 + math.random(-200, 200)/1000, 0, 0.5 + math.random(-100, 100)/1000, 0)
    particle.BackgroundColor3 = Color3.new(0.9, 0.1, 0.1)
    particle.BackgroundTransparency = math.random(60, 90)/100
    particle.BorderSizePixel = 0
    particle.Parent = logoFrame
    
    local particleCorner = Instance.new("UICorner")
    particleCorner.CornerRadius = UDim.new(1, 0)
    particleCorner.Parent = particle
    
    table.insert(logoParticles, particle)
end

-- FUNCIONES DE ANIMACIÓN AVANZADAS
local function fadeIn(object, duration, property)
    property = property or "TextTransparency"
    local props = {}
    props[property] = 0
    local tween = TweenService:Create(object, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props)
    tween:Play()
    return tween
end

local function fadeOut(object, duration, property)
    property = property or "TextTransparency"
    local props = {}
    props[property] = 1
    local tween = TweenService:Create(object, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props)
    tween:Play()
    return tween
end

local function scaleIn(object, duration, targetSize)
    object.Size = UDim2.new(0, 0, 0, 0)
    local tween = TweenService:Create(object, TweenInfo.new(duration, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = targetSize
    })
    tween:Play()
    return tween
end

local function glitchEffect(object, duration)
    local originalPos = object.Position
    for i = 1, 10 do
        wait(duration/10)
        object.Position = UDim2.new(originalPos.X.Scale + math.random(-5, 5)/1000, originalPos.X.Offset, 
                                   originalPos.Y.Scale + math.random(-5, 5)/1000, originalPos.Y.Offset)
    end
    object.Position = originalPos
end

local function pulseGlow(object, duration)
    local pulseTween = TweenService:Create(object, 
        TweenInfo.new(duration, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
        {BackgroundTransparency = 0.3}
    )
    pulseTween:Play()
    return pulseTween
end

-- SECUENCIA ÉPICA DE INTRODUCCIÓN
local function startIntro()
    -- Fase 1: Carga con efectos
    fadeIn(initText, 0.8)
    wait(1)
    
    local loadProgress = 0
    local loadTween = TweenService:Create(loadingBar, TweenInfo.new(4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(1, 0, 1, 0)
    })
    loadTween:Play()
    
    -- Animación del porcentaje
    spawn(function()
        while loadProgress < 100 do
            loadProgress = loadProgress + math.random(1, 3)
            if loadProgress > 100 then loadProgress = 100 end
            percentText.Text = loadProgress .. "%"
            wait(0.05)
        end
    end)
    
    -- Pulso en los efectos de brillo
    pulseGlow(glowEffect1, 0.5)
    pulseGlow(glowEffect2, 0.7)
    
    loadTween.Completed:Connect(function()
        fadeOut(initText, 0.5)
        wait(1)
        
        -- Fase 2: Escaneo avanzado
        loadingFrame.Visible = false
        scanFrame.Visible = true
        
        -- Animaciones de líneas de escaneo
        for i, line in ipairs(scanLines) do
            spawn(function()
                wait(i * 0.1)
                local moveTween = TweenService:Create(line, 
                    TweenInfo.new(2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
                    {Position = UDim2.new(0, 0, 1, 0)}
                )
                moveTween:Play()
            end)
        end
        
        -- Aparición del perfil con efectos
        scaleIn(profileContainer, 1.2, UDim2.new(0, 200, 0, 200))
        
        -- Animación de anillos
        for i, ring in ipairs(rings) do
            spawn(function()
                wait(i * 0.3)
                local rotateTween = TweenService:Create(ring,
                    TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
                    {Rotation = 360}
                )
                rotateTween:Play()
            end)
        end
        
        -- Información del jugador aparece gradualmente
        for i, label in ipairs(playerInfo:GetChildren()) do
            if label:IsA("TextLabel") then
                spawn(function()
                    wait(i * 0.5)
                    fadeIn(label, 0.8)
                    glitchEffect(label, 0.3)
                end)
            end
        end
        
        -- Texto de escaneo con efectos
        fadeIn(scanText, 1)
        spawn(function()
            local scanDots = ""
            for i = 1, 15 do
                wait(0.2)
                if #scanDots < 3 then
                    scanDots = scanDots .. "."
                else
                    scanDots = ""
                end
                scanText.Text = "ESCANEANDO SUJETO" .. scanDots
            end
        end)
        
        wait(4)
        
        -- Fase 3: Acceso concedido épico
        scanFrame.Visible = false
        accessFrame.Visible = true
        
        -- Flash de pantalla
        local flashTween = TweenService:Create(flashFrame, TweenInfo.new(0.1, Enum.EasingStyle.Quad), {
            BackgroundTransparency = 0.5
        })
        flashTween:Play()
        flashTween.Completed:Connect(function()
            TweenService:Create(flashFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {
                BackgroundTransparency = 1
            }):Play()
        end)
        
        -- Texto con efectos
        fadeIn(accessText, 0.5)
        glitchEffect(accessText, 0.5)
        
        -- Líneas de energía
        for i, line in ipairs(energyLines) do
            spawn(function()
                wait(i * 0.1)
                local expandTween = TweenService:Create(line, TweenInfo.new(0.8, Enum.EasingStyle.Quad), {
                    Size = UDim2.new(0, line.Size.X.Offset * 2, 0, 4)
                })
                expandTween:Play()
                expandTween.Completed:Connect(function()
                    TweenService:Create(line, TweenInfo.new(0.5, Enum.EasingStyle.Quad), {
                        BackgroundTransparency = 1
                    }):Play()
                end)
            end)
        end
        
        wait(2)
        fadeOut(accessText, 0.8)
        wait(1)
        
        -- Fase 4: Logo cinematográfico
        accessFrame.Visible = false
        logoFrame.Visible = true
        
        -- Rayos de luz rotativos
        for i, ray in ipairs(lightRays) do
            spawn(function()
                local rotateTween = TweenService:Create(ray,
                    TweenInfo.new(8, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
                    {Rotation = ray.Rotation + 360}
                )
                rotateTween:Play()
            end)
        end
        
        -- Partículas flotantes
        for i, particle in ipairs(logoParticles) do
            spawn(function()
                wait(i * 0.05)
                local floatTween = TweenService:Create(particle,
                    TweenInfo.new(math.random(2, 5), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
                    {Position = UDim2.new(particle.Position.X.Scale + math.random(-100, 100)/1000, 0,
                                         particle.Position.Y.Scale + math.random(-50, 50)/1000, 0)}
                )
                floatTween:Play()
                
                local blinkTween = TweenService:Create(particle,
                    TweenInfo.new(math.random(1, 3), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
                    {BackgroundTransparency = math.random(30, 95)/100}
                )
                blinkTween:Play()
            end)
        end
        
        -- Logo con zoom cinematográfico
        logoText.Size = UDim2.new(0, 50, 0, 10)
        logoText.Position = UDim2.new(0.5, -25, 0.5, -5)
        logoText.TextTransparency = 0
        
        local logoZoom = TweenService:Create(logoText, TweenInfo.new(3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 800, 0, 150),
            Position = UDim2.new(0.5, -400, 0.5, -75)
        })
        logoZoom:Play()
        
        -- Efectos de resplandor
        spawn(function()
            wait(1)
            pulseGlow(logoGlow1, 1.5)
            pulseGlow(logoGlow2, 2)
        end)
        
        logoZoom.Completed:Connect(function()
            wait(3)
            
            -- Fade out épico
            local finalFade = TweenService:Create(mainFrame, TweenInfo.new(2, Enum.EasingStyle.Quad), {
                BackgroundTransparency = 1
            })
            local logoFade = fadeOut(logoText, 2)
            
            finalFade:Play()
            
            finalFade.Completed:Connect(function()
                screenGui:Destroy()
            end)
        end)
    end)
end0.5, -300, 0.5, -60)
            })
            logoZoom:Play()
            
            -- Efecto de resplandor
            local glowTween = TweenService:Create(logoGlow, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                BackgroundTransparency = 0.7
            })
            glowTween:Play()
            
            logoZoom.Completed:Connect(function()
                wait(3)
                
                -- Fade out final
                local finalFade = TweenService:Create(mainFrame, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BackgroundTransparency = 1
                })
                local logoFade = fadeOut(logoText, 1)
                local glowFade = TweenService:Create(logoGlow, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    BackgroundTransparency = 1
                })
                
                finalFade:Play()
                glowFade:Play()
                
                finalFade.Completed:Connect(function()
                    screenGui:Destroy()
                end)
            end)
        end)
    end)
end

-- Iniciar la introducción épica
startIntro()