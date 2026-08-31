-- [[ Blox Fruits Sea 1 Module - Sea1Functions.lua ]] --
-- Repositorio: Waza123-beep | Optimizado y Verificado al 100%

if not game:IsLoaded() then game.Loaded:Wait() end

local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

-- ============================================================================
-- SERVICIOS Y CLIENTE
-- ============================================================================
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")

local LocalPlayer = Players.LocalPlayer
local CommF = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")

-- ============================================================================
-- ESTADOS GLOBALES DE CONFIGURACIÓN
-- ============================================================================
_G.AutoFarm = false
_G.AutoFarmNearest = false
_G.AutoBoss = false
_G.SelectedBoss = ""
_G.FastAttack = true
_G.BringMobs = true
_G.SelectWeapon = "Melee"
_G.Noclip = false
_G.TweenSpeed = 250

_G.AutoSaber = false
_G.AutoSecondSea = false

_G.AutoStoreFruit = false
_G.AutoBringFruits = false
_G.AutoEatFruit = false

_G.AutoChest = false
_G.AutoBuso = true

_G.ESP = {
    Players = false,
    Enemies = false,
    Fruits = false
}

_G.AutoStats = {
    Melee = false,
    Defense = false,
    Sword = false,
    Gun = false,
    Fruit = false,
    PointsPerTick = 1
}

