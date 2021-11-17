local ESX = nil

local drawDistance = 10.0
local itrDistance = 1.0

local locationPosition = vector3(300.67, -1394.36, 31.18)
local spawnLocation = {
    position = vector3(307.9, -1379.03, 31.81),
    heading = 50.0
}

local waitingForServerResponse = false

RegisterNetEvent("zLocation2:already")
AddEventHandler("zLocation2:already", function()
    waitingForServerResponse = false
    ESX.ShowNotification("~r~Vous avez déjà utilisé votre location payante")
end)

RegisterNetEvent("zLocation2:cbLocation")
AddEventHandler("zLocation2:cbLocation", function(success)
    waitingForServerResponse = false
    if (not success) then
        ESX.ShowNotification("~r~Vous n'avez pas assez d'argent sur vous !")
        return
    end
    local model = GetHashKey("panto")
    RequestModel(model)
    while (not (HasModelLoaded(model))) do
        Wait(100)
    end
    local car = CreateVehicle(model, spawnLocation.position, spawnLocation.heading, true)
    TaskWarpPedIntoVehicle(PlayerPedId(), car, -1)
end)

CreateThread(function()
    TriggerEvent("esx:getSharedObject", function(obj)
        ESX = obj
    end)
    while (true) do
        local interval = 250
        local playerPos = GetEntityCoords(PlayerPedId())
        local dst = #(locationPosition-playerPos)

        if (dst <= drawDistance) then
            -- Ici je peux commencer à afficher ma zone
            interval = 0
            DrawMarker(22, locationPosition, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 0.45, 0.45, 0.45, 255, 0, 0, 255, 55555, false, true, 2, false, false, false, false)
            if (dst <= itrDistance) then
                -- Ici je suis dans une zone que j'ai appellée la zone d'interaction
                ESX.ShowHelpNotification("Appuyez sur ~INPUT_CONTEXT~ pour ouvrir la location de véhicule")
                if (IsControlJustPressed(0, 51) and not (waitingForServerResponse)) then
                    waitingForServerResponse = true
                    TriggerServerEvent("zLocation2:requestLocation")
                end
            end
        end
        Wait(interval)
    end
end)

--[[
local test = true
print(not (not (not (not (test)))))
--]]