local spawned = {}

local function clearAnimals()
    for _, ent in ipairs(spawned) do
        if DoesEntityExist(ent) then DeleteEntity(ent) end
    end
    spawned = {}
end

local function spawnAnimals(def)
    clearAnimals()
    local center = def.zone
    local animals = def.animals or { `a_c_deer` }
    for i = 1, 5 do
        local model = animals[math.random(1, #animals)]
        lib.requestModel(model, 5000)
        local ang = math.rad(math.random(0, 360))
        local dist = math.random(30, 80)
        local x = center.x + math.cos(ang) * dist
        local y = center.y + math.sin(ang) * dist
        local z = center.z
        local found, gz = GetGroundZFor_3dCoord(x, y, z + 50.0, false)
        if found then z = gz end
        local ped = CreatePed(28, model, x, y, z, math.random(0, 360) + 0.0, true, true)
        SetEntityAsMissionEntity(ped, true, true)
        TaskWanderStandard(ped, 10.0, 10)
        spawned[#spawned + 1] = ped
        SetModelAsNoLongerNeeded(model)
    end
end

RegisterNetEvent('bsrp-jobs:client:startHunt', function()
    local def = Jobs.GetDef('hunter')
    if not def then return end
    if not Jobs.IsOnDutyFor('hunter') then
        FW.Notify('On-duty hunter only', 'error')
        return
    end
    Jobs.Active = { job = 'hunter', type = 'hunter', def = def }
    spawnAnimals(def)
    Jobs.SetRouteBlip(def.zone, 'Hunting Zone')
    FW.Hud('showJob', {
        title = def.label,
        line = 'Hunt wildlife — skin kills in the zone',
        pay = ('Pay: $%s–$%s'):format(def.pay.min, def.pay.max),
    })
    FW.Notify('Hunting started — animals spawned in the zone', 'success')
end)

-- Skin dead animals near player while hunting
CreateThread(function()
    while true do
        local sleep = 1000
        if Jobs.Active and Jobs.Active.type == 'hunter' then
            sleep = 300
            local ped = PlayerPedId()
            local pcoords = GetEntityCoords(ped)
            for i = #spawned, 1, -1 do
                local animal = spawned[i]
                if DoesEntityExist(animal) and IsEntityDead(animal) then
                    if #(GetEntityCoords(animal) - pcoords) < 2.5 then
                        sleep = 0
                        BeginTextCommandDisplayHelp('STRING')
                        AddTextComponentSubstringPlayerName('~INPUT_CONTEXT~ Skin animal')
                        EndTextCommandDisplayHelp(0, false, true, -1)
                        if IsControlJustReleased(0, 38) then
                            if lib.progressCircle({
                                duration = 5000,
                                label = 'Skinning…',
                                position = 'bottom',
                                canCancel = true,
                                disable = { move = true, combat = true },
                                anim = { dict = 'amb@medic@standing@kneel@base', clip = 'base' },
                            }) then
                                DeleteEntity(animal)
                                table.remove(spawned, i)
                                local def = Jobs.GetDef('hunter')
                                TriggerServerEvent('bsrp-jobs:server:pay', 'hunter', 'skin', def and def.pay)
                                -- respawn one
                                if def then
                                    local model = (def.animals or { `a_c_deer` })[1]
                                    lib.requestModel(model, 3000)
                                    local c = def.zone
                                    local ang = math.rad(math.random(0, 360))
                                    local dist = math.random(40, 90)
                                    local x = c.x + math.cos(ang) * dist
                                    local y = c.y + math.sin(ang) * dist
                                    local z = c.z
                                    local found, gz = GetGroundZFor_3dCoord(x, y, z + 80.0, false)
                                    if found then z = gz end
                                    local np = CreatePed(28, model, x, y, z, 0.0, true, true)
                                    TaskWanderStandard(np, 10.0, 10)
                                    spawned[#spawned + 1] = np
                                end
                            end
                        end
                    end
                elseif not DoesEntityExist(animal) then
                    table.remove(spawned, i)
                end
            end
        end
        Wait(sleep)
    end
end)

AddEventHandler('onResourceStop', function(res)
    if res == GetCurrentResourceName() then
        clearAnimals()
    end
end)
