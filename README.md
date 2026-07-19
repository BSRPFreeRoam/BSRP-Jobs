# 💼 BSRP Jobs

A modern job management system built exclusively for the **BSRP Framework**.

BSRP Jobs provides a complete employment system allowing players to interact with different careers, manage job assignments, and participate in roleplay activities while integrating directly with the BSRP ecosystem. Designed for flexibility, performance, and easy expansion, it serves as the foundation for civilian and professional jobs across BSRP resources.

---

## Features

* 💼 Job management system
* 👷 Multiple job support
* 📋 Job assignment handling
* 🔄 Job switching support
* 💰 Job payment integration
* 🏢 Employer system support
* 👤 Player job data management
* ⚡ Optimized performance
* 🔗 Full BSRP Framework integration

---

## Framework Requirements

This resource requires:

* BSRP Framework
* oxmysql
* ox_lib

Recommended:

* ox_inventory
* bsrp-characters
* bsrp-banking
* bsrp-phone
* bsrp-dispatch

---

## Installation

### 1. Place Resource

```text
resources/
└── bsrp-jobs/
```

### 2. Ensure Dependencies

```cfg
ensure oxmysql
ensure ox_lib

ensure bsrp
ensure bsrp-jobs
```

> BSRP Jobs must start after the `bsrp` core resource.

---

## Database

Import the provided SQL file if included:

```sql
sql/bsrp-jobs.sql
```

If automatic database initialization is enabled, required tables will be created automatically.

---

## Configuration

Configuration options can be found in:

```text
config.lua
```

Available settings may include:

* Available jobs
* Job grades
* Salary settings
* Job permissions
* Boss permissions
* Work locations
* Job vehicles
* Job restrictions

---

## Job System

### Job Management

Players can:

* View available jobs
* Receive job assignments
* Change employment
* Manage job information
* Access job-specific features

---

### Job Grades

Supports:

* Multiple ranks
* Different permissions
* Salary levels
* Job hierarchy
* Employee management

---

### Employment Features

Jobs can include:

* Civilian careers
* Government jobs
* Emergency services
* Business roles
* Custom server occupations

---

## Job Data

Each character stores:

* Job Name
* Job Grade
* Duty Status
* Employment Information
* Payment Information
* Employer Data

---

## Framework Integration

### Get Player

```lua
local player = exports.bsrp:GetPlayer(source)

if player then
    print(player.PlayerData.citizenid)
end
```

---

### Check Player Job

```lua
if player.PlayerData.job.name == "jobname" then
    -- Job actions
end
```

---

### Get Job Grade

```lua
local grade = player.PlayerData.job.grade.level
```

---

## Job Events

Example usage:

```lua
RegisterNetEvent('bsrp:jobChanged', function(job)
    print('New job:', job)
end)
```

```lua
RegisterNetEvent('bsrp:dutyChanged', function(state)
    print('Duty status:', state)
end)
```

> Event names may vary depending on implementation.

---

## Permissions

Administrative job actions can utilize the BSRP permission system:

```lua
if exports.bsrp:IsAdmin(source, 2) then
    -- Job administration actions
end
```

---

## Compatibility

| Resource          | Supported |
| ----------------- | --------- |
| BSRP Framework    | ✅         |
| oxmysql           | ✅         |
| ox_lib            | ✅         |
| ox_inventory      | ✅         |
| bsrp-characters   | ✅         |
| bsrp-banking      | ✅         |
| bsrp-phone        | ✅         |
| bsrp-dispatch     | ✅         |

---

## Job Lifecycle

### Player Joins

1. Player connects to the server
2. Character data loads
3. Job information is retrieved
4. Employment systems become available

---

### Job Selection

1. Player receives or selects a job
2. Job permissions are loaded
3. Grade information is assigned
4. Job features become available

---

### Job Updates

Job information is saved during:

* Job changes
* Grade promotions
* Duty changes
* Character switching
* Player logout
* Server restart

---

## Development

When creating resources that depend on job data:

```lua
local player = exports.bsrp:GetPlayer(source)

if not player then
    return
end

local job = player.PlayerData.job.name
```

Always verify player permissions and job information server-side before processing job-related actions.
