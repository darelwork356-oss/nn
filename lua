-- STRANGER THINGS INTRO AUTÉNTICO - ROBLOX
-- Recreación exacta del intro original

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "StrangerThingsIntro"
screenGui.Parent = playerGui

-- Fondo negro profundo absoluto
local blackFrame = Instance.new("Frame")
blackFrame.Size = UDim2.new(1, 0, 1, 0)
blackFrame.BackgroundColor3 = Color3.new(0, 0, 0)
blackFrame.BorderSizePixel = 0
blackFrame.Parent = screenGui

-- Crear título principal centrado muy grande
local mainTitle = Instance.new("TextLabel")
mainTitle.Size = UDim2.new(0.9, 0, 0.4, 0)
mainTitle.Position = UDim2.new(0.05, 0, 0.3, 0)
mainTitle.BackgroundTransparency = 1
mainTitle.Text = "STRANGER\nTHINGS"
mainTitle.TextColor3 = Color3.new(0.8, 0.1, 0.1) -- Rojo oscuro con brillo
mainTitle.TextScaled = true
mainTitle.Font = Enum.Font.Antique -- Serif retro similar a ITC Benguiat
mainTitle.TextStrokeTransparency = 0.2
mainTitle.TextStrokeColor3 = Color3.new(1, 0.3, 0.3) -- Borde luminoso
mainTitle.TextTransparency = 1
mainTitle.Parent = blackFrame

-- Efecto de resplandor (glow)
local uiStroke = Instance.new("UIStroke")
uiStroke.Color = Color3.new(1, 0.2, 0.2)
uiStroke.Thickness = 3
uiStroke.Transparency = 0.3
uiStroke.Parent = mainTitle

-- Función para crear créditos en blanco
local function createCredit(text, yPos, delay, duration)
    local creditLabel = Instance.new("TextLabel")
    creditLabel.Size = UDim2.new(0.8, 0, 0.06, 0)
    creditLabel.Position = UDim2.new(0.1, 0, yPos, 0)
    creditLabel.BackgroundTransparency = 1
    creditLabel.Text = text
    creditLabel.TextColor3 = Color3.new(1, 1, 1) -- Blanco
    creditLabel.TextScaled = true
    creditLabel.Font = Enum.Font.Gotham
    creditLabel.TextTransparency = 1
    creditLabel.Parent = blackFrame
    
    spawn(function()
        wait(delay)
        -- Fade in lento (1-3 segundos)
        local fadeIn = TweenService:Create(
            creditLabel, 
            TweenInfo.new(2, Enum.EasingStyle.Quad), 
            {TextTransparency = 0}
        )
        fadeIn:Play()
        
        wait(duration)
        
        -- Fade out suave
        local fadeOut = TweenService:Create(
            creditLabel, 
            TweenInfo.new(2, Enum.EasingStyle.Quad), 
            {TextTransparency = 1}
        )
        fadeOut:Play()
        fadeOut.Completed:Connect(function() creditLabel:Destroy() end)
    end)
end

-- Función para crear destellos/parpadeos retro
local function createFlicker(element)
    spawn(function()
        for i = 1, 5 do
            wait(math.random(0.5, 1.5))
            -- Parpadeo sutil como luz imperfecta
            local flicker = TweenService:Create(
                element,
                TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, true),
                {TextTransparency = 0.4}
            )
            flicker:Play()
        end
    end)
end

-- Función principal del intro
local function playStrangerThingsIntro()
    -- Pantalla negra inicial
    wait(2)
    
    -- Movimiento suave de zoom/cámara - letras aparecen muy de cerca
    mainTitle.Size = UDim2.new(1.5, 0, 0.6, 0)
    mainTitle.Position = UDim2.new(-0.25, 0, 0.2, 0)
    
    -- Aparición lenta del título principal (fade in largo)
    local titleAppear = TweenService:Create(
        mainTitle,
        TweenInfo.new(3, Enum.EasingStyle.Quad), -- 3 segundos fade in
        {TextTransparency = 0}
    )
    titleAppear:Play()
    
    -- Movimiento de cámara - zoom out para centrar
    wait(1)
    local zoomOut = TweenService:Create(
        mainTitle,
        TweenInfo.new(4, Enum.EasingStyle.Quad),
        {
            Size = UDim2.new(0.9, 0, 0.4, 0),
            Position = UDim2.new(0.05, 0, 0.3, 0)
        }
    )
    zoomOut:Play()
    
    -- Destellos retro en el título
    createFlicker(mainTitle)
    
    wait(3)
    
    -- Subtítulo BLOGS 2026
    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(0.6, 0, 0.08, 0)
    subtitle.Position = UDim2.new(0.2, 0, 0.75, 0)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "BLOGS 2026"
    subtitle.TextColor3 = Color3.new(0.7, 0.7, 0.7)
    subtitle.TextScaled = true
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextTransparency = 1
    subtitle.Parent = blackFrame
    
    local subtitleAppear = TweenService:Create(
        subtitle,
        TweenInfo.new(2, Enum.EasingStyle.Quad),
        {TextTransparency = 0}
    )
    subtitleAppear:Play()
    
    -- Créditos superpuestos en blanco (ritmo lento y cinematográfico)
    createCredit("Created by", 0.45, 8, 4)
    createCredit("DAREL VEGA", 0.52, 8.5, 4)
    
    createCredit("Programmed by", 0.45, 14, 4)
    createCredit("DAREK AND MALI MENDEZ", 0.52, 14.5, 4)
    
    createCredit("Written by", 0.45, 20, 4)
    createCredit("DAREK", 0.52, 20.5, 4)
    
    -- Mantener título completo hasta el final
    wait(30)
    
    -- Fade out final muy lento
    local finalFade = TweenService:Create(
        blackFrame,
        TweenInfo.new(4, Enum.EasingStyle.Quad),
        {BackgroundTransparency = 1}
    )
    finalFade:Play()
    
    finalFade.Completed:Connect(function()
        screenGui:Destroy()
    end)
end

playStrangerThingsIntro()

_G.StrangerThingsIntro = {
    start = function()
        if screenGui then screenGui:Destroy() end
        wait(0.5)
        playStrangerThingsIntro()
    end
}
