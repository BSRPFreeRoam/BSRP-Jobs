RegisterNetEvent('bsrp-jobs:client:foodMenu', function()
    local pd = FW.GetPlayerData()
    if not pd then return end
    local def = Jobs.GetDef(pd.job)
    if not def or def.type ~= 'food' then
        FW.Notify('Not a food job', 'error')
        return
    end
    if not Jobs.IsOnDutyFor(pd.job) then
        FW.Notify('On duty required', 'error')
        return
    end

    local options = {}
    for _, recipe in ipairs(def.craft or {}) do
        options[#options + 1] = {
            title = 'Prep: ' .. (recipe.label or recipe.item),
            icon = 'kitchen-set',
            onSelect = function()
                if def.kitchen and FW.Dist(GetEntityCoords(PlayerPedId()), def.kitchen) > 8.0 then
                    FW.Notify('Go to the kitchen', 'error')
                    return
                end
                if lib.progressCircle({
                    duration = recipe.ms or 5000,
                    label = ('Making %s…'):format(recipe.label or recipe.item),
                    position = 'bottom',
                    canCancel = true,
                    disable = { move = true, combat = true },
                    anim = { dict = 'amb@prop_human_bbq@male@base', clip = 'base' },
                }) then
                    TriggerServerEvent('bsrp-jobs:server:craft', pd.job, recipe.item, 1)
                    TriggerServerEvent('bsrp-jobs:server:pay', pd.job, 'craft', def.pay)
                end
            end,
        }
    end
    options[#options + 1] = {
        title = 'Serve Customer (quick pay)',
        icon = 'bell-concierge',
        onSelect = function()
            if def.counter and FW.Dist(GetEntityCoords(PlayerPedId()), def.counter) > 8.0 then
                FW.Notify('Go to the counter', 'error')
                return
            end
            if lib.progressCircle({
                duration = 4000,
                label = 'Serving…',
                position = 'bottom',
                canCancel = true,
                disable = { move = true, combat = true },
            }) then
                TriggerServerEvent('bsrp-jobs:server:pay', pd.job, 'serve', {
                    min = math.floor((def.pay.min or 40) * 0.5),
                    max = math.floor((def.pay.max or 80) * 0.5),
                })
            end
        end,
    }

    lib.registerContext({
        id = 'bsrp_food_menu',
        title = def.label or 'KITCHEN',
        options = options,
    })
    lib.showContext('bsrp_food_menu')
end)

CreateThread(function()
    while GetResourceState('ox_target') ~= 'started' do Wait(200) end
    Wait(600)
    for name, def in pairs(Config.Jobs or {}) do
        if def.type == 'food' then
            if def.kitchen then
                exports.ox_target:addSphereZone({
                    coords = def.kitchen,
                    radius = 1.4,
                    options = {
                        {
                            name = 'bsrp_jobs_kitchen_' .. name,
                            icon = 'fa-solid fa-fire-burner',
                            label = 'Use Kitchen',
                            canInteract = function()
                                return Jobs.IsOnDutyFor(name)
                            end,
                            onSelect = function()
                                TriggerEvent('bsrp-jobs:client:foodMenu')
                            end,
                        },
                    },
                })
            end
            if def.counter then
                exports.ox_target:addSphereZone({
                    coords = def.counter,
                    radius = 1.3,
                    options = {
                        {
                            name = 'bsrp_jobs_counter_' .. name,
                            icon = 'fa-solid fa-cash-register',
                            label = 'Serve Counter',
                            canInteract = function()
                                return Jobs.IsOnDutyFor(name)
                            end,
                            onSelect = function()
                                TriggerEvent('bsrp-jobs:client:foodMenu')
                            end,
                        },
                    },
                })
            end
        end
    end
end)