-- ============================================================================
-- BASE DE DATOS DEL SEA 1 (Nivel 1 - 700)
-- ============================================================================
local Quests = {
    {MinLevel = 1,   MaxLevel = 9,   Mob = "Bandit",               QuestName = "BanditQuest1",    QuestLevel = 1, NPCCFrame = CFrame.new(1059.3, 15.4, 1549.3),   MobCFrame = CFrame.new(1145, 17, 1634)},
    {MinLevel = 10,  MaxLevel = 14,  Mob = "Monkey",               QuestName = "JungleQuest",     QuestLevel = 1, NPCCFrame = CFrame.new(-1598.1, 36.8, 153.8),  MobCFrame = CFrame.new(-1448, 50, 63)},
    {MinLevel = 15,  MaxLevel = 29,  Mob = "Gorilla",              QuestName = "JungleQuest",     QuestLevel = 2, NPCCFrame = CFrame.new(-1598.1, 36.8, 153.8),  MobCFrame = CFrame.new(-1237, 6, -486)},
    {MinLevel = 30,  MaxLevel = 39,  Mob = "Pirate",               QuestName = "BuggyQuest1",     QuestLevel = 1, NPCCFrame = CFrame.new(-1140.2, 4.1, 3827.4),  MobCFrame = CFrame.new(-1215, 4, 3915)},
    {MinLevel = 40,  MaxLevel = 59,  Mob = "Brute",                QuestName = "BuggyQuest1",     QuestLevel = 2, NPCCFrame = CFrame.new(-1140.2, 4.1, 3827.4),  MobCFrame = CFrame.new(-1146, 14, 4350)},
    {MinLevel = 60,  MaxLevel = 74,  Mob = "Desert Bandit",        QuestName = "DesertQuest",     QuestLevel = 1, NPCCFrame = CFrame.new(897.2, 6.4, 4388.6),     MobCFrame = CFrame.new(932, 6, 4484)},
    {MinLevel = 75,  MaxLevel = 89,  Mob = "Desert Officer",       QuestName = "DesertQuest",     QuestLevel = 2, NPCCFrame = CFrame.new(897.2, 6.4, 4388.6),     MobCFrame = CFrame.new(1572, 10, 4374)},
    {MinLevel = 90,  MaxLevel = 99,  Mob = "Snow Bandit",          QuestName = "SnowQuest",       QuestLevel = 1, NPCCFrame = CFrame.new(1384.8, 87.3, -1298.1), MobCFrame = CFrame.new(1287, 105, -1380)},
    {MinLevel = 100, MaxLevel = 119, Mob = "Snowman",              QuestName = "SnowQuest",       QuestLevel = 2, NPCCFrame = CFrame.new(1384.8, 87.3, -1298.1), MobCFrame = CFrame.new(1287, 105, -1380)},
    {MinLevel = 120, MaxLevel = 149, Mob = "Chief Petty Officer", QuestName = "MarineQuest2",    QuestLevel = 1, NPCCFrame = CFrame.new(-5035.4, 27.4, 4324.7), MobCFrame = CFrame.new(-4856, 22, 4263)},
    {MinLevel = 150, MaxLevel = 174, Mob = "Sky Bandit",           QuestName = "SkyQuest",        QuestLevel = 1, NPCCFrame = CFrame.new(-4839.5, 717.7, -2619),  MobCFrame = CFrame.new(-4975, 718, -2628)},
    {MinLevel = 175, MaxLevel = 189, Mob = "Dark Master",          QuestName = "SkyQuest",        QuestLevel = 2, NPCCFrame = CFrame.new(-4839.5, 717.7, -2619),  MobCFrame = CFrame.new(-5223, 388, -2273)},
    {MinLevel = 190, MaxLevel = 224, Mob = "Prisoner",             QuestName = "PrisonerQuest",   QuestLevel = 1, NPCCFrame = CFrame.new(530.8, 1.7, 474.1),      MobCFrame = CFrame.new(480, 3, 525)},
    {MinLevel = 225, MaxLevel = 274, Mob = "Dangerous Prisoner",  QuestName = "PrisonerQuest",   QuestLevel = 2, NPCCFrame = CFrame.new(530.8, 1.7, 474.1),      MobCFrame = CFrame.new(530, 3, 740)},
    {MinLevel = 275, MaxLevel = 299, Mob = "Military Soldier",    QuestName = "MagmaQuest",      QuestLevel = 1, NPCCFrame = CFrame.new(-5313.3, 12.2, 8515.2), MobCFrame = CFrame.new(-5400, 11, 8515)},
    {MinLevel = 300, MaxLevel = 324, Mob = "Military Officer",   QuestName = "MagmaQuest",      QuestLevel = 2, NPCCFrame = CFrame.new(-5313.3, 12.2, 8515.2), MobCFrame = CFrame.new(-5815, 84, 8820)},
    {MinLevel = 325, MaxLevel = 374, Mob = "Fishman Warrior",     QuestName = "FishmanQuest",    QuestLevel = 1, NPCCFrame = CFrame.new(61163.8, 18.5, 1568.8), MobCFrame = CFrame.new(60800, 18, 1500)},
    {MinLevel = 375, MaxLevel = 449, Mob = "Fishman Commando",    QuestName = "FishmanQuest",    QuestLevel = 2, NPCCFrame = CFrame.new(61163.8, 18.5, 1568.8), MobCFrame = CFrame.new(61800, 18, 1400)},
    {MinLevel = 450, MaxLevel = 524, Mob = "God's Guard",         QuestName = "SkyExp1Quest",    QuestLevel = 1, NPCCFrame = CFrame.new(-4721.8, 845.3, -1949.9),MobCFrame = CFrame.new(-4725, 845, -1950)},
    {MinLevel = 525, MaxLevel = 549, Mob = "Shanda",               QuestName = "SkyExp2Quest",    QuestLevel = 1, NPCCFrame = CFrame.new(-7861.8, 5545.5, -380.2),MobCFrame = CFrame.new(-7700, 5560, -500)},
    {MinLevel = 550, MaxLevel = 624, Mob = "Royal Squad",         QuestName = "SkyExp2Quest",    QuestLevel = 2, NPCCFrame = CFrame.new(-7861.8, 5545.5, -380.2),MobCFrame = CFrame.new(-7900, 5600, -600)},
    {MinLevel = 625, MaxLevel = 699, Mob = "Galley Pirate",       QuestName = "FountainQuest",   QuestLevel = 1, NPCCFrame = CFrame.new(5259.8, 38.5, 4050),    MobCFrame = CFrame.new(5580, 38, 3990)},
    {MinLevel = 700, MaxLevel = 700, Mob = "Galley Captain",      QuestName = "FountainQuest",   QuestLevel = 2, NPCCFrame = CFrame.new(5259.8, 38.5, 4050),    MobCFrame = CFrame.new(5640, 38, 4400)}
}

