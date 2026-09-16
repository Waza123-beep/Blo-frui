--╔══════════════════════════════════════════════════════════════════════════════╗
--║                    BLOX FRUITS ULTIMATE HUB - MAIN LOADER                    ║
--║                    Auto-Detect Sea | Fluent UI | Synapse X                    ║
--╚══════════════════════════════════════════════════════════════════════════════╝

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")

-- Local Player
local LocalPlayer = Players.LocalPlayer

--═══════════════════════════════════════════════════════════════════════════════
-- SEA DETECTION SYSTEM
--═══════════════════════════════════════════════════════════════════════════════

local PlaceId = game.PlaceId

-- Sea Detection
local SeaDetection = {
    FirstSea = PlaceId == 2753915549 or PlaceId == 85211729168715,
    SecondSea = PlaceId == 4442272183 or PlaceId == 79091703265657,
    ThirdSea = PlaceId == 7449423635 or PlaceId == 100117331123089
}

--═══════════════════════════════════════════════════════════════════════════════
-- NOTIFICATION SYSTEM
--═══════════════════════════════════════════════════════════════════════════════

function SendNotification(Title, Text, Duration)
    local CoreGui = game:GetService("CoreGui")
    local Notification = Instance.new("ScreenGui")
    Notification.Name = "BFNotification"
    Notification.Parent = CoreGui
    
    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 300, 0, 80)
    Frame.Position = UDim2.new(0.5, -150, 0, -100)
    Frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Frame.BorderSizePixel = 0
    Frame.Parent = Notification
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Frame
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, -20, 0, 25)
    TitleLabel.Position = UDim2.new(0, 10, 0, 5)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = Title
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 16
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Frame
    
    local TextLabel = Instance.new("TextLabel")
    TextLabel.Size = UDim2.new(1, -20, 0, 45)
    TextLabel.Position = UDim2.new(0, 10, 0, 30)
    TextLabel.BackgroundTransparency = 1
    TextLabel.Text = Text
    TextLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
    TextLabel.TextSize = 14
    TextLabel.Font = Enum.Font.Gotham
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left
    TextLabel.TextWrapped = true
    TextLabel.Parent = Frame
    
    -- Animation
    Frame:TweenPosition(UDim2.new(0.5, -150, 0, 20), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.5, true)
    
    task.wait(Duration or 5)
    
    Frame:TweenPosition(UDim2.new(0.5, -150, 0, -100), Enum.EasingDirection.In, Enum.EasingStyle.Quad, 0.5, true)
    task.wait(0.5)
    Notification:Destroy()
end

--═══════════════════════════════════════════════════════════════════════════════
-- SCRIPT LOADER
--═══════════════════════════════════════════════════════════════════════════════

function LoadSeaScript(SeaName, ScriptUrl)
    SendNotification("Loading...", "Loading " .. SeaName .. " Functions...", 3)
    
    local success, result = pcall(function()
        return loadstring(game:HttpGet(ScriptUrl))()
    end)
    
    if success then
        SendNotification("Success!", SeaName .. " Functions Loaded Successfully!", 5)
        print("✅ [" .. SeaName .. "] Functions loaded successfully")
    else
        SendNotification("Error!", "Failed to load " .. SeaName .. " Functions", 5)
        warn("❌ [" .. SeaName .. "] Failed to load: " .. tostring(result))
    end
end

--═══════════════════════════════════════════════════════════════════════════════
-- MAIN EXECUTION
--═══════════════════════════════════════════════════════════════════════════════

print("╔══════════════════════════════════════════════════════════════════════════════╗")
print("║                    BLOX FRUITS ULTIMATE HUB - MAIN LOADER                    ║")
print("║                                                                              ║")
print("║   Detecting Current Sea...                                                   ║")
print("╚══════════════════════════════════════════════════════════════════════════════╝")

-- GitHub Raw URLs (Replace with your actual repository URLs)
local GitHubBase = "https://raw.githubusercontent.com/Waza123-beep/Blo-frui/main/"

if SeaDetection.FirstSea then
    print("🌊 First Sea Detected!")
    SendNotification("First Sea Detected!", "Loading First Sea Functions...", 3)
    LoadSeaScript("First Sea", GitHubBase .. "Sea1Functions.lua")
    
elseif SeaDetection.SecondSea then
    print("🌊 Second Sea Detected!")
    SendNotification("Second Sea Detected!", "Loading Second Sea Functions...", 3)
    LoadSeaScript("Second Sea", GitHubBase .. "Sea2Functions.lua")
    
elseif SeaDetection.ThirdSea then
    print("🌊 Third Sea Detected!")
    SendNotification("Third Sea Detected!", "Loading Third Sea Functions...", 3)
    LoadSeaScript("Third Sea", GitHubBase .. "Sea3Functions.lua")
    
else
    print("❌ Unknown Sea!")
    SendNotification("Error!", "Could not detect current sea!", 5)
    
    -- Try to determine from level
    local Level = LocalPlayer.Data.Level.Value
    if Level <= 700 then
        print("📊 Based on level, assuming First Sea")
        LoadSeaScript("First Sea", GitHubBase .. "Sea1Functions.lua")
    elseif Level <= 1500 then
        print("📊 Based on level, assuming Second Sea")
        LoadSeaScript("Second Sea", GitHubBase .. "Sea2Functions.lua")
    else
        print("📊 Based on level, assuming Third Sea")
        LoadSeaScript("Third Sea", GitHubBase .. "Sea3Functions.lua")
    end
end

print("╔══════════════════════════════════════════════════════════════════════════════╗")
print("║                    MAIN LOADER COMPLETED                                     ║")
print("╚══════════════════════════════════════════════════════════════════════════════╝")
