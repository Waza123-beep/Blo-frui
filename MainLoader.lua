--╔══════════════════════════════════════════════════════════════════════════════╗
--║                    BLOX FRUITS ULTIMATE HUB - MAIN LOADER                      ║
--║                   Auto-Detect Sea & Load Corresponding Functions               ║
--║                         Compatible: Synapse X | Fluent UI                    ║
--╚══════════════════════════════════════════════════════════════════════════════╝

-- Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

-- Local Player
local LocalPlayer = Players.LocalPlayer

-- Sea Detection
local PlaceId = game.PlaceId
local World1 = PlaceId == 2753915549 or PlaceId == 85211729168715
local World2 = PlaceId == 4442272183 or PlaceId == 79091703265657
local World3 = PlaceId == 7449423635 or PlaceId == 100117331123089

-- GitHub Repository Configuration
local GitHubRepo = "https://raw.githubusercontent.com/Waza123-beep/Blo-frui/main/"

-- Sea Information
local CurrentSea = "Unknown"
local SeaLevelRange = ""

if World1 then
    CurrentSea = "First Sea"
    SeaLevelRange = "Levels 1 - 700"
elseif World2 then
    CurrentSea = "Second Sea"
    SeaLevelRange = "Levels 700 - 1500"
elseif World3 then
    CurrentSea = "Third Sea"
    SeaLevelRange = "Levels 1500 - 2600+"
end

-- Load Fluent UI Library
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()

-- Create Main Window
local Window = Fluent:CreateWindow({
    Title = "Blox Fruits Ultimate Hub",
    SubTitle = CurrentSea .. " | " .. SeaLevelRange,
    TabWidth = 160,
    Size = UDim2.fromOffset(600, 500),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Notification on Load
Fluent:Notify({
    Title = "Blox Fruits Hub Loaded",
    Content = "Detected: " .. CurrentSea .. "\nLoading specific functions...",
    Duration = 5
})

-- Load Sea-Specific Functions
local function LoadSeaFunctions()
    if World1 then
        -- Load First Sea Functions
        Fluent:Notify({
            Title = "Loading...",
            Content = "Loading First Sea Functions...",
            Duration = 3
        })
        
        local Sea1Functions = loadstring(game:HttpGet(GitHubRepo .. "Sea1Functions.lua"))()
        Sea1Functions.Initialize(Window, Fluent)
        
    elseif World2 then
        -- Load Second Sea Functions
        Fluent:Notify({
            Title = "Loading...",
            Content = "Loading Second Sea Functions...",
            Duration = 3
        })
        
        local Sea2Functions = loadstring(game:HttpGet(GitHubRepo .. "Sea2Functions.lua"))()
        Sea2Functions.Initialize(Window, Fluent)
        
    elseif World3 then
        -- Load Third Sea Functions
        Fluent:Notify({
            Title = "Loading...",
            Content = "Loading Third Sea Functions...",
            Duration = 3
        })
        
        local Sea3Functions = loadstring(game:HttpGet(GitHubRepo .. "Sea3Functions.lua"))()
        Sea3Functions.Initialize(Window, Fluent)
    else
        Fluent:Notify({
            Title = "Error",
            Content = "Could not detect current sea!",
            Duration = 5
        })
    end
end

-- Initialize
spawn(function()
    wait(2)
    LoadSeaFunctions()
end)

print("╔══════════════════════════════════════════════════════════════════════════════╗")
print("║                    BLOX FRUITS ULTIMATE HUB                                  ║")
print("║                         Main Loader Initialized                              ║")
print("║                                                                              ║")
print("║   Current Sea: " .. string.format("%-20s", CurrentSea) .. "                    ║")
print("║   Level Range: " .. string.format("%-20s", SeaLevelRange) .. "                    ║")
print("╚══════════════════════════════════════════════════════════════════════════════╝")
