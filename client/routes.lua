local function pickStops(def, count)
    local pool = {}
    for i, s in ipairs(def.stops or {}) do pool[i] = s end
    local picked = {}
    count = math.min(count or 4, #pool)
    for _ = 1, count do
        if #pool == 0 then break end
        local idx = math.random(1, #pool)
        picked[#picked + 1] = pool[idx]
        table.remove(pool, idx)
    end
    return picked
end

local function advanceRoute()
    local run = Jobs.Active
    if not run then return end
    run.index = (run.index or 1) + 1
    if run.index > #run.stops then
        TriggerServerEvent('bsrp-jobs:server:pay', run.job, 'route_complete', run.def.pay)
        FW.Notify('Route complete — paid!', 'success')
        Jobs.StopRoute(true)
        return
    end
    local stop = run.stops[run.index]
    Jobs.SetRouteBlip(stop, ('Stop %s/%s'):format(run.index, #run.stops))
    FW.Hud('showJob', {
        title = run.def.label,
        line = ('Stop %s / %s — head to the waypoint'):format(run.index, #run.stops),
        pay = ('Pay: $%s–$%s'):format(run.def.pay.min, run.def.pay.max),
    })
    FW.Notify(('Next stop (%s/%s)'):format(run.index, #run.stops), 'info')
end

local function doStopAction()
    local run = Jobs.Active
    if not run then return end
    local stop = run.stops[run.index]
    if not stop then return end
    local ped = PlayerPedId()
    if FW.Dist(GetEntityCoords(ped), stop) > 12.0 then
        FW.Notify('Get closer to the stop', 'error')
        return
    end

    local label = run.def.progressLabel or 'Working…'
    local ms = run.def.progressMs or 5000
    local mode = run.def.mode or 'deliver'

    if mode == 'taxi' or mode == 'bus' then
        -- board/dropoff style: short wait at marker
        if lib.progressCircle({
            duration = ms,
            label = mode == 'taxi' and 'Passenger boarding…' or 'Bus stop…',
            position = 'bottom',
            canCancel = true,
            disable = { car = false, move = false, combat = true },
        }) then
            TriggerServerEvent('bsrp-jobs:server:pay', run.job, 'stop', {
                min = math.floor((run.def.pay.min or 50) * 0.35),
                max = math.floor((run.def.pay.max or 100) * 0.35),
            })
            advanceRoute()
        end
        return
    end

    if lib.progressCircle({
        duration = ms,
        label = label,
        position = 'bottom',
        canCancel = true,
        disable = { move = true, car = true, combat = true },
        anim = { dict = 'anim@heists@narcotics@trash', clip = 'pickup' },
    }) then
        TriggerServerEvent('bsrp-jobs:server:pay', run.job, 'stop', {
            min = math.floor((run.def.pay.min or 50) * 0.4),
            max = math.floor((run.def.pay.max or 100) * 0.4),
        })
        advanceRoute()
    end
end

RegisterNetEvent('bsrp-jobs:client:startRoute', function(jobName)
    local def = Jobs.GetDef(jobName)
    if not def or def.type ~= 'route' then return end
    if not Jobs.IsOnDutyFor(jobName) then
        FW.Notify('On duty required', 'error')
        return
    end
    if not def.stops or #def.stops < 1 then
        FW.Notify('No stops configured', 'error')
        return
    end
    if Jobs.Active then Jobs.StopRoute(true) end

    local stops = pickStops(def, math.random(3, math.min(6, #def.stops)))
    Jobs.Active = {
        job = jobName,
        type = 'route',
        def = def,
        stops = stops,
        index = 1,
    }
    local stop = stops[1]
    Jobs.SetRouteBlip(stop, 'Stop 1/' .. #stops)
    FW.Hud('showJob', {
        title = def.label,
        line = ('Stop 1 / %s — head to the waypoint'):format(#stops),
        pay = ('Pay: $%s–$%s'):format(def.pay.min, def.pay.max),
    })
    FW.Notify(('Route started — %s stops'):format(#stops), 'success')
end)

-- Marker + E at current stop
CreateThread(function()
    while true do
        local sleep = 1000
        local run = Jobs.Active
        if run and run.type == 'route' and run.stops and run.stops[run.index] then
            local stop = run.stops[run.index]
            local ped = PlayerPedId()
            local dist = FW.Dist(GetEntityCoords(ped), stop)
            if dist < 40.0 then
                sleep = 0
                DrawMarker(
                    1, stop.x, stop.y, stop.z - 1.0,
                    0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                    2.0, 2.0, 1.0,
                    0, 229, 255, 140,
                    false, false, 2, false, nil, nil, false
                )
                if dist < 8.0 then
                    BeginTextCommandDisplayHelp('STRING')
                    AddTextComponentSubstringPlayerName('~INPUT_CONTEXT~ Complete stop')
                    EndTextCommandDisplayHelp(0, false, true, -1)
                    if IsControlJustReleased(0, 38) then
                        doStopAction()
                    end
                end
            end
        end
        Wait(sleep)
    end
end)