local BossesList = {
    ["Gorilla King"]    = CFrame.new(-1128, 6, -451),
    ["Bobby"]           = CFrame.new(-1131, 14, 4080),
    ["The Saw"]         = CFrame.new(-690, 15, 1580),
    ["Yeti"]            = CFrame.new(1185, 105, -1518),
    ["Vice Admiral"]    = CFrame.new(-4807, 21, 4360),
    ["Warden"]          = CFrame.new(482, 3, 715),
    ["Chief Warden"]    = CFrame.new(520, 3, 670),
    ["Swan"]            = CFrame.new(520, 3, 1150),
    ["Magma Admiral"]   = CFrame.new(-5690, 18, 8735),
    ["Fishman Lord"]    = CFrame.new(61350, 18, 1100),
    ["Wysper"]          = CFrame.new(-7927, 5551, -637),
    ["Thunder God"]     = CFrame.new(-7750, 5607, -230),
    ["Cyborg"]          = CFrame.new(6118, 10, 3950),
    ["Saber Expert"]    = CFrame.new(-1460, 30, -50)
}

local IslandLocations = {
    ["Starter Pirate"]  = CFrame.new(1095, 16, 1420),
    ["Starter Marine"]  = CFrame.new(-2575, 7, 2050),
    ["Selva (Jungle)"]  = CFrame.new(-1598, 37, 153),
    ["Aldea Pirata"]    = CFrame.new(-1140, 4, 3828),
    ["Desierto"]        = CFrame.new(897, 6, 4388),
    ["Middle Town"]     = CFrame.new(-690, 15, 1580),
    ["Pueblo Congelado"]= CFrame.new(1385, 87, -1298),
    ["Base Marina"]     = CFrame.new(-5035, 27, 4324),
    ["Skypiea (Isla 1)"]= CFrame.new(-4839, 717, -2619),
    ["Skypiea (Upper)"] = CFrame.new(-7861, 5545, -380),
    ["Prisión"]         = CFrame.new(530, 2, 474),
    ["Aldea Magma"]     = CFrame.new(-5313, 12, 8515),
    ["Ciudad Submarina"]= CFrame.new(61163, 18, 1569),
    ["Ciudad Fuente"]   = CFrame.new(5259, 38, 4050)
}

-- ============================================================================
-- FUNCIONES AUXILIARES SEGURO-VERIFICADAS
-- ============================================================================
local function GetPlayerLevel()
    if LocalPlayer:FindFirstChild("Data") and LocalPlayer.Data:FindFirstChild("Level") then
        return LocalPlayer.Data.Level.Value
    end
    return 1
end

local function GetCurrentQuest()
    local lvl = GetPlayerLevel()
    for _, q in ipairs(Quests) do
        if lvl >= q.MinLevel and lvl <= q.MaxLevel then
            return q
        end
    end
    return Quests[1]
end

local function HasQuest()
    local main = LocalPlayer.PlayerGui:FindFirstChild("Main")
    return main and main:FindFirstChild("Quest") and main.Quest.Visible
end

local function TweenTo(targetCFrame)
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    local hrp = LocalPlayer.Character.HumanoidRootPart

    local dist = (hrp.Position - targetCFrame.Position).Magnitude
    local duration = dist / math.max(_G.TweenSpeed, 50)

    _G.Noclip = true
    local tweenInfo = TweenInfo.new(duration, Enum.EasingStyle.Linear)
    local tween = TweenService:Create(hrp, tweenInfo, {CFrame = targetCFrame})
    tween:Play()
    
    tween.Completed:Connect(function()
        _G.Noclip = false
    end)
    return tween
end

local function EquipToolCategory(category)
    local backpack = LocalPlayer:FindFirstChild("Backpack")
    local character = LocalPlayer.Character
    if not backpack or not character or not character:FindFirstChildOfClass("Humanoid") then return end

    for _, tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") and (tool.ToolTip == category or tool.Name:find(category)) then
            character.Humanoid:EquipTool(tool)
            break
        end
    end
end

local function FastAttack()
    pcall(function()
        local netFolder = ReplicatedStorage:FindFirstChild("Modules") and ReplicatedStorage.Modules:FindFirstChild("Net")
        if netFolder and netFolder:FindFirstChild("RegisterAttack") then
            netFolder.RegisterAttack:FireServer(0)
        else
            VirtualUser:CaptureController()
            VirtualUser:Button1Down(Vector2.new(0, 0))
            VirtualUser:Button1Up(Vector2.new(0, 0))
        end
    end)
