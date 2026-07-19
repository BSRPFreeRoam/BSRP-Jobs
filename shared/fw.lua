FW = FW or {}

function FW.Started(name)
    return GetResourceState(name) == 'started'
end

function FW.Notify(msg, nType)
    nType = nType or 'info'
    if FW.Started('bsrp') then
        local ok = pcall(function() exports.bsrp:Notify(msg, nType) end)
        if ok then return end
    end
    if lib and lib.notify then
        lib.notify({
            description = msg,
            type = nType == 'error' and 'error' or (nType == 'success' and 'success' or 'inform'),
        })
        return
    end
    BeginTextCommandThefeedPost('STRING')
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandThefeedPostTicker(false, true)
end

function FW.GetPlayerData()
    if not FW.Started('bsrp') then return nil end
    local ok, data = pcall(function() return exports.bsrp:GetPlayerData() end)
    if ok then return data end
    return nil
end

function FW.IsLoaded()
    if not FW.Started('bsrp') then return false end
    local ok, v = pcall(function() return exports.bsrp:IsPlayerLoaded() end)
    return ok and v == true
end

function FW.HasJob(jobName, requireDuty)
    local pd = FW.GetPlayerData()
    if not pd or pd.job ~= jobName then return false end
    if requireDuty and not pd.duty then return false end
    return true
end

function FW.JobGrade()
    local pd = FW.GetPlayerData()
    return pd and (tonumber(pd.job_grade) or 0) or 0
end

function FW.LoadAnim(dict)
    if HasAnimDictLoaded(dict) then return end
    RequestAnimDict(dict)
    local t = 0
    while not HasAnimDictLoaded(dict) and t < 100 do Wait(10) t = t + 1 end
end

function FW.SpawnVehicle(model, coords)
    local hash = type(model) == 'number' and model or joaat(model)
    if not IsModelInCdimage(hash) then
        FW.Notify('Invalid vehicle model', 'error')
        return nil
    end
    lib.requestModel(hash, 5000)
    local veh = CreateVehicle(hash, coords.x, coords.y, coords.z, coords.w or 0.0, true, false)
    SetVehicleOnGroundProperly(veh)
    SetEntityAsMissionEntity(veh, true, true)
    SetVehicleEngineOn(veh, true, true, false)
    SetModelAsNoLongerNeeded(hash)
    local plate = ('JOB%04d'):format(math.random(0, 9999))
    SetVehicleNumberPlateText(veh, plate)
    TriggerEvent('vehiclekeys:client:SetOwner', plate)
    return veh
end

function FW.DeleteVehicle(veh)
    if veh and DoesEntityExist(veh) then
        SetEntityAsMissionEntity(veh, true, true)
        DeleteVehicle(veh)
    end
end

function FW.SetWaypoint(coords)
    if not coords then return end
    SetNewWaypoint(coords.x + 0.0, coords.y + 0.0)
end

function FW.Dist(a, b)
    return #(vector3(a.x, a.y, a.z) - vector3(b.x, b.y, b.z))
end

function FW.Hud(action, data)
    SendNUIMessage({ action = action, data = data or {} })
end
