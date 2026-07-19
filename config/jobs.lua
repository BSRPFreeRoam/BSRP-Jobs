Config = Config or {}

--[[
    BSRP Jobs — gameplay modules for every job in bsrp/config_jobs.lua
    Types:
      route      — start run, visit stops, get paid
      workplace  — duty / garage / stash / clock work progress
      mechanic   — repair / clean vehicles
      tow        — flatbed hook + drop
      hunter     — hunt animals in zone
      food       — prep / serve mini-loop at kitchen
      skip       — handled by dedicated resource (police, ambulance)
]]

Config.Debug = false
Config.RequireDuty = true

-- LEO / EMS handled by dedicated resources (still listed for blips optional)
Config.SkipJobs = {
    police = true,
    ambulance = true,
    -- other LEO can still use workplaces below for duty/garage
}

Config.Jobs = {
    -- ═══════════════════════════════════════════
    -- TRANSPORT / LOGISTICS (route jobs)
    -- ═══════════════════════════════════════════
    taxi = {
        type = 'route',
        label = 'Downtown Cab Co.',
        blip = { sprite = 198, color = 5, scale = 0.7 },
        duty = vector3(894.88, -179.22, 74.7),
        garage = vector4(909.5, -177.35, 74.22, 240.0),
        vehicles = { { model = 'taxi', label = 'Taxi' } },
        stash = vector3(891.5, -182.2, 74.7),
        pay = { min = 120, max = 280 },
        stops = {
            vector4(257.61, -380.57, 44.71, 340.5),
            vector4(-48.58, -790.12, 44.22, 340.5),
            vector4(240.06, -862.77, 29.73, 341.5),
            vector4(826.0, -1885.26, 29.32, 81.5),
            vector4(-1053.23, -2716.2, 13.75, 329.5),
            vector4(-515.19, -260.29, 35.53, 201.5),
            vector4(442.09, -1684.33, 29.25, 320.5),
            vector4(1120.73, -957.31, 47.43, 289.5),
            vector4(1920.93, 3703.85, 32.63, 120.5),
            vector4(-9.51, 6529.67, 31.37, 136.5),
        },
        mode = 'taxi', -- pickup NPC style (marker dropoff)
        description = 'Pick up fares across the city',
    },

    bus = {
        type = 'route',
        label = 'Los Santos Transit',
        blip = { sprite = 513, color = 3, scale = 0.7 },
        duty = vector3(453.6, -600.6, 28.6),
        garage = vector4(462.22, -641.15, 28.45, 175.0),
        vehicles = { { model = 'bus', label = 'City Bus' } },
        pay = { min = 90, max = 180 },
        stops = {
            vector4(304.36, -764.56, 29.31, 252.09),
            vector4(-110.31, -1686.29, 29.31, 223.84),
            vector4(-712.83, -824.56, 23.54, 194.7),
            vector4(-250.14, -886.78, 30.63, 8.67),
            vector4(114.2, -781.5, 31.4, 160.0),
            vector4(-1034.6, -2730.5, 20.2, 240.0),
        },
        mode = 'bus',
        description = 'Drive the city bus route',
    },

    garbage = {
        type = 'route',
        label = 'Sanitation',
        blip = { sprite = 318, color = 25, scale = 0.7 },
        duty = vector3(-321.45, -1545.86, 31.02),
        garage = vector4(-333.84, -1527.28, 27.28, 1.97),
        vehicles = { { model = 'trash2', label = 'Garbage Truck' } },
        pay = { min = 80, max = 160 },
        stops = {
            vector4(-168.07, -1662.8, 33.31, 137.5),
            vector4(118.06, -1943.96, 20.43, 179.5),
            vector4(297.94, -2018.26, 20.49, 119.5),
            vector4(424.98, -1523.57, 29.28, 120.08),
            vector4(488.49, -1284.1, 29.24, 138.5),
            vector4(-35.5, -1490.2, 30.5, 50.0),
            vector4(-700.2, -920.5, 19.0, 90.0),
        },
        mode = 'collect',
        progressLabel = 'Collecting trash…',
        progressMs = 5000,
        description = 'Collect trash around the city',
    },

    trucker = {
        type = 'route',
        label = 'Haul & Freight',
        blip = { sprite = 477, color = 5, scale = 0.7 },
        duty = vector3(153.5, -3211.7, 5.9),
        garage = vector4(145.5, -3210.5, 5.9, 270.0),
        vehicles = { { model = 'phantom', label = 'Hauler' }, { model = 'packer', label = 'Packer' } },
        pay = { min = 200, max = 450 },
        stops = {
            vector4(1181.0, -3243.5, 6.0, 90.0),
            vector4(173.5, 2778.5, 45.7, 280.0),
            vector4(2561.5, 468.5, 108.5, 0.0),
            vector4(-315.5, -2780.0, 5.0, 90.0),
            vector4(2673.5, 3515.5, 52.7, 60.0),
            vector4(1695.0, 4785.0, 42.0, 90.0),
        },
        mode = 'deliver',
        progressLabel = 'Unloading freight…',
        progressMs = 7000,
        description = 'Haul freight across San Andreas',
    },

    delivery = {
        type = 'route',
        label = "Jax's Postal Service",
        blip = { sprite = 478, color = 31, scale = 0.7 },
        duty = vector3(78.9, 112.5, 81.2),
        garage = vector4(69.5, 124.0, 79.2, 160.0),
        vehicles = { { model = 'boxville2', label = 'Postal Van' } },
        pay = { min = 70, max = 150 },
        stops = {
            vector4(288.8, -1601.2, 31.3, 0.0),
            vector4(-702.5, -917.2, 19.2, 0.0),
            vector4(1138.2, -981.5, 46.4, 0.0),
            vector4(-1223.5, -907.2, 12.3, 0.0),
            vector4(25.7, -1346.5, 29.5, 0.0),
            vector4(-48.5, -1757.5, 29.4, 0.0),
            vector4(1163.4, -323.8, 69.2, 0.0),
            vector4(373.5, 325.5, 103.6, 0.0),
        },
        mode = 'deliver',
        progressLabel = 'Delivering package…',
        progressMs = 4000,
        description = 'Deliver packages across the city',
    },

    recycle = {
        type = 'route',
        label = 'Recycling Center',
        blip = { sprite = 365, color = 2, scale = 0.7 },
        duty = vector3(55.5, 6472.2, 31.4),
        garage = vector4(46.5, 6458.5, 31.4, 225.0),
        vehicles = { { model = 'scrap', label = 'Scrap Truck' } },
        pay = { min = 60, max = 130 },
        stops = {
            vector4(2340.5, 3126.5, 48.2, 0.0),
            vector4(2415.5, 4993.5, 46.2, 0.0),
            vector4(1705.5, 4920.5, 42.1, 0.0),
            vector4(-355.5, -1513.5, 27.7, 0.0),
            vector4(747.5, -1399.5, 26.6, 0.0),
        },
        mode = 'collect',
        progressLabel = 'Sorting recyclables…',
        progressMs = 5500,
        description = 'Collect and sort recyclables',
    },

    tow = {
        type = 'tow',
        label = 'Tow Yard',
        blip = { sprite = 68, color = 17, scale = 0.7 },
        duty = vector3(409.0, -1623.0, 29.3),
        garage = vector4(401.5, -1631.5, 29.3, 230.0),
        dropoff = vector3(408.5, -1638.5, 29.3),
        vehicles = { { model = 'flatbed', label = 'Flatbed' } },
        pay = { min = 150, max = 350 },
        description = 'Impound and deliver vehicles',
    },

    mechanic = {
        type = 'mechanic',
        label = "Sparky's Auto Repair",
        blip = { sprite = 446, color = 5, scale = 0.75 },
        duty = vector3(-347.4, -133.3, 39.0),
        garage = vector4(-356.5, -125.5, 38.7, 70.0),
        stash = vector3(-345.5, -130.5, 39.0),
        vehicles = { { model = 'towtruck2', label = 'Service Truck' } },
        repairPay = { min = 80, max = 200 },
        cleanPay = { min = 30, max = 60 },
        description = 'Repair and service vehicles',
    },

    -- ═══════════════════════════════════════════
    -- OUTDOOR / SPECIALTY
    -- ═══════════════════════════════════════════
    hunter = {
        type = 'hunter',
        label = 'Wilderness Hunting Co.',
        blip = { sprite = 141, color = 21, scale = 0.75 },
        duty = vector3(-679.0, 5834.5, 17.3),
        garage = vector4(-685.5, 5830.5, 17.3, 130.0),
        vehicles = { { model = 'bodhi2', label = 'Hunt Truck' } },
        zone = vector3(-938.61, 4823.99, 313.92),
        zoneRadius = 650.0,
        pay = { min = 100, max = 250 },
        animals = { `a_c_deer`, `a_c_boar`, `a_c_coyote`, `a_c_mtlion` },
        description = 'Hunt wildlife in the mountains',
    },

    vineyard = {
        type = 'route',
        label = 'Vineyard Workers',
        blip = { sprite = 85, color = 27, scale = 0.7 },
        duty = vector3(-1889.5, 2050.5, 140.9),
        garage = vector4(-1923.5, 2053.5, 140.7, 250.0),
        vehicles = { { model = 'kalahari', label = 'Vineyard Cart' } },
        pay = { min = 70, max = 140 },
        stops = {
            vector4(-1874.5, 2090.5, 139.5, 0.0),
            vector4(-1905.5, 2115.5, 131.5, 0.0),
            vector4(-1928.5, 2070.5, 140.5, 0.0),
            vector4(-1856.5, 2065.5, 140.5, 0.0),
        },
        mode = 'collect',
        progressLabel = 'Harvesting grapes…',
        progressMs = 6000,
        description = 'Harvest and process grapes',
    },

    oilwell = {
        type = 'route',
        label = 'Los Santos Oil Corp.',
        blip = { sprite = 436, color = 5, scale = 0.7 },
        duty = vector3(1365.5, -2075.5, 52.0),
        garage = vector4(1375.5, -2065.5, 52.0, 90.0),
        vehicles = { { model = 'tiptruck2', label = 'Oil Rig Truck' } },
        pay = { min = 110, max = 220 },
        stops = {
            vector4(1445.5, -2295.5, 66.5, 0.0),
            vector4(1565.5, -2165.5, 77.5, 0.0),
            vector4(1695.5, -1915.5, 113.5, 0.0),
            vector4(1225.5, -2425.5, 44.5, 0.0),
        },
        mode = 'collect',
        progressLabel = 'Working the pump…',
        progressMs = 8000,
        description = 'Service oil pumps and transport crude',
    },

    airport = {
        type = 'route',
        label = 'LSIA Operations',
        blip = { sprite = 90, color = 3, scale = 0.7 },
        duty = vector3(-1037.5, -2737.5, 20.2),
        garage = vector4(-1025.5, -2733.5, 13.8, 330.0),
        vehicles = { { model = 'airtug', label = 'Airtug' }, { model = 'ripley', label = 'Ripley' } },
        pay = { min = 90, max = 180 },
        stops = {
            vector4(-1336.5, -2650.5, 13.9, 0.0),
            vector4(-1650.5, -3145.5, 13.9, 0.0),
            vector4(-1165.5, -2975.5, 13.9, 0.0),
            vector4(-970.5, -3000.5, 13.9, 0.0),
        },
        mode = 'deliver',
        progressLabel = 'Handling cargo…',
        progressMs = 6000,
        description = 'Airport ramp and cargo work',
    },

    -- ═══════════════════════════════════════════
    -- FOOD / HOSPITALITY (food + workplace)
    -- ═══════════════════════════════════════════
    burgershot = {
        type = 'food',
        label = 'Burger Shot',
        blip = { sprite = 106, color = 1, scale = 0.7 },
        duty = vector3(-1195.5, -901.5, 13.9),
        stash = vector3(-1197.5, -896.5, 13.9),
        kitchen = vector3(-1198.5, -898.5, 13.9),
        counter = vector3(-1193.5, -895.5, 13.9),
        garage = vector4(-1175.5, -890.5, 13.9, 30.0),
        vehicles = { { model = 'faggio', label = 'Delivery Scooter' } },
        pay = { min = 40, max = 90 },
        craft = { { item = 'burger', label = 'Burger', ms = 5000 } },
        description = 'Cook and serve burgers',
    },

    taco = {
        type = 'food',
        label = 'Los Santos Taco Co.',
        blip = { sprite = 79, color = 46, scale = 0.7 },
        duty = vector3(11.5, -1605.5, 29.4),
        kitchen = vector3(15.5, -1598.5, 29.4),
        counter = vector3(8.5, -1606.5, 29.4),
        stash = vector3(13.5, -1600.5, 29.4),
        pay = { min = 40, max = 85 },
        craft = { { item = 'taco', label = 'Taco', ms = 4500 } },
        description = 'Prep and sell tacos',
    },

    beanmachine = {
        type = 'food',
        label = 'Bean Machine',
        blip = { sprite = 106, color = 10, scale = 0.65 },
        duty = vector3(-628.5, 239.5, 81.9),
        kitchen = vector3(-635.5, 235.5, 81.9),
        counter = vector3(-627.5, 235.5, 81.9),
        pay = { min = 35, max = 75 },
        craft = { { item = 'water', label = 'Coffee Cup', ms = 4000 } },
        description = 'Brew and serve coffee',
    },

    pizzathis = {
        type = 'food',
        label = 'Pizza This',
        blip = { sprite = 267, color = 1, scale = 0.7 },
        duty = vector3(538.5, 101.5, 96.5),
        kitchen = vector3(544.5, 105.5, 96.5),
        counter = vector3(536.5, 100.5, 96.5),
        pay = { min = 45, max = 95 },
        craft = { { item = 'burger', label = 'Pizza Slice', ms = 5500 } },
        description = 'Make and serve pizza',
    },

    uwu = {
        type = 'food',
        label = 'uWu Cafe',
        blip = { sprite = 621, color = 8, scale = 0.7 },
        duty = vector3(-584.5, -1061.5, 22.3),
        kitchen = vector3(-590.5, -1056.5, 22.3),
        counter = vector3(-583.5, -1060.5, 22.3),
        pay = { min = 40, max = 85 },
        craft = { { item = 'water', label = 'Boba Tea', ms = 4500 } },
        description = 'Cafe service and prep',
    },

    upnatoms = {
        type = 'food',
        label = 'Up-N-Atoms',
        blip = { sprite = 106, color = 5, scale = 0.65 },
        duty = vector3(81.5, 274.5, 110.2),
        kitchen = vector3(89.5, 285.5, 110.2),
        counter = vector3(86.5, 275.5, 110.2),
        pay = { min = 40, max = 85 },
        craft = { { item = 'burger', label = 'Atom Burger', ms = 5000 } },
        description = 'Fast food service',
    },

    mesanuxta = {
        type = 'food',
        label = 'Mesa Nuxta',
        blip = { sprite = 93, color = 48, scale = 0.65 },
        duty = vector3(-1345.5, -1078.5, 6.9),
        kitchen = vector3(-1348.5, -1070.5, 6.9),
        counter = vector3(-1342.5, -1075.5, 6.9),
        pay = { min = 45, max = 95 },
        craft = { { item = 'burger', label = 'Plate Special', ms = 6000 } },
        description = 'Restaurant kitchen and service',
    },

    tequilala = {
        type = 'food',
        label = 'Tequi-la-la',
        blip = { sprite = 93, color = 27, scale = 0.7 },
        duty = vector3(-562.5, 287.5, 82.2),
        kitchen = vector3(-561.5, 286.5, 82.2),
        counter = vector3(-560.5, 285.5, 82.2),
        pay = { min = 40, max = 100 },
        craft = { { item = 'water', label = 'Cocktail', ms = 4000 } },
        description = 'Bar service',
    },

    vanilla = {
        type = 'workplace',
        label = 'Vanilla Unicorn',
        blip = { sprite = 121, color = 8, scale = 0.7 },
        duty = vector3(127.5, -1297.5, 29.3),
        stash = vector3(108.5, -1304.5, 28.8),
        garage = vector4(141.5, -1282.5, 29.3, 30.0),
        vehicles = { { model = 'stretch', label = 'Club Limo' } },
        work = { label = 'Work the floor…', ms = 12000, pay = { min = 50, max = 140 } },
        description = 'Club floor and hosting',
    },

    hotdog = {
        type = 'food',
        label = "Hotdog Stands",
        blip = { sprite = 106, color = 46, scale = 0.6 },
        duty = vector3(44.5, -997.5, 29.3),
        kitchen = vector3(43.5, -998.5, 29.3),
        counter = vector3(45.5, -998.5, 29.3),
        pay = { min = 30, max = 70 },
        craft = { { item = 'burger', label = 'Hotdog', ms = 3500 } },
        description = 'Street hotdog sales',
    },

    casino = {
        type = 'workplace',
        label = "Lando's Diamond Casino",
        blip = { sprite = 679, color = 0, scale = 0.75 },
        duty = vector3(965.5, 47.5, 71.7),
        stash = vector3(978.5, 25.5, 71.5),
        garage = vector4(920.5, 41.5, 81.1, 150.0),
        vehicles = { { model = 'stretch', label = 'Casino Limo' } },
        work = { label = 'Working the floor…', ms = 15000, pay = { min = 80, max = 200 } },
        description = 'Casino floor operations',
    },

    whitewidow = {
        type = 'route',
        label = 'Whitewidow Enterprises',
        blip = { sprite = 140, color = 2, scale = 0.7 },
        duty = vector3(195.5, -240.5, 54.1),
        garage = vector4(185.5, -235.5, 54.1, 250.0),
        vehicles = { { model = 'speedo', label = 'Courier Van' } },
        pay = { min = 70, max = 160 },
        stops = {
            vector4(1138.2, -981.5, 46.4, 0.0),
            vector4(-1223.5, -907.2, 12.3, 0.0),
            vector4(25.7, -1346.5, 29.5, 0.0),
            vector4(-48.5, -1757.5, 29.4, 0.0),
        },
        mode = 'deliver',
        progressLabel = 'Delivering product…',
        progressMs = 5000,
        description = 'Cultivate, package, and deliver',
    },

    -- ═══════════════════════════════════════════
    -- DEALERSHIPS / SERVICES
    -- ═══════════════════════════════════════════
    cardealer = {
        type = 'workplace',
        label = 'Premium Deluxe Motorsport',
        blip = { sprite = 326, color = 3, scale = 0.7 },
        duty = vector3(-32.0, -1114.2, 26.4),
        garage = vector4(-23.5, -1094.5, 27.3, 160.0),
        vehicles = { { model = 'sultan', label = 'Test Drive Sultan' } },
        work = { label = 'Showing a vehicle…', ms = 10000, pay = { min = 60, max = 150 } },
        description = 'Vehicle sales (see also bsrp-pdm)',
    },

    airdealer = {
        type = 'workplace',
        label = 'Aircraft Sales',
        blip = { sprite = 423, color = 3, scale = 0.7 },
        duty = vector3(-941.5, -2954.5, 13.9),
        garage = vector4(-980.5, -2995.5, 13.9, 60.0),
        vehicles = { { model = 'seashark', label = 'Demo Seashark' } },
        work = { label = 'Aircraft demo tour…', ms = 12000, pay = { min = 100, max = 220 } },
        description = 'Aircraft dealership floor',
    },

    boatdealer = {
        type = 'workplace',
        label = 'Boat Sales',
        blip = { sprite = 410, color = 3, scale = 0.7 },
        duty = vector3(-714.5, -1297.5, 5.1),
        garage = vector4(-725.5, -1310.5, 1.6, 140.0),
        vehicles = { { model = 'dinghy', label = 'Demo Dinghy' } },
        work = { label = 'Boat showing…', ms = 11000, pay = { min = 90, max = 200 } },
        description = 'Boat dealership floor',
    },

    realestate = {
        type = 'workplace',
        label = 'Dynasty 8',
        blip = { sprite = 374, color = 2, scale = 0.7 },
        duty = vector3(-716.5, 261.3, 84.1),
        garage = vector4(-700.5, 268.5, 83.1, 30.0),
        vehicles = { { model = 'oracle', label = 'Realtor Car' } },
        work = { label = 'Showing a property…', ms = 14000, pay = { min = 100, max = 250 } },
        description = 'Property sales (see also bsrp-housing)',
    },

    reporter = {
        type = 'workplace',
        label = 'Weazel News',
        blip = { sprite = 135, color = 1, scale = 0.7 },
        duty = vector3(-598.5, -929.5, 23.9),
        garage = vector4(-557.5, -925.5, 23.9, 90.0),
        vehicles = { { model = 'rumpo', label = 'News Van' } },
        work = { label = 'Filing a report…', ms = 10000, pay = { min = 70, max = 160 } },
        description = 'News reporting around the city',
    },

    dj = {
        type = 'workplace',
        label = 'Nightclub DJ',
        blip = { sprite = 136, color = 27, scale = 0.65 },
        duty = vector3(-1604.5, -3012.5, -77.8),
        work = { label = 'Spinning tracks…', ms = 15000, pay = { min = 80, max = 200 } },
        description = 'Perform sets at the club',
    },

    -- ═══════════════════════════════════════════
    -- GOV / LEGAL (light workplace)
    -- ═══════════════════════════════════════════
    judge = {
        type = 'workplace',
        label = 'Courthouse',
        blip = { sprite = 408, color = 0, scale = 0.7 },
        duty = vector3(243.5, -1073.5, 29.3),
        work = { label = 'Reviewing cases…', ms = 12000, pay = { min = 120, max = 250 } },
        description = 'Judicial duties',
    },

    lawyer = {
        type = 'workplace',
        label = 'Law Office',
        blip = { sprite = 408, color = 5, scale = 0.65 },
        duty = vector3(-70.5, -801.5, 44.2),
        work = { label = 'Preparing briefs…', ms = 10000, pay = { min = 90, max = 200 } },
        description = 'Legal counsel work',
    },

    mayor = {
        type = 'workplace',
        label = 'City Hall',
        blip = { sprite = 419, color = 0, scale = 0.75 },
        duty = vector3(-545.5, -204.5, 38.2),
        work = { label = 'City business…', ms = 12000, pay = { min = 150, max = 300 } },
        description = 'Mayoral administration',
    },

    racerx = {
        type = 'workplace',
        label = 'RacerX',
        blip = { sprite = 38, color = 1, scale = 0.75 },
        duty = vector3(967.5, -1829.5, 31.2),
        garage = vector4(972.5, -1820.5, 31.1, 355.0),
        vehicles = { { model = 'sultanrs', label = 'Team Sultan RS' } },
        work = { label = 'Garage prep…', ms = 8000, pay = { min = 50, max = 120 } },
        description = 'Racing team ops (see also bsrp-racing)',
    },

    -- ═══════════════════════════════════════════
    -- LEO departments — duty + garage (tools in bsrp-policejob)
    -- ═══════════════════════════════════════════
    bcso = {
        type = 'workplace',
        label = 'BCSO',
        blip = { sprite = 60, color = 5, scale = 0.7 },
        duty = vector3(1853.2, 3689.5, 34.3),
        garage = vector4(1868.5, 3695.5, 33.6, 210.0),
        vehicles = { { model = 'sheriff', label = 'Sheriff Cruiser' } },
        description = 'Blaine County Sheriff — use F6 police tools',
    },
    sasp = {
        type = 'workplace',
        label = 'SASP',
        blip = { sprite = 60, color = 0, scale = 0.7 },
        duty = vector3(1538.5, 811.2, 77.5),
        garage = vector4(1545.5, 795.5, 77.1, 60.0),
        vehicles = { { model = 'police', label = 'State Cruiser' } },
        description = 'State Troopers — use F6 police tools',
    },
    lssd = {
        type = 'workplace',
        label = 'LSSD',
        blip = { sprite = 60, color = 3, scale = 0.7 },
        duty = vector3(1818.5, 3665.5, 34.3),
        garage = vector4(1830.5, 3665.5, 33.9, 210.0),
        vehicles = { { model = 'sheriff2', label = 'LSSD Unit' } },
        description = 'County Sheriff — use F6 police tools',
    },
    pbpd = {
        type = 'workplace',
        label = 'Paleto PD',
        blip = { sprite = 60, color = 29, scale = 0.7 },
        duty = vector3(-448.5, 6012.5, 31.7),
        garage = vector4(-455.5, 6002.0, 31.3, 87.0),
        vehicles = { { model = 'police', label = 'PBPD Cruiser' } },
        description = 'Paleto Bay PD',
    },
    dppd = {
        type = 'workplace',
        label = 'Del Perro PD',
        blip = { sprite = 60, color = 3, scale = 0.65 },
        duty = vector3(-1630.5, -1015.5, 13.1),
        garage = vector4(-1635.5, -1008.5, 13.0, 50.0),
        vehicles = { { model = 'police3', label = 'DPPD Unit' } },
        description = 'Del Perro PD',
    },
    grapeseedpd = {
        type = 'workplace',
        label = 'Grapeseed PD',
        blip = { sprite = 60, color = 2, scale = 0.65 },
        duty = vector3(1658.5, 4882.5, 42.0),
        garage = vector4(1665.5, 4880.5, 42.0, 100.0),
        vehicles = { { model = 'sheriff', label = 'GSPD Unit' } },
        description = 'Grapeseed PD',
    },
    sapr = {
        type = 'workplace',
        label = 'Park Rangers',
        blip = { sprite = 141, color = 2, scale = 0.7 },
        duty = vector3(387.5, 792.5, 187.7),
        garage = vector4(392.5, 780.5, 186.0, 90.0),
        vehicles = { { model = 'pranger', label = 'Ranger SUV' } },
        description = 'Park ranger unit',
    },
    doc = {
        type = 'workplace',
        label = 'DOC',
        blip = { sprite = 60, color = 0, scale = 0.7 },
        duty = vector3(1845.5, 2585.5, 45.7),
        garage = vector4(1855.5, 2595.5, 45.7, 270.0),
        vehicles = { { model = 'policet', label = 'DOC Transport' } },
        description = 'Department of Corrections',
    },
    swat = {
        type = 'workplace',
        label = 'SWAT',
        blip = { sprite = 60, color = 1, scale = 0.7 },
        duty = vector3(461.5, -981.5, 30.7),
        garage = vector4(452.5, -1017.5, 28.5, 90.0),
        vehicles = { { model = 'riot', label = 'Riot Van' } },
        description = 'Tactical unit',
    },
    noose = {
        type = 'workplace',
        label = 'NOOSE',
        blip = { sprite = 60, color = 40, scale = 0.7 },
        duty = vector3(2492.5, -384.5, 94.1),
        garage = vector4(2500.5, -380.5, 93.0, 90.0),
        vehicles = { { model = 'fbi2', label = 'NOOSE SUV' } },
        description = 'Federal security',
    },
    fib = {
        type = 'workplace',
        label = 'FIB',
        blip = { sprite = 60, color = 40, scale = 0.75 },
        duty = vector3(141.2, -769.0, 45.75),
        garage = vector4(124.5, -742.5, 33.1, 340.0),
        vehicles = { { model = 'fbi', label = 'FIB Buffalo' }, { model = 'fbi2', label = 'FIB Granger' } },
        stash = vector3(136.5, -762.5, 45.75),
        description = 'Federal Investigation Bureau',
    },
    borderpatrol = {
        type = 'workplace',
        label = 'Border Patrol',
        blip = { sprite = 60, color = 3, scale = 0.7 },
        duty = vector3(1545.5, 6333.5, 24.1),
        garage = vector4(1535.5, 6325.5, 24.1, 90.0),
        vehicles = { { model = 'sheriff2', label = 'BP Unit' } },
        description = 'Border security',
    },
    mw = {
        type = 'workplace',
        label = 'Merryweather',
        blip = { sprite = 487, color = 5, scale = 0.7 },
        duty = vector3(567.5, -3126.5, 18.8),
        garage = vector4(560.5, -3115.5, 18.8, 0.0),
        vehicles = { { model = 'mesa3', label = 'MW Mesa' } },
        description = 'Private security',
    },
    fire = {
        type = 'workplace',
        label = 'Fire Department',
        blip = { sprite = 436, color = 1, scale = 0.75 },
        duty = vector3(215.1, -1641.5, 29.8),
        garage = vector4(210.5, -1656.5, 29.8, 320.0),
        vehicles = { { model = 'firetruk', label = 'Fire Truck' }, { model = 'ambulance', label = 'Rescue' } },
        description = 'Fire & rescue — medical tools via EMS resource',
    },
}