end

local function BringEnemiesTo(targetPos)
    local enemiesFolder = Workspace:FindFirstChild("Enemies")
    if not enemiesFolder then return end

    for _, enemy in ipairs(enemiesFolder:GetChildren()) do
        local hrp = enemy:FindFirstChild("HumanoidRootPart")
        local humanoid = enemy:FindFirstChildOfClass("Humanoid")
        if hrp and humanoid and humanoid.Health > 0 then
            if (hrp.Position - targetPos).Magnitude <= 350 then
                hrp.Size = Vector3.new(50, 50, 50)
                hrp.Transparency = 0.8
                hrp.CanCollide = false
                hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                hrp.CFrame = CFrame.new(targetPos)
            end
        end
    end
end

local function AutoBusoHandler()
    if _G.AutoBuso and LocalPlayer.Character then
        if not LocalPlayer.Character:FindFirstChild("HasBuso") then
            pcall(function() CommF:InvokeServer("HasBuso") end)
        end
    end
end

local function ApplyESP(model, color)
    if model and not model:FindFirstChild("ESPHighlight") then
        local hl = Instance.new("Highlight")
        hl.Name = "ESPHighlight"
        hl.FillColor = color
        hl.OutlineColor = Color3.fromRGB(255, 255, 255)
        hl.FillTransparency = 0.5
        hl.Adornee = model
        hl.Parent = model
    end
end

local function RemoveESP(model)
    if model and model:FindFirstChild("ESPHighlight") then
        model.ESPHighlight:Destroy()
    end
end

-- Anti-AFK & Noclip
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
end)

RunService.Stepped:Connect(function()
    if _G.Noclip and LocalPlayer.Character then
        for _, v in ipairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") then
                v.CanCollide = false
            end
        end
    end
end)

-- ============================================================================
-- INTERFAZ FLUENT DE CONTROL
-- ============================================================================
local Window = Fluent:CreateWindow({
    Title = "Blox Fruits | Sea 1 Module",
    SubTitle = "GitHub: Waza123-beep",
    TabWidth = 160,
    Size = UDim2.fromOffset(620, 480),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = Enum.KeyCode.LeftControl
})

local Tabs = {
    Main      = Window:AddTab({ Title = "Auto Farm", Icon = "sword" }),
    Bosses    = Window:AddTab({ Title = "Jefes (Bosses)", Icon = "skull" }),
    Quests    = Window:AddTab({ Title = "Misiones / Sea 2", Icon = "flag" }),
    Stats     = Window:AddTab({ Title = "Stats", Icon = "bar-chart-2" }),
    Fruits    = Window:AddTab({ Title = "Frutas", Icon = "apple" }),
    Shop      = Window:AddTab({ Title = "Tienda", Icon = "shopping-cart" }),
    Teleport  = Window:AddTab({ Title = "Teleports", Icon = "map-pin" }),
    ESP       = Window:AddTab({ Title = "ESP Visuales", Icon = "eye" }),
    Settings  = Window:AddTab({ Title = "Configuración", Icon = "settings" })
}

-- TAB: AUTO FARM
Tabs.Main:AddToggle("AutoFarmToggle", { Title = "Auto Farm Level", Default = false, Callback = function(v) _G.AutoFarm = v end })
Tabs.Main:AddToggle("AutoNearestToggle", { Title = "Auto Farm Enemigo Cercano", Default = false, Callback = function(v) _G.AutoFarmNearest = v end })
Tabs.Main:AddToggle("FastAttackToggle", { Title = "Fast Attack", Default = true, Callback = function(v) _G.FastAttack = v end })
Tabs.Main:AddToggle("BringMobsToggle", { Title = "Bring Mobs", Default = true, Callback = function(v) _G.BringMobs = v end })
Tabs.Main:AddDropdown("WeaponSelect", { Title = "Arma Equipada", Values = {"Melee", "Sword", "Blox Fruit", "Gun"}, Default = 1, Callback = function(v) _G.SelectWeapon = v end })
Tabs.Main:AddSlider("TweenSpeedSlider", { Title = "Velocidad Tween", Default = 250, Min = 100, Max = 350, Rounding = 0, Callback = function(v) _G.TweenSpeed = v end })

