--[[
⚡ SISTEMA DE TORMENTAS ÉPICO - RAYOS NATURALES AZULES ⚡
 
Características Ultra Realistas:
- Rayos azules naturales con múltiples capas
- Efectos de partículas cinematográficos
- Iluminación volumétrica dinámica
- Sistema de sonido 3D avanzado
- Efectos de clima atmosférico
- Ondas de choque realistas
 
Pegar en: ServerScriptService
]]

local Workspace = game:GetService("Workspace")
local Debris = game:GetService("Debris")
local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

math.randomseed(tick())

-- ======== CONFIGURACIÓN VISUAL ÉPICA ========
local INTERVALO_TORMENTA = 8                -- Segundos entre ráfagas
local RAYOS_POR_RAFAGA = 25                 -- Cantidad optimizada
local RAYO_ALTURA_MAXIMA = 5000
local DURACION_RAYO = 0.6                   -- Duración visible del rayo

-- COLORES NATURALES AZULES
local COLOR_NUCLEO = Color3.fromRGB(200, 220, 255)     -- Azul blanco brillante
local COLOR_MEDIO = Color3.fromRGB(100, 150, 255)      -- Azul eléctrico
local COLOR_EXTERIOR = Color3.fromRGB(50, 100, 200)    -- Azul profundo
local COLOR_RESPLANDOR = Color3.fromRGB(150, 200, 255) -- Resplandor suave

-- TEXTURAS MEJORADAS
local TEXTURA_ELECTRICIDAD = "rbxassetid://4483431961"
local TEXTURA_ENERGIA = "rbxassetid://241650934"
local TEXTURA_RESPLANDOR = "rbxassetid://241650934"

-- ======= AUDIO CINEMATOGRÁFICO =======
local SONIDOS_TRUENO = {
    "rbxassetid://130457325001606",
    "rbxassetid://142070127",
    "rbxassetid://133707377"
}
local VOLUMEN_TRUENO = 3.5
local DISTANCIA_MAXIMA = 4000
local POOL_SONIDOS = 15

-- ======= CONFIGURACIÓN DE RAYOS =======
local SEGMENTOS_RAYO = 15
local CAOS_MAXIMO = 60                      -- Desviación natural
local GROSOR_BASE = 3.5
local VARIACION_GROSOR = 2.0

