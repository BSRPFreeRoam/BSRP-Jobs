local function getPlayer(src)
    if GetResourceState('bsrp') ~= 'started' then return nil end
    return exports.bsrp:GetPlayer(src)
end

local function notify(src, msg, nType)
    TriggerClientEvent('bsrp:client:notify', src, msg, nType or 'info')
end

local function jobDef(name)
    return Config.Jobs and Config.Jobs[name]
end

RegisterNetEvent('bsrp-jobs:server:pay', function(jobName, reason, payRange)
    local src = source
    local player = getPlayer(src)
    if not player then return end
    if player.job ~= jobName then
        notify(src, 'Wrong job', 'error')
        return
    end
    if Config.RequireDuty and not player.duty then
        notify(src, 'You must be on duty', 'error')
        return
    end

    local def = jobDef(jobName)
    if not def then return end

    payRange = payRange or def.pay or { min = 50, max = 100 }
    local minP = tonumber(payRange.min) or 50
    local maxP = tonumber(payRange.max) or minP
    if maxP < minP then maxP = minP end
    local amount = math.random(minP, maxP)

    -- Grade bonus: +5% per grade level (capped)
    local grade = player.job_grade or 0
    local bonus = math.floor(amount * math.min(grade, 10) * 0.05)
    amount = amount + bonus

    exports.bsrp:AddMoney(src, 'cash', amount, 'bsrp-jobs:' .. tostring(reason or 'work'))
end)

RegisterNetEvent('bsrp-jobs:server:craft', function(jobName, item, count)
    local src = source
    local player = getPlayer(src)
    if not player or player.job ~= jobName then return end
    if Config.RequireDuty and not player.duty then return end

    local def = jobDef(jobName)
    if not def or def.type ~= 'food' then return end

    local allowed = false
    for _, r in ipairs(def.craft or {}) do
        if r.item == item then allowed = true break end
    end
    if not allowed then return end

    count = math.min(tonumber(count) or 1, 5)
    if GetResourceState('ox_inventory') ~= 'started' then
        notify(src, 'Inventory offline', 'error')
        return
    end
    local ok = exports.ox_inventory:AddItem(src, item, count)
    if ok then
        notify(src, ('Prepared %sx %s'):format(count, item), 'success')
    else
        notify(src, 'Could not add item (full inventory or missing item def)', 'error')
    end
end)

RegisterNetEvent('bsrp-jobs:server:openStash', function(jobName)
    local src = source
    local player = getPlayer(src)
    if not player or player.job ~= jobName then return end
    if Config.RequireDuty and not player.duty then return end

    local id = ('job_stash_%s_%s'):format(jobName, tostring(player.identifier or src):gsub('[^%w_]', '_'))
    if GetResourceState('ox_inventory') == 'started' then
        pcall(function()
            exports.ox_inventory:RegisterStash(id, (jobName or 'job') .. ' Locker', 50, 100000, true)
        end)
    end
    TriggerClientEvent('bsrp-jobs:client:openStash', src, id)
end)

-- Shared stashes per job (register once)
CreateThread(function()
    Wait(1500)
    if GetResourceState('ox_inventory') ~= 'started' then return end
    for name, def in pairs(Config.Jobs or {}) do
        if def.stash then
            pcall(function()
                exports.ox_inventory:RegisterStash('job_shared_' .. name, (def.label or name) .. ' Shared', 80, 250000, false)
            end)
        end
    end
end)

print('^2[bsrp-jobs]^7 Job scripts ready — all BSRP civ/service jobs')
