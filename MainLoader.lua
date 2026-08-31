local RAW_URL = "https://raw.githubusercontent.com/Waza123-beep/Blo-frui/refs/heads/main/"

local PlaceIds = {
    Sea1 = {2753915549},
    Sea2 = {4442272183},
    Sea3 = {7449423635}
}

local function LoadScript(file)
    loadstring(game:HttpGet(RAW_URL .. file))()
end

local placeId = game.PlaceId

if table.find(PlaceIds.Sea1, placeId) then
    LoadScript("Sea1Functions.lua")
elseif table.find(PlaceIds.Sea2, placeId) then
    LoadScript("Sea2Functions.lua")
elseif table.find(PlaceIds.Sea3, placeId) then
    LoadScript("Sea3Functions.lua")
else
    game:GetService("StarterGui"):SetCore("SendNotification", {
        Title = "Error de Carga",
        Text = "Lugar no compatible con este script.",
        Duration = 5
    })
end