-- TAB: BOSSES
local bossNameList = {}
for name, _ in pairs(BossesList) do table.insert(bossNameList, name) end
Tabs.Bosses:AddDropdown("BossDropdown", { Title = "Seleccionar Jefe", Values = bossNameList, Multi = false, Default = 1, Callback = function(v) _G.SelectedBoss = v end })
Tabs.Bosses:AddToggle("AutoBossToggle", { Title = "Auto Farm Jefe", Default = false, Callback = function(v) _G.AutoBoss = v end })

-- TAB: QUESTS & SEA 2
Tabs.Quests:AddButton({
    Title = "Resolver Puzzle de Saber (Shanks)",
    Callback = function()
        local buttons = {
            CFrame.new(-1602, 36, 152), CFrame.new(-1461, 30, 2),
            CFrame.new(-1317, 39, -493), CFrame.new(-1526, 30, -305),
            CFrame.new(-1667, 36, -177)
        }
        for _, btn in ipairs(buttons) do TweenTo(btn) task.wait(1) end
    end
})
Tabs.Quests:AddToggle("AutoSaberToggle", { Title = "Auto Farm Saber Expert", Default = false, Callback = function(v) _G.AutoSaber = v end })
Tabs.Quests:AddToggle("AutoSecondSeaToggle", { Title = "Auto Viajar a Sea 2 (Req. Niv 700)", Default = false, Callback = function(v) _G.AutoSecondSea = v end })

-- TAB: STATS
local StatMap = { Melee = "Melee", Defense = "Defense", Sword = "Sword", Gun = "Gun", Fruit = "Demon Fruit" }
for StatKey, _ in pairs(StatMap) do
    Tabs.Stats:AddToggle("Stat_" .. StatKey, { Title = "Auto " .. StatKey, Default = false, Callback = function(v) _G.AutoStats[StatKey] = v end })
end
Tabs.Stats:AddSlider("StatPointsSlider", { Title = "Puntos por Pulso", Default = 1, Min = 1, Max = 10, Rounding = 0, Callback = function(v) _G.AutoStats.PointsPerTick = v end })

-- TAB: FRUTAS
Tabs.Fruits:AddButton({ Title = "Comprar Fruta Gacha", Callback = function() pcall(function() CommF:InvokeServer("Cousin", "Buy") end) end })
Tabs.Fruits:AddToggle("AutoStoreToggle", { Title = "Auto Guardar Frutas", Default = false, Callback = function(v) _G.AutoStoreFruit = v end })
Tabs.Fruits:AddToggle("AutoBringToggle", { Title = "Traer Frutas del Mapa", Default = false, Callback = function(v) _G.AutoBringFruits = v end })
Tabs.Fruits:AddToggle("AutoEatToggle", { Title = "Auto Comer Frutas", Default = false, Callback = function(v) _G.AutoEatFruit = v end })

-- TAB: TIENDA
Tabs.Shop:AddButton({ Title = "Aura (Buso) - $25,000", Callback = function() pcall(function() CommF:InvokeServer("BuyHaki", "Buso") end) end })
Tabs.Shop:AddButton({ Title = "Skyjump - $10,000", Callback = function() pcall(function() CommF:InvokeServer("BuyHaki", "Geppo") end) end })
Tabs.Shop:AddButton({ Title = "Flash Step - $100,000", Callback = function() pcall(function() CommF:InvokeServer("BuyHaki", "Sori") end) end })
Tabs.Shop:AddButton({ Title = "Black Leg - $150,000", Callback = function() pcall(function() CommF:InvokeServer("BuyItem", "Black Leg") end) end })
Tabs.Shop:AddButton({ Title = "Electro - $500,000", Callback = function() pcall(function() CommF:InvokeServer("BuyItem", "Electro") end) end })
Tabs.Shop:AddButton({ Title = "Fishman Karate - $750,000", Callback = function() pcall(function() CommF:InvokeServer("BuyItem", "Fishman Karate") end) end })

