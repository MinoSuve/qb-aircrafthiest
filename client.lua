local QBCore = exports['qb-core']:GetCoreObject()



local hiestactive=false
local looting = true
------ Events
RegisterNetEvent('police:SetCopCount')
AddEventHandler('police:SetCopCount', function(amount)
    CurrentCops = amount
end)

RegisterNetEvent('qb-aircraft:Cooldownheist')
AddEventHandler('qb-aircraft:Cooldownheist', function(cooldown)
end)


    RegisterNetEvent('qb-aircraft:client:getjob', function()
    TriggerEvent('animations:client:EmoteCommandStart', {"wait"})
    QBCore.Functions.Progressbar('bosstalk', 'Talking to the boss...', 5000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function()
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        QBCore.Functions.Notify('You will recive an email with the location of the lab, the go there and start the hack!Take it you will need this!', 'primary')
        hiestactive=true
        PullOutVehicle()
        SetNewWaypoint(Config.locations["aircraft"].coords)
        Wait(5000)
        TriggerServerEvent('qb-phone:server:sendNewMail', {
            sender = 'Boss',
            subject = 'Human Labs...',
            message = 'You recive the location, now go there and rob the informations for me and i will pay you good!',
            })
            return hiestactive
    end)
    end)



RegisterNetEvent('qb-aircraft:client:starthack', function()
    if hiestactive == true then
    local result= QBCore.Functions.HasItem("electronickit")
        if result then
            TriggerServerEvent('qb-aircraftheist:server:removeElectronicKit')
            TriggerServerEvent('police:server:policeAlert', 'LABS ROBBERY IN COURSE!')
            TriggerEvent('animations:client:EmoteCommandStart', {"type"})
            QBCore.Functions.Progressbar('cnct_elect', 'CONNECTING ELECTRONICS...', 7500, false, true, {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            }, {}, {}, {}, function()
            end)
            Wait(700)
        TriggerEvent('animations:client:EmoteCommandStart', {"type"})
        exports["memorygame_2"]:thermiteminigame(5, 5, 5, 10,
        function() -- Success
        Wait(100)
        TriggerEvent('animations:client:EmoteCommandStart', {"type"})
        Wait(500)
        QBCore.Functions.Progressbar('po_usb', 'PULLING OUT USB..', 5000, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {}, {}, {}, function()
        end)
        Wait(200)
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        TriggerServerEvent("qb-aircraftheist:server:usb")
        SpawnGuards()
        hiestactive = false
        looting = true
        QBCore.Functions.Notify('You recive an USB Now RUN from the guards or just kill them! And Dont Forget to check the boxes', 'primary')
        Wait(100)
        TriggerServerEvent('qb-phone:server:sendNewMail', {
            sender = 'Boss',
            subject = 'Human Labs...',
            message = 'I recive some informations that you got what i want, now come here to me and give me it!',
            })
    end,
        function() -- Fail thermite game
            TriggerEvent('animations:client:EmoteCommandStart', {"c"})
            QBCore.Functions.Notify('You failed Hacking', 'error')
        end)
    end
    end
    end)

RegisterNetEvent('qb-aircraft:client:EnterUSB', function()
    TriggerServerEvent('qb-aircraft:server:RecievePayment')
end)




RegisterNetEvent('qb-aircraftheist-collect') -- PEW PEW 
AddEventHandler('qb-aircraftheist-collect', function()
    if not robberyBusy then
        TriggerServerEvent("qb-aircraftheist:server:loot")
        looting =false
        robberyBusy = true
    else
       QBCore.Functions.Notify("you have already looted the stuff", 'error')
    end
end)

