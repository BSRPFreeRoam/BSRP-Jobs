Jobs = Jobs or {}
Jobs.Active = nil -- { job = name, type = ..., step = n, blip = handle, vehicle = ent }
Jobs.PlayerJob = nil

local stationBlips = {}

local function clearStationBlips()
    for _, b in pairs(stationBlips) do
        if DoesBlipExist(b) then RemoveBlip(b) end
    end
    stationBlips = {}
end

local function createStationBlips()
    clearStationBlips()
    for name, def in pairs(Config.Jobs or {}) do
        if def.blip and def.duty then
            local c = def.duty
            local blip = AddBlipForCoord(c.x, c.y, c.z)
            SetBlipSprite(blip, def.blip.sprite or 1)
            SetBlipDisplay(blip, 4)
            SetBlipScale(blip, def.blip.scale or 0.7)
            SetBlipColour(blip, def.blip.color or 0)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName('STRING')
            AddTextComponentSubstringPlayerName(def.label or name)
            EndTextCommandSetBlipName(blip)
            stationBlips[#stationBlips + 1] = blip
        end
    end
end

function Jobs.GetDef(jobName)
    return Config.Jobs and Config.Jobs[jobName]
end

function Jobs.RefreshPlayer()
    Jobs.PlayerJob = FW.GetPlayerData()
end

function Jobs.IsOnDutyFor(jobName)
    local pd = FW.GetPlayerData()
    if not pd or pd.job ~= jobName then return false end
    if Config.RequireDuty and not pd.duty then return false end
    return true
end

function Jobs.StopRoute(silent)
    if Jobs.Active then
        if Jobs.Active.blip and DoesBlipExist(Jobs.Active.blip) then
            RemoveBlip(Jobs.Active.blip)
        end
        Jobs.Active = nil
    end
    FW.Hud('hideJob')
    if not silent then
        FW.Notify('Job run ended', 'info')
    end
end

function Jobs.SetRouteBlip(coords, label)
    if Jobs.Active and Jobs.Active.blip and DoesBlipExist(Jobs.Active.blip) then
        RemoveBlip(Jobs.Active.blip)
    end
    if not Jobs.Active then return end
    local blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, 1)
    SetBlipColour(blip, 5)
    SetBlipRoute(blip, true)
    SetBlipRouteColour(blip, 5)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(label or 'Job Stop')
    EndTextCommandSetBlipName(blip)
    Jobs.Active.blip = blip
    FW.SetWaypoint(coords)
end

RegisterNetEvent('bsrp:client:onPlayerLoaded', function(data)
    Jobs.PlayerJob = data
    createStationBlips()
end)

RegisterNetEvent('bsrp:client:onJobUpdate', function(job)
    Jobs.RefreshPlayer()
    if Jobs.Active and Jobs.Active.job ~= job.name then
        Jobs.StopRoute(true)
    end
end)

AddEventHandler('onResourceStart', function(res)
    if res ~= GetCurrentResourceName() then return end
    createStationBlips()
    if FW.IsLoaded() then Jobs.RefreshPlayer() end
end)

CreateThread(function()
    createStationBlips()
end)

-- Global F6 job action menu for current job
local function openJobActions()
    local pd = FW.GetPlayerData()
    if not pd then return end
    local def = Jobs.GetDef(pd.job)
    if not def then
        FW.Notify('No bsrp-jobs module for your job', 'error')
        return
    end
    if Config.RequireDuty and not pd.duty and def.type ~= 'skip' then
        FW.Notify('You must be on duty', 'error')
        return
    end

    local options = {}
    if def.type == 'route' then
        options[#options + 1] = {
            title = Jobs.Active and 'Cancel Run' or 'Start Run',
            icon = Jobs.Active and 'ban' or 'play',
            onSelect = function()
                if Jobs.Active then
                    Jobs.StopRoute()
                else
                    TriggerEvent('bsrp-jobs:client:startRoute', pd.job)
                end
            end,
        }
    elseif def.type == 'tow' then
        options[#options + 1] = { title = 'Tow Menu', icon = 'truck-ramp-box', event = 'bsrp-jobs:client:towMenu' }
    elseif def.type == 'mechanic' then
        options[#options + 1] = { title = 'Mechanic Tools', icon = 'wrench', event = 'bsrp-jobs:client:mechMenu' }
    elseif def.type == 'hunter' then
        options[#options + 1] = {
            title = Jobs.Active and 'Stop Hunting' or 'Start Hunt',
            icon = 'crosshairs',
            onSelect = function()
                if Jobs.Active then Jobs.StopRoute() else TriggerEvent('bsrp-jobs:client:startHunt') end
            end,
        }
    elseif def.type == 'food' then
        options[#options + 1] = { title = 'Food Actions', icon = 'utensils', event = 'bsrp-jobs:client:foodMenu' }
    elseif def.type == 'workplace' and def.work then
        options[#options + 1] = {
            title = 'Do Work',
            icon = 'briefcase',
            onSelect = function()
                TriggerEvent('bsrp-jobs:client:doWork', pd.job)
            end,
        }
    end

    if def.garage and def.vehicles then
        options[#options + 1] = {
            title = 'Job Garage',
            icon = 'car',
            onSelect = function()
                TriggerEvent('bsrp-jobs:client:openGarage', pd.job)
            end,
        }
        options[#options + 1] = {
            title = 'Store Vehicle',
            icon = 'square-parking',
            onSelect = function()
                local ped = PlayerPedId()
                if IsPedInAnyVehicle(ped, false) then
                    local veh = GetVehiclePedIsIn(ped, false)
                    FW.DeleteVehicle(veh)
                    FW.Notify('Vehicle stored', 'success')
                else
                    FW.Notify('Not in a vehicle', 'error')
                end
            end,
        }
    end

    options[#options + 1] = {
        title = 'Toggle Duty',
        icon = 'clipboard-user',
        onSelect = function()
            TriggerServerEvent('bsrp:server:toggleDuty')
        end,
    }

    lib.registerContext({
        id = 'bsrp_jobs_menu',
        title = def.label or pd.job_label or 'JOB',
        options = options,
    })
    lib.showContext('bsrp_jobs_menu')
end

RegisterCommand('jobsmenu', openJobActions, false)
-- F5 (F6 used by police menu; F7 by bsrp job panel)
RegisterKeyMapping('jobsmenu', 'BSRP Jobs Actions', 'keyboard', 'F5')

-- Avoid fighting police F6 if both open — LEO can use either
exports('OpenJobsMenu', openJobActions)
exports('StopJobRun', Jobs.StopRoute)
