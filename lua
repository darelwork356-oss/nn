-- STRANGER THINGS INTRO - ROBLOX
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "StrangerThingsIntro"
screenGui.Parent = playerGui

local blackFrame = Instance.new("Frame")
blackFrame.Size = UDim2.new(1, 0, 1, 0)
blackFrame.BackgroundColor3 = Color3.new(0, 0, 0)
blackFrame.BorderSizePixel = 0
blackFrame.Parent = screenGui

local function createRedLetter(letter, xPos, yPos)
    local letterFrame = Instance.new("TextLabel")
    letterFrame.Size = UDim2.new(0.06, 0, 0.12, 0)
    letterFrame.Position = UDim2.new(xPos, 0, yPos, 0)
    letterFrame.BackgroundTransparency = 1
    letterFrame.Text = letter
    letterFrame.TextColor3 = Color3.new(1, 0.1, 0.1)
    letterFrame.TextScaled = true
    letterFrame.Font = Enum.Font.Antique
    letterFrame.TextStrokeTransparency = 0.3
    letterFrame.TextStrokeColor3 = Color3.new(0.8, 0, 0)
    letterFrame.TextTransparency = 1
    letterFrame.Parent = blackFrame
    return letterFrame
end

local function createCredit(text, delay, duration)
    local creditLabel = Instance.new("TextLabel")
    creditLabel.Size = UDim2.new(0.6, 0, 0.05, 0)
    creditLabel.Position = UDim2.new(0.2, 0, 0.75, 0)
    creditLabel.BackgroundTransparency = 1
    creditLabel.Text = text
    creditLabel.TextColor3 = Color3.new(1, 1, 1)
    creditLabel.TextScaled = true
    creditLabel.Font = Enum.Font.Gotham
    creditLabel.TextTransparency = 1
    creditLabel.Parent = blackFrame
    
    spawn(function()
        wait(delay)
        TweenService:Create(creditLabel, TweenInfo.new(1), {TextTransparency = 0}):Play()
        wait(duration)
        local fadeOut = TweenService:Create(creditLabel, TweenInfo.new(1.5), {TextTransparency = 1})
        fadeOut:Play()
        fadeOut.Completed:Connect(function() creditLabel:Destroy() end)
    end)
end

local function playStrangerThingsIntro()
    wait(3)
    
    local strangerLetters = {}
    local thingsLetters = {}
    
    -- STRANGER
    local strangerText = "STRANGER"
    for i = 1, #strangerText do
        local letter = createRedLetter(string.sub(strangerText, i, i), 0.15 + (i-1) * 0.08, 0.35)
        table.insert(strangerLetters, letter)
    end
    
    -- THINGS
    local thingsText = "THINGS"
    for i = 1, #thingsText do
        local letter = createRedLetter(string.sub(thingsText, i, i), 0.25 + (i-1) * 0.08, 0.5)
        table.insert(thingsLetters, letter)
    end
    
    spawn(function()
        for i, letter in ipairs(strangerLetters) do
            wait(0.15)
            TweenService:Create(letter, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
        end
        
        wait(0.5)
        
        for i, letter in ipairs(thingsLetters) do
            wait(0.15)
            TweenService:Create(letter, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
        end
    end)
    
    wait(4)
    
    local subtitle = Instance.new("TextLabel")
    subtitle.Size = UDim2.new(0.4, 0, 0.06, 0)
    subtitle.Position = UDim2.new(0.3, 0, 0.65, 0)
    subtitle.BackgroundTransparency = 1
    subtitle.Text = "BLOGS 2026"
    subtitle.TextColor3 = Color3.new(0.8, 0.8, 0.8)
    subtitle.TextScaled = true
    subtitle.Font = Enum.Font.Gotham
    subtitle.TextTransparency = 1
    subtitle.Parent = blackFrame
    
    TweenService:Create(subtitle, TweenInfo.new(1), {TextTransparency = 0}):Play()
    
    createCredit("Created by DAREL VEGA", 6, 3)
    createCredit("Programmed by DAREK AND MALI MENDEZ", 10, 3)
    createCredit("Written by DAREK", 14, 3)
    
    wait(20)
    
    local finalFade = TweenService:Create(blackFrame, TweenInfo.new(3), {BackgroundTransparency = 1})
    finalFade:Play()
    finalFade.Completed:Connect(function() screenGui:Destroy() end)
end

playStrangerThingsIntro()

_G.StrangerThingsIntro = {
    start = function()
        if screenGui then screenGui:Destroy() end
        wait(0.5)
        playStrangerThingsIntro()
    end
}
