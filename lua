-- STRANGER THINGS INTRO SCRIPT PARA ROBLOX
-- Script completo para recrear el intro épico de Stranger Things

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local SoundService = game:GetService("SoundService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

-- Configuración del intro
local INTRO_DURATION = 60 -- 1 minuto como mencionaste
local FADE_TIME = 2
local TEXT_APPEAR_TIME = 3
local FLICKER_INTENSITY = 0.3

-- Crear GUI principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "StrangerThingsIntro"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.Parent = playerGui

-- Frame principal negro
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(1, 0, 1, 0)
mainFrame.Position = UDim2.new(0, 0, 0, 0)
mainFrame.BackgroundColor3 = Color3.new(0, 0, 0)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Función para crear texto con efecto Stranger Things
local function createStrangerText(text, position, size, delay)
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = size or UDim2.new(0.8, 0, 0.15, 0)
    textLabel.Position = position or UDim2.new(0.1, 0, 0.4, 0)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = ""
    textLabel.TextColor3 = Color3.new(1, 0.2, 0.2) -- Rojo característico
    textLabel.TextScaled = true
    textLabel.Font = Enum.Font.SourceSansBold
    textLabel.TextStrokeTransparency = 0
    textLabel.TextStrokeColor3 = Color3.new(0, 0, 0)
    textLabel.Parent = mainFrame
    
    -- Efecto de aparición letra por letra
    spawn(function()
        wait(delay or 0)
        for i = 1, #text do
            textLabel.Text = string.sub(text, 1, i)
            
            -- Efecto de parpadeo/flicker
            local flickerTween = TweenService:Create(
                textLabel,
                TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, true),
                {TextTransparency = FLICKER_INTENSITY}
            )
            flickerTween:Play()
            
            wait(0.1)
        end
        
        -- Efecto final de brillo
        local glowTween = TweenService:Create(
            textLabel,
            TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            {TextColor3 = Color3.new(1, 0.4, 0.4)}
        )
        glowTween:Play()
    end)
    
    return textLabel
end

-- Función para crear efectos de partículas/chispas
local function createSparkEffect()
    for i = 1, 20 do
        local spark = Instance.new("Frame")
        spark.Size = UDim2.new(0, math.random(2, 6), 0, math.random(2, 6))
        spark.Position = UDim2.new(math.random(), 0, math.random(), 0)
        spark.BackgroundColor3 = Color3.new(1, 1, 0.8)
        spark.BorderSizePixel = 0
        spark.Parent = mainFrame
        
        -- Animación de chispa
        local sparkTween = TweenService:Create(
            spark,
            TweenInfo.new(math.random(1, 3), Enum.EasingStyle.Linear),
            {
                Position = UDim2.new(math.random(), 0, math.random(), 0),
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 0, 0, 0)
            }
        )
        sparkTween:Play()
        
        sparkTween.Completed:Connect(function()
            spark:Destroy()
        end)
    end
end

-- Función principal del intro
local function playStrangerThingsIntro()
    -- Oscurecer la iluminación
    local originalBrightness = Lighting.Brightness
    local darkTween = TweenService:Create(
        Lighting,
        TweenInfo.new(2, Enum.EasingStyle.Quad),
        {Brightness = 0}
    )
    darkTween:Play()
    
    wait(3)
    
    -- Título principal
    local titleText = createStrangerText("STRANGER THINGS", UDim2.new(0.1, 0, 0.35, 0), UDim2.new(0.8, 0, 0.2, 0), 0)
    
    -- Efectos de chispas
    spawn(function()
        for i = 1, 10 do
            createSparkEffect()
            wait(1)
        end
    end)
    
    wait(4)
    
    -- Subtítulo
    local subtitleText = createStrangerText("BLOGS 2026", UDim2.new(0.1, 0, 0.55, 0), UDim2.new(0.8, 0, 0.1, 0), 0)
    
    wait(6)
    
    -- Fade out del título
    local titleFade = TweenService:Create(
        titleText,
        TweenInfo.new(2, Enum.EasingStyle.Quad),
        {TextTransparency = 1}
    )
    local subtitleFade = TweenService:Create(
        subtitleText,
        TweenInfo.new(2, Enum.EasingStyle.Quad),
        {TextTransparency = 1}
    )
    titleFade:Play()
    subtitleFade:Play()
    
    wait(3)
    
    -- CRÉDITOS
    local credits = {
        {text = "CREADOR ORIGINAL", name = "DAREL VEGA", delay = 0},
        {text = "PROGRAMADOR", name = "DAREK AND MALI MENDEZ", delay = 4},
        {text = "GUIÓN", name = "DAREK", delay = 8}
    }
    
    for _, credit in ipairs(credits) do
        spawn(function()
            wait(credit.delay)
            
            -- Texto del rol
            local roleText = createStrangerText(
                credit.text, 
                UDim2.new(0.1, 0, 0.3, 0), 
                UDim2.new(0.8, 0, 0.08, 0), 
                0
            )
            roleText.TextColor3 = Color3.new(0.8, 0.8, 0.8)
            
            wait(1)
            
            -- Nombre de la persona
            local nameText = createStrangerText(
                credit.name, 
                UDim2.new(0.1, 0, 0.45, 0), 
                UDim2.new(0.8, 0, 0.12, 0), 
                0
            )
            
            wait(2.5)
            
            -- Fade out de los créditos
            local roleFade = TweenService:Create(roleText, TweenInfo.new(1), {TextTransparency = 1})
            local nameFade = TweenService:Create(nameText, TweenInfo.new(1), {TextTransparency = 1})
            roleFade:Play()
            nameFade:Play()
        end)
    end
    
    wait(15)
    
    -- ANIMACIÓN ÉPICA FINAL
    local epicText = createStrangerText("THE UPSIDE DOWN AWAITS...", UDim2.new(0.1, 0, 0.4, 0), UDim2.new(0.8, 0, 0.15, 0), 0)
    epicText.TextColor3 = Color3.new(0.5, 0, 1) -- Púrpura místico
    
    -- Efectos finales intensos
    spawn(function()
        for i = 1, 30 do
            createSparkEffect()
            wait(0.2)
        end
    end)
    
    -- Parpadeo épico del texto final
    spawn(function()
        for i = 1, 10 do
            epicText.TextTransparency = 0.5
            wait(0.1)
            epicText.TextTransparency = 0
            wait(0.1)
        end
    end)
    
    wait(8)
    
    -- Fade final y restaurar iluminación
    local finalFade = TweenService:Create(
        mainFrame,
        TweenInfo.new(3, Enum.EasingStyle.Quad),
        {BackgroundTransparency = 1}
    )
    finalFade:Play()
    
    local lightRestore = TweenService:Create(
        Lighting,
        TweenInfo.new(3, Enum.EasingStyle.Quad),
        {Brightness = originalBrightness}
    )
    lightRestore:Play()
    
    finalFade.Completed:Connect(function()
        screenGui:Destroy()
        print("¡Intro de Stranger Things completado!")
    end)
end

-- Función para activar el intro (puedes llamarla cuando quieras)
local function startIntro()
    playStrangerThingsIntro()
end

-- Auto-iniciar el intro (comenta esta línea si no quieres que se inicie automáticamente)
startIntro()

-- Función para reiniciar el intro (opcional)
local function restartIntro()
    if screenGui then
        screenGui:Destroy()
    end
    wait(1)
    startIntro()
end

-- Exportar funciones para uso externo
_G.StrangerThingsIntro = {
    start = startIntro,
    restart = restartIntro
}

print("Script de Stranger Things Intro cargado. Usa _G.StrangerThingsIntro.start() para iniciar manualmente.")