-- ======= EFECTOS ATMOSFÉRICOS =======
local function configurarAtmosfera()
    -- Configurar iluminación dramática
    Lighting.Brightness = 0.8
    Lighting.Ambient = Color3.fromRGB(20, 30, 50)
    Lighting.OutdoorAmbient = Color3.fromRGB(30, 40, 60)
    Lighting.FogEnd = 2000
    Lighting.FogStart = 500
    Lighting.FogColor = Color3.fromRGB(40, 50, 70)
    
    -- Crear nubes dinámicas si no existen
    if not Workspace:FindFirstChild("StormClouds") then
        local cloudsFolder = Instance.new("Folder")
        cloudsFolder.Name = "StormClouds"
        cloudsFolder.Parent = Workspace
        
        for i = 1, 8 do
            local cloud = Instance.new("Part")
            cloud.Name = "StormCloud_" .. i
            cloud.Size = Vector3.new(800, 200, 800)
            cloud.Anchored = true
            cloud.CanCollide = false
            cloud.Material = Enum.Material.ForceField
            cloud.Color = Color3.fromRGB(30, 30, 40)
            cloud.Transparency = 0.7
            cloud.Position = Vector3.new(
                math.random(-2000, 2000),
                4500 + math.random(-200, 200),
                math.random(-2000, 2000)
            )
            cloud.Parent = cloudsFolder
            
            -- Movimiento suave de nubes
            local moveTween = TweenService:Create(cloud, 
                TweenInfo.new(math.random(30, 60), Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
                {Position = cloud.Position + Vector3.new(math.random(-500, 500), 0, math.random(-500, 500))}
            )
            moveTween:Play()
        end
    end
end

-- ======= POOL DE SONIDOS AVANZADO =======
local PoolSonidos = {}
local indiceSonido = 1

local function crearPoolSonidos()
    local carpetaSonidos = Instance.new("Folder")
    carpetaSonidos.Name = "EpicThunder_Sounds"
    carpetaSonidos.Parent = Workspace
    
    for i = 1, POOL_SONIDOS do
        local parte = Instance.new("Part")
        parte.Size = Vector3.new(0.1, 0.1, 0.1)
        parte.Anchored = true
        parte.CanCollide = false
        parte.Transparency = 1
        parte.Position = Vector3.new(0, -10000, 0)
        parte.Parent = carpetaSonidos
        
        local sonido = Instance.new("Sound")
        sonido.Name = "Thunder"
        sonido.Parent = parte
        sonido.SoundId = SONIDOS_TRUENO[math.random(1, #SONIDOS_TRUENO)]
        sonido.Volume = VOLUMEN_TRUENO
        sonido.RollOffMode = Enum.RollOffMode.InverseTapered
        sonido.MaxDistance = DISTANCIA_MAXIMA
        sonido.EmitterSize = 100
        
        table.insert(PoolSonidos, {parte = parte, sonido = sonido})
    end
end

local function reproducirTrueno(posicion, intensidad)
    local entrada = PoolSonidos[indiceSonido]
    if not entrada then return end
    
    entrada.parte.Position = posicion
    if entrada.sonido.Playing then entrada.sonido:Stop() end
    
    -- Variación natural del sonido
    entrada.sonido.PlaybackSpeed = 0.7 + (math.random() * 0.6)
    entrada.sonido.Volume = VOLUMEN_TRUENO * intensidad
    entrada.sonido.SoundId = SONIDOS_TRUENO[math.random(1, #SONIDOS_TRUENO)]
    entrada.sonido:Play()
    
    indiceSonido = indiceSonido + 1
    if indiceSonido > #PoolSonidos then indiceSonido = 1 end
end

-- ======= UTILIDADES MEJORADAS =======
local function numeroAleatorio(min, max)
    return min + math.random() * (max - min)
end

local function obtenerAreaMapa()
    local limites = Workspace:FindFirstChild("MapBounds") or Workspace:FindFirstChild("Map")
    if limites then
        if limites:IsA("BasePart") then
            return Vector3.new(limites.Size.X + 1000, 100, limites.Size.Z + 1000)
        elseif limites:IsA("Model") then
            local tamaño = limites:GetExtentsSize()
            return Vector3.new(tamaño.X + 1000, 100, tamaño.Z + 1000)
        end
    end
    return Vector3.new(6000, 100, 6000) -- Área por defecto
end

local function raycastSuelo(x, z)
    local origen = Vector3.new(x, RAYO_ALTURA_MAXIMA, z)
    local parametros = RaycastParams.new()
    parametros.FilterType = Enum.RaycastFilterType.Blacklist
    parametros.FilterDescendantsInstances = {Workspace:FindFirstChild("StormClouds")}
    
    local resultado = Workspace:Raycast(origen, Vector3.new(0, -RAYO_ALTURA_MAXIMA * 2, 0), parametros)
    if resultado then
        return resultado.Position, origen.Y, resultado.Instance
    else
        return Vector3.new(x, 0, z), origen.Y, nil
    end
end

-- ======= SISTEMA DE PARTÍCULAS ÉPICO =======
local function crearEfectosImpacto(padre, posicion, intensidad)
    -- 1. Onda de Choque Azul
    local ondaChoque = Instance.new("Part")
    ondaChoque.Size = Vector3.new(1, 1, 1)
    ondaChoque.Anchored = true
    ondaChoque.CanCollide = false
    ondaChoque.Transparency = 1
    ondaChoque.Position = posicion
    ondaChoque.Parent = padre
    
    local attachment = Instance.new("Attachment", ondaChoque)
    
    -- Onda expansiva
    local particulasOnda = Instance.new("ParticleEmitter")
    particulasOnda.Texture = "rbxassetid://292289455"
    particulasOnda.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 8),
        NumberSequenceKeypoint.new(0.5, 25),
        NumberSequenceKeypoint.new(1, 50)
    })
    particulasOnda.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.2),
        NumberSequenceKeypoint.new(0.7, 0.5),
        NumberSequenceKeypoint.new(1, 1)
    })
    particulasOnda.Lifetime = NumberRange.new(1.2)
    particulasOnda.Rate = 0
    particulasOnda.Speed = NumberRange.new(0)
    particulasOnda.Color = ColorSequence.new(COLOR_RESPLANDOR)
    particulasOnda.LightEmission = 0.8
    particulasOnda.Parent = attachment
    particulasOnda:Emit(2)
    
    -- 2. Chispas Eléctricas Azules
    local chispas = Instance.new("ParticleEmitter")
    chispas.Texture = "rbxassetid://277033580"
    chispas.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, COLOR_NUCLEO),
        ColorSequenceKeypoint.new(0.5, COLOR_MEDIO),
        ColorSequenceKeypoint.new(1, COLOR_EXTERIOR)
    })
    chispas.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1.5),
        NumberSequenceKeypoint.new(0.5, 0.8),
        NumberSequenceKeypoint.new(1, 0)
    })
    chispas.Lifetime = NumberRange.new(0.8, 2.5)
    chispas.Speed = NumberRange.new(30, 80)
    chispas.SpreadAngle = Vector2.new(180, 180)
    chispas.Drag = 8
    chispas.LightEmission = 1
    chispas.Rate = 0
    chispas.Parent = attachment
    chispas:Emit(40 * intensidad)
    
    -- 3. Vapor Eléctrico
    local vapor = Instance.new("ParticleEmitter")
    vapor.Texture = "rbxassetid://241650934"
    vapor.Color = ColorSequence.new(Color3.fromRGB(80, 120, 180))
    vapor.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 6),
        NumberSequenceKeypoint.new(0.5, 15),
        NumberSequenceKeypoint.new(1, 25)
    })
    vapor.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.6),
        NumberSequenceKeypoint.new(0.8, 0.8),
        NumberSequenceKeypoint.new(1, 1)
    })
    vapor.Lifetime = NumberRange.new(3, 6)
    vapor.Speed = NumberRange.new(8, 20)
    vapor.Acceleration = Vector3.new(0, 15, 0)
    vapor.Rate = 0
    vapor.LightEmission = 0.3
    vapor.Parent = attachment
    vapor:Emit(15)
    
    -- 4. Iluminación Dinámica
    local luz = Instance.new("PointLight")
    luz.Color = COLOR_RESPLANDOR
    luz.Range = 120 * intensidad
    luz.Brightness = 80 * intensidad
    luz.Shadows = true
    luz.Parent = ondaChoque
    
    -- Animación de la luz
    local infoTween = TweenInfo.new(DURACION_RAYO * 1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local tweenLuz = TweenService:Create(luz, infoTween, {
        Brightness = 0,
        Range = 0
    })
    tweenLuz:Play()
    
    -- 5. Destello de Pantalla (para jugadores cercanos)
    local jugadores = Players:GetPlayers()
    for _, jugador in ipairs(jugadores) do
        if jugador.Character and jugador.Character:FindFirstChild("HumanoidRootPart") then
            local distancia = (jugador.Character.HumanoidRootPart.Position - posicion).Magnitude
            if distancia < 300 then
                -- Crear efecto de destello en la pantalla del jugador
                local gui = Instance.new("ScreenGui")
                gui.Name = "LightningFlash"
                gui.Parent = jugador.PlayerGui
                
                local flash = Instance.new("Frame")
                flash.Size = UDim2.new(1, 0, 1, 0)
                flash.BackgroundColor3 = COLOR_NUCLEO
                flash.BackgroundTransparency = 1
                flash.Parent = gui
                
                local flashTween = TweenService:Create(flash, TweenInfo.new(0.1), {BackgroundTransparency = 0.7})
                flashTween:Play()
                flashTween.Completed:Connect(function()
                    local fadeOut = TweenService:Create(flash, TweenInfo.new(0.4), {BackgroundTransparency = 1})
                    fadeOut:Play()
                    fadeOut.Completed:Connect(function()
                        gui:Destroy()
                    end)
                end)
            end
        end
    end
end

-- ======= GENERACIÓN DE RAYOS ÉPICOS =======
local function crearRayoNatural(posImpacto, alturaCielo, intensidad)
    local alturaTotal = alturaCielo - posImpacto.Y
    if alturaTotal <= 10 then return end
    
    local carpetaRayo = Instance.new("Folder")
    carpetaRayo.Name = "NaturalLightning"
    carpetaRayo.Parent = Workspace
    Debris:AddItem(carpetaRayo, DURACION_RAYO + 2)
    
    -- Generar trayectoria natural del rayo
    local puntos = {}
    local origenX, origenZ = posImpacto.X, posImpacto.Z
    
    -- Punto inicial en las nubes
    table.insert(puntos, Vector3.new(
        origenX + numeroAleatorio(-200, 200),
        alturaCielo,
        origenZ + numeroAleatorio(-200, 200)
    ))
    
    -- Puntos intermedios con patrón zigzag natural
    for i = 1, SEGMENTOS_RAYO - 1 do
        local progreso = i / SEGMENTOS_RAYO
        local y = alturaCielo - (progreso * alturaTotal)
        
        -- Crear desviación natural (más caos en la parte superior)
        local factorCaos = (1 - progreso) * 0.7 + 0.3
        local desviacion = CAOS_MAXIMO * factorCaos
        
        local dx = (math.random() - 0.5) * 2 * desviacion
        local dz = (math.random() - 0.5) * 2 * desviacion
        
        -- Tendencia hacia el punto de impacto
        local tendenciaX = (posImpacto.X - puntos[#puntos].X) * 0.3
        local tendenciaZ = (posImpacto.Z - puntos[#puntos].Z) * 0.3
        
        table.insert(puntos, Vector3.new(
            puntos[#puntos].X + dx + tendenciaX,
            y,
            puntos[#puntos].Z + dz + tendenciaZ
        ))
    end
    
    -- Punto final exacto
    table.insert(puntos, posImpacto)
    
    -- Crear attachments para los beams
    local attachments = {}
    for i, punto in ipairs(puntos) do
        local parte = Instance.new("Part")
        parte.Size = Vector3.new(0.1, 0.1, 0.1)
        parte.Transparency = 1
        parte.Anchored = true
        parte.CanCollide = false
        parte.Position = punto
        parte.Parent = carpetaRayo
        
        local att = Instance.new("Attachment", parte)
        table.insert(attachments, att)
    end
    
    -- Crear múltiples capas de beams para realismo
    for i = 1, #attachments - 1 do
        local att1, att2 = attachments[i], attachments[i + 1]
        local distancia = (att1.WorldPosition - att2.WorldPosition).Magnitude
        local factorGrosor = math.min(1, distancia / 100)
        
        -- Capa 1: Núcleo brillante
        local nucleo = Instance.new("Beam")
        nucleo.Attachment0 = att1
        nucleo.Attachment1 = att2
        nucleo.Color = ColorSequence.new(COLOR_NUCLEO)
        nucleo.Width0 = GROSOR_BASE * 0.4 * factorGrosor
        nucleo.Width1 = GROSOR_BASE * 0.4 * factorGrosor
        nucleo.FaceCamera = true
        nucleo.LightEmission = 1
        nucleo.Transparency = NumberSequence.new(0)
        nucleo.Texture = TEXTURA_ELECTRICIDAD
        nucleo.TextureMode = Enum.TextureMode.Wrap
        nucleo.TextureLength = 8
        nucleo.TextureSpeed = 3
        nucleo.Parent = carpetaRayo
        
        -- Capa 2: Energía media
        local medio = Instance.new("Beam")
        medio.Attachment0 = att1
        medio.Attachment1 = att2
        medio.Color = ColorSequence.new(COLOR_MEDIO)
        medio.Width0 = GROSOR_BASE * 0.8 * factorGrosor
        medio.Width1 = GROSOR_BASE * 0.8 * factorGrosor
        medio.FaceCamera = true
        medio.LightEmission = 0.9
        medio.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.3),
            NumberSequenceKeypoint.new(0.5, 0.1),
            NumberSequenceKeypoint.new(1, 0.3)
        })
        medio.Texture = TEXTURA_ENERGIA
        medio.TextureSpeed = 2
        medio.Parent = carpetaRayo
        
        -- Capa 3: Resplandor exterior
        local resplandor = Instance.new("Beam")
        resplandor.Attachment0 = att1
        resplandor.Attachment1 = att2
        resplandor.Color = ColorSequence.new(COLOR_EXTERIOR)
        resplandor.Width0 = GROSOR_BASE * 1.5 * factorGrosor
        resplandor.Width1 = GROSOR_BASE * 2.0 * factorGrosor
        resplandor.FaceCamera = true
        resplandor.LightEmission = 0.7
        resplandor.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.6),
            NumberSequenceKeypoint.new(0.5, 0.3),
            NumberSequenceKeypoint.new(1, 0.6)
        })
        resplandor.Texture = TEXTURA_RESPLANDOR
        resplandor.TextureSpeed = 1.5
        resplandor.Parent = carpetaRayo
    end
    
    -- Pilar de energía en el punto de impacto
    local pilar = Instance.new("Part")
    pilar.Anchored = true
    pilar.CanCollide = false
    pilar.Shape = Enum.PartType.Cylinder
    pilar.Size = Vector3.new(150, 4, 4)
    pilar.Position = posImpacto + Vector3.new(0, 75, 0)
    pilar.Orientation = Vector3.new(0, 0, 90)
    pilar.Material = Enum.Material.Neon
    pilar.Color = COLOR_RESPLANDOR
    pilar.Transparency = 0.4
    pilar.Parent = carpetaRayo
    
    -- Animaciones de desvanecimiento
    task.delay(0.1, function()
        if not carpetaRayo.Parent then return end
        
        local infoDesvanecimiento = TweenInfo.new(DURACION_RAYO, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        
        for _, objeto in ipairs(carpetaRayo:GetDescendants()) do
            if objeto:IsA("Beam") then
                TweenService:Create(objeto, infoDesvanecimiento, {
                    Transparency = NumberSequence.new(1)
                }):Play()
            elseif objeto == pilar then
                TweenService:Create(objeto, infoDesvanecimiento, {
                    Transparency = 1,
                    Size = Vector3.new(0, 0, 0)
                }):Play()
            end
        end
    end)
    
    -- Efectos finales
    crearEfectosImpacto(carpetaRayo, posImpacto, intensidad)
    reproducirTrueno(posImpacto, intensidad)
    
    -- Sacudida sísmica sutil
    if intensidad > 0.7 then
        local explosion = Instance.new("Explosion")
        explosion.Position = posImpacto
        explosion.BlastRadius = 0
        explosion.BlastPressure = 1500
        explosion.Visible = false
        explosion.Parent = Workspace
    end
end

-- ======= SISTEMA PRINCIPAL DE TORMENTA =======
local function iniciarTormentaEpica()
    configurarAtmosfera()
    crearPoolSonidos()
    
    local areaMapa = obtenerAreaMapa()
    
    print("⚡ SISTEMA DE TORMENTAS ÉPICO ACTIVADO ⚡")
    print("Área de cobertura:", areaMapa)
    
    while true do
        task.wait(INTERVALO_TORMENTA)
        
        local jugadores = Players:GetPlayers()
        
        -- Rayos cerca de jugadores (alta calidad)
        for _, jugador in ipairs(jugadores) do
            if jugador.Character and jugador.Character:FindFirstChild("HumanoidRootPart") then
                local raiz = jugador.Character.HumanoidRootPart
                
                -- 2-4 rayos cercanos por jugador
                for i = 1, math.random(2, 4) do
                    local angulo = numeroAleatorio(0, math.pi * 2)
                    local distancia = numeroAleatorio(50, 250)
                    local posObjetivo = raiz.Position + Vector3.new(
                        math.cos(angulo) * distancia,
                        0,
                        math.sin(angulo) * distancia
                    )
                    
                    local posImpacto, alturaCielo = raycastSuelo(posObjetivo.X, posObjetivo.Z)
                    crearRayoNatural(posImpacto, alturaCielo, numeroAleatorio(0.8, 1.0))
                    
                    task.wait(numeroAleatorio(0.1, 0.3))
                end
            end
        end
        
        -- Rayos aleatorios en el mapa
        for i = 1, RAYOS_POR_RAFAGA do
            local x = numeroAleatorio(-areaMapa.X/2, areaMapa.X/2)
            local z = numeroAleatorio(-areaMapa.Z/2, areaMapa.Z/2)
            
            local posImpacto, alturaCielo = raycastSuelo(x, z)
            local intensidad = numeroAleatorio(0.3, 0.8)
            
            crearRayoNatural(posImpacto, alturaCielo, intensidad)
            
            if i % 5 == 0 then task.wait() end -- Prevenir lag
        end
        
        -- Pausa dramática entre ráfagas
        task.wait(numeroAleatorio(2, 4))
    end
end

-- ======= CONTROLES ADICIONALES =======
local function cambiarIntensidadTormenta(nuevaIntensidad)
    RAYOS_POR_RAFAGA = math.floor(25 * nuevaIntensidad)
    INTERVALO_TORMENTA = math.max(3, 8 / nuevaIntensidad)
    print("Intensidad de tormenta cambiada a:", nuevaIntensidad)
end

-- Comandos de chat para administradores
game.Players.PlayerAdded:Connect(function(jugador)
    jugador.Chatted:Connect(function(mensaje)
        if jugador.Name == game.CreatorId or jugador:GetRankInGroup(0) >= 100 then
            local comando = mensaje:lower()
            if comando:find("/storm") then
                local intensidad = tonumber(comando:match("(%d+%.?%d*)")) or 1
                cambiarIntensidadTormenta(math.clamp(intensidad, 0.1, 3))
            end
        end
    end)
end)

-- Iniciar el sistema
task.spawn(iniciarTormentaEpica)