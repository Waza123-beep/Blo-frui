-- ============================================
-- Sea2Functions.lua
-- Segundo Mar: Niveles 700-1500, Factory, Raids, Race V2/V3
-- ============================================

local Sea2Functions = {}

function Sea2Functions.Initialize(Window, Tabs, Fluent)
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local LocalPlayer = Players.LocalPlayer
    
    local CommF_ = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")
    
    -- Variables
    local AutoFarmLevel = false
    local AutoFactory = false
    local AutoRaid = false
    local AutoRaceV2 = false
    local AutoRaceV3 = false
    
    -- ==========================================
    -- CONFIGURACIÓN DEL SEGUNDO MAR
    -- ==========================================
    
    local Sea2Data = {
        Islands = {
            {Name = "Kingdom of Rose", Level = {700, 850}, Quest = "Area1Quest", NPC = "Raider", Pos = CFrame.new(-321, 73, 297)},
            {Name = "Green Zone", Level = {850, 950}, Quest = "MarineQuest3", NPC = "Marine Lieutenant", Pos = CFrame.new(-2447, 73, -3211)},
            {Name = "Graveyard", Level = {950, 1000}, Quest = "GraveyardQuest", NPC = "Zombie", Pos = CFrame.new(-9515, 142, 5536)},
            {Name = "Snow Mountain", Level = {1000, 1100}, Quest = "SnowMountainQuest", NPC = "Snow Trooper", Pos = CFrame.new(561, 401, -5306)},
            {Name = "Hot and Cold", Level = {1100, 1200}, Quest = "FireSideQuest", NPC = "Magma Ninja", Pos = CFrame.new(-6026, 15, -5062)},
            {Name = "Cursed Ship", Level = {1200, 1350}, Quest = "ShipQuest", NPC = "Ship Deckhand", Pos = CFrame.new(902, 126, 33071)},
            {Name = "Ice Castle", Level = {1350, 1450}, Quest = "FrostQuest", NPC = "Arctic Warrior", Pos = CFrame.new(6137, 294, -6747)},
            {Name = "Forgotten Island", Level = {1450, 1500}, Quest = "ForgottenQuest", NPC = "Sea Soldier", Pos = CFrame.new(-3043, 238, -10191)}
        },
        
        Bosses = {
            {Name = "Diamond", Level = 750, Quest = "Area1Quest", CFrame = CFrame.new(-1576, 198, 13)},
            {Name = "Jeremy", Level = 850, Quest = "Area2Quest", CFrame = CFrame.new(2006, 448, 853)},
            {Name = "Orbitus", Level = 950, Quest = "MarineQuest3", CFrame = CFrame.new(-2172, 103, -4015)},
            {Name = "Don Swan", Level = 1000, Quest = nil, CFrame = CFrame.new(2286, 15, 863), RaidBoss = true},
            {Name = "Smoke Admiral", Level = 1150, Quest = "IceSideQuest", CFrame = CFrame.new(-5275, 20, -5260)},
            {Name = "Awakened Ice Admiral", Level = 1400, Quest = "FrostQuest", CFrame = CFrame.new(6403, 340, -6894)},
            {Name = "Tide Keeper", Level = 1475, Quest = "ForgottenQuest", CFrame = CFrame.new(-3795, 105, -11421)},
            {Name = "Darkbeard", Level = 1000, Quest = nil, CFrame = CFrame.new(3677, 62, -3144), RaidBoss = true, Item = "Fist of Darkness"},
            {Name = "Cursed Captain", Level = 1325, Quest = nil, CFrame = CFrame.new(916, 181, 33422), NightOnly = true},
            {Name = "Order", Level = 1250, Quest = nil, CFrame = CFrame.new(-6217, 28, -5053), RaidBoss = true}
        },
        
        Factory = {
            Position = CFrame.new(448, 199, -441),
            CoreName = "Core"
        },
        
        Raids = {
            Chips = {"Flame", "Ice", "Quake", "Light", "Dark", "String", "Rumble", "Magma", "Human: Buddha", "Sand", " "},
            Locations = {
                CFrame.new(-6438, 250, -4491), -- Second Sea Raid Entrance
            }
        },
        
        RaceV2 = {
            RequiredLevel = 850,
            AlchemistPos = CFrame.new(-2775, 72, -936), -- Verificar posición real
            FlowerQuest = true
        },
        
        RaceV3 = {
            RequiredLevel = 1000,
            WenlockPos = CFrame.new(-2200, 100, -1800), -- Verificar posición real
            Requirements = {"Kill 50 Enemies", "Complete Quests"}
        }
    }
    
    -- ==========================================
    -- UI: MAIN
    -- ==========================================
    
    Tabs.Main:AddParagraph({
        Title = "Second Sea Status",
        Content = "Level Range: 700-1500\nFeatures: Factory Raid, Raids, Race V2/V3"
    })
    
    -- Auto Travel to Third Sea
    Tabs.Main:AddToggle("AutoThirdSea", {
        Title = "Auto Travel Third Sea (Lv 1500+)",
        Default = false,
        Callback = function(Value)
            if Value then
                task.spawn(function()
                    while Value do
                        task.wait(1)
                        if LocalPlayer.Data.Level.Value >= 1500 then
                            -- CommF_:InvokeServer("TravelZou") -- Verificar remote exacto
                        end
                    end
                end)
            end
        end
    })
    
    -- ==========================================
    -- UI: FACTORY RAID
    -- ==========================================
    
    Tabs.Farm:AddSection("Factory Raid")
    
    Tabs.Farm:AddToggle("AutoFactory", {
        Title = "Auto Factory Raid",
        Description = "Automatically attack factory core when available",
        Default = false,
        Callback = function(Value)
            AutoFactory = Value
            if Value then
                task.spawn(function()
                    while AutoFactory do
                        task.wait(1)
                        -- Verificar si la factory está abierta
                        -- Buscar "Core" en workspace.Enemies
                        -- Atacar hasta destruir
                    end
                end)
            end
        end
    })
    
    -- ==========================================
    -- UI: RAIDS
    -- ==========================================
    
    Tabs.Farm:AddSection("Raids")
    
    Tabs.Farm:AddDropdown("RaidChip", {
        Title = "Select Raid Chip",
        Values = Sea2Data.Raids.Chips,
        Callback = function(Value)
            -- Guardar selección
        end
    })
    
    Tabs.Farm:AddToggle("AutoRaid", {
        Title = "Auto Complete Raids",
        Description = "Buy chip, start raid, and complete all islands",
        Default = false,
        Callback = function(Value)
            AutoRaid = Value
            if Value then
                task.spawn(function()
                    while AutoRaid do
                        task.wait(2)
                        -- 1. Comprar chip si no tiene
                        -- 2. Ir a localización de raid
                        -- 3. Activar raid
                        -- 4. Farmear cada isla automáticamente
                        -- 5. Awaken fruit si es posible
                    end
                end)
            end
        end
    })
    
    -- ==========================================
    -- UI: RACE V2/V3
    -- ==========================================
    
    Tabs.Quests:AddSection("Race Evolution")
    
    Tabs.Quests:AddToggle("AutoRaceV2", {
        Title = "Auto Race V2",
        Description = "Complete Alchemist quest and flower quest",
        Default = false,
        Callback = function(Value)
            AutoRaceV2 = Value
            if Value then
                task.spawn(function()
                    while AutoRaceV2 do
                        task.wait(2)
                        -- Verificar progreso con Alchemist
                        -- Buscar flores (Flower1, Flower2, Flower3)
                        -- Completar quest
                    end
                end)
            end
        end
    })
    
    Tabs.Quests:AddToggle("AutoRaceV3", {
        Title = "Auto Race V3",
        Description = "Complete Wenlocktoad quest",
        Default = false,
        Callback = function(Value)
            AutoRaceV3 = Value
            if Value then
                task.spawn(function()
                    while AutoRaceV3 do
                        task.wait(2)
                        -- Matar 50 enemigos
                        -- Completar requisitos específicos de raza
                    end
                end)
            end
        end
    })
    
    -- ==========================================
    -- UI: CODES (SEA 2 SPECIFIC)
    -- ==========================================
    
    Tabs.Codes:AddSection("Second Sea Codes")
    
    local Sea2Codes = {
        "UPDATE30", "SECONDSEA", "RACEV2UPDATE",
        "Sub2Fer999", "Enyu_is_Pro", "Magicbus",
        "JCWK", "Starcodeheo", "Bluxxy"
    }
    
    Tabs.Codes:AddButton({
        Title = "Redeem Sea 2 Codes",
        Callback = function()
            for _, code in ipairs(Sea2Codes) do
                CommF_:InvokeServer("RedeemCode", code)
                task.wait(0.5)
            end
        end
    })
end

return Sea2Functions
