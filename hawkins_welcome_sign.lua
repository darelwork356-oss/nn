-- HAWKINS WELCOME SIGN SCRIPT
-- Colocar en ServerScriptService

-- Configuración del cartel
local SIGN_CONFIG = {
    POLE_HEIGHT = 100,
    POLE_WIDTH = 4,
    SIGN_WIDTH = 40,
    SIGN_HEIGHT = 20,
    SIGN_THICKNESS = 2
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
    base.Size = Vector3.new(12, 4, 12)
    base.Position = Vector3.new(0, 2, 0)
    base.Material = Enum.Material.Plastic
    base.BrickColor = BrickColor.new("Dark stone grey")
    base.Shape = Enum.PartType.Block
    base.TopSurface = Enum.SurfaceType.Studs
    base.BottomSurface = Enum.SurfaceType.Studs
    base.LeftSurface = Enum.SurfaceType.Studs
    base.RightSurface = Enum.SurfaceType.Studs
    base.FrontSurface = Enum.SurfaceType.Studs
    base.BackSurface = Enum.SurfaceType.Studs
    base.Anchored = true
    base.Parent = signModel
    
    -- POSTE PRINCIPAL
    local pole = Instance.new("Part")
    pole.Name = "Pole"
    pole.Size = Vector3.new(SIGN_CONFIG.POLE_WIDTH, SIGN_CONFIG.POLE_HEIGHT, SIGN_CONFIG.POLE_WIDTH)
    pole.Position = Vector3.new(0, SIGN_CONFIG.POLE_HEIGHT/2 + 4, 0)
    pole.Material = Enum.Material.Plastic
    pole.BrickColor = BrickColor.new("Really black")
    pole.Shape = Enum.PartType.Block
    pole.TopSurface = Enum.SurfaceType.Studs
    pole.BottomSurface = Enum.SurfaceType.Studs
    pole.LeftSurface = Enum.SurfaceType.Studs
    pole.RightSurface = Enum.SurfaceType.Studs
    pole.FrontSurface = Enum.SurfaceType.Studs
    pole.BackSurface = Enum.SurfaceType.Studs
    pole.Anchored = true
    pole.Parent = signModel
    
    -- SOPORTE HORIZONTAL
    local support = Instance.new("Part")
    support.Name = "Support"
    support.Size = Vector3.new(SIGN_CONFIG.SIGN_WIDTH + 8, 2, 2)
    support.Position = Vector3.new(0, SIGN_CONFIG.POLE_HEIGHT - 5, 0)
    support.Material = Enum.Material.Plastic
    support.BrickColor = BrickColor.new("Really black")
    support.Shape = Enum.PartType.Block
    support.TopSurface = Enum.SurfaceType.Studs
    support.BottomSurface = Enum.SurfaceType.Studs
    support.LeftSurface = Enum.SurfaceType.Studs
    support.RightSurface = Enum.SurfaceType.Studs
    support.FrontSurface = Enum.SurfaceType.Studs
    support.BackSurface = Enum.SurfaceType.Studs
    support.Anchored = true
    support.Parent = signModel
    
    -- BORDE BLANCO DEL CARTEL
    local border = Instance.new("Part")
    border.Name = "Border"
    border.Size = Vector3.new(SIGN_CONFIG.SIGN_WIDTH + 2, SIGN_CONFIG.SIGN_HEIGHT + 2, SIGN_CONFIG.SIGN_THICKNESS)
    border.Position = Vector3.new(0, SIGN_CONFIG.POLE_HEIGHT - 15, 5)
    border.Material = Enum.Material.Plastic
    border.BrickColor = BrickColor.new("Institutional white")
    border.Shape = Enum.PartType.Block
    border.TopSurface = Enum.SurfaceType.Studs
    border.BottomSurface = Enum.SurfaceType.Studs
    border.LeftSurface = Enum.SurfaceType.Studs
    border.RightSurface = Enum.SurfaceType.Studs
    border.FrontSurface = Enum.SurfaceType.Studs
    border.BackSurface = Enum.SurfaceType.Studs
    border.Anchored = true
    border.Parent = signModel
    
    -- CARTEL VERDE PRINCIPAL
    local sign = Instance.new("Part")
    sign.Name = "Sign"
    sign.Size = Vector3.new(SIGN_CONFIG.SIGN_WIDTH - 2, SIGN_CONFIG.SIGN_HEIGHT - 2, SIGN_CONFIG.SIGN_THICKNESS + 0.2)
    sign.Position = Vector3.new(0, SIGN_CONFIG.POLE_HEIGHT - 15, 5.2)
    sign.Material = Enum.Material.Plastic
    sign.BrickColor = BrickColor.new("Dark green")
    sign.Shape = Enum.PartType.Block
    sign.TopSurface = Enum.SurfaceType.Smooth
    sign.BottomSurface = Enum.SurfaceType.Smooth
    sign.LeftSurface = Enum.SurfaceType.Smooth
    sign.RightSurface = Enum.SurfaceType.Smooth
    sign.FrontSurface = Enum.SurfaceType.Smooth
    sign.BackSurface = Enum.SurfaceType.Smooth
    sign.Anchored = true
    sign.Parent = signModel
    
    -- TEXTO WELCOME TO
    local welcomePart = Instance.new("Part")
    welcomePart.Name = "WelcomeText"
    welcomePart.Size = Vector3.new(30, 4, 0.1)
    welcomePart.Position = Vector3.new(0, SIGN_CONFIG.POLE_HEIGHT - 12, 5.5)
    welcomePart.Material = Enum.Material.Neon
    welcomePart.BrickColor = BrickColor.new("Institutional white")
    welcomePart.Anchored = true
    welcomePart.Parent = signModel
    
    -- TEXTO HAWKINS
    local hawkinsPart = Instance.new("Part")
    hawkinsPart.Name = "HawkinsText"
    hawkinsPart.Size = Vector3.new(35, 6, 0.1)
    hawkinsPart.Position = Vector3.new(0, SIGN_CONFIG.POLE_HEIGHT - 17, 5.5)
    hawkinsPart.Material = Enum.Material.Neon
    hawkinsPart.BrickColor = BrickColor.new("Really red")
    hawkinsPart.Anchored = true
    hawkinsPart.Parent = signModel
    
    -- LUCES DECORATIVAS
    for i = 1, 4 do
        local light = Instance.new("Part")
        light.Name = "Light" .. i
        light.Size = Vector3.new(1, 1, 1)
        light.Shape = Enum.PartType.Ball
        light.Material = Enum.Material.Neon
        light.BrickColor = BrickColor.new("Bright yellow")
        light.TopSurface = Enum.SurfaceType.Smooth
        light.BottomSurface = Enum.SurfaceType.Smooth
        light.Anchored = true
        light.Parent = signModel
        
        -- Posicionar luces en las esquinas
        local xPos = (i <= 2) and -SIGN_CONFIG.SIGN_WIDTH/2 + 3 or SIGN_CONFIG.SIGN_WIDTH/2 - 3
        local yPos = (i == 1 or i == 3) and (SIGN_CONFIG.POLE_HEIGHT - 15) + SIGN_CONFIG.SIGN_HEIGHT/2 - 2 or (SIGN_CONFIG.POLE_HEIGHT - 15) - SIGN_CONFIG.SIGN_HEIGHT/2 + 2
        light.Position = Vector3.new(xPos, yPos, 6)
        
        -- Efecto de parpadeo
        spawn(function()
            while light.Parent do
                wait(math.random(2, 5))
                light.Transparency = math.random(0, 30)/100
                wait(0.1)
            end
        end)
    end
    
    -- SOLDADURA DE TODAS LAS PARTES
    local function weldTo(part1, part2)
        local weld = Instance.new("WeldConstraint")
        weld.Part0 = part1
        weld.Part1 = part2
        weld.Parent = part1
    end
    
    -- Soldar todo al poste principal
    weldTo(pole, base)
    weldTo(pole, support)
    weldTo(pole, border)
    weldTo(pole, sign)
    weldTo(pole, welcomePart)
    weldTo(pole, hawkinsPart)
    
    -- Soldar luces
    for _, child in pairs(signModel:GetChildren()) do
        if child.Name:find("Light") then
            weldTo(pole, child)
        end
    end
    
    -- HACER SOLO EL POSTE MOVIBLE
    pole.Anchored = false
    
    print("Cartel de Hawkins creado exitosamente!")
    return signModel
end

-- Crear el cartel
createHawkinsSign()
