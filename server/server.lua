local ESX = nil

local price = 500

local hasDoneLocation = {}

local function playerAlreadyHasVehicle(_src)
    for _, source in pairs(hasDoneLocation) do
        if (source == _src) then
            return true
        end
    end
    return false
end

TriggerEvent("esx:getSharedObject", function(obj)
    ESX = obj
end)

RegisterNetEvent("zLocation2:requestLocation")
AddEventHandler("zLocation2:requestLocation", function()
    -- Je reçois une variable cachée et volatile appellée la source
    local _src = source
    local name = GetPlayerName(_src)
    -- J'ai entendu l'event zLocation2:requestLocation
    local xPlayer = ESX.GetPlayerFromId(_src)
    local money = xPlayer.getAccount("money").money
    
    if (money < price) then
        TriggerClientEvent("zLocation2:cbLocation", _src, false)
        return
    end

    if (playerAlreadyHasVehicle(_src)) then
        TriggerClientEvent("zLocation2:already", _src)
        return
    end

    table.insert(hasDoneLocation, _src)
    xPlayer.removeAccountMoney("money", price)
    TriggerClientEvent("zLocation2:cbLocation", _src, true)
end)