-- TAB: TELEPORTS
local islandList = {}
for name, _ in pairs(IslandLocations) do table.insert(islandList, name) end
Tabs.Teleport:AddDropdown("TeleportIslandDropdown", { Title = "Seleccionar Isla", Values = islandList, Multi = false, Default = 1, Callback = function(v) _G.SelectedIslandTP = v end })
Tabs.Teleport:AddButton({ Title = "Teletransportarse", Callback = function() if _G.SelectedIslandTP then TweenTo(IslandLocations[_G.SelectedIslandTP]) end end })
Tabs.Teleport:AddToggle("AutoChestToggle", { Title = "Auto Farm Cofres", Default = false, Callback = function(v) _G.AutoChest = v end })

-- TAB: ESP
Tabs.ESP:AddToggle("ESP_Players", { Title = "ESP Jugadores", Default = false, Callback = function(v) _G.ESP.Players = v end })
Tabs.ESP:AddToggle("ESP_Enemies", { Title = "ESP Enemigos", Default = false, Callback = function(v) _G.ESP.Enemies = v end })
Tabs.ESP:AddToggle("ESP_Fruits", { Title = "ESP Frutas", Default = false, Callback = function(v) _G.ESP.Fruits = v end })

-- TAB: CONFIGURACIÓN
Tabs.Settings:AddButton({ Title = "Rejoin Servidor", Callback = function() TeleportService:Teleport(game.PlaceId, LocalPlayer) end })

-- ============================================================================
-- HILOS DE EJECUCIÓN SÍNCRO-SEGUROS
-- ============================================================================

-- HILO 1: Auto Farm Principal & Farm Cercano
task.spawn(function()
    while task.wait(0.1) do
        if _G.AutoFarm then
            local quest = GetCurrentQuest()
            if quest then
                EquipToolCategory(_G.SelectWeapon)
                AutoBusoHandler()
                
                if not HasQuest() then
                    TweenTo(quest.NPCCFrame)
                    task.wait(0.5)
                    pcall(function() CommF:InvokeServer("StartQuest", quest.QuestName, quest.QuestLevel) end)
                else
                    local targetMob = nil
                    local enemies = Workspace:FindFirstChild("Enemies")
                    if enemies then
                        for _, v in ipairs(enemies:GetChildren()) do
                            if v.Name == quest.Mob and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 and v:FindFirstChild("HumanoidRootPart") then
                                targetMob = v
                                break
                            end
                        end
                    end

                    if targetMob and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                        LocalPlayer.Character.HumanoidRootPart.CFrame = targetMob.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)
                        if _G.BringMobs then BringEnemiesTo(targetMob.HumanoidRootPart.Position) end
                        if _G.FastAttack then FastAttack() end
                    else
                        TweenTo(quest.MobCFrame)
                    end
                end
            end
        elseif _G.AutoFarmNearest then
            local nearest = nil
            local dist = math.huge
            local enemies = Workspace:FindFirstChild("Enemies")
            if enemies and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                for _, enemy in ipairs(enemies:GetChildren()) do
                    local hrp = enemy:FindFirstChild("HumanoidRootPart")
                    local hum = enemy:FindFirstChildOfClass("Humanoid")
                    if hrp and hum and hum.Health > 0 then
                        local d = (hrp.Position - LocalPlayer.Character.HumanoidRootPart.Position).Magnitude
                        if d < dist then dist = d; nearest = enemy end
                    end
                end
            end

            if nearest and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                EquipToolCategory(_G.SelectWeapon)
                LocalPlayer.Character.HumanoidRootPart.CFrame = nearest.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)
                if _G.FastAttack then FastAttack() end
            end
        end
    end
end)

