-- LocalScript para Introducción de Stranger Things
-- Colocar en StarterPlayerScripts

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Crear ScreenGui principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "StrangerThingsIntro"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder = 999
screenGui.Parent = playerGui

-- Frame principal (fondo negro)
local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(1, 0, 1, 0)
mainFrame.Position = UDim2.new(0, 0, 0, 0)
mainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- FASE 1: PANTALLA DE CARGA
local loadingFrame = Instance.new("Frame")
loadingFrame.Name = "LoadingFrame"
loadingFrame.Size = UDim2.new(1, 0, 1, 0)
loadingFrame.BackgroundTransparency = 1
loadingFrame.Parent = mainFrame

-- Barra de carga contenedor
local loadingBarBG = Instance.new("Frame")
loadingBarBG.Name = "LoadingBarBG"
loadingBarBG.Size = UDim2.new(0, 400, 0, 8)
loadingBarBG.Position = UDim2.new(0.5, -200, 0.5, -4)
loadingBarBG.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
loadingBarBG.BorderSizePixel = 0
loadingBarBG.Parent = loadingFrame

-- Esquinas redondeadas para el fondo
local bgCorner = Instance.new("UICorner")
bgCorner.CornerRadius = UDim.new(0, 4)
bgCorner.Parent = loadingBarBG

-- Barra de carga roja
local loadingBar = Instance.new("Frame")
loadingBar.Name = "LoadingBar"
loadingBar.Size = UDim2.new(0, 0, 1, 0)
loadingBar.Position = UDim2.new(0, 0, 0, 0)
loadingBar.BackgroundColor3 = Color3.new(0.8, 0.1, 0.1)
loadingBar.BorderSizePixel = 0
loadingBar.Parent = loadingBarBG

-- Esquinas redondeadas para la barra
local barCorner = Instance.new("UICorner")
barCorner.CornerRadius = UDim.new(0, 4)
barCorner.Parent = loadingBar

-- Efecto de brillo en la barra
local glowEffect = Instance.new("Frame")
glowEffect.Name = "GlowEffect"
glowEffect.Size = UDim2.new(1, 20, 1, 20)
glowEffect.Position = UDim2.new(0, -10, 0, -10)
glowEffect.BackgroundColor3 = Color3.new(0.8, 0.1, 0.1)
glowEffect.BackgroundTransparency = 0.7
glowEffect.BorderSizePixel = 0
glowEffect.Parent = loadingBar

local glowCorner = Instance.new("UICorner")
glowCorner.CornerRadius = UDim.new(0, 8)
glowCorner.Parent = glowEffect

-- FASE 2: PANTALLA DE ESCANEO
local scanFrame = Instance.new("Frame")
scanFrame.Name = "ScanFrame"
scanFrame.Size = UDim2.new(1, 0, 1, 0)
scanFrame.BackgroundTransparency = 1
scanFrame.Visible = false
scanFrame.Parent = mainFrame

