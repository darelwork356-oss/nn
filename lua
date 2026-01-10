-- STRANGER THINGS POWERS SHOP - VERSIÓN COMPLETA CON ROTACIÓN
-- LOCAL SCRIPT - StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local MarketplaceService = game:GetService("MarketplaceService")
local player = Players.LocalPlayer

print("🔥 Power Shop - Starting...")

-- ESPERAR EVENTOS
local powerEvents = ReplicatedStorage:WaitForChild("PowerEvents", 10)
if not powerEvents then
    warn("❌ PowerEvents not found!")
    return
end

local telekinesisPower = powerEvents:WaitForChild("TelekinesisPower", 5)
local explosionPower = powerEvents:WaitForChild("ExplosionPower", 5)
local controlPower = powerEvents:WaitForChild("ControlPower", 5)
local protectionPower = powerEvents:WaitForChild("ProtectionPower", 5)
local healingPower = powerEvents:WaitForChild("HealingPower", 5)
local lightningPower = powerEvents:WaitForChild("LightningPower", 5)

-- CONFIGURACIÓN
local COOLDOWN_TIMES = {
Telekinesis = 15,
Explosion = 20,
Control = 25,
Protection = 60,
Healing = 18,
Lightning = 12
}

local cooldowns = {}
local unlockedPowers = {}
local powerButtons = {}
local shopOpen = false
local selectedPower = nil
local currentIndex = 1

-- SISTEMA DE ROTACIÓN DE TIENDA
local SHOP_ROTATION_TIME = 120 -- 2 minutos
local shopRotationTimer = SHOP_ROTATION_TIME
local availablePowers = {} -- Poderes disponibles en la tienda actual

-- ID DEL PRODUCTO HEALING (ROBUX)
local HEALING_PRODUCT_ID = 3485680292

-- SONIDO DE COMPRA
local PURCHASE_SOUND_ID = "rbxassetid://81946687425639"

-- DATOS DE PODERES
local POWER_DATA = {
{Name = "Telekinesis", Key = "Q", Color = Color3.fromRGB(138, 43, 226), Rarity = "Legendary", Description = "Levita y controla enemigos con tu mente", Icon = "⚡", Price = 0, IsFree = true},
{Name = "Explosion", Key = "E", Color = Color3.fromRGB(255, 20, 20), Rarity = "Epic", Description = "Explosión psíquica devastadora", Icon = "💥", Price = 0, IsFree = true},
{Name = "Control", Key = "R", Color = Color3.fromRGB(255, 140, 0), Rarity = "Epic", Description = "Control mental masivo de área", Icon = "🌀", Price = 0, IsFree = true},
{Name = "Protection", Key = "T", Color = Color3.fromRGB(255, 10, 10), Rarity = "Rare", Description = "Escudo protector temporal", Icon = "🛡️", Price = 0, IsFree = true},
{Name = "Healing", Key = "F", Color = Color3.fromRGB(0, 255, 127), Rarity = "Common", Description = "Curación instantánea (ROBUX)", Icon = "💚", Price = 30, IsFree = false},
{Name = "Lightning", Key = "G", Color = Color3.fromRGB(100, 200, 255), Rarity = "Epic", Description = "Rayo devastador azul eléctrico", Icon = "⚡", Price = 0, IsFree = true}
}

-- INICIALIZAR COOLDOWNS
for _, power in ipairs(POWER_DATA) do
    cooldowns[power.Name] = 0
end

