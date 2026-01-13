-- =====================================================
-- OFF-GRID MENU - SERVER SIDE
-- =====================================================
-- All permission checks and vehicle spawning must be
-- validated server-side to prevent cheating.
-- =====================================================

-- =====================================================
-- DISCORD ROLE CHECKING
-- =====================================================

function GetDiscordRoles(source)
    local identifiers = GetPlayerIdentifiers(source)
    local discordId = nil
    
    for _, id in pairs(identifiers) do
        if string.match(id, "discord:") then
            discordId = string.gsub(id, "discord:", "")
            break
        end
    end
    
    if not discordId then
        print("[Off-Grid Menu] No Discord ID found for player " .. source)
        return {}
    end
    
    print("[Off-Grid Menu] Discord ID for player " .. source .. ": " .. discordId)
    
    -- Try multiple Discord API exports (compatible with most frameworks)
    local roles = {}
    
    -- Try badger_discord_api
    if GetResourceState('badger_discord_api') == 'started' then
        roles = exports.badger_discord_api:GetDiscordRoles(source) or {}
        print("[Off-Grid Menu] Badger returned " .. #roles .. " roles for player " .. source)
        for i, role in pairs(roles) do
            print("[Off-Grid Menu]   Role #" .. i .. ": " .. tostring(role))
        end
    -- Try discord-roles
    elseif GetResourceState('discord-roles') == 'started' then
        roles = exports['discord-roles']:GetRoles(source) or {}
    -- Try discord_perms
    elseif GetResourceState('discord_perms') == 'started' then
        roles = exports.discord_perms:GetRoles(source) or {}
    end
    
    return roles
end

function HasDiscordRole(source, roleId)
    if not roleId or roleId == "1234567890123456789" then
        print("[Off-Grid Menu] WARNING: Pack uses default Discord role ID. Please configure proper role IDs in config.lua")
        return false
    end
    
    local roles = GetDiscordRoles(source)
    
    print("[Off-Grid Menu] Checking if player " .. source .. " has role: " .. tostring(roleId))
    
    for _, role in pairs(roles) do
        if tostring(role) == tostring(roleId) then
            print("[Off-Grid Menu] MATCH! Player has role " .. tostring(roleId))
            return true
        end
    end
    
    print("[Off-Grid Menu] NO MATCH for role " .. tostring(roleId))
    return false
end

-- =====================================================
-- PERMISSION VALIDATION
-- =====================================================

RegisterNetEvent('offgrid:checkPermission')
AddEventHandler('offgrid:checkPermission', function(permission, packKey)
    local source = source
    local hasPermission = false
    
    if not Config.Packs[packKey] then
        TriggerClientEvent('offgrid:permissionResult', source, permission, packKey, false)
        return
    end
    
    local pack = Config.Packs[packKey]
    
    -- Check Discord roles if enabled
    if Config.UseDiscordRoles then
        if pack.discordRole then
            hasPermission = HasDiscordRole(source, pack.discordRole)
        end
    else
        -- Fall back to ACE permissions
        hasPermission = IsPlayerAceAllowed(source, permission)
    end
    
    -- Send result back to client
    TriggerClientEvent('offgrid:permissionResult', source, permission, packKey, hasPermission)
    
    -- Log for debugging (optional)
    print(("[Off-Grid Menu] Player %d checked permission '%s' for pack '%s': %s"):format(
        source, permission, packKey, hasPermission and "GRANTED" or "DENIED"
    ))
end)

-- =====================================================
-- VEHICLE SPAWN VALIDATION
-- =====================================================

RegisterNetEvent('offgrid:requestVehicleSpawn')
AddEventHandler('offgrid:requestVehicleSpawn', function(model, packKey)
    local source = source
    
    -- Validate pack exists
    if not Config.Packs[packKey] then
        print(("[Off-Grid Menu] Player %d attempted to spawn vehicle from invalid pack: %s"):format(source, packKey))
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            multiline = true,
            args = {"Off-Grid Menu", "Invalid pack."}
        })
        return
    end
    
    local pack = Config.Packs[packKey]
    
    -- Check permission server-side (CRITICAL SECURITY CHECK)
    local hasPermission = false
    
    if Config.UseDiscordRoles then
        if pack.discordRole then
            hasPermission = HasDiscordRole(source, pack.discordRole)
        end
    else
        hasPermission = IsPlayerAceAllowed(source, pack.permission)
    end
    
    if not hasPermission then
        print(("[Off-Grid Menu] Player %d attempted to spawn vehicle without permission: %s"):format(source, pack.permission))
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            multiline = true,
            args = {"Off-Grid Menu", "You don't have permission to spawn this vehicle."}
        })
        return
    end
    
    -- Validate vehicle exists in pack
    local vehicleValid = false
    for _, vehicle in ipairs(pack.vehicles) do
        if vehicle.model == model then
            vehicleValid = true
            break
        end
    end
    
    if not vehicleValid then
        print(("[Off-Grid Menu] Player %d attempted to spawn invalid vehicle: %s from pack %s"):format(source, model, packKey))
        TriggerClientEvent('chat:addMessage', source, {
            color = {255, 0, 0},
            multiline = true,
            args = {"Off-Grid Menu", "Invalid vehicle."}
        })
        return
    end
    
    -- All checks passed, spawn vehicle
    TriggerClientEvent('offgrid:spawnVehicle', source, model)
    
    -- Log spawn
    print(("[Off-Grid Menu] Player %d spawned vehicle '%s' from pack '%s'"):format(source, model, packKey))
end)

-- =====================================================
-- ADMIN COMMANDS (Optional)
-- =====================================================
-- These commands can help with testing and debugging

RegisterCommand('offgrid:debug', function(source, args)
    if source == 0 then
        -- Console command
        print("=== Off-Grid Menu Debug Info ===")
        for packKey, packData in pairs(Config.Packs) do
            print(("Pack: %s | Permission: %s | Vehicles: %d"):format(
                packData.name, packData.permission, #packData.vehicles
            ))
        end
    else
        -- Player command - check if admin
        if IsPlayerAceAllowed(source, "command.offgrid") then
            print(("=== Off-Grid Debug for Player %d ==="):format(source))
            for packKey, packData in pairs(Config.Packs) do
                local hasPermission = IsPlayerAceAllowed(source, packData.permission)
                print(("Pack: %s | Permission: %s | Has Access: %s"):format(
                    packData.name, packData.permission, hasPermission and "YES" or "NO"
                ))
            end
        end
    end
end, false)

-- =====================================================
-- SERVER STARTUP
-- =====================================================

Citizen.CreateThread(function()
    print("^2============================================^0")
    print("^2Off-Grid Menu System Started^0")
    print("^3Loaded Packs:^0")
    for packKey, packData in pairs(Config.Packs) do
        print(("  - %s (%d vehicles)"):format(packData.name, #packData.vehicles))
    end
    print("^2============================================^0")
end)