-- Imagen de perfil del jugador
local profileImage = Instance.new("ImageLabel")
profileImage.Name = "ProfileImage"
profileImage.Size = UDim2.new(0, 150, 0, 150)
profileImage.Position = UDim2.new(0.5, -75, 0.5, -100)
profileImage.BackgroundTransparency = 1
profileImage.Image = Players:GetUserThumbnailAsync(player.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
profileImage.Parent = scanFrame

-- Marco rojo alrededor de la imagen
local imageFrame = Instance.new("Frame")
imageFrame.Name = "ImageFrame"
imageFrame.Size = UDim2.new(0, 160, 0, 160)
imageFrame.Position = UDim2.new(0.5, -80, 0.5, -105)
imageFrame.BackgroundTransparency = 1
imageFrame.BorderSizePixel = 2
imageFrame.BorderColor3 = Color3.new(0.8, 0.1, 0.1)
imageFrame.Parent = scanFrame

local frameCorner = Instance.new("UICorner")
frameCorner.CornerRadius = UDim.new(0, 8)
frameCorner.Parent = imageFrame

local frameStroke = Instance.new("UIStroke")
frameStroke.Color = Color3.new(0.8, 0.1, 0.1)
frameStroke.Thickness = 2
frameStroke.Parent = imageFrame

-- Texto "ESCANEANDO..."
local scanText = Instance.new("TextLabel")
scanText.Name = "ScanText"
scanText.Size = UDim2.new(0, 300, 0, 50)
scanText.Position = UDim2.new(0.5, -150, 0.5, 80)
scanText.BackgroundTransparency = 1
scanText.Text = "ESCANEANDO"
scanText.TextColor3 = Color3.new(0.9, 0.9, 0.9)
scanText.TextScaled = true
scanText.Font = Enum.Font.Code
scanText.Parent = scanFrame

-- FASE 3: ACCESO CONCEDIDO
local accessFrame = Instance.new("Frame")
accessFrame.Name = "AccessFrame"
accessFrame.Size = UDim2.new(1, 0, 1, 0)
accessFrame.BackgroundTransparency = 1
accessFrame.Visible = false
accessFrame.Parent = mainFrame

local accessText = Instance.new("TextLabel")
accessText.Name = "AccessText"
accessText.Size = UDim2.new(0, 400, 0, 80)
accessText.Position = UDim2.new(0.5, -200, 0.5, -40)
accessText.BackgroundTransparency = 1
accessText.Text = "ACCESO CONCEDIDO"
accessText.TextColor3 = Color3.new(0.8, 0.1, 0.1)
accessText.TextScaled = true
accessText.Font = Enum.Font.Code
accessText.TextTransparency = 1
accessText.Parent = accessFrame

-- FASE 4: LOGO DE STRANGER THINGS
local logoFrame = Instance.new("Frame")
logoFrame.Name = "LogoFrame"
logoFrame.Size = UDim2.new(1, 0, 1, 0)
logoFrame.BackgroundTransparency = 1
logoFrame.Visible = false
logoFrame.Parent = mainFrame

local logoText = Instance.new("TextLabel")
logoText.Name = "LogoText"
logoText.Size = UDim2.new(0, 600, 0, 120)
logoText.Position = UDim2.new(0.5, -300, 0.5, -60)
logoText.BackgroundTransparency = 1
logoText.Text = "STRANGER THINGS"
logoText.TextColor3 = Color3.new(0.9, 0.1, 0.1)
logoText.TextScaled = true
logoText.Font = Enum.Font.Code
logoText.TextStrokeTransparency = 0.5
logoText.TextStrokeColor3 = Color3.new(0.9, 0.1, 0.1)
logoText.TextTransparency = 1
logoText.Parent = logoFrame

-- Efecto de resplandor en el logo
local logoGlow = Instance.new("Frame")
logoGlow.Name = "LogoGlow"
logoGlow.Size = UDim2.new(0, 620, 0, 140)
logoGlow.Position = UDim2.new(0.5, -310, 0.5, -70)
logoGlow.BackgroundColor3 = Color3.new(0.9, 0.1, 0.1)
logoGlow.BackgroundTransparency = 0.9
logoGlow.BorderSizePixel = 0
logoGlow.Parent = logoFrame

local logoGlowCorner = Instance.new("UICorner")
logoGlowCorner.CornerRadius = UDim.new(0, 20)
logoGlowCorner.Parent = logoGlow

-- FUNCIONES DE ANIMACIÓN
local function fadeIn(object, duration)
    local tween = TweenService:Create(object, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        TextTransparency = 0
    })
    tween:Play()
    return tween
end

local function fadeOut(object, duration)
    local tween = TweenService:Create(object, TweenInfo.new(duration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        TextTransparency = 1
    })
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

-- SECUENCIA DE INTRODUCCIÓN
local function startIntro()
    -- Fase 1: Animación de carga
    local loadTween = TweenService:Create(loadingBar, TweenInfo.new(3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
        Size = UDim2.new(1, 0, 1, 0)
    })
    loadTween:Play()
    
    loadTween.Completed:Connect(function()
        wait(0.5)
        
        -- Transición a escaneo
        loadingFrame.Visible = false
        scanFrame.Visible = true
        
        -- Animación de aparición de imagen y marco
        scaleIn(profileImage, 0.8, UDim2.new(0, 150, 0, 150))
        scaleIn(imageFrame, 0.8, UDim2.new(0, 160, 0, 160))
        
        -- Animación de texto escaneando con puntos
        local scanDots = ""
        local dotCount = 0
        local scanConnection
        scanConnection = RunService.Heartbeat:Connect(function()
            dotCount = dotCount + 1
            if dotCount >= 60 then -- Cambia cada segundo aprox
                dotCount = 0
                if #scanDots < 3 then
                    scanDots = scanDots .. "."
                else
                    scanDots = ""
                end
                scanText.Text = "ESCANEANDO" .. scanDots
            end
        end)
        
        wait(3)
        scanConnection:Disconnect()
        
        -- Fase 3: Acceso concedido
        scanFrame.Visible = false
        accessFrame.Visible = true
        
        local accessTween = fadeIn(accessText, 0.5)
        accessTween.Completed:Connect(function()
            wait(1)
            fadeOut(accessText, 0.5)
            wait(0.5)
            
            -- Fase 4: Logo final
            accessFrame.Visible = false
            logoFrame.Visible = true
            
            -- Efecto de zoom del logo
            logoText.Size = UDim2.new(0, 100, 0, 20)
            logoText.Position = UDim2.new(0.5, -50, 0.5, -10)
            logoText.TextTransparency = 0
            
            local logoZoom = TweenService:Create(logoText, TweenInfo.new(2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 600, 0, 120),
                Position = UDim2.new(0.5, -300, 0.5, -60)
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

-- Iniciar la introducción
startIntro()