-- FUNCIÓN PARA ROTAR PODERES DISPONIBLES
local function rotateShopInventory()
    availablePowers = {}
    
    -- Siempre incluir Healing (poder de pago)
    table.insert(availablePowers, "Healing")
    
    -- Seleccionar aleatoriamente 3-5 poderes gratuitos
    local freePowers = {}
    for _, power in ipairs(POWER_DATA) do
        if power.IsFree then
            table.insert(freePowers, power.Name)
        end
    end
    
    -- Mezclar y tomar 3-5 aleatorios
    local count = math.random(3, 5)
    for i = #freePowers, 2, -1 do
        local j = math.random(i)
        freePowers[i], freePowers[j] = freePowers[j], freePowers[i]
    end
    
    for i = 1, math.min(count, #freePowers) do
        table.insert(availablePowers, freePowers[i])
    end
    
    print("🔄 Shop rotated! Available powers:", table.concat(availablePowers, ", "))
    shopRotationTimer = SHOP_ROTATION_TIME
end

-- VERIFICAR SI PODER ESTÁ DISPONIBLE
local function isPowerAvailable(powerName)
    for _, name in ipairs(availablePowers) do
        if name == powerName then
            return true
        end
    end
    return false
end

-- SONIDO DE COMPRA
local function playPurchaseSound()
    local sound = Instance.new("Sound")
    sound.SoundId = PURCHASE_SOUND_ID
    sound.Volume = 0.5
    sound.Parent = workspace
    sound:Play()
    
    sound.Ended:Connect(function()
        sound:Destroy()
    end)
end

-- EFECTOS VISUALES
local function createScreenVignette(color)
    local screenGui = player.PlayerGui:FindFirstChild("PowerShopUI")
    if not screenGui then return end
    
    local vignette = Instance.new("Frame")
    vignette.Size = UDim2.new(1, 0, 1, 0)
    vignette.BackgroundColor3 = color
    vignette.BackgroundTransparency = 1
    vignette.BorderSizePixel = 0
    vignette.ZIndex = 5
    vignette.Parent = screenGui
    
    local gradient = Instance.new("UIGradient")
    gradient.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.5, 0.9),
    NumberSequenceKeypoint.new(1, 0)
    })
    gradient.Parent = vignette
    
    task.spawn(function()
        for i = 1, 3 do
            TweenService:Create(vignette, TweenInfo.new(0.3), {BackgroundTransparency = 0.7}):Play()
            task.wait(0.3)
            TweenService:Create(vignette, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            task.wait(0.3)
        end
        vignette:Destroy()
    end)
end

local function createPowerActivationEffect(powerName, color)
    createScreenVignette(color)
    local screenGui = player.PlayerGui:FindFirstChild("PowerShopUI")
    if not screenGui then return end
    
    local flash = Instance.new("Frame")
    flash.Size = UDim2.new(1, 0, 1, 0)
    flash.BackgroundColor3 = color
    flash.BackgroundTransparency = 0.3
    flash.BorderSizePixel = 0
    flash.ZIndex = 10
    flash.Parent = screenGui
    
    TweenService:Create(flash, TweenInfo.new(0.2), {BackgroundTransparency = 1}):Play()
    task.delay(0.2, function() if flash and flash.Parent then flash:Destroy() end end)
    end
        
        -- FEEDBACK AL USUARIO
        local function showFeedback(message, color)
            local screenGui = player.PlayerGui:FindFirstChild("PowerShopUI")
            if not screenGui then return end
            
            local feedback = Instance.new("TextLabel")
            feedback.Size = UDim2.new(0, 300, 0, 60)
            feedback.Position = UDim2.new(0.5, -150, 0.4, 0)
            feedback.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
            feedback.BackgroundTransparency = 0.2
            feedback.Text = message
            feedback.Font = Enum.Font.GothamBold
            feedback.TextSize = 20
            feedback.TextColor3 = color
            feedback.TextStrokeTransparency = 0
            feedback.ZIndex = 300
            feedback.Parent = screenGui
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0, 10)
            corner.Parent = feedback
            
            TweenService:Create(feedback, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Position = UDim2.new(0.5, -150, 0.35, 0)}):Play()
            
            task.delay(2, function()
                if feedback and feedback.Parent then
                    TweenService:Create(feedback, TweenInfo.new(0.3), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
                    task.wait(0.3)
                    feedback:Destroy()
                end
            end)
        end
        
        -- ICONO TIENDA
        local function createShopIcon(screenGui)
            local shopButton = Instance.new("ImageButton")
            shopButton.Name = "ShopButton"
            shopButton.Size = UDim2.new(0, 36, 0, 36)
            shopButton.Position = UDim2.new(0, 145, 0, 25)
            shopButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            shopButton.BackgroundTransparency = 0.1
            shopButton.BorderSizePixel = 0
            shopButton.ZIndex = 10000
            shopButton.Parent = screenGui
            
            local corner = Instance.new("UICorner")
            corner.CornerRadius = UDim.new(0.5, 0)
            corner.Parent = shopButton
            
            local stroke = Instance.new("UIStroke")
            stroke.Color = Color3.fromRGB(100, 100, 100)
            stroke.Thickness = 1
            stroke.Transparency = 0.3
            stroke.Parent = shopButton
            
            -- ICONO DE TIENDA (DISEÑO VECTORIAL)
            local iconContainer = Instance.new("Frame")
            iconContainer.Size = UDim2.new(0, 20, 0, 20)
            iconContainer.Position = UDim2.new(0.5, -10, 0.5, -10)
            iconContainer.BackgroundTransparency = 1
            iconContainer.ZIndex = 10001
            iconContainer.Parent = shopButton
            
            -- Base de la tienda
            local shopBase = Instance.new("Frame")
            shopBase.Size = UDim2.new(0, 16, 0, 12)
            shopBase.Position = UDim2.new(0, 2, 0, 8)
            shopBase.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
            shopBase.BorderSizePixel = 0
            shopBase.ZIndex = 10002
            shopBase.Parent = iconContainer
            
            local baseCorner = Instance.new("UICorner")
            baseCorner.CornerRadius = UDim.new(0, 2)
            baseCorner.Parent = shopBase
            
            -- Techo de la tienda
            local shopRoof = Instance.new("Frame")
            shopRoof.Size = UDim2.new(0, 18, 0, 6)
            shopRoof.Position = UDim2.new(0, 1, 0, 2)
            shopRoof.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
            shopRoof.BorderSizePixel = 0
            shopRoof.ZIndex = 10003
            shopRoof.Parent = iconContainer
            
            local roofCorner = Instance.new("UICorner")
            roofCorner.CornerRadius = UDim.new(0, 3)
            roofCorner.Parent = shopRoof
            
            -- Puerta
            local door = Instance.new("Frame")
            door.Size = UDim2.new(0, 4, 0, 6)
            door.Position = UDim2.new(0, 8, 0, 14)
            door.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
            door.BorderSizePixel = 0
            door.ZIndex = 10004
            door.Parent = iconContainer
            
            local doorCorner = Instance.new("UICorner")
            doorCorner.CornerRadius = UDim.new(0, 1)
            doorCorner.Parent = door
            
            shopButton.MouseEnter:Connect(function()
                TweenService:Create(shopButton, TweenInfo.new(0.2), {Size = UDim2.new(0, 40, 0, 40), BackgroundColor3 = Color3.fromRGB(45, 45, 45)}):Play()
            end)
            shopButton.MouseLeave:Connect(function()
                TweenService:Create(shopButton, TweenInfo.new(0.2), {Size = UDim2.new(0, 36, 0, 36), BackgroundColor3 = Color3.fromRGB(25, 25, 25)}):Play()
            end)
            
            return shopButton
        end
        
        -- TIENDA MODERNA STRANGER THINGS
        local function createCompactShop(screenGui)
            local shopModal = Instance.new("Frame")
            shopModal.Name = "ShopModal"
            shopModal.Size = UDim2.new(0, 700, 0, 450)
            shopModal.Position = UDim2.new(0.5, -350, 0.5, -225)
            shopModal.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
            shopModal.BorderSizePixel = 0
            shopModal.Visible = false
            shopModal.ZIndex = 5000
            shopModal.Parent = screenGui
            
            local modalCorner = Instance.new("UICorner")
            modalCorner.CornerRadius = UDim.new(0, 20)
            modalCorner.Parent = shopModal
            
            -- BORDE NEÓN ANIMADO STRANGER THINGS
            local modalStroke = Instance.new("UIStroke")
            modalStroke.Color = Color3.fromRGB(255, 0, 100)
            modalStroke.Thickness = 3
            modalStroke.Transparency = 0
            modalStroke.Parent = shopModal
            
            -- EFECTO GLOW EXTERIOR
            local glowFrame = Instance.new("Frame")
            glowFrame.Size = UDim2.new(1, 20, 1, 20)
            glowFrame.Position = UDim2.new(0, -10, 0, -10)
            glowFrame.BackgroundColor3 = Color3.fromRGB(255, 0, 100)
            glowFrame.BackgroundTransparency = 0.8
            glowFrame.BorderSizePixel = 0
            glowFrame.ZIndex = 4999
            glowFrame.Parent = shopModal
            
            local glowCorner = Instance.new("UICorner")
            glowCorner.CornerRadius = UDim.new(0, 25)
            glowCorner.Parent = glowFrame
            
            -- Animación del borde neón
            task.spawn(function()
                while shopModal.Parent do
                    -- Ciclo rojo-azul-púrpura como Stranger Things
                    TweenService:Create(modalStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine), {
                        Color = Color3.fromRGB(0, 150, 255)
                    }):Play()
                    TweenService:Create(glowFrame, TweenInfo.new(1.5, Enum.EasingStyle.Sine), {
                        BackgroundColor3 = Color3.fromRGB(0, 150, 255)
                    }):Play()
                    task.wait(1.5)
                    
                    TweenService:Create(modalStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine), {
                        Color = Color3.fromRGB(138, 43, 226)
                    }):Play()
                    TweenService:Create(glowFrame, TweenInfo.new(1.5, Enum.EasingStyle.Sine), {
                        BackgroundColor3 = Color3.fromRGB(138, 43, 226)
                    }):Play()
                    task.wait(1.5)
                    
                    TweenService:Create(modalStroke, TweenInfo.new(1.5, Enum.EasingStyle.Sine), {
                        Color = Color3.fromRGB(255, 0, 100)
                    }):Play()
                    TweenService:Create(glowFrame, TweenInfo.new(1.5, Enum.EasingStyle.Sine), {
                        BackgroundColor3 = Color3.fromRGB(255, 0, 100)
                    }):Play()
                    task.wait(1.5)
                end
            end)
            
            -- HEADER MODERNO
            local header = Instance.new("Frame")
            header.Size = UDim2.new(1, 0, 0, 80)
            header.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
            header.BorderSizePixel = 0
            header.ZIndex = 5001
            header.Parent = shopModal
            
            local headerCorner = Instance.new("UICorner")
            headerCorner.CornerRadius = UDim.new(0, 20)
            headerCorner.Parent = header
            
            -- GRADIENTE HEADER
            local headerGradient = Instance.new("UIGradient")
            headerGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(25, 15, 35)),
                ColorSequenceKeypoint.new(0.5, Color3.fromRGB(15, 15, 25)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(35, 15, 25))
            }
            headerGradient.Rotation = 45
            headerGradient.Parent = header
            
            -- LOGO STRANGER THINGS CON MÁS ESTILO
            local logo = Instance.new("TextLabel")
            logo.Size = UDim2.new(0, 400, 0, 50)
            logo.Position = UDim2.new(0, 30, 0, 15)
            logo.BackgroundTransparency = 1
            logo.Text = "S T R A N G E R   P O W E R S"
            logo.Font = Enum.Font.GothamBold
            logo.TextSize = 24
            logo.TextColor3 = Color3.fromRGB(255, 50, 50)
            logo.TextStrokeTransparency = 0
            logo.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            logo.TextXAlignment = Enum.TextXAlignment.Left
            logo.ZIndex = 5002
            logo.Parent = header
            
            -- SUBTITULO
            local subtitle = Instance.new("TextLabel")
            subtitle.Size = UDim2.new(0, 300, 0, 25)
            subtitle.Position = UDim2.new(0, 30, 0, 50)
            subtitle.BackgroundTransparency = 1
            subtitle.Text = "THE UPSIDE DOWN SHOP"
            subtitle.Font = Enum.Font.Gotham
            subtitle.TextSize = 14
            subtitle.TextColor3 = Color3.fromRGB(100, 150, 255)
            subtitle.TextStrokeTransparency = 0.3
            subtitle.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            subtitle.TextXAlignment = Enum.TextXAlignment.Left
            subtitle.ZIndex = 5002
            subtitle.Parent = header
            
            -- EFECTO PARPADEO EN EL LOGO
            task.spawn(function()
                while logo.Parent do
                    task.wait(math.random(3, 8))
                    for i = 1, 3 do
                        logo.TextTransparency = 0.7
                        task.wait(0.1)
                        logo.TextTransparency = 0
                        task.wait(0.1)
                    end
                end
            end)
            
            -- TIMER MEJORADO
            local timerContainer = Instance.new("Frame")
            timerContainer.Size = UDim2.new(0, 200, 0, 35)
            timerContainer.Position = UDim2.new(0, 30, 0, 40)
            timerContainer.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            timerContainer.BorderSizePixel = 0
            timerContainer.ZIndex = 5002
            timerContainer.Parent = header
            
            local timerCorner = Instance.new("UICorner")
            timerCorner.CornerRadius = UDim.new(0, 10)
            timerCorner.Parent = timerContainer
            
            local timerGlow = Instance.new("UIStroke")
            timerGlow.Color = Color3.fromRGB(255, 100, 100)
            timerGlow.Thickness = 2
            timerGlow.Transparency = 0.3
            timerGlow.Parent = timerContainer
            
            local timerLabel = Instance.new("TextLabel")
            timerLabel.Name = "RotationTimer"
            timerLabel.Size = UDim2.new(1, 0, 1, 0)
            timerLabel.BackgroundTransparency = 1
            timerLabel.Text = "⚡ RENUEVA EN: 2:00"
            timerLabel.Font = Enum.Font.GothamBold
            timerLabel.TextSize = 16
            timerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
            timerLabel.TextStrokeTransparency = 0.5
            timerLabel.ZIndex = 5003
            timerLabel.Parent = timerContainer
            
            -- BOTÓN X MODERNO
            local closeButton = Instance.new("TextButton")
            closeButton.Name = "CloseButton"
            closeButton.Size = UDim2.new(0, 50, 0, 50)
            closeButton.Position = UDim2.new(1, -65, 0.5, -25)
            closeButton.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
            closeButton.Text = "✕"
            closeButton.Font = Enum.Font.GothamBold
            closeButton.TextSize = 30
            closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            closeButton.BorderSizePixel = 0
            closeButton.ZIndex = 5003
            closeButton.Parent = header
            
            local closeCorner = Instance.new("UICorner")
            closeCorner.CornerRadius = UDim.new(1, 0)
            closeCorner.Parent = closeButton
            
            local closeGlow = Instance.new("UIStroke")
            closeGlow.Color = Color3.fromRGB(255, 100, 100)
            closeGlow.Thickness = 3
            closeGlow.Transparency = 0.5
            closeGlow.Parent = closeButton
            
            -- Efecto hover mejorado
            closeButton.MouseEnter:Connect(function()
                TweenService:Create(closeButton, TweenInfo.new(0.2), {
                    Size = UDim2.new(0, 55, 0, 55),
                    BackgroundColor3 = Color3.fromRGB(255, 50, 50)
                }):Play()
                TweenService:Create(closeGlow, TweenInfo.new(0.2), {Transparency = 0.2}):Play()
            end)
            closeButton.MouseLeave:Connect(function()
                TweenService:Create(closeButton, TweenInfo.new(0.2), {
                    Size = UDim2.new(0, 50, 0, 50),
                    BackgroundColor3 = Color3.fromRGB(200, 30, 30)
                }):Play()
                TweenService:Create(closeGlow, TweenInfo.new(0.2), {Transparency = 0.5}):Play()
            end)
            
            -- CONTENEDOR DEL PRODUCTO MODERNO
            local productBox = Instance.new("Frame")
            productBox.Name = "ProductBox"
            productBox.Size = UDim2.new(1, -40, 0, 250)
            productBox.Position = UDim2.new(0, 20, 0, 100)
            productBox.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
            productBox.BorderSizePixel = 0
            productBox.ZIndex = 5002
            productBox.Parent = shopModal
            
            local boxCorner = Instance.new("UICorner")
            boxCorner.CornerRadius = UDim.new(0, 15)
            boxCorner.Parent = productBox
            
            local boxStroke = Instance.new("UIStroke")
            boxStroke.Color = Color3.fromRGB(100, 100, 150)
            boxStroke.Thickness = 2
            boxStroke.Transparency = 0.3
            boxStroke.Parent = productBox
            
            -- EFECTO GLOW INTERNO
            local innerGlow = Instance.new("Frame")
            innerGlow.Size = UDim2.new(1, -4, 1, -4)
            innerGlow.Position = UDim2.new(0, 2, 0, 2)
            innerGlow.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
            innerGlow.BackgroundTransparency = 0.9
            innerGlow.BorderSizePixel = 0
            innerGlow.ZIndex = 5003
            innerGlow.Parent = productBox
            
            local innerCorner = Instance.new("UICorner")
            innerCorner.CornerRadius = UDim.new(0, 13)
            innerCorner.Parent = innerGlow
            
            -- ICONO MEJORADO (MÁS GRANDE Y ANIMADO)
            local iconContainer = Instance.new("Frame")
            iconContainer.Size = UDim2.new(0, 200, 0, 200)
            iconContainer.Position = UDim2.new(0, 20, 0, 20)
            iconContainer.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
            iconContainer.BorderSizePixel = 0
            iconContainer.ZIndex = 5003
            iconContainer.Parent = productBox
            
            local iconCorner = Instance.new("UICorner")
            iconCorner.CornerRadius = UDim.new(0, 15)
            iconCorner.Parent = iconContainer
            
            local iconStroke = Instance.new("UIStroke")
            iconStroke.Color = Color3.fromRGB(138, 43, 226)
            iconStroke.Thickness = 3
            iconStroke.Transparency = 0.3
            iconStroke.Parent = iconContainer
            
            -- EFECTO PARTÍCULAS ALREDEDOR DEL ICONO
            for i = 1, 8 do
                local particle = Instance.new("Frame")
                particle.Size = UDim2.new(0, 4, 0, 4)
                particle.BackgroundColor3 = Color3.fromRGB(255, 100, 255)
                particle.BorderSizePixel = 0
                particle.ZIndex = 5005
                particle.Parent = iconContainer
                
                local particleCorner = Instance.new("UICorner")
                particleCorner.CornerRadius = UDim.new(1, 0)
                particleCorner.Parent = particle
                
                -- Animación orbital
                task.spawn(function()
                    local angle = (i - 1) * (360 / 8)
                    while particle.Parent do
                        local radius = 90
                        local x = math.cos(math.rad(angle)) * radius + 98
                        local y = math.sin(math.rad(angle)) * radius + 98
                        particle.Position = UDim2.new(0, x, 0, y)
                        angle = angle + 2
                        task.wait(0.05)
                    end
                end)
            end
            
            local powerIcon = Instance.new("TextLabel")
            powerIcon.Name = "PowerIcon"
            powerIcon.Size = UDim2.new(1, 0, 1, 0)
            powerIcon.BackgroundTransparency = 1
            powerIcon.Text = "?"
            powerIcon.TextSize = 120
            powerIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
            powerIcon.TextStrokeTransparency = 0
            powerIcon.TextStrokeColor3 = Color3.fromRGB(138, 43, 226)
            powerIcon.ZIndex = 5004
            powerIcon.Parent = iconContainer
            
            -- Animación de pulso del icono
            task.spawn(function()
                while powerIcon.Parent do
                    TweenService:Create(powerIcon, TweenInfo.new(1, Enum.EasingStyle.Sine), {
                        TextSize = 130
                    }):Play()
                    task.wait(1)
                    TweenService:Create(powerIcon, TweenInfo.new(1, Enum.EasingStyle.Sine), {
                        TextSize = 120
                    }):Play()
                    task.wait(1)
                end
            end)
            
            -- INFO MEJORADA CON EFECTOS
            local infoContainer = Instance.new("Frame")
            infoContainer.Size = UDim2.new(1, -250, 1, -40)
            infoContainer.Position = UDim2.new(0, 240, 0, 20)
            infoContainer.BackgroundTransparency = 1
            infoContainer.ZIndex = 5003
            infoContainer.Parent = productBox
            
            -- FONDO CON GRADIENTE PARA LA INFO
            local infoBg = Instance.new("Frame")
            infoBg.Size = UDim2.new(1, 0, 1, 0)
            infoBg.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
            infoBg.BackgroundTransparency = 0.3
            infoBg.BorderSizePixel = 0
            infoBg.ZIndex = 5002
            infoBg.Parent = infoContainer
            
            local infoBgCorner = Instance.new("UICorner")
            infoBgCorner.CornerRadius = UDim.new(0, 12)
            infoBgCorner.Parent = infoBg
            
            local infoGradient = Instance.new("UIGradient")
            infoGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 25, 45)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(25, 25, 35))
            }
            infoGradient.Rotation = 45
            infoGradient.Parent = infoBg
            
            local powerName = Instance.new("TextLabel")
            powerName.Name = "PowerName"
            powerName.Size = UDim2.new(1, -20, 0, 50)
            powerName.Position = UDim2.new(0, 10, 0, 10)
            powerName.BackgroundTransparency = 1
            powerName.Text = "POWER NAME"
            powerName.Font = Enum.Font.GothamBold
            powerName.TextSize = 32
            powerName.TextColor3 = Color3.fromRGB(255, 255, 255)
            powerName.TextXAlignment = Enum.TextXAlignment.Left
            powerName.TextStrokeTransparency = 0
            powerName.TextStrokeColor3 = Color3.fromRGB(255, 0, 100)
            powerName.ZIndex = 5004
            powerName.Parent = infoContainer
            
            -- Efecto parpadeo en el nombre
            task.spawn(function()
                while powerName.Parent do
                    task.wait(math.random(4, 10))
                    for i = 1, 2 do
                        powerName.TextTransparency = 0.5
                        task.wait(0.1)
                        powerName.TextTransparency = 0
                        task.wait(0.1)
                    end
                end
            end)
            
            local stockLabel = Instance.new("TextLabel")
            stockLabel.Name = "StockLabel"
            stockLabel.Size = UDim2.new(0, 200, 0, 30)
            stockLabel.Position = UDim2.new(0, 10, 0, 65)
            stockLabel.BackgroundTransparency = 1
            stockLabel.Text = "✓ DISPONIBLE"
            stockLabel.Font = Enum.Font.GothamBold
            stockLabel.TextSize = 18
            stockLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            stockLabel.TextXAlignment = Enum.TextXAlignment.Left
            stockLabel.TextStrokeTransparency = 0.5
            stockLabel.ZIndex = 5004
            stockLabel.Parent = infoContainer
            
            local priceLabel = Instance.new("TextLabel")
            priceLabel.Name = "PriceLabel"
            priceLabel.Size = UDim2.new(1, -20, 0, 55)
            priceLabel.Position = UDim2.new(0, 10, 0, 100)
            priceLabel.BackgroundTransparency = 1
            priceLabel.Text = "FREE"
            priceLabel.Font = Enum.Font.GothamBold
            priceLabel.TextSize = 42
            priceLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
            priceLabel.TextXAlignment = Enum.TextXAlignment.Left
            priceLabel.TextStrokeTransparency = 0
            priceLabel.TextStrokeColor3 = Color3.fromRGB(0, 200, 0)
            priceLabel.ZIndex = 5004
            priceLabel.Parent = infoContainer
            
            local rarityBadge = Instance.new("TextLabel")
            rarityBadge.Name = "RarityBadge"
            rarityBadge.Size = UDim2.new(0, 120, 0, 35)
            rarityBadge.Position = UDim2.new(0, 10, 0, 165)
            rarityBadge.BackgroundColor3 = Color3.fromRGB(100, 150, 255)
            rarityBadge.Text = "Rare"
            rarityBadge.Font = Enum.Font.GothamBold
            rarityBadge.TextSize = 18
            rarityBadge.TextColor3 = Color3.fromRGB(255, 255, 255)
            rarityBadge.TextStrokeTransparency = 0.3
            rarityBadge.ZIndex = 5004
            rarityBadge.Parent = infoContainer
            
            local rarityCorner = Instance.new("UICorner")
            rarityCorner.CornerRadius = UDim.new(0, 8)
            rarityCorner.Parent = rarityBadge
            
            local rarityGlow = Instance.new("UIStroke")
            rarityGlow.Color = Color3.fromRGB(150, 200, 255)
            rarityGlow.Thickness = 2
            rarityGlow.Transparency = 0.4
            rarityGlow.Parent = rarityBadge
            
            -- BOTÓN DE ACCIÓN BIEN POSICIONADO
            local actionButton = Instance.new("TextButton")
            actionButton.Name = "ActionButton"
            actionButton.Size = UDim2.new(0, 180, 0, 45)
            actionButton.Position = UDim2.new(0, 240, 0, 180)
            actionButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
            actionButton.Text = "🎁 OBTENER GRATIS"
            actionButton.Font = Enum.Font.GothamBold
            actionButton.TextSize = 18
            actionButton.TextColor3 = Color3.fromRGB(0, 0, 0)
            actionButton.BorderSizePixel = 0
            actionButton.ZIndex = 5004
            actionButton.Parent = productBox
            
            local actionCorner = Instance.new("UICorner")
            actionCorner.CornerRadius = UDim.new(0, 12)
            actionCorner.Parent = actionButton
            
            local actionGlow = Instance.new("UIStroke")
            actionGlow.Color = Color3.fromRGB(150, 255, 150)
            actionGlow.Thickness = 3
            actionGlow.Transparency = 0.3
            actionGlow.Parent = actionButton
            
            -- Animación de pulso del botón
            task.spawn(function()
                while actionButton.Parent do
                    TweenService:Create(actionGlow, TweenInfo.new(1, Enum.EasingStyle.Sine), {
                        Transparency = 0.1
                    }):Play()
                    task.wait(1)
                    TweenService:Create(actionGlow, TweenInfo.new(1, Enum.EasingStyle.Sine), {
                        Transparency = 0.5
                    }):Play()
                    task.wait(1)
                end
            end)
            
            -- Efecto hover mejorado
            actionButton.MouseEnter:Connect(function()
                TweenService:Create(actionButton, TweenInfo.new(0.2), {
                    Size = UDim2.new(0, 210, 0, 55),
                    BackgroundColor3 = Color3.fromRGB(150, 255, 150)
                }):Play()
                TweenService:Create(actionGlow, TweenInfo.new(0.2), {Transparency = 0}):Play()
            end)
            actionButton.MouseLeave:Connect(function()
                TweenService:Create(actionButton, TweenInfo.new(0.2), {
                    Size = UDim2.new(0, 200, 0, 50),
                    BackgroundColor3 = Color3.fromRGB(100, 255, 100)
                }):Play()
                TweenService:Create(actionGlow, TweenInfo.new(0.2), {Transparency = 0.3}):Play()
            end)
            
            -- DESCRIPCIÓN BIEN POSICIONADA
            local descText = Instance.new("TextLabel")
            descText.Name = "DescriptionText"
            descText.Size = UDim2.new(1, -40, 0, 60)
            descText.Position = UDim2.new(0, 20, 0, 370)
            descText.BackgroundColor3 = Color3.fromRGB(15, 15, 25)
            descText.BackgroundTransparency = 0.3
            descText.Text = "Descripción del poder..."
            descText.Font = Enum.Font.Gotham
            descText.TextSize = 16
            descText.TextColor3 = Color3.fromRGB(220, 220, 220)
            descText.TextWrapped = true
            descText.TextXAlignment = Enum.TextXAlignment.Center
            descText.TextYAlignment = Enum.TextYAlignment.Center
            descText.ZIndex = 5003
            descText.Parent = shopModal
            
            local descCorner = Instance.new("UICorner")
            descCorner.CornerRadius = UDim.new(0, 10)
            descCorner.Parent = descText
            
            local descStroke = Instance.new("UIStroke")
            descStroke.Color = Color3.fromRGB(138, 43, 226)
            descStroke.Thickness = 1
            descStroke.Transparency = 0.5
            descStroke.Parent = descText
            
            -- FLECHAS
            local leftArrow = Instance.new("TextButton")
            leftArrow.Name = "LeftArrow"
            leftArrow.Size = UDim2.new(0, 50, 0, 50)
            leftArrow.Position = UDim2.new(0, -65, 0.5, -25)
            leftArrow.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
            leftArrow.Text = "◄"
            leftArrow.Font = Enum.Font.GothamBold
            leftArrow.TextSize = 28
            leftArrow.TextColor3 = Color3.fromRGB(255, 255, 255)
            leftArrow.ZIndex = 5010
            leftArrow.Parent = shopModal
            
            local leftCorner = Instance.new("UICorner")
            leftCorner.CornerRadius = UDim.new(1, 0)
            leftCorner.Parent = leftArrow
            
            local rightArrow = Instance.new("TextButton")
            rightArrow.Name = "RightArrow"
            rightArrow.Size = UDim2.new(0, 50, 0, 50)
            rightArrow.Position = UDim2.new(1, 15, 0.5, -25)
            rightArrow.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
            rightArrow.Text = "►"
            rightArrow.Font = Enum.Font.GothamBold
            rightArrow.TextSize = 28
            rightArrow.TextColor3 = Color3.fromRGB(255, 255, 255)
            rightArrow.ZIndex = 5010
            rightArrow.Parent = shopModal
            
            local rightCorner = Instance.new("UICorner")
            rightCorner.CornerRadius = UDim.new(1, 0)
            rightCorner.Parent = rightArrow
            
            -- Efectos hover flechas
            leftArrow.MouseEnter:Connect(function()
                TweenService:Create(leftArrow, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(138, 43, 226), Size = UDim2.new(0, 55, 0, 55)}):Play()
            end)
            leftArrow.MouseLeave:Connect(function()
                TweenService:Create(leftArrow, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 60), Size = UDim2.new(0, 50, 0, 50)}):Play()
            end)
            
            rightArrow.MouseEnter:Connect(function()
                TweenService:Create(rightArrow, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(138, 43, 226), Size = UDim2.new(0, 55, 0, 55)}):Play()
            end)
            rightArrow.MouseLeave:Connect(function()
                TweenService:Create(rightArrow, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(50, 50, 60), Size = UDim2.new(0, 50, 0, 50)}):Play()
            end)
            
            -- FUNCIÓN ACTUALIZAR PRODUCTO
            local function updateProduct(index)
                local power = POWER_DATA[index]
                if not power then return end
                
                currentIndex = index
                selectedPower = power
                
                -- Verificar disponibilidad
                local isAvailable = isPowerAvailable(power.Name)
                
                -- Actualizar visuales
                powerIcon.Text = power.Icon
                powerIcon.TextColor3 = power.Color
                iconContainer.BackgroundColor3 = Color3.new(
                power.Color.R * 0.3,
                power.Color.G * 0.3,
                power.Color.B * 0.3
                )
                
                powerName.Text = power.Name:upper()
                
                if isAvailable then
                    stockLabel.Text = "✓ DISPONIBLE"
                    stockLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
                else
                    stockLabel.Text = "✕ NO DISPONIBLE"
                    stockLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
                end
                
                if power.IsFree then
                    priceLabel.Text = "GRATIS"
                    priceLabel.TextColor3 = Color3.fromRGB(100, 255, 100)
                else
                    priceLabel.Text = power.Price .. " ROBUX"
                    priceLabel.TextColor3 = Color3.fromRGB(255, 200, 50)
                end
                
                rarityBadge.Text = power.Rarity
                rarityBadge.BackgroundColor3 = power.Color
                descText.Text = power.Description
                
                -- Actualizar botón de acción
                if unlockedPowers[power.Name] then
                    actionButton.Text = "✓ DESBLOQUEADO"
                    actionButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
                elseif not isAvailable then
                    actionButton.Text = "⏳ NO DISPONIBLE"
                    actionButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
                elseif power.IsFree then
                    actionButton.Text = "🎁 OBTENER GRATIS"
                    actionButton.BackgroundColor3 = Color3.fromRGB(100, 255, 100)
                else
                    actionButton.Text = "💰 COMPRAR " .. power.Price .. " R$"
                    actionButton.BackgroundColor3 = Color3.fromRGB(255, 200, 50)
                end
                
                -- Animación
                productBox.Position = UDim2.new(1, 0, 0, 70)
                TweenService:Create(productBox, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Position = UDim2.new(0, 15, 0, 70)
                }):Play()
            end
            
            -- NAVEGACIÓN
            leftArrow.MouseButton1Click:Connect(function()
                currentIndex = currentIndex - 1
                if currentIndex < 1 then currentIndex = #POWER_DATA end
                updateProduct(currentIndex)
            end)
            
            rightArrow.MouseButton1Click:Connect(function()
                currentIndex = currentIndex + 1
                if currentIndex > #POWER_DATA then currentIndex = 1 end
                updateProduct(currentIndex)
            end)
            
            -- BOTÓN DE ACCIÓN
            actionButton.MouseButton1Click:Connect(function()
                if not selectedPower then return end
                
                if unlockedPowers[selectedPower.Name] then
                    showFeedback("⚠️ YA ESTÁ DESBLOQUEADO", Color3.fromRGB(255, 200, 100))
                    return
                end
                
                if not isPowerAvailable(selectedPower.Name) then
                    showFeedback("⏳ ESTE PODER NO ESTÁ DISPONIBLE AHORA", Color3.fromRGB(255, 150, 50))
                    return
                end
                
                if selectedPower.Name == "Healing" and not selectedPower.IsFree then
                    print("💰 Opening Robux purchase...")
                    pcall(function()
                        MarketplaceService:PromptProductPurchase(player, HEALING_PRODUCT_ID)
                    end)
                else
                    print("🎁 Unlocking free power:", selectedPower.Name)
                    unlockedPowers[selectedPower.Name] = true
                    playPurchaseSound()
                    updateProduct(currentIndex)
                    updatePowerBar()
                    showFeedback("✅ PODER DESBLOQUEADO: " .. selectedPower.Name:upper(), Color3.fromRGB(100, 255, 100))
                end
            end)
            
            -- CERRAR
            closeButton.MouseButton1Click:Connect(function()
                shopOpen = false
                TweenService:Create(shopModal, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 0, 0, 0),
                Position = UDim2.new(0.5, 0, 0.5, 0)
                }):Play()
                task.wait(0.3)
                shopModal.Visible = false
            end)
            
            -- Inicializar
            updateProduct(1)
            
            return shopModal, timerLabel
        end
        
        -- POWER BAR
        local function createCompactPowerBar(screenGui)
            local powerBar = Instance.new("Frame")
            powerBar.Name = "CompactPowerBar"
            powerBar.Size = UDim2.new(0, 0, 0, 65)
            powerBar.Position = UDim2.new(0.5, 0, 1, -85)
            powerBar.AnchorPoint = Vector2.new(0.5, 0)
            powerBar.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
            powerBar.BackgroundTransparency = 0.2
            powerBar.BorderSizePixel = 0
            powerBar.ZIndex = 150
            powerBar.Parent = screenGui
            
            local barCorner = Instance.new("UICorner")
            barCorner.CornerRadius = UDim.new(0, 10)
            barCorner.Parent = powerBar
            
            local barStroke = Instance.new("UIStroke")
            barStroke.Color = Color3.fromRGB(200, 50, 50)
            barStroke.Thickness = 2
            barStroke.Transparency = 0.5
            barStroke.Parent = powerBar
            
            local listLayout = Instance.new("UIListLayout")
            listLayout.FillDirection = Enum.FillDirection.Horizontal
            listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
            listLayout.Padding = UDim.new(0, 8)
            listLayout.Parent = powerBar
            
            local padding = Instance.new("UIPadding")
            padding.PaddingTop = UDim.new(0, 8)
            padding.PaddingBottom = UDim.new(0, 8)
            padding.PaddingLeft = UDim.new(0, 12)
            padding.PaddingRight = UDim.new(0, 12)
            padding.Parent = powerBar
            
            return powerBar
        end
        
        -- CREAR BOTÓN DE PODER
        local function createPowerButton(powerData, powerBar)
            local buttonContainer = Instance.new("Frame")
            buttonContainer.Name = powerData.Name .. "Container"
            buttonContainer.Size = UDim2.new(0, 55, 0, 55)
            buttonContainer.BackgroundTransparency = 1
            buttonContainer.Visible = false
            buttonContainer.ZIndex = 151
            buttonContainer.Parent = powerBar
            
            local button = Instance.new("TextButton")
            button.Size = UDim2.new(1, 0, 1, 0)
            button.BackgroundColor3 = powerData.Color
            button.Text = ""
            button.BorderSizePixel = 0
            button.AutoButtonColor = false
            button.ZIndex = 151
            button.Parent = buttonContainer
            
            local buttonCorner = Instance.new("UICorner")
            buttonCorner.CornerRadius = UDim.new(0, 10)
            buttonCorner.Parent = button
            
            local buttonStroke = Instance.new("UIStroke")
            buttonStroke.Color = Color3.fromRGB(255, 255, 255)
            buttonStroke.Thickness = 2.5
            buttonStroke.Transparency = 0.6
            buttonStroke.Parent = button
            
            local overlay = Instance.new("Frame")
            overlay.Name = "CooldownOverlay"
            overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            overlay.BackgroundTransparency = 0.2
            overlay.Size = UDim2.new(1, 0, 1, 0)
            overlay.BorderSizePixel = 0
            overlay.ZIndex = 152
            overlay.Parent = button
            
            local overlayCorner = Instance.new("UICorner")
            overlayCorner.CornerRadius = UDim.new(0, 10)
            overlayCorner.Parent = overlay
            
            local timerText = Instance.new("TextLabel")
            timerText.Size = UDim2.new(1, 0, 1, 0)
            timerText.BackgroundTransparency = 1
            timerText.Text = ""
            timerText.Font = Enum.Font.GothamBold
            timerText.TextSize = 22
            timerText.TextColor3 = Color3.new(1, 1, 1)
            timerText.TextStrokeTransparency = 0
            timerText.ZIndex = 153
            timerText.Parent = overlay
            
            local keyLabel = Instance.new("TextLabel")
            keyLabel.Size = UDim2.new(0, 20, 0, 20)
            keyLabel.Position = UDim2.new(1, -23, 1, -23)
            keyLabel.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            keyLabel.BackgroundTransparency = 0.3
            keyLabel.Text = powerData.Key
            keyLabel.Font = Enum.Font.GothamBold
            keyLabel.TextSize = 13
            keyLabel.TextColor3 = Color3.new(1, 1, 1)
            keyLabel.BorderSizePixel = 0
            keyLabel.ZIndex = 154
            keyLabel.Parent = button
            
            local keyCorner = Instance.new("UICorner")
            keyCorner.CornerRadius = UDim.new(0, 5)
            keyCorner.Parent = keyLabel
            
            button.MouseEnter:Connect(function()
                TweenService:Create(button, TweenInfo.new(0.2), {Size = UDim2.new(1, 6, 1, 6)}):Play()
                TweenService:Create(buttonStroke, TweenInfo.new(0.2), {Transparency = 0.2}):Play()
            end)
            button.MouseLeave:Connect(function()
                TweenService:Create(button, TweenInfo.new(0.2), {Size = UDim2.new(1, 0, 1, 0)}):Play()
                TweenService:Create(buttonStroke, TweenInfo.new(0.2), {Transparency = 0.6}):Play()
            end)
            
            return {
            Container = buttonContainer,
            Button = button,
            Overlay = overlay,
            Timer = timerText,
            KeyCode = Enum.KeyCode[powerData.Key],
            Color = powerData.Color
            }
        end
        
        -- ACTUALIZAR BARRA
        function updatePowerBar()
            local powerBar = player.PlayerGui.PowerShopUI:FindFirstChild("CompactPowerBar")
            if not powerBar then return end
            
            local unlockedCount = 0
            for powerName, isUnlocked in pairs(unlockedPowers) do
                if isUnlocked then
                    unlockedCount = unlockedCount + 1
                    if powerButtons[powerName] then
                        powerButtons[powerName].Container.Visible = true
                    end
                end
            end
            
            local newWidth = math.max(100, unlockedCount * 63 + 24)
            TweenService:Create(powerBar, TweenInfo.new(0.3), {Size = UDim2.new(0, newWidth, 0, 65)}):Play()
        end
        
        -- COOLDOWN
        local function startCooldown(powerName, duration)
            local data = powerButtons[powerName]
            if not data then return end
            
            data.Overlay.Size = UDim2.new(1, 0, 1, 0)
            data.Timer.Text = tostring(duration)
            
            TweenService:Create(data.Overlay, TweenInfo.new(duration, Enum.EasingStyle.Linear), {Size = UDim2.new(1, 0, 0, 0)}):Play()
            
            local startTime = tick()
            local connection
            connection = RunService.Heartbeat:Connect(function()
                local remaining = duration - (tick() - startTime)
                if remaining <= 0 then
                    data.Timer.Text = ""
                    connection:Disconnect()
                else
                    data.Timer.Text = tostring(math.ceil(remaining))
                end
            end)
        end
        
        -- OBTENER JUGADOR OBJETIVO
        local function getTargetPlayer()
            local mouse = player:GetMouse()
            local mouseTarget = mouse.Target
            local MAX_TARGET_RANGE = 70
            
            if mouseTarget then
                local character = mouseTarget:FindFirstAncestorOfClass("Model")
                if character and character:FindFirstChild("Humanoid") then
                    local targetPlayer = Players:GetPlayerFromCharacter(character)
                    if targetPlayer and targetPlayer ~= player then
                        return targetPlayer
                    end
                end
            end
            
            local playerCharacter = player.Character
            if playerCharacter and playerCharacter:FindFirstChild("HumanoidRootPart") then
                local closestPlayer, closestDistance = nil, MAX_TARGET_RANGE
                
                for _, otherPlayer in pairs(Players:GetPlayers()) do
                    if otherPlayer ~= player and otherPlayer.Character and otherPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        local distance = (playerCharacter.HumanoidRootPart.Position - otherPlayer.Character.HumanoidRootPart.Position).Magnitude
                        if distance < closestDistance then
                            closestDistance = distance
                            closestPlayer = otherPlayer
                        end
                    end
                end
                
                return closestPlayer
            end
            
            return nil
        end
        
        -- USAR PODER
        local function handlePowerUse(powerName, target)
            if not unlockedPowers[powerName] then
                showFeedback("🔒 PODER BLOQUEADO - ABRE LA TIENDA", Color3.fromRGB(255, 100, 100))
                return
            end
            
            local now = tick()
            if cooldowns[powerName] > now then
                local remaining = math.ceil(cooldowns[powerName] - now)
                showFeedback("⏱️ COOLDOWN: " .. remaining .. "s", Color3.fromRGB(255, 200, 100))
                return
            end
            
            local targetRequired = (powerName == "Telekinesis" or powerName == "Explosion" or powerName == "Healing" or powerName == "Lightning")
            if targetRequired and not target then
                showFeedback("⚠️ APUNTA A UN JUGADOR", Color3.fromRGB(255, 150, 50))
                return
            end
            
            local success = false
            if powerName == "Telekinesis" and target then
                telekinesisPower:FireServer(target)
                success = true
            elseif powerName == "Explosion" and target then
                explosionPower:FireServer(target)
                success = true
            elseif powerName == "Control" then
                controlPower:FireServer()
                success = true
            elseif powerName == "Protection" then
                protectionPower:FireServer()
                success = true
            elseif powerName == "Healing" and target then
                healingPower:FireServer(target)
                success = true
            elseif powerName == "Lightning" and target then
                lightningPower:FireServer(target)
                success = true
            end
            
            if success then
                cooldowns[powerName] = now + COOLDOWN_TIMES[powerName]
                startCooldown(powerName, COOLDOWN_TIMES[powerName])
                createPowerActivationEffect(powerName, powerButtons[powerName].Color)
                showFeedback("⚡ " .. powerName:upper() .. " ACTIVADO", powerButtons[powerName].Color)
            end
        end
        
        -- INPUT TECLADO
        local function handleKeyboardInput(input, gameProcessed)
            if gameProcessed then return end
            for powerName, data in pairs(powerButtons) do
                if input.KeyCode == data.KeyCode then
                    handlePowerUse(powerName, getTargetPlayer())
                    break
                end
            end
        end
        
        -- COMPRA ROBUX
        MarketplaceService.PromptProductPurchaseFinished:Connect(function(userId, productId, wasPurchased)
            if userId == player.UserId and productId == HEALING_PRODUCT_ID and wasPurchased then
                print("✅ Healing Power purchased!")
                unlockedPowers["Healing"] = true
                playPurchaseSound()
                updatePowerBar()
                showFeedback("✅ HEALING POWER COMPRADO", Color3.fromRGB(100, 255, 100))
            end
        end)
        
        -- INICIALIZAR
        local function initialize()
            print("🚀 Power Shop - Initializing...")
            
            local screenGui = Instance.new("ScreenGui")
            screenGui.Name = "PowerShopUI"
            screenGui.Parent = player:WaitForChild("PlayerGui")
            screenGui.DisplayOrder = 10
            screenGui.ResetOnSpawn = false
            screenGui.IgnoreGuiInset = true
            
            -- Iniciar rotación
            rotateShopInventory()
            
            local shopButton = createShopIcon(screenGui)
            local shopModal, timerLabel = createCompactShop(screenGui)
            local powerBar = createCompactPowerBar(screenGui)
            
            -- Crear botones
            for _, powerData in ipairs(POWER_DATA) do
                powerButtons[powerData.Name] = createPowerButton(powerData, powerBar)
                powerButtons[powerData.Name].Button.MouseButton1Click:Connect(function()
                    local targetRequired = (powerData.Name == "Telekinesis" or powerData.Name == "Explosion" or powerData.Name == "Healing" or powerData.Name == "Lightning")
                    handlePowerUse(powerData.Name, targetRequired and getTargetPlayer())
                end)
            end
            
            -- Botón tienda
            shopButton.MouseButton1Click:Connect(function()
                shopOpen = not shopOpen
                
                if shopOpen then
                    shopModal.Visible = true
                    shopModal.Size = UDim2.new(0, 0, 0, 0)
                    shopModal.Position = UDim2.new(0.5, 0, 0.5, 0)
                    TweenService:Create(shopModal, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, 620, 0, 340),
                    Position = UDim2.new(0.5, -310, 0.5, -170)
                    }):Play()
                else
                    TweenService:Create(shopModal, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                    Size = UDim2.new(0, 0, 0, 0),
                    Position = UDim2.new(0.5, 0, 0.5, 0)
                    }):Play()
                    task.wait(0.3)
                    shopModal.Visible = false
                end
            end)
            
            UserInputService.InputBegan:Connect(handleKeyboardInput)
            
            -- Timer de rotación
            task.spawn(function()
                while true do
                    task.wait(1)
                    shopRotationTimer = shopRotationTimer - 1
                    
                    if shopRotationTimer <= 0 then
                        rotateShopInventory()
                        showFeedback("🔄 ¡TIENDA RENOVADA!", Color3.fromRGB(255, 200, 50))
                    end
                    
                    local minutes = math.floor(shopRotationTimer / 60)
                    local seconds = shopRotationTimer % 60
                    timerLabel.Text = string.format("🔄 Renueva en: %d:%02d", minutes, seconds)
                    
                    if shopRotationTimer <= 10 then
                        timerLabel.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
                    else
                        timerLabel.BackgroundColor3 = Color3.fromRGB(100, 100, 255)
                    end
                end
            end)
            
            print("✅ Power Shop - Ready!")
        end
        
        initialize()
