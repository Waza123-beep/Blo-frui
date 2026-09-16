-- ============================================
-- Sea1Functions.lua
-- Primer Mar: Niveles 1-700, Update 30, First Sea Rework
-- ============================================

local Sea1Functions = {}

function Sea1Functions.Initialize(Window, Tabs, Fluent)
    local Players = game:GetService("Players")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local LocalPlayer = Players.LocalPlayer
    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    
    -- Remotes comunes
    local CommF_ = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("CommF_")
    
    -- Variables de estado
    local AutoFarmLevel = false
    local AutoFarmQuest = false
    local AutoSecretQuests = false -- Update 30 Feature
    local AutoCombatV2 = false     -- Update 30 Feature
    local FastAttackEnabled = false
    
    -- ==========================================
    -- CONFIGURACIÓN DE ISLAS Y MISIONES (SEA 1)
    -- ==========================================
    
    local Sea1Data = {
        -- Estructura basada en Update 30 / First Sea Rework
        -- NOTA: Verificar en juego los nombres exactos de las quests
        Islands = {
            {Name = "Starter Island", Level = {1, 10}, Quest = "BanditQuest1", NPC = "Bandit", Pos = CFrame.new(1060, 17, 1550)},
            {Name = "Jungle", Level = {10, 30}, Quest = "JungleQuest", NPC = "Monkey", Pos = CFrame.new(-1600, 36, 150)},
            {Name = "Pirate Village", Level = {30, 60}, Quest = "BuggyQuest1", NPC = "Pirate", Pos = CFrame.new(-1125, 5, 3850)},
            {Name = "Desert", Level = {60, 90}, Quest = "DesertQuest", NPC = "Desert Bandit", Pos = CFrame.new(1090, 7, 4370)},
            {Name = "Frozen Village", Level = {90, 120}, Quest = "SnowQuest", NPC = "Snow Bandit", Pos = CFrame.new(1200, 28, -1500)},
            {Name = "Marine Fortress", Level = {120, 150}, Quest = "MarineQuest2", NPC = "Chief Petty Officer", Pos = CFrame.new(-4500, 20, 4250)},
            {Name = "Skylands (Lower)", Level = {150, 190}, Quest = "SkyExp1Quest", NPC = "Sky Bandit", Pos = CFrame.new(-5000, 700, -2500)},
            {Name = "Prison", Level = {190, 250}, Quest = "PrisonQuest", NPC = "Prisoner", Pos = CFrame.new(4875, 6, 735)},
            {Name = "Colosseum", Level = {250, 300}, Quest = "ColosseumQuest", NPC = "Toga Warrior", Pos = CFrame.new(-1500, 60, -290)},
            {Name = "Magma Village", Level = {300, 375}, Quest = "MagmaQuest", NPC = "Military Soldier", Pos = CFrame.new(-5200, 8, 8400)},
            {Name = "Underwater City", Level = {375, 450}, Quest = "FishmanQuest", NPC = "Fishman Warrior", Pos = CFrame.new(61160, 5, 1819)},
            {Name = "Skylands (Upper)", Level = {450, 525}, Quest = "SkyExp2Quest", NPC = "God's Guard", Pos = CFrame.new(-7880, 5545, -380)},
            {Name = "Fountain City", Level = {525, 700}, Quest = "FountainQuest", NPC = "Galley Pirate", Pos = CFrame.new(5258, 38, 4050)}
        },
        
        Bosses = {
            {Name = "The Gorilla King", Level = 20, Quest = "JungleQuest", CFrame = CFrame.new(-1088, 8, -488)},
            {Name = "Bobby", Level = 55, Quest = "BuggyQuest1", CFrame = CFrame.new(-1087, 46, 4040)},
            {Name = "Yeti", Level = 110, Quest = "SnowQuest", CFrame = CFrame.new(1218, 138, -1488)},
            {Name = "Vice Admiral", Level = 130, Quest = "MarineQuest2", CFrame = CFrame.new(-5006, 88, 4353)},
            {Name = "Saber Expert", Level = 200, Quest = nil, CFrame = CFrame.new(-1458, 29, -50)}, -- Requiere puzzle
            {Name = "Chief Warden", Level = 230, Quest = "ImpelQuest", CFrame = CFrame.new(5206, 0.9, 814)},
            {Name = "Swan", Level = 240, Quest = "ImpelQuest", CFrame = CFrame.new(5325, 7, 719)},
            {Name = "Magma Admiral", Level = 350, Quest = "MagmaQuest", CFrame = CFrame.new(-5765, 82, 8718)},
            {Name = "Fishman Lord", Level = 425, Quest = "FishmanQuest", CFrame = CFrame.new(61260, 30, 1193)},
            {Name = "Wysper", Level = 500, Quest = "SkyExp2Quest", CFrame = CFrame.new(-7866, 5576, -546)},
            {Name = "Thunder God", Level = 575, Quest = "SkyExp2Quest", CFrame = CFrame.new(-7994, 5761, -2088)},
            {Name = "Cyborg", Level = 675, Quest = "FountainQuest", CFrame = CFrame.new(6094, 73, 3825)},
            {Name = "Greybeard", Level = 1125, Quest = nil, CFrame = CFrame.new(-5081, 85, 4257), RaidBoss = true}
        },
        
        -- Update 30: Island Secrets (Verificar nombres exactos en juego)
        IslandSecrets = {
            {Island = "Jungle", SecretName = "Jungle Mystery", Completed = false},
            {Island = "Pirate Village", SecretName = "Windmill Repair", Completed = false},
            {Island = "Desert", SecretName = "Temple of Sand", Completed = false},
            {Island = "Colosseum", SecretName = "Champion's Trial", Completed = false},
            {Island = "Upper Skylands", SecretName = "Heaven's Gate", Completed = false}
        },
        
        -- Update 30: Combat V2 Requirements (Verificar en juego)
        CombatV2Data = {
            RequiredSecrets = 5,
            RequiredLevel = 700,
            RequiredFightingStyle = "Combat", -- Solo Combat, no Super Human ni otros
            AwakenedBosses = {"Awakened Gorilla King", "Awakened Bobby", "Awakened Yeti"}, -- Verificar nombres reales
            FountainLocation = CFrame.new(5258, 38, 4050),
            SecretsMasterPos = CFrame.new(0, 0, 0) -- Verificar posición real
        }
    }
    
    -- ==========================================
    -- FUNCIONES UTILITARIAS
    -- ==========================================
    
    local function GetCurrentLevel()
        return LocalPlayer.Data.Level.Value
    end
    
    local function GetQuestForLevel(level)
        for _, island in ipairs(Sea1Data.Islands) do
            if level >= island.Level[1] and level <= island.Level[2] then
                return island
            end
        end
        return Sea1Data.Islands[#Sea1Data.Islands] -- Default a última isla
    end
    
    local function TeleportTo(cframe)
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            char.HumanoidRootPart.CFrame = cframe
        end
    end
    
    local function AttackRemote()
        -- Implementación de Fast Attack usando remotes reales
        pcall(function()
            local ReplicatedStorage = game:GetService("ReplicatedStorage")
            local Net = ReplicatedStorage:WaitForChild("Modules"):WaitForChild("Net")
            
            -- RemoteEvent para ataque
            local AttackRemote = Net:WaitForChild("RE/RegisterAttack")
            local HitRemote = Net:WaitForChild("RE/RegisterHit")
            
            -- Patrón de ataque rápido
            if AttackRemote and HitRemote then
                AttackRemote:FireServer(0.5)
                -- HitRemote requiere argumentos específicos del objetivo
            end
        end)
    end
    
    -- ==========================================
    -- UI: MAIN TAB (SEA 1 INFO)
    -- ==========================================
    
    Tabs.Main:AddParagraph({
        Title = "First Sea Status",
        Content = "Level: " .. GetCurrentLevel() .. "/700\nUpdate 30: First Sea Rework Active\nIsland Secrets: " .. #Sea1Data.IslandSecrets .. " Available"
    })
    
    -- Verificador de progreso para Second Sea
    Tabs.Main:AddButton({
        Title = "Check Second Sea Requirements",
        Description = "Verify if you can travel to Second Sea",
        Callback = function()
            local level = GetCurrentLevel()
            if level >= 700 then
                Fluent:Notify({Title = "Requirements Met", Content = "You can travel to Second Sea!", Duration = 5})
            else
                Fluent:Notify({Title = "Requirements Not Met", Content = "Need level 700. Current: " .. level, Duration = 5})
            end
        end
    })
    
    -- Auto Travel to Second Sea
    Tabs.Main:AddToggle("AutoSecondSea", {
        Title = "Auto Travel Second Sea (Lv 700+)",
        Default = false,
        Callback = function(Value)
            if Value then
                task.spawn(function()
                    while Value do
                        task.wait(1)
                        if GetCurrentLevel() >= 700 then
                            -- Verificar si tiene la llave o requisitos
                            -- CommF_:InvokeServer("TravelDressrosa") -- Verificar remote exacto
                            Fluent:Notify({Title = "Traveling", Content = "Attempting to travel to Second Sea...", Duration = 3})
                        end
                    end
                end)
            end
        end
    })
    
    -- ==========================================
    -- UI: FARM TAB
    -- ==========================================
    
    Tabs.Farm:AddSection("Level Farm")
    
    local SelectedFarmMethod = "Quest" -- Quest, Mob, Boss
    
    Tabs.Farm:AddDropdown("FarmMethod", {
        Title = "Farm Method",
        Description = "Select farming method",
        Values = {"Quest", "Mob", "Boss"},
        Default = "Quest",
        Callback = function(Value)
            SelectedFarmMethod = Value
        end
    })
    
    Tabs.Farm:AddToggle("AutoFarmLevel", {
        Title = "Auto Farm Level",
        Description = "Automatically farm at best location for your level",
        Default = false,
        Callback = function(Value)
            AutoFarmLevel = Value
            if Value then
                task.spawn(function()
                    while AutoFarmLevel do
                        task.wait(0.5)
                        local level = GetCurrentLevel()
                        local questData = GetQuestForLevel(level)
                        
                        if questData then
                            -- Lógica de farmeo
                            -- 1. Tomar quest
                            -- 2. Teletransportarse a enemigos
                            -- 3. Atacar
                            -- 4. Verificar completado
                            
                            -- Placeholder para lógica completa:
                            if SelectedFarmMethod == "Quest" then
                                -- CommF_:InvokeServer("StartQuest", questData.Quest, 1)
                                -- TeleportTo(questData.Pos)
                            end
                        end
                    end
                end)
            end
        end
    })
    
    -- ==========================================
    -- UI: ISLAND SECRETS (UPDATE 30)
    -- ==========================================
    
    Tabs.Quests:AddSection("Island Secrets (Update 30)")
    
    Tabs.Quests:AddParagraph({
        Title = "Secret Quests",
        Content = "Complete secret quests across islands to unlock Combat V2"
    })
    
    local SecretSelector = Tabs.Quests:AddDropdown("SecretSelector", {
        Title = "Select Secret",
        Description = "Choose which secret to complete",
        Values = {"All Auto", "Jungle Mystery", "Windmill Repair", "Temple of Sand", "Champion's Trial", "Heaven's Gate"},
        Default = "All Auto",
        Callback = function(Value)
            -- Lógica de selección
        end
    })
    
    Tabs.Quests:AddToggle("AutoIslandSecrets", {
        Title = "Auto Complete Island Secrets",
        Description = "Automatically complete available secret quests",
        Default = false,
        Callback = function(Value)
            AutoSecretQuests = Value
            if Value then
                task.spawn(function()
                    while AutoSecretQuests do
                        task.wait(2)
                        -- Verificar progreso de secretos
                        -- CommF_:InvokeServer("CheckSecretProgress") -- Verificar remote exacto
                        
                        -- Para cada secreto no completado:
                        -- 1. Teletransportarse a la isla
                        -- 2. Interactuar con NPCs/objetos específicos
                        -- 3. Resolver puzzles (patrones específicos por isla)
                        -- 4. Reportar completado
                    end
                end)
            end
        end
    })
    
    -- ==========================================
    -- UI: COMBAT V2 (UPDATE 30)
    -- ==========================================
    
    Tabs.Combat:AddSection("Combat V2 / Advanced Combat")
    
    Tabs.Combat:AddParagraph({
        Title = "Requirements",
        Content = "- Complete all Island Secrets\n- Reach Level 700\n- Defeat Awakened Bosses\n- Use only Combat Fighting Style"
    })
    
    -- Máquina de estados para Combat V2
    local CombatV2States = {
        CHECK_SECRETS = 1,
        CHECK_LEVEL = 2,
        EQUIP_COMBAT = 3,
        FIGHT_AWAKENED_BOSSES = 4,
        FOUNTAIN_PROGRESS = 5,
        UNLOCK_COMBAT_V2 = 6,
        COMPLETED = 7
    }
    
    local CurrentState = CombatV2States.CHECK_SECRETS
    
    Tabs.Combat:AddToggle("AutoCombatV2", {
        Title = "Auto Unlock Combat V2",
        Description = "Complete all requirements automatically",
        Default = false,
        Callback = function(Value)
            AutoCombatV2 = Value
            if Value then
                task.spawn(function()
                    while AutoCombatV2 and CurrentState ~= CombatV2States.COMPLETED do
                        task.wait(1)
                        
                        if CurrentState == CombatV2States.CHECK_SECRETS then
                            -- Verificar si todos los secretos están completados
                            -- Si sí, cambiar a CHECK_LEVEL
                            -- Si no, activar AutoIslandSecrets primero
                            
                        elseif CurrentState == CombatV2States.CHECK_LEVEL then
                            if GetCurrentLevel() >= 700 then
                                CurrentState = CombatV2States.EQUIP_COMBAT
                            else
                                Fluent:Notify({Title = "Combat V2", Content = "Need level 700 first!", Duration = 3})
                                task.wait(10)
                            end
                            
                        elseif CurrentState == CombatV2States.EQUIP_COMBAT then
                            -- Equipar Combat Fighting Style
                            -- Verificar que no tenga otros estilos equipados
                            -- CommF_:InvokeServer("EquipFightingStyle", "Combat")
                            
                        elseif CurrentState == CombatV2States.FIGHT_AWAKENED_BOSSES then
                            -- Derrotar Awakened Bosses usando SOLO Combat
                            -- Verificar que el daño sea solo de Combat (no frutas, espadas)
                            
                        elseif CurrentState == CombatV2States.FOUNTAIN_PROGRESS then
                            -- Progreso en la fuente
                            -- Completar requisitos de la fuente
                            
                        elseif CurrentState == CombatV2States.UNLOCK_COMBAT_V2 then
                            -- Hablar con Secrets Master
                            -- TeleportTo(Sea1Data.CombatV2Data.SecretsMasterPos)
                            -- CommF_:InvokeServer("UnlockCombatV2")
                            CurrentState = CombatV2States.COMPLETED
                        end
                    end
                end)
            end
        end
    })
    
    -- ==========================================
    -- UI: BOSSES
    -- ==========================================
    
    Tabs.Bosses:AddSection("Sea 1 Bosses")
    
    local BossList = {}
    for _, boss in ipairs(Sea1Data.Bosses) do
        table.insert(BossList, boss.Name)
    end
    
    local SelectedBoss = ""
    
    Tabs.Bosses:AddDropdown("BossSelector", {
        Title = "Select Boss",
        Values = BossList,
        Callback = function(Value)
            SelectedBoss = Value
        end
    })
    
    Tabs.Bosses:AddToggle("AutoFarmBoss", {
        Title = "Auto Farm Selected Boss",
        Default = false,
        Callback = function(Value)
            if Value and SelectedBoss ~= "" then
                task.spawn(function()
                    while Value do
                        task.wait(0.5)
                        -- Encontrar boss en workspace.Enemies o ReplicatedStorage
                        -- Teleportar y atacar
                        -- Verificar drop
                    end
                end)
            end
        end
    })
    
    -- ==========================================
    -- UI: CODES
    -- ==========================================
    
    Tabs.Codes:AddSection("Redeem Codes")
    
    -- Lista de códigos activos (verificar en wiki)
    local ActiveCodes = {
        "UPDATE30", "MAGNETUPDATE", "FIRSTSEAREWORK", 
        "SUB2GAMERROBOT", "GAMERROBOT_YT", "TYB1M",
        "Sub2Fer999", "Enyu_is_Pro", "Magicbus",
        "JCWK", "Starcodeheo", "Bluxxy",
        "fudd10_v2", "Fudd10", "BIGNEWS",
        "TheGreatAce", "Sub2NoobMaster123"
    }
    
    Tabs.Codes:AddButton({
        Title = "Redeem All Codes",
        Description = "Redeem all available codes",
        Callback = function()
            for _, code in ipairs(ActiveCodes) do
                CommF_:InvokeServer("RedeemCode", code)
                task.wait(0.5)
            end
            Fluent:Notify({Title = "Codes", Content = "All codes redeemed!", Duration = 3})
        end
    })
    
    -- ==========================================
    -- UI: FRUITS
    -- ==========================================
    
    Tabs.Fruits:AddSection("Fruit Management")
    
    Tabs.Fruits:AddButton({
        Title = "Check Normal Stock",
        Callback = function()
            local stock = CommF_:InvokeServer("GetFruits")
            -- Procesar y mostrar stock
            Fluent:Notify({Title = "Fruit Stock", Content = "Check console for details", Duration = 3})
        end
    })
    
    Tabs.Fruits:AddToggle("AutoRandomFruit", {
        Title = "Auto Buy Random Fruit",
        Default = false,
        Callback = function(Value)
            if Value then
                task.spawn(function()
                    while Value do
                        task.wait(5)
                        CommF_:InvokeServer("Cousin", "Buy")
                    end
                end)
            end
        end
    })
    
    -- ==========================================
    -- SISTEMA DE FAST ATTACK (MEJORADO)
    -- ==========================================
    
    local FastAttackConnection
    
    Tabs.Settings:AddSection("Combat Settings")
    
    Tabs.Settings:AddToggle("FastAttack", {
        Title = "Fast Attack (Remote Based)",
        Description = "Use RemoteEvents for fast attacking",
        Default = true,
        Callback = function(Value)
            FastAttackEnabled = Value
            if Value then
                FastAttackConnection = game:GetService("RunService").Heartbeat:Connect(function()
                    if FastAttackEnabled then
                        AttackRemote()
                    end
                end)
            else
                if FastAttackConnection then
                    FastAttackConnection:Disconnect()
                end
            end
        end
    })
    
    -- Cleanup al morir
    LocalPlayer.CharacterAdded:Connect(function()
        if FastAttackEnabled and FastAttackConnection then
            FastAttackConnection:Disconnect()
            task.wait(1)
            FastAttackConnection = game:GetService("RunService").Heartbeat:Connect(function()
                if FastAttackEnabled then
                    AttackRemote()
                end
            end)
        end
    end)
end

return Sea1Functions