local pedSpawned = false
CreateThread(function()
    if pedSpawned then return end
    RequestModel(Config.locations["boss"].model)
    while not HasModelLoaded(Config.locations["boss"].model) do Wait(1) end
    local labboss = CreatePed(0, Config.locations["boss"].model, Config.locations["boss"].coords.x, Config.locations["boss"].coords.y, Config.locations["boss"].coords.z, 12.9, false, false) -- change here the cords for the ped 
    TaskStartScenarioInPlace(labboss, 'WORLD_HUMAN_STAND_IMPATIENT', 0, true)
    FreezeEntityPosition(labboss, true)
    print (labboss)
    SetEntityInvincible(labboss, true)
    SetBlockingOfNonTemporaryEvents(labboss, true)
    local targetOpts ={{
        name = 'sams_AH_getjob',
        event = 'qb-aircraft:client:getjob',
        icon = 'fa-solid fa-person-rifle fa-2xs',
        label = 'Talk to boss',
        drawSprite = true,
        canInteract = function(_, distance)
            return distance < 4.5
        end
    }}
    targetOpts[#targetOpts+1]={
        name = 'sams_AH_getpayment',
        event = 'qb-aircraft:client:EnterUSB',
        icon = 'fa-brands fa-usb fa-2xs',
        label = 'Redeem usb',
        items = {[Config.usb]=1},
        canInteract = function(_, distance)
            return distance < 4.5
        end
    }
    exports.ox_target:addLocalEntity(labboss, targetOpts)
    pedSpawned = true

        exports.ox_target:addBoxZone({
            coords = vec3(3084.24, -4685.79, 26.95),
            size = vec3(1, 1, 3),
            rotation = 45,
            debug = drawZones,
            drawSprite = true,
            options = {
                {
                    name = 'Hack-aircraft',
                    event = 'qb-aircraft:client:starthack',
                    icon = 'fa-solid fa-cube',
                    label = 'Hack System',
                    items = {[Config.hacki]=1},
                    canInteract = function()
                        if hiestactive == true then --and distance < 1.5 then
                            return true 
                        end
                    end
                }
            
            }
        })
        exports.ox_target:addBoxZone({
            coords = vector3(3061.98, -4716.31, 5),
            size = vec3(1, 1, 3),
            rotation = 45,
            debug = drawZones,
            drawSprite = true,
            options = 
            {
                {
                    name = 'loot the item',
                    event = 'qb-aircraftheist-collect',
                    icon = 'fa-solid fa-cube',
                    label = 'Grab the stuff',
                    items = {[Config.usb]=1},
                    canInteract = function()
                        if looting == true then --and distance < 1.5 then
                            return true
                        end
                    end
                }
            }
        })
end)

labguards = {
    ['npcguards'] = {}
}

function loadModel(model)
    if type(model) == 'number' then
        model = model
    else
        model = GetHashKey(model)
    end
    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(0)
    end
end

function SpawnGuards()
    local ped = PlayerPedId()

    SetPedRelationshipGroupHash(ped, `PLAYER`)
    AddRelationshipGroup('npcguards')

    for k, v in pairs(Config['labguards']['npcguards']) do
        loadModel(v['model'])
        labguards['npcguards'][k] = CreatePed(26, GetHashKey(v['model']), v['coords'], v['heading'], true, true)
        NetworkRegisterEntityAsNetworked(labguards['npcguards'][k])
        networkID = NetworkGetNetworkIdFromEntity(labguards['npcguards'][k])
        SetNetworkIdCanMigrate(networkID, true)
        SetNetworkIdExistsOnAllMachines(networkID, true)
        SetPedRandomComponentVariation(labguards['npcguards'][k], 0)
        SetPedRandomProps(labguards['npcguards'][k])
        SetEntityAsMissionEntity(labguards['npcguards'][k])
        SetEntityVisible(labguards['npcguards'][k], true)
        SetPedRelationshipGroupHash(labguards['npcguards'][k], `npcguards`)
        SetPedAccuracy(labguards['npcguards'][k], 75)
        SetPedArmour(labguards['npcguards'][k], 100)
        SetPedCanSwitchWeapon(labguards['npcguards'][k], true)
        SetPedDropsWeaponsWhenDead(labguards['npcguards'][k], false)
        SetPedFleeAttributes(labguards['npcguards'][k], 0, false)
        GiveWeaponToPed(labguards['npcguards'][k], `weapon_assaultrifle`, 255, false, false)
        TaskGoToEntity(labguards['npcguards'][k], PlayerPedId(), -1, 1.0, 10.0, 1073741824.0, 0)
        local random = math.random(1, 2)
        if random == 2 then
            TaskGuardCurrentPosition(labguards['npcguards'][k], 10.0, 10.0, 1)
        end
    end

    SetRelationshipBetweenGroups(0, `npcguards`, `npcguards`)
    SetRelationshipBetweenGroups(5, `npcguards`, `PLAYER`)
    SetRelationshipBetweenGroups(5, `PLAYER`, `npcguards`)
end

function PullOutVehicle()
        QBCore.Functions.SpawnVehicle('Frogger', function(hiestveh)
        SetVehicleNumberPlateText(hiestveh, "ramey" .. tostring(math.random(1000, 9999)))
        SetVehicleColours(hiestveh, 111, 111)
        SetVehicleDirtLevel(hiestveh, 1)
        if Config.UseDefultVehicles then
            SetVehicleLivery(hiestveh, 3)
        end
        DecorSetFloat(hiestveh, "pizza_job", 1)
        TaskWarpPedIntoVehicle(PlayerPedId(), hiestveh, -1)
        TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(hiestveh))
        SetVehicleEngineOn(hiestveh, true, true)
        TriggerServerEvent('qb-aircraftheist:server:setfuel', hiestveh)
    end, Config.locations["vehicle"].coords, true)
    ownsVan = true
end
function DeletePeds()
    if not pedSpawned then return end
            DeletePed(labboss)
end

AddEventHandler('onResourceStop', function(resource)
    if resource ~= GetCurrentResourceName() then return end
    exports.ox_target:removeEntity(labboss, {'sams_AH_getjob'})
    DeletePeds()
end)

