local QBCore = exports['qb-core']:GetCoreObject()

--- Events

--delivering the item to boss instead
RegisterNetEvent('qb-aircraft:server:RecievePayment', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    Player.Functions.RemoveItem('labs_usb', 1)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["labs_usb"], "remove")
    Player.Functions.AddMoney('bank', Config.PaymentMoney)
end)



-- crate looting system
local ItemTable = Config.Items
RegisterServerEvent("qb-aircraftheist:server:loot")
AddEventHandler("qb-aircraftheist:server:loot", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    Player.Functions.RemoveItem('labs_usb', 1)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["labs_usb"], "remove")
    for i = 1, math.random(1, 8), 1 do
        local randItem = ItemTable[math.random(1, #ItemTable)]
        Player.Functions.AddItem(randItem, 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[randItem], 'add')
        Citizen.Wait(500)
    end
end)


-- giving usb to player
local ua= {Config.usb},
RegisterServerEvent("qb-aircraftheist:server:usb")
AddEventHandler("qb-aircraftheist:server:usb", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
        local randItem = ua[math.random(1, #ua)]
        Player.Functions.AddItem(randItem, 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[randItem], 'add')
        Citizen.Wait(500)
end)	

--removing electrokit
RegisterNetEvent('qb-aircraftheist:server:removeElectronicKit', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    if not Player then return end
    Player.Functions.RemoveItem(Config.hacki, 1)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["electronickit"], "remove")
end)

--local function cooldown()
    --local cdll = MySQL.Sync.fetchAll('SELECT * FROM tyam', {})
    --for _, v in pairs(cdll) do
        --local time = {}
        --end
        --Races[v.time] = {
            --hittime = v.hittime,
            --hitId = v.hitid,
            --Started = false,
           -- Waiting = false,
        --}
    --end
--end

RegisterNetEvent('qb-aircraftheist:server:setfuel', function(veh)
    if Config.Fuel == "LegacyFuel" then
        exports["LegacyFuel"]:SetFuel(veh, 100.0)
    elseif Config.Fuel == "okokFuel" then
        exports['okokGasStation']:SetFuel(veh, 100.0)
    elseif Config.Fuel == "ox_fuel" then
        SetVehicleFuelLevel(veh, 100.0)
    elseif Config.Fuel == "ti_fuel" then
        exports["ti_fuel"]:setFuel(veh, 100.0, "RON91")
    elseif Config.Fuel == "qs-fuel" then
        exports['qs-fuelstations']:SetFuel(veh, 100.0)
    elseif Config.Fuel == "cdn-fuel" then
        SetVehicleFuelLevel(veh, 100.0)
    end
end)





