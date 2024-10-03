Config = {}

-- Enable or disable qb-target
Config.UseQBTarget = true

-- Menu and notification systems
Config.MenuSystem = 'bs'                    -- Use 'qb' for qb-menu, 'bs' for bs-menu
Config.NotifySystem = 'bs'                  -- Use 'qb' for qb-notify, 'bs' for bs-notify, or 'none' for no notifications

-- Elevator locations
Config.Elevators = {
    ["MAZE BANK TOWER"] = {
        useRestriction = true,              -- Set to true to enable job/item/citizenid restrictions 
        restrictedTo = {
            jobs = {"police"},              -- Add job names that are allowed to use this elevator              /   leave blank to allow all jobs           /add multiple jobs like this {"police", "doctor"}
            items = {'police_keycard'},     -- Add item names that are required to use this elevator            /   leave blank to allow all items          /add multiple items like this {'police_keycard', 'hospital_keycard'}
            citizenids = {}                 -- Add specific citizen IDs that are allowed to use this elevator   /   leave blank to allow all citizen IDs
        },
        isCarElevator = false,              -- Set to true if this is a car elevator
        floors = {
            {
                name = "Lobby",
                coords = vector3(-70.87, -801.05, 43.23),
                heading = 0.0
            },
            {
                name = "Roof",
                coords = vector3(-67.77, -821.68, 320.29),
                heading = 0.0
            }
        }
    },
    ["Hospital"] = {
        useRestriction = true,
        restrictedTo = {
            jobs = {"ambulance", "doctor"},
            items = {"hospital_keycard"},
            citizenids = {}
        },
        isCarElevator = false,
        floors = {
            {
                name = "Lobby",
                coords = vector3(200.0, 200.0, 30.0),
                heading = 90.0
            },
            {
                name = "Emergency Room",
                coords = vector3(200.0, 200.0, 35.0),
                heading = 90.0
            },
            {
                name = "Rooftop",
                coords = vector3(200.0, 200.0, 50.0),
                heading = 90.0
            }
        }
    }
    -- easily add more elevators here following the same structure
}