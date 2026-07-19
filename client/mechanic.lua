local function closestVehicle(maxDist)
    maxDist = maxDist or 4.0
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local veh = lib.getClosestVehicle(coords, maxDist, false)
    return veh
end

RegisterNetEvent('bsrp-jobs:client:mechMenu', function()
    if not Jobs.IsOnDutyFor('mechanic') then
        FW.Notify('On-duty mechanic only', 'error')
        return
    end
    lib.registerContext({
        id = 'bsrp_mech_menu',
        title = 'MECHANIC TOOLS',
        options = {
            {
                title = 'Repair Vehicle',
                icon = 'wrench',
                onSelect = function()
                    local veh = closestVehicle(5.0)
                    if not veh then
                        FW.Notify('No vehicle nearby', 'error')
                        return
                    end
                    if lib.progressCircle({
                        duration = 8000,
                        label = 'Repairing…',
                        position = 'bottom',
                        canCancel = true,
                        disable = { move = true, car = true, combat = true },
                        anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
                    }) then
                        SetVehicleFixed(veh)
                        SetVehicleDeformationFixed(veh)
                        SetVehicleEngineHealth(veh, 1000.0)
                        SetVehicleBodyHealth(veh, 1000.0)
                        FW.Notify('Vehicle repaired', 'success')
                        local def = Jobs.GetDef('mechanic')
                        TriggerServerEvent('bsrp-jobs:server:pay', 'mechanic', 'repair', def and def.repairPay)
                    end
                end,
            },
            {
                title = 'Clean Vehicle',
                icon = 'soap',
                onSelect = function()
                    local veh = closestVehicle(5.0)
                    if not veh then
                        FW.Notify('No vehicle nearby', 'error')
                        return
                    end
                    if lib.progressCircle({
                        duration = 5000,
                        label = 'Cleaning…',
                        position = 'bottom',
                        canCancel = true,
                        disable = { move = true, combat = true },
                        anim = { dict = 'amb@world_human_maid_clean@', clip = 'base' },
                    }) then
                        SetVehicleDirtLevel(veh, 0.0)
                        WashDecalsFromVehicle(veh, 1.0)
                        FW.Notify('Vehicle cleaned', 'success')
                        local def = Jobs.GetDef('mechanic')
                        TriggerServerEvent('bsrp-jobs:server:pay', 'mechanic', 'clean', def and def.cleanPay)
                    end
                end,
            },
            {
                title = 'Flip Vehicle',
                icon = 'rotate',
                onSelect = function()
                    local veh = closestVehicle(5.0)
                    if not veh then return end
                    local c = GetEntityCoords(veh)
                    local h = GetEntityHeading(veh)
                    SetEntityCoords(veh, c.x, c.y, c.z + 0.5, false, false, false, false)
                    SetEntityRotation(veh, 0.0, 0.0, h, 2, true)
                    FW.Notify('Vehicle flipped', 'success')
                end,
            },
        },
    })
    lib.showContext('bsrp_mech_menu')
end)

CreateThread(function()
    while GetResourceState('ox_target') ~= 'started' do Wait(200) end
    exports.ox_target:addGlobalVehicle({
        {
            name = 'bsrp_jobs_mech_repair',
            icon = 'fa-solid fa-wrench',
            label = 'Repair Vehicle',
            distance = 3.0,
            canInteract = function()
                return Jobs.IsOnDutyFor('mechanic')
            end,
            onSelect = function(data)
                local veh = data.entity
                if lib.progressCircle({
                    duration = 8000,
                    label = 'Repairing…',
                    position = 'bottom',
                    canCancel = true,
                    disable = { move = true, combat = true },
                    anim = { dict = 'mini@repair', clip = 'fixing_a_ped' },
                }) then
                    SetVehicleFixed(veh)
                    SetVehicleDeformationFixed(veh)
                    SetVehicleEngineHealth(veh, 1000.0)
                    FW.Notify('Vehicle repaired', 'success')
                    local def = Jobs.GetDef('mechanic')
                    TriggerServerEvent('bsrp-jobs:server:pay', 'mechanic', 'repair', def and def.repairPay)
                end
            end,
        },
    })
end)
