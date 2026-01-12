-- HAWKINS WELCOME SIGN SCRIPT
-- Colocar en ServerScriptService

local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

-- Configuración del cartel
local SIGN_CONFIG = {
    POLE_HEIGHT = 25,
    POLE_WIDTH = 1,
    SIGN_WIDTH = 12,
    SIGN_HEIGHT = 6,
    SIGN_THICKNESS = 0.5
}

-- Función para crear el cartel completo
local function createHawkinsSign()
    -- Modelo principal
    local signModel = Instance.new("Model")
    signModel.Name = "HawkinsWelcomeSign"
    signModel.Parent = workspace
    
    -- BASE DEL POSTE
    local base = Instance.new("Part")
    base.Name = "Base"
    base.Size = Vector3.new(3, 1, 3)
    base.Position = Vector3.new(0, 0.5, 0)
    base.Material = Enum.Material.Concrete
    base.Color = Color3.new(0.4, 0.4, 0.4)
    base.Anchored = true
    base.Parent = signModel
    
    -- POSTE PRINCIPAL
    local pole = Instance.new("Part")
    pole.Name = "Pole"
    pole.Size = Vector3.new(SIGN_CONFIG.POLE_WIDTH, SIGN_CONFIG.POLE_HEIGHT, SIGN_CONFIG.POLE_WIDTH)
    pole.Position = Vector3.new(0, SIGN_CONFIG.POLE_HEIGHT/2 + 1, 0)
    pole.Material = Enum.Material.Metal
    pole.Color = Color3.new(0.2, 0.2, 0.2)
    pole.Anchored = true
    pole.Parent = signModel
    
    -- SOPORTE HORIZONTAL
    local support = Instance.new("Part")
    support.Name = "Support"
    support.Size = Vector3.new(SIGN_CONFIG.SIGN_WIDTH + 2, 0.5, 0.5)
    support.Position = Vector3.new(0, SIGN_CONFIG.POLE_HEIGHT - 2, 0)
    support.Material = Enum.Material.Metal
    support.Color = Color3.new(0.2, 0.2, 0.2)
    support.Anchored = true
    support.Parent = signModel
    
    -- CARTEL PRINCIPAL
    local sign = Instance.new("Part")
    sign.Name = "Sign"
    sign.Size = Vector3.new(SIGN_CONFIG.SIGN_WIDTH, SIGN_CONFIG.SIGN_HEIGHT, SIGN_CONFIG.SIGN_THICKNESS)
    sign.Position = Vector3.new(0, SIGN_CONFIG.POLE_HEIGHT - 5, 0)
    sign.Material = Enum.Material.SmoothPlastic
    sign.Color = Color3.new(0.1, 0.3, 0.1)
    sign.Anchored = true
    sign.Parent = signModel
    
    -- BORDE DEL CARTEL
    local border = Instance.new("Part")
    border.Name = "Border"
    border.Size = Vector3.new(SIGN_CONFIG.SIGN_WIDTH + 0.5, SIGN_CONFIG.SIGN_HEIGHT + 0.5, SIGN_CONFIG.SIGN_THICKNESS + 0.1)
    border.Position = sign.Position
    border.Material = Enum.Material.Metal
    border.Color = Color3.new(0.8, 0.8, 0.8)
    border.Anchored = true
    border.Parent = signModel
    
    -- TEXTO PRINCIPAL
    local surfaceGui = Instance.new("SurfaceGui")
    surfaceGui.Face = Enum.NormalId.Front
    surfaceGui.Parent = sign
    
    local mainText = Instance.new("TextLabel")
    mainText.Size = UDim2.new(1, 0, 0.6, 0)
    mainText.Position = UDim2.new(0, 0, 0.1, 0)
    mainText.BackgroundTransparency = 1
    mainText.Text = "WELCOME TO"
    mainText.TextColor3 = Color3.new(1, 1, 1)
    mainText.TextScaled = true
    mainText.Font = Enum.Font.SourceSansBold
    mainText.TextStrokeTransparency = 0.5
    mainText.TextStrokeColor3 = Color3.new(0, 0, 0)
    mainText.Parent = surfaceGui
    
    local hawkinsText = Instance.new("TextLabel")
    hawkinsText.Size = UDim2.new(1, 0, 0.4, 0)
    hawkinsText.Position = UDim2.new(0, 0, 0.6, 0)
    hawkinsText.BackgroundTransparency = 1
    hawkinsText.Text = "HAWKINS"
    hawkinsText.TextColor3 = Color3.new(0.9, 0.1, 0.1)
    hawkinsText.TextScaled = true
    hawkinsText.Font = Enum.Font.SourceSansBold
    hawkinsText.TextStrokeTransparency = 0.3
    hawkinsText.TextStrokeColor3 = Color3.new(0, 0, 0)
    hawkinsText.Parent = surfaceGui
    
    -- TEXTO TRASERO
    local backSurfaceGui = Instance.new("SurfaceGui")
    backSurfaceGui.Face = Enum.NormalId.Back
    backSurfaceGui.Parent = sign
    
    local backMainText = mainText:Clone()
    backMainText.Parent = backSurfaceGui
    
    local backHawkinsText = hawkinsText:Clone()
    backHawkinsText.Parent = backSurfaceGui
    
    -- LUCES DECORATIVAS
    for i = 1, 4 do
        local light = Instance.new("Part")
        light.Name = "Light" .. i
        light.Size = Vector3.new(0.3, 0.3, 0.3)
        light.Shape = Enum.PartType.Ball
        light.Material = Enum.Material.Neon
        light.Color = Color3.new(1, 1, 0.8)
        light.Anchored = true
        light.Parent = signModel
        
        -- Posicionar luces en las esquinas
        local xPos = (i <= 2) and -SIGN_CONFIG.SIGN_WIDTH/2 + 1 or SIGN_CONFIG.SIGN_WIDTH/2 - 1
        local yPos = (i == 1 or i == 3) and sign.Position.Y + SIGN_CONFIG.SIGN_HEIGHT/2 - 0.5 or sign.Position.Y - SIGN_CONFIG.SIGN_HEIGHT/2 + 0.5
        light.Position = Vector3.new(xPos, yPos, sign.Position.Z + 0.5)
        
        -- Efecto de parpadeo
        spawn(function()
            while light.Parent do
                local flickerTween = TweenService:Create(light,
                    TweenInfo.new(math.random(1, 3), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut),
                    {Transparency = math.random(0, 30)/100}
                )
                flickerTween:Play()
                wait(math.random(1, 4))
            end
        end)
    end
    
    -- SOLDADURA DE TODAS LAS PARTES
    local function weldParts()
        local function weldTo(part1, part2)
            local weld = Instance.new("WeldConstraint")
            weld.Part0 = part1
            weld.Part1 = part2
            weld.Parent = part1
        end
        
        -- Soldar todo al poste principal
        weldTo(pole, base)
        weldTo(pole, support)
        weldTo(pole, sign)
        weldTo(pole, border)
        
        -- Soldar luces
        for _, child in pairs(signModel:GetChildren()) do
            if child.Name:find("Light") then
                weldTo(pole, child)
            end
        end
    end
    
    weldParts()
    
    -- SISTEMA DE MOVIMIENTO
    local function setupMovement()
        -- Hacer el poste movible pero mantener soldaduras
        pole.Anchored = false
        base.Anchored = false
        support.Anchored = false
        sign.Anchored = false
        border.Anchored = false
        
        for _, child in pairs(signModel:GetChildren()) do
            if child.Name:find("Light") then
                child.Anchored = false
            end
        end
        
        -- BodyPosition para estabilidad
        local bodyPos = Instance.new("BodyPosition")
        bodyPos.MaxForce = Vector3.new(4000, 4000, 4000)
        bodyPos.Position = pole.Position
        bodyPos.Parent = pole
        
        local bodyAngular = Instance.new("BodyAngularVelocity")
        bodyAngular.MaxTorque = Vector3.new(4000, 4000, 4000)
        bodyAngular.AngularVelocity = Vector3.new(0, 0, 0)
        bodyAngular.Parent = pole
        
        -- Actualizar posición cuando se mueva
        local lastPosition = pole.Position
        RunService.Heartbeat:Connect(function()
            if (pole.Position - lastPosition).Magnitude > 0.1 then
                bodyPos.Position = pole.Position
                lastPosition = pole.Position
            end
        end)
    end
    
    setupMovement()
    
    -- EFECTOS AMBIENTALES
    spawn(function()
        while signModel.Parent do
            -- Efecto de viento sutil
            local windTween = TweenService:Create(sign,
                TweenInfo.new(math.random(3, 6), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
                {Rotation = Vector3.new(0, 0, math.random(-2, 2))}
            )
            windTween:Play()
            wait(math.random(5, 10))
        end
    end)
    
    print("Cartel de Hawkins creado exitosamente!")
    return signModel
end

-- Crear el cartel
createHawkinsSign()