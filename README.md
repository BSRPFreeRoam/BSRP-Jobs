# bsrp-jobs

Gameplay scripts for **every job** defined in `bsrp/config_jobs.lua` (except full LEO/EMS toolkits, which live in `bsrp-policejob` / `bsrp-ambulancejob`).

Inspired by the qbcore-framework job suite (`qb-taxijob`, `qb-towjob`, `qb-garbagejob`, `qb-busjob`, `qb-mechanicjob`, food jobs, etc.) — rebuilt for **BSRP**, **ox_*** stack, and the futuristic theme.

## Dependencies

```
ox_lib
ox_target
ox_inventory
bsrp
```

## server.cfg

```cfg
ensure ox_lib
ensure ox_target
ensure ox_inventory
ensure bsrp
ensure bsrp-jobs
# optional specialized:
ensure bsrp-policejob
ensure bsrp-ambulancejob
ensure ps-multijob
```

## Controls

| Input | Action |
|-------|--------|
| **F5** / `/jobsmenu` | Job actions for your current job |
| **E** at stop markers | Complete route stops |
| ox_target at workplaces | Duty, garage, kitchen, locker |

## Job types

| Type | Jobs | Gameplay |
|------|------|----------|
| **route** | taxi, bus, garbage, trucker, delivery, recycle, vineyard, oilwell, airport, whitewidow | Start run → visit stops → pay |
| **mechanic** | mechanic | Repair / clean / flip vehicles |
| **tow** | tow | Hook vehicle on flatbed → yard dropoff |
| **hunter** | hunter | Spawn animals in zone → skin for pay |
| **food** | burgershot, taco, beanmachine, pizzathis, uwu, upnatoms, mesanuxta, tequilala, hotdog | Kitchen craft + counter serve |
| **workplace** | casino, vanilla, dealerships, realestate, reporter, dj, legal, LEO depts, fire, racerx | Duty, garage, timed work pay |

## LEO / EMS

- **police** / **ambulance** full scripts: `bsrp-policejob`, `bsrp-ambulancejob`
- Other LEO (`fib`, `bcso`, `sasp`, …): duty + garage here; interactions/cuff via policejob if job is LEO type

## Config

Edit `config/jobs.lua`:

- Locations (duty, garage, stops, kitchen)
- Vehicles, pay ranges, progress times
- Food craft recipes (ox_inventory item names)

## Notes

- Pay goes to **cash** via `bsrp` with grade bonus
- Food craft needs items defined in ox_inventory (`burger`, `water`, etc. — add `taco` if missing)
- Coords are sensible defaults; tweak per map / MLO
