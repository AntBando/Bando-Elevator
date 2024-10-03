local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('bs-elevator:server:checkAccess', function(source, cb, elevatorId)
    local Player = QBCore.Functions.GetPlayer(source)
    local citizenid = Player.PlayerData.citizenid
    local elevatorData = Config.Elevators[elevatorId]

    if not elevatorData.useRestriction then
        cb(true)
        return
    end

    local hasAccess = false

    -- Check jobs
    for _, job in ipairs(elevatorData.restrictedTo.jobs) do
        if Player.PlayerData.job.name == job then
            hasAccess = true
            break
        end
    end

    -- Check items
    if not hasAccess then
        for _, item in ipairs(elevatorData.restrictedTo.items) do
            if Player.Functions.GetItemByName(item) then
                hasAccess = true
                break
            end
        end
    end

    -- Check citizenids
    if not hasAccess then
        for _, id in ipairs(elevatorData.restrictedTo.citizenids) do
            if citizenid == id then
                hasAccess = true
                break
            end
        end
    end

    cb(hasAccess)
end)