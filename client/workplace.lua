local jobVehicles = {}

local function openGarage(jobName)
    local def = Jobs.GetDef(jobName)
    if not def or not def.garage or not def.vehicles then
        FW.Notify('No garage for this job', 'error')
        return
    end
    if not Jobs.IsOnDutyFor(jobName) then
        FW.Notify('On duty required', 'error')
        return
    end

    local options = {}
    for _, v in ipairs(def.vehicles) do
        options[#options + 1] = {
            title = v.label or v.model,
            icon = 'car',
            onSelect = function()
                if jobVehicles[jobName] and DoesEntityExist(jobVehicles[jobName]) then
                    FW.DeleteVehicle(jobVehicles[jobName])
                end
                local veh = FW.SpawnVehicle(v.model, def.garage)
                if veh then
                    jobVehicles[jobName] = veh
                    TaskWarpPedIntoVehicle(PlayerPedId(), veh, -1)
                    FW.Notify(('Deployed %s'):format(v.label or v.model), 'success')
                end
            end,
        }
    end
    lib.registerContext({ id = 'bsrp_jobs_garage', title = (def.label or jobName) .. ' Garage', options = options })
    lib.showContext('bsrp_jobs_garage')
end

RegisterNetEvent('bsrp-jobs:client:openGarage', openGarage)

RegisterNetEvent('bsrp-jobs:client:doWork', function(jobName)
    local def = Jobs.GetDef(jobName)
    if not def or not def.work then return end
    if not Jobs.IsOnDutyFor(jobName) then
        FW.Notify('On duty required', 'error')
        return
    end
    if def.duty and FW.Dist(GetEntityCoords(PlayerPedId()), def.duty) > 40.0 then
        FW.Notify('Too far from workplace', 'error')
        return
    end
    if lib.progressCircle({
        duration = def.work.ms or 10000,
        label = def.work.label or 'Working…',
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,
        disable = { move = true, car = true, combat = true },
        anim = { dict = 'amb@world_human_clipboard@male@idle_a', clip = 'idle_c' },
    }) then
        TriggerServerEvent('bsrp-jobs:server:pay', jobName, 'work', def.work.pay)
    end
end)

RegisterNetEvent('bsrp-jobs:client:openStash', function(id)
    if GetResourceState('ox_inventory') ~= 'started' then return end
    exports.ox_inventory:openInventory('stash', id)
end)

local function registerWorkplaceTargets()
    if GetResourceState('ox_target') ~= 'started' then return end

    for name, def in pairs(Config.Jobs or {}) do
        if Config.SkipJobs and Config.SkipJobs[name] then
            -- still allow duty if defined and not police/ambulance exclusive
        end

        if def.duty then
            exports.ox_target:addSphereZone({
                coords = def.duty,
                radius = 1.3,
                options = {
                    {
                        name = 'bsrp_jobs_duty_' .. name,
                        icon = 'fa-solid fa-clipboard-user',
                        label = ('Toggle Duty (%s)'):format(def.label or name),
                        canInteract = function()
                            local pd = FW.GetPlayerData()
                            return pd and pd.job == name
                        end,
                        onSelect = function()
                            TriggerServerEvent('bsrp:server:toggleDuty')
                        end,
                    },
                    {
                        name = 'bsrp_jobs_actions_' .. name,
                        icon = 'fa-solid fa-briefcase',
                        label = 'Job Actions',
                        canInteract = function()
                            return Jobs.IsOnDutyFor(name)
                        end,
                        onSelect = function()
                            exports[GetCurrentResourceName()]:OpenJobsMenu()
                        end,
                    },
                },
            })
        end

        if def.garage and def.vehicles then
            local g = def.garage
            exports.ox_target:addSphereZone({
                coords = vec3(g.x, g.y, g.z),
                radius = 2.2,
                options = {
                    {
                        name = 'bsrp_jobs_garage_' .. name,
                        icon = 'fa-solid fa-car',
                        label = 'Job Garage',
                        canInteract = function()
                            return Jobs.IsOnDutyFor(name)
                        end,
                        onSelect = function()
                            openGarage(name)
                        end,
                    },
                    {
                        name = 'bsrp_jobs_store_' .. name,
                        icon = 'fa-solid fa-square-parking',
                        label = 'Store Job Vehicle',
                        canInteract = function()
                            return Jobs.IsOnDutyFor(name) and IsPedInAnyVehicle(PlayerPedId(), false)
                        end,
                        onSelect = function()
                            local veh = GetVehiclePedIsIn(PlayerPedId(), false)
                            FW.DeleteVehicle(veh)
                            if jobVehicles[name] == veh then jobVehicles[name] = nil end
                            FW.Notify('Vehicle stored', 'success')
                        end,
                    },
                },
            })
        end

        if def.stash then
            exports.ox_target:addSphereZone({
                coords = def.stash,
                radius = 1.2,
                options = {
                    {
                        name = 'bsrp_jobs_stash_' .. name,
                        icon = 'fa-solid fa-box',
                        label = 'Job Locker',
                        canInteract = function()
                            return Jobs.IsOnDutyFor(name)
                        end,
                        onSelect = function()
                            TriggerServerEvent('bsrp-jobs:server:openStash', name)
                        end,
                    },
                },
            })
        end

        if def.work and def.type == 'workplace' and def.duty then
            exports.ox_target:addSphereZone({
                coords = def.duty,
                radius = 1.5,
                options = {
                    {
                        name = 'bsrp_jobs_work_' .. name,
                        icon = 'fa-solid fa-hand',
                        label = def.work.label or 'Work',
                        canInteract = function()
                            return Jobs.IsOnDutyFor(name)
                        end,
                        onSelect = function()
                            TriggerEvent('bsrp-jobs:client:doWork', name)
                        end,
                    },
                },
            })
        end
    end
end

CreateThread(function()
    while GetResourceState('ox_target') ~= 'started' do Wait(200) end
    Wait(500)
    registerWorkplaceTargets()
end)
