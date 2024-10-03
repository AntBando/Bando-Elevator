local QBCore = exports['qb-core']:GetCoreObject()
local soundId = GetSoundId()

local function NotifyPlayer(message, type)
    if Config.NotifySystem == 'qb' then
        QBCore.Functions.Notify(message, type)
    elseif Config.NotifySystem == 'bs' then
        TriggerEvent('BS-Notify', {type = type, message = message})
    elseif Config.NotifySystem == 'none' then
        -- Do nothing
    else
        print("Invalid notify system specified in config")
    end
end

local function OpenMenu(data)
    if Config.MenuSystem == 'qb' then
        exports['qb-menu']:openMenu(data)
    elseif Config.MenuSystem == 'bs' then
        exports['bs-menu']:bsmenu(data)
    else
        print("Invalid menu system specified in config")
    end
end

Citizen.CreateThread(function()
    if Config.MenuSystem ~= 'qb' and Config.MenuSystem ~= 'bs' then
        print("WARNING: Invalid menu system specified in config. Please use 'qb' or 'bs'.")
    end
end)

Citizen.CreateThread(function()
    if Config.NotifySystem ~= 'qb' and Config.NotifySystem ~= 'bs' and Config.NotifySystem ~= 'none' then
        print("WARNING: Invalid notify system specified in config. Please use 'qb', 'bs', or 'none'.")
    end
end)

-- Functions
local function TeleportToFloor(elevatorId, floorIndex)
    local ped = PlayerPedId()
    local isInVehicle = IsPedInAnyVehicle(ped, false)
    local floor = Config.Elevators[elevatorId].floors[floorIndex]
    local isCarElevator = Config.Elevators[elevatorId].isCarElevator

    if isInVehicle and not isCarElevator then
        NotifyPlayer("This is not a car elevator. Please exit your vehicle.", "error")
        return
    end
    
    -- Check if player is already on this floor
    local playerCoords = GetEntityCoords(ped)
    if #(playerCoords - floor.coords) < 2.0 then
        NotifyPlayer("You are already on this floor.", "error")
        return
    end
    
    -- Create a black screen
    DoScreenFadeOut(1000)
    
    -- Wait for the screen to fade out
    while not IsScreenFadedOut() do
        Citizen.Wait(10)
    end
    
    -- Play elevator sound (Dont Work Yet) coming soon
    -- PlaySound(soundId, "Beep_Green", ped, "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1, 0)
   
    -- Wait for 5 seconds
    Citizen.Wait(5000)
    
    -- Teleport the player or vehicle
    if isCarElevator and IsPedInAnyVehicle(ped, false) then
        local vehicle = GetVehiclePedIsIn(ped, false)
        SetEntityCoords(vehicle, floor.coords.x, floor.coords.y, floor.coords.z, false, false, false, false)
        SetEntityHeading(vehicle, floor.heading)
    else
        SetEntityCoords(ped, floor.coords.x, floor.coords.y, floor.coords.z, false, false, false, false)
        SetEntityHeading(ped, floor.heading)
    end
    
    -- Fade the screen back in
    DoScreenFadeIn(1000)
end

local function OpenElevatorMenu(elevatorId)
    local ped = PlayerPedId()
    local isInVehicle = IsPedInAnyVehicle(ped, false)
    local isCarElevator = Config.Elevators[elevatorId].isCarElevator 
    if isInVehicle and not isCarElevator then
        NotifyPlayer("This is not a car elevator. Please exit your vehicle to use it.", "error")
        return
    end

    QBCore.Functions.TriggerCallback('bs-elevator:server:checkAccess', function(hasAccess)
        if hasAccess then
            local menuItems = {
                {
                    header = Config.Elevators[elevatorId].name or elevatorId,
                    icon = 'fas fa-building',
                    isMenuHeader = true
                }
            }
            
            for i, floor in ipairs(Config.Elevators[elevatorId].floors) do
                table.insert(menuItems, {
                    header = floor.name,
                    txt = "Go to " .. floor.name,
                    icon = 'fas fa-arrow-up-from-bracket',
                    params = {
                        event = 'bs-elevator:client:useElevator',
                        args = {
                            elevatorId = elevatorId,
                            floorIndex = i
                        }
                    }
                })
            end
            
            OpenMenu(menuItems)
        else
            NotifyPlayer("You don't have access to this elevator.", "error")
        end
    end, elevatorId)
end

-- Events
RegisterNetEvent('bs-elevator:client:useElevator', function(data)
    TeleportToFloor(data.elevatorId, data.floorIndex)
end)

-- Main thread
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerCoords = GetEntityCoords(PlayerPedId())

        for elevatorId, elevatorData in pairs(Config.Elevators) do
            for i, floor in ipairs(elevatorData.floors) do
                local distance = #(playerCoords - floor.coords)

                if distance < 1.5 then
                    if not Config.UseQBTarget then
                        DrawText3D(floor.coords.x, floor.coords.y, floor.coords.z, "Press [E] to use elevator")
                        if IsControlJustReleased(0, 38) then -- 'E' key
                            OpenElevatorMenu(elevatorId)
                        end
                    end
                    break
                end
            end
        end
    end
end)

-- QB-Target integration
if Config.UseQBTarget then
    for elevatorId, elevatorData in pairs(Config.Elevators) do
        for i, floor in ipairs(elevatorData.floors) do
            exports['qb-target']:AddBoxZone("elevator_" .. elevatorId .. "_" .. i, floor.coords, 2.0, 2.0, {
                name = "elevator_" .. elevatorId .. "_" .. i,
                heading = floor.heading,
                debugPoly = false,
                minZ = floor.coords.z - 1,
                maxZ = floor.coords.z + 2,
            }, {
                options = {
                    {
                        type = "client",
                        event = "bs-elevator:client:openMenu",
                        icon = "fas fa-elevator",
                        label = "Use Elevator",
                        elevatorId = elevatorId
                    },
                },
                distance = 2.0
            })
        end
    end
end

RegisterNetEvent('bs-elevator:client:openMenu', function(data)
    OpenElevatorMenu(data.elevatorId)
end)

-- Utility function for 3D text
function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoords())
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x, _y)
    local factor = (string.len(text)) / 370
    DrawRect(_x, _y + 0.0125, 0.015 + factor, 0.03, 41, 11, 41, 68)
end