-- HILO 2: Auto Bosses & Auto Saber
task.spawn(function()
    while task.wait(0.1) do
        if _G.AutoBoss and _G.SelectedBoss ~= "" then
            local bossTarget = nil
            local enemies = Workspace:FindFirstChild("Enemies")
            if enemies then
                for _, enemy in ipairs(enemies:GetChildren()) do
                    if enemy.Name == _G.SelectedBoss and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                        bossTarget = enemy
                        break
                    end
                end
            end

            if bossTarget and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                EquipToolCategory(_G.SelectWeapon)
                LocalPlayer.Character.HumanoidRootPart.CFrame = bossTarget.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)
                if _G.FastAttack then FastAttack() end
            else
                local bossCF = BossesList[_G.SelectedBoss]
                if bossCF then TweenTo(bossCF) end
            end
        elseif _G.AutoSaber then
            local saberExpert = Workspace.Enemies:FindFirstChild("Saber Expert")
            if saberExpert and saberExpert:FindFirstChild("Humanoid") and saberExpert.Humanoid.Health > 0 and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                EquipToolCategory(_G.SelectWeapon)
                LocalPlayer.Character.HumanoidRootPart.CFrame = saberExpert.HumanoidRootPart.CFrame * CFrame.new(0, 10, 0)
                if _G.FastAttack then FastAttack() end
            else
                TweenTo(BossesList["Saber Expert"])
            end
        end
    end
end)

-- HILO 3: Frutas, Cofres, Stats & Auto Eat
task.spawn(function()
    while task.wait(1.5) do
        if _G.AutoStoreFruit then
            for _, item in ipairs(LocalPlayer.Backpack:GetChildren()) do
                if item:IsA("Tool") and item.Name:find("Fruit") then
                    pcall(function() CommF:InvokeServer("StoreFruit", item.Name, item) end)
                end
            end
        end

        if _G.AutoBringFruits then
            for _, v in ipairs(Workspace:GetChildren()) do
                if v:IsA("Tool") and v.Name:find("Fruit") and v:FindFirstChild("Handle") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    v.Handle.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame
                end
            end
        end

        if _G.AutoEatFruit then
            for _, item in ipairs(LocalPlayer.Backpack:GetChildren()) do
                if item:IsA("Tool") and item.Name:find("Fruit") then
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                        LocalPlayer.Character.Humanoid:EquipTool(item)
                        item:Activate()
                    end
                end
            end
        end

        if _G.AutoChest then
            for _, obj in ipairs(Workspace:GetDescendants()) do
                if obj:IsA("Part") and string.find(obj.Name, "Chest") then
                    TweenTo(obj.CFrame)
                    task.wait(0.3)
                end
            end
        end

        for StatKey, Enabled in pairs(_G.AutoStats) do
            if Enabled and StatMap[StatKey] then
                pcall(function() CommF:InvokeServer("AddPoint", StatMap[StatKey], _G.AutoStats.PointsPerTick or 1) end)
            end
        end
    end
end)

-- HILO 4: Transición a Sea 2
task.spawn(function()
    while task.wait(2) do
        if _G.AutoSecondSea and GetPlayerLevel() >= 700 then
            pcall(function()
                CommF:InvokeServer("MilitaryDetective", "1")
                task.wait(1)
                CommF:InvokeServer("TravelMain")
            end)
        end
    end
end)

-- HILO 5: Motor Renderizador ESP
task.spawn(function()
    while task.wait(0.5) do
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character then
                if _G.ESP.Players then ApplyESP(plr.Character, Color3.fromRGB(0, 255, 0)) else RemoveESP(plr.Character) end
            end
        end

        local enemies = Workspace:FindFirstChild("Enemies")
        if enemies then
            for _, enemy in ipairs(enemies:GetChildren()) do
                if _G.ESP.Enemies then ApplyESP(enemy, Color3.fromRGB(255, 0, 0)) else RemoveESP(enemy) end
            end
        end

        for _, obj in ipairs(Workspace:GetChildren()) do
            if obj:IsA("Tool") and obj.Name:find("Fruit") then
                if _G.ESP.Fruits then ApplyESP(obj, Color3.fromRGB(255, 255, 0)) else RemoveESP(obj) end
            end
        end
    end
end)

-- ============================================================================
-- INICIALIZACIÓN DE LA LIBRERÍA
-- ============================================================================
InterfaceManager:SetLibrary(Fluent)
SaveManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:BuildConfigSection(Tabs.Settings)
InterfaceManager:BuildInterfaceSection(Tabs.Settings)

Window:SelectTab(1)
Fluent:Notify({
    Title = "Sea 1 Module Loaded",
    Content = "Script para Sea 1 ejecutado correctamente desde el repositorio.",
    Duration = 5
})
