local hooked = nil -- vehicle entity

local function getFlatbed()
    local ped = PlayerPedId()
    if not IsPedInAnyVehicle(ped, false) then return nil end
    local veh = GetVehiclePedIsIn(ped, false)
    local model = GetEntityModel(veh)
    if model == joaat('flatbed') or model == joaat('towtruck') or model == joaat('towtruck2') then
        return veh
    end
    return nil
end

local function attachToFlatbed(flatbed, target)
    if not flatbed or not target then return false end
    AttachEntityToEntity(
        target, flatbed, GetEntityBoneIndexByName(flatbed, 'bodyshell'),
        0.0, -2.2, 1.0,
        0.0, 0.0, 0.0,
        false, false, false, false, 20, true
    )
    return true
end

RegisterNetEvent('bsrp-jobs:client:towMenu', function()
    if not Jobs.IsOnDutyFor('tow') then
        FW.Notify('On-duty tow only', 'error')
        return
    end
    local def = Jobs.GetDef('tow')
    lib.registerContext({
        id = 'bsrp_tow_menu',
        title = 'TOW OPS',
        options = {
            {
                title = 'Hook Closest Vehicle',
                icon = 'link',
                onSelect = function()
                    local flatbed = getFlatbed()
                    if not flatbed then
                        FW.Notify('Sit in a flatbed / tow truck', 'error')
                        return
                    end
                    local coords = GetEntityCoords(flatbed)
                    local target = lib.getClosestVehicle(coords, 8.0, false)
                    if not target or target == flatbed then
                        FW.Notify('No vehicle to hook', 'error')
                        return
                    end
                    if lib.progressCircle({
                        duration = 5000,
                        label = 'Hooking vehicle…',
                        position = 'bottom',
                        canCancel = true,
                        disable = { car = true, move = true },
                    }) then
                        if attachToFlatbed(flatbed, target) then
                            hooked = target
                            FW.Notify('Vehicle hooked — deliver to yard', 'success')
                            if def and def.dropoff then
                                FW.SetWaypoint(def.dropoff)
                                Jobs.Active = Jobs.Active or { job = 'tow', type = 'tow', def = def }
                                Jobs.SetRouteBlip(def.dropoff, 'Tow Dropoff')
                                FW.Hud('showJob', {
                                    title = 'Tow',
                                    line = 'Deliver hooked vehicle to the yard',
                                    pay = ('Pay: $%s–$%s'):format(def.pay.min, def.pay.max),
                                })
                            end
                        end
                    end
                end,
            },
            {
                title = 'Unhook / Deliver',
                icon = 'truck-ramp-box',
                onSelect = function()
                    if not hooked or not DoesEntityExist(hooked) then
                        FW.Notify('Nothing hooked', 'error')
                        return
                    end
                    local def2 = Jobs.GetDef('tow')
                    local ped = PlayerPedId()
                    if def2 and def2.dropoff and FW.Dist(GetEntityCoords(ped), def2.dropoff) > 25.0 then
                        FW.Notify('Deliver at the tow yard dropoff', 'error')
                        FW.SetWaypoint(def2.dropoff)
                        return
                    end
                    DetachEntity(hooked, true, true)
                    local drop = def2 and def2.dropoff or GetEntityCoords(ped)
                    SetEntityCoords(hooked, drop.x + 2.0, drop.y, drop.z, false, false, false, false)
                    FreezeEntityPosition(hooked, true)
                    hooked = nil
                    TriggerServerEvent('bsrp-jobs:server:pay', 'tow', 'impound', def2 and def2.pay)
                    Jobs.StopRoute(true)
                    FW.Notify('Vehicle delivered', 'success')
                end,
            },
        },
    })
    lib.showContext('bsrp_tow_menu')
end)
