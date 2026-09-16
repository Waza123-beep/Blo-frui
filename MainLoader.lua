-- ============================================
-- MainLoader.lua
-- Detecta el mar actual y carga el módulo correspondiente
-- ============================================

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer

-- Detección de Seas por PlaceId
local SEA_DATA = {
    [2753915549] = {Name = "First Sea", Module = "Sea1Functions", MaxLevel = 700},
    [85211729168715] = {Name = "First Sea", Module = "Sea1Functions", MaxLevel = 700}, -- Private/Alternative ID
    [4442272183] = {Name = "Second Sea", Module = "Sea2Functions", MaxLevel = 1500},
    [79091703265657] = {Name = "Second Sea", Module = "Sea2Functions", MaxLevel = 1500},
    [7449423635] = {Name = "Third Sea", Module = "Sea3Functions", MaxLevel = 3000},
    [100117331123089] = {Name = "Third Sea", Module = "Sea3Functions", MaxLevel = 3000}
}

local CurrentSea = SEA_DATA[game.PlaceId] or {Name = "Unknown", Module = "Sea1Functions", MaxLevel = 700}

-- Variables globales compartidas
getgenv().BloxFruitsHub = {
    CurrentSea = CurrentSea.Name,
    ModuleName = CurrentSea.Module,
    MaxLevel = CurrentSea.MaxLevel,
    FluentLoaded = false,
    Settings = {
        FastAttack = true,
        BringMobs = true,
        SafeMode = false,
        AutoHaki = true
    }
}

-- Cargar Fluent UI
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
getgenv().BloxFruitsHub.FluentLoaded = true

-- Crear ventana principal
local Window = Fluent:CreateWindow({
    Title = "Blox Fruits Hub | " .. CurrentSea.Name,
    SubTitle = "Update 30 Compatible",
    TabWidth = 160,
    Size = UDim2.fromOffset(580, 460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

-- Tabs globales (disponibles en todos los mares)
local Tabs = {
    Main = Window:AddTab({ Title = "Main", Icon = "home" }),
    Farm = Window:AddTab({ Title = "Farm", Icon = "sword" }),
    Quests = Window:AddTab({ Title = "Quests", Icon = "scroll" }),
    Bosses = Window:AddTab({ Title = "Bosses", Icon = "skull" }),
    Teleport = Window:AddTab({ Title = "Teleport", Icon = "map" }),
    Fruits = Window:AddTab({ Title = "Fruits", Icon = "apple" }),
    Codes = Window:AddTab({ Title = "Codes", Icon = "ticket" }),
    Combat = Window:AddTab({ Title = "Combat V2", Icon = "zap" }), -- Solo funcional en Sea 1 tras Update 30
    Settings = Window:AddTab({ Title = "Settings", Icon = "settings" })
}

-- Notificación inicial
Fluent:Notify({
    Title = "Hub Loaded",
    Content = "Detected: " .. CurrentSea.Name,
    Duration = 5
})

-- Cargar módulo específico del mar
task.spawn(function()
    local success, module = pcall(function()
        return loadstring(game:HttpGet("https://raw.githubusercontent.com/Waza123-beep/Blo-frui/main/" .. CurrentSea.Module .. ".lua"))()
    end)
    
    if success and module then
        module.Initialize(Window, Tabs, Fluent)
        Fluent:Notify({
            Title = "Module Loaded",
            Content = CurrentSea.Module .. " initialized successfully",
            Duration = 3
        })
    else
        Fluent:Notify({
            Title = "Error",
            Content = "Failed to load " .. CurrentSea.Module,
            Duration = 5
        })
        warn("Module load error:", module)
    end
end)

-- Sistema de cambio de detección (si el jugador viaja entre seas)
LocalPlayer.OnTeleport:Connect(function()
    -- El script se reiniciará automáticamente al teleportar
end)
