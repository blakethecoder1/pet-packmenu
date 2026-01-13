-- =====================================================
-- OFF-GRID MENU - CLIENT SIDE (Native UI Version)
-- =====================================================

print("^2[Off-Grid Menu] Client script loading...^0")

local playerPermissions = {}
local lastRepairTime = 0
local menuOpen = false
local currentMenu = "main"
local menuHistory = {}
local selectedIndex = 1
local logoLoaded = false
local logoTxd = nil
local menuHistory = {}
local selectedIndex = 1

print("^2[Off-Grid Menu] Variables initialized^0")

-- =====================================================
-- PERMISSION CHECK
-- =====================================================

function CheckPermissions()
    playerPermissions = {}
    
    for packKey, packData in pairs(Config.Packs) do
        TriggerServerEvent('offgrid:checkPermission', packData.permission, packKey)
    end
end

RegisterNetEvent('offgrid:permissionResult')
AddEventHandler('offgrid:permissionResult', function(permission, packKey, hasPermission)
    playerPermissions[packKey] = hasPermission
end)

-- =====================================================
-- HELPER FUNCTIONS
-- =====================================================

function HasAnyPack()
    for packKey, hasPerm in pairs(playerPermissions) do
        if hasPerm then
            return true
        end
    end
    return false
end

function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, false)
end

function SpawnVehicle(model, packKey)
    -- Validate on server before spawning
    TriggerServerEvent('offgrid:requestVehicleSpawn', model, packKey)
end

function RepairVehicle()
    local currentTime = GetGameTimer()
    
    -- Check cooldown
    if currentTime - lastRepairTime < Config.RepairCooldown then
        local remaining = math.ceil((Config.RepairCooldown - (currentTime - lastRepairTime)) / 1000)
        ShowNotification("~r~Please wait " .. remaining .. " seconds before repairing again.")
        return
    end
    
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    
    if vehicle == 0 then
        ShowNotification("~r~You must be in a vehicle to repair it.")
        return
    end
    
    -- Repair vehicle
    SetVehicleFixed(vehicle)
    SetVehicleDeformationFixed(vehicle)
    SetVehicleUndriveable(vehicle, false)
    SetVehicleEngineOn(vehicle, true, true)
    
    lastRepairTime = currentTime
    ShowNotification("~g~Vehicle repaired!")
end

function DespawnVehicle()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    
    if vehicle == 0 then
        vehicle = GetVehiclePedIsUsing(ped)
    end
    
    if vehicle == 0 then
        ShowNotification("~r~No vehicle found nearby.")
        return
    end
    
    -- Delete vehicle
    SetEntityAsMissionEntity(vehicle, true, true)
    DeleteVehicle(vehicle)
    ShowNotification("~g~Vehicle despawned.")
end

-- =====================================================
-- LEO TOOLS
-- =====================================================

local spikeStrips = {}
local policeLightsActive = false
local sirenActive = false

function SpawnSpikeStrip()
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    local forward = GetEntityForwardVector(ped)
    
    local spawnCoords = vector3(
        coords.x + forward.x * 3.0,
        coords.y + forward.y * 3.0,
        coords.z - 0.9
    )
    
    local model = `p_ld_stinger_s`
    RequestModel(model)
    while not HasModelLoaded(model) do
        Wait(10)
    end
    
    local spike = CreateObject(model, spawnCoords.x, spawnCoords.y, spawnCoords.z, true, true, true)
    SetEntityHeading(spike, heading)
    PlaceObjectOnGroundProperly(spike)
    FreezeEntityPosition(spike, true)
    
    table.insert(spikeStrips, spike)
    ShowNotification("~g~Spike strip deployed.")
end

function TogglePoliceLights()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    
    if vehicle == 0 then
        ShowNotification("~r~You must be in a vehicle.")
        return
    end
    
    if not IsVehicleEmergencyServicesVehicle(vehicle) then
        ShowNotification("~r~This vehicle doesn't have emergency lights.")
        return
    end
    
    policeLightsActive = not policeLightsActive
    SetVehicleSiren(vehicle, policeLightsActive)
    
    if policeLightsActive then
        ShowNotification("~g~Police lights enabled.")
    else
        ShowNotification("~r~Police lights disabled.")
    end
end

function ToggleSiren()
    local ped = PlayerPedId()
    local vehicle = GetVehiclePedIsIn(ped, false)
    
    if vehicle == 0 then
        ShowNotification("~r~You must be in a vehicle.")
        return
    end
    
    if not IsVehicleEmergencyServicesVehicle(vehicle) then
        ShowNotification("~r~This vehicle doesn't have a siren.")
        return
    end
    
    sirenActive = not sirenActive
    
    if sirenActive then
        SetVehicleHasMutedSirens(vehicle, false)
        ShowNotification("~g~Siren enabled.")
    else
        SetVehicleHasMutedSirens(vehicle, true)
        ShowNotification("~r~Siren disabled.")
    end
end

-- =====================================================
-- NATIVE UI MENU SYSTEM
-- =====================================================

function GetMenuItems()
    if currentMenu == "main" then
        local items = {}
        table.insert(items, {text = "My Packs", action = "menu:packs"})
        if HasAnyPack() then
            table.insert(items, {text = "Utilities", action = "menu:utilities"})
        end
        if playerPermissions.leo then
            table.insert(items, {text = "LEO Tools", action = "menu:leo"})
        end
        table.insert(items, {text = "~r~Close Menu", action = "close"})
        return items
        
    elseif currentMenu == "packs" then
        local items = {}
        local ownedPackCount = 0
        for packKey, packData in pairs(Config.Packs) do
            if playerPermissions[packKey] then
                table.insert(items, {text = packData.name .. " >", action = "menu:pack:" .. packKey, description = packData.description})
                ownedPackCount = ownedPackCount + 1
            end
        end
        if ownedPackCount == 0 then
            table.insert(items, {text = "~r~No Packs Owned", action = "none"})
            table.insert(items, {text = "~o~Configure Discord roles", action = "none"})
        end
        table.insert(items, {text = "~r~← Back", action = "back"})
        return items
        
    elseif currentMenu == "vehicles" then
        local items = {}
        local vehicleCount = 0
        for packKey, packData in pairs(Config.Packs) do
            if playerPermissions[packKey] then
                table.insert(items, {text = packData.name, action = "menu:pack:" .. packKey})
                vehicleCount = vehicleCount + 1
            end
        end
        if vehicleCount == 0 then
            table.insert(items, {text = "No Vehicles Available", action = "none"})
        end
        table.insert(items, {text = "~r~← Back", action = "back"})
        return items
        
    elseif string.sub(currentMenu, 1, 5) == "pack:" then
        local packKey = string.sub(currentMenu, 6)
        local items = {}
        if Config.Packs[packKey] then
            for _, vehicle in ipairs(Config.Packs[packKey].vehicles) do
                table.insert(items, {text = vehicle.name, action = "spawn:" .. vehicle.model .. ":" .. packKey})
            end
        end
        table.insert(items, {text = "~r~← Back", action = "back"})
        return items
        
    elseif currentMenu == "utilities" then
        local items = {}
        table.insert(items, {text = "Repair Vehicle", action = "repair"})
        table.insert(items, {text = "Despawn Vehicle", action = "despawn"})
        table.insert(items, {text = "~r~← Back", action = "back"})
        return items
        
    elseif currentMenu == "leo" then
        local items = {}
        table.insert(items, {text = "Deploy Spike Strip", action = "spike"})
        table.insert(items, {text = "Toggle Police Lights", action = "lights"})
        table.insert(items, {text = "Toggle Siren", action = "siren"})
        table.insert(items, {text = "~r~← Back", action = "back"})
        return items
    end
    
    return {}
end

function HandleMenuAction(action)
    if action == "close" then
        CloseMenu()
    elseif action == "back" then
        GoBack()
    elseif action == "none" then
        -- Do nothing
    elseif string.sub(action, 1, 5) == "menu:" then
        local newMenu = string.sub(action, 6)
        OpenSubMenu(newMenu)
    elseif string.sub(action, 1, 6) == "spawn:" then
        local parts = {}
        for part in string.gmatch(action, "[^:]+") do
            table.insert(parts, part)
        end
        if #parts >= 3 then
            SpawnVehicle(parts[2], parts[3])
            CloseMenu()
        end
    elseif action == "repair" then
        RepairVehicle()
    elseif action == "despawn" then
        DespawnVehicle()
    elseif action == "spike" then
        SpawnSpikeStrip()
    elseif action == "lights" then
        TogglePoliceLights()
    elseif action == "siren" then
        ToggleSiren()
    end
end

function OpenSubMenu(menu)
    table.insert(menuHistory, currentMenu)
    currentMenu = menu
    selectedIndex = 1
end

function GoBack()
    if #menuHistory > 0 then
        currentMenu = table.remove(menuHistory)
        selectedIndex = 1
    else
        CloseMenu()
    end
end

function OpenMenu()
    print("^2[Off-Grid Menu] OpenMenu() function called^0")
    menuOpen = true
    currentMenu = "main"
    menuHistory = {}
    selectedIndex = 1
    SetNuiFocus(false, false)
    print("^2[Off-Grid Menu] Menu opened, menuOpen=" .. tostring(menuOpen) .. "^0")
end

function CloseMenu()
    print("^2[Off-Grid Menu] CloseMenu() function called^0")
    menuOpen = false
    SetNuiFocus(false, false)
    Citizen.Wait(50) -- Small delay before re-enabling controls
    EnableAllControlActions(0)
    print("^2[Off-Grid Menu] Menu closed, menuOpen=" .. tostring(menuOpen) .. "^0")
end

function DrawMenuTitle(title, subtitle)
    local menuWidth = 0.24
    local menuX = 0.145
    
    -- Draw header background with gradient
    DrawRect(menuX, 0.092, menuWidth, 0.002, 220, 20, 20, 255) -- Top accent line (red)
    DrawRect(menuX, 0.120, menuWidth, 0.055, 20, 20, 20, 245) -- Title background (dark) - made taller for logo
    DrawRect(menuX, 0.149, menuWidth, 0.001, 220, 20, 20, 200) -- Bottom accent
    
    -- Draw "OFF-GRID" text (logo style)
    SetTextFont(4)
    SetTextProportional(0)
    SetTextScale(0.55, 0.55)
    SetTextColour(255, 60, 60, 255)
    SetTextCentre(1)
    SetTextEntry("STRING")
    AddTextComponentString("OFF-GRID")
    DrawText(menuX, 0.095)
    
    -- Draw "ROLEPLAY" text below
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(0.28, 0.28)
    SetTextColour(200, 200, 200, 255)
    SetTextCentre(1)
    SetTextEntry("STRING")
    AddTextComponentString("ROLEPLAY")
    DrawText(menuX, 0.128)
    
    -- Draw subtitle banner
    DrawRect(menuX, 0.175, menuWidth, 0.042, 15, 15, 15, 235)
    
    -- Draw subtitle text
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(0.38, 0.38)
    SetTextColour(200, 200, 200, 255)
    SetTextCentre(0)
    SetTextEntry("STRING")
    AddTextComponentString(subtitle)
    DrawText(menuX - (menuWidth / 2) + 0.01, 0.159)
end

function DrawMenuItem(text, index, totalItems, isSelected)
    local menuWidth = 0.24
    local menuX = 0.145
    local itemHeight = 0.042
    local y = 0.209 + (index - 1) * itemHeight -- Updated to match new header size
    
    -- Draw item background
    if isSelected then
        -- Selected item with red gradient
        DrawRect(menuX, y, menuWidth, itemHeight, 220, 30, 30, 255)
        DrawRect(menuX - (menuWidth / 2) + 0.001, y, 0.003, itemHeight, 255, 60, 60, 255) -- Red accent bar
    else
        -- Unselected item
        DrawRect(menuX, y, menuWidth, itemHeight, 25, 25, 25, 230)
    end
    
    -- Draw text with better styling
    SetTextFont(0)
    SetTextProportional(0)
    SetTextScale(0.38, 0.38)
    if isSelected then
        SetTextColour(255, 255, 255, 255) -- White text when selected
    else
        SetTextColour(200, 200, 200, 255) -- Gray text normally
    end
    SetTextCentre(0)
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(menuX - (menuWidth / 2) + 0.012, y - 0.0155)
    
    -- Draw right arrow for submenus
    if string.find(text, ">") then
        SetTextFont(0)
        SetTextProportional(0)
        SetTextScale(0.4, 0.4)
        if isSelected then
            SetTextColour(255, 60, 60, 255) -- Red arrow when selected
        else
            SetTextColour(150, 150, 150, 255) -- Gray arrow
        end
        SetTextCentre(0)
        SetTextRightJustify(1)
        SetTextWrap(0.0, menuX + (menuWidth / 2) - 0.01)
        SetTextEntry("STRING")
        AddTextComponentString(">")
        DrawText(0, y - 0.0155)
    end
end

-- =====================================================
-- VEHICLE SPAWN HANDLER
-- =====================================================

RegisterNetEvent('offgrid:spawnVehicle')
AddEventHandler('offgrid:spawnVehicle', function(model)
    local modelHash = GetHashKey(model)
    
    RequestModel(modelHash)
    local timeout = 0
    while not HasModelLoaded(modelHash) and timeout < 5000 do
        Wait(10)
        timeout = timeout + 10
    end
    
    if not HasModelLoaded(modelHash) then
        ShowNotification("~r~Failed to load vehicle model.")
        return
    end
    
    local ped = PlayerPedId()
    local coords = GetEntityCoords(ped)
    local heading = GetEntityHeading(ped)
    
    -- Calculate spawn position
    local spawnCoords = coords
    if Config.SpawnInFrontOfPlayer then
        local forward = GetEntityForwardVector(ped)
        spawnCoords = vector3(
            coords.x + forward.x * Config.SpawnDistance,
            coords.y + forward.y * Config.SpawnDistance,
            coords.z
        )
    end
    
    -- Create vehicle
    local vehicle = CreateVehicle(modelHash, spawnCoords.x, spawnCoords.y, spawnCoords.z, heading, true, false)
    
    -- Set player into vehicle
    SetPedIntoVehicle(ped, vehicle, -1)
    SetVehicleEngineOn(vehicle, true, true)
    
    SetModelAsNoLongerNeeded(modelHash)
    ShowNotification("~g~Vehicle spawned!")
end)

-- =====================================================
-- MAIN THREADS
-- =====================================================

Citizen.CreateThread(function()
    print("^2[Off-Grid Menu] Permission check thread started^0")
    CheckPermissions()
end)

-- Menu control and input thread
Citizen.CreateThread(function()
    print("^2[Off-Grid Menu] Input control thread started^0")
    
    while true do
        Citizen.Wait(0) -- MUST be 0 for proper control detection
        
        -- Force-enable M key every frame (needed if other scripts are blocking it)
        EnableControlAction(0, 244, true)
        
        if menuOpen then
            local items = GetMenuItems()
            
            -- Disable controls while menu is open (MUST be every frame)
            DisableAllControlActions(0)
            EnableControlAction(0, 1, true) -- Look Left/Right
            EnableControlAction(0, 2, true) -- Look Up/Down
            EnableControlAction(0, 172, true) -- Up
            EnableControlAction(0, 173, true) -- Down
            EnableControlAction(0, 191, true) -- Enter
            EnableControlAction(0, 201, true) -- Select
            EnableControlAction(0, 194, true) -- Backspace
            EnableControlAction(0, 202, true) -- Back
            EnableControlAction(0, 244, true) -- M key to close menu
            
            -- Handle navigation with better input detection
            if IsControlJustPressed(0, 172) or IsDisabledControlJustPressed(0, 172) then -- Up arrow
                PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
                selectedIndex = selectedIndex - 1
                if selectedIndex < 1 then
                    selectedIndex = #items
                end
                Citizen.Wait(150)
            end
            
            if IsControlJustPressed(0, 173) or IsDisabledControlJustPressed(0, 173) then -- Down arrow
                PlaySoundFrontend(-1, "NAV_UP_DOWN", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
                selectedIndex = selectedIndex + 1
                if selectedIndex > #items then
                    selectedIndex = 1
                end
                Citizen.Wait(150)
            end
            
            if IsControlJustPressed(0, 191) or IsControlJustPressed(0, 201) or IsDisabledControlJustPressed(0, 191) then -- Enter or Select
                if items[selectedIndex] then
                    PlaySoundFrontend(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
                    HandleMenuAction(items[selectedIndex].action)
                end
                Citizen.Wait(200)
            end
            
            if IsControlJustPressed(0, 194) or IsControlJustPressed(0, 202) or IsDisabledControlJustPressed(0, 194) then -- Backspace
                PlaySoundFrontend(-1, "BACK", "HUD_FRONTEND_DEFAULT_SOUNDSET", true)
                GoBack()
                Citizen.Wait(200)
            end
            
            -- Check for M key to close menu
            if IsControlJustPressed(0, 244) or IsDisabledControlJustPressed(0, 244) then
                print("^3[Off-Grid Menu] M key pressed (closing)^0")
                CloseMenu()
                Citizen.Wait(200)
            end
        else
            -- Check for M key to open menu (when menu is closed)
            if IsControlJustPressed(0, 244) or IsDisabledControlJustPressed(0, 244) then
                print("^3[Off-Grid Menu] M key pressed (opening)^0")
                OpenMenu()
                Citizen.Wait(200)
            else
                Citizen.Wait(200)
            end
        end
    end
end)

-- Menu rendering thread (separate for smooth drawing)
Citizen.CreateThread(function()
    print("^2[Off-Grid Menu] Rendering thread started^0")
    while true do
        Citizen.Wait(0) -- Must be 0 for every frame rendering
        
        if menuOpen then
            local items = GetMenuItems()
            
            if #items == 0 then
                print("^1[Off-Grid Menu] WARNING: No menu items found!^0")
            end
            
            -- Get subtitle based on current menu
            local subtitle = ""
            if currentMenu == "packs" then 
                subtitle = "Your owned packs"
            elseif currentMenu == "vehicles" then 
                subtitle = "Select a pack"
            elseif currentMenu == "utilities" then 
                subtitle = "Vehicle utilities"
            elseif currentMenu == "leo" then 
                subtitle = "Law enforcement tools"
            elseif string.sub(currentMenu, 1, 5) == "pack:" then 
                subtitle = "Select a vehicle"
            end
            
            -- Draw menu title
            DrawMenuTitle(Config.MenuTitle, subtitle)
            
            -- Draw menu items
            for i, item in ipairs(items) do
                DrawMenuItem(item.text, i, #items, i == selectedIndex)
            end
            
            -- Draw footer with controls
            local menuWidth = 0.24
            local menuX = 0.145
            local footerY = 0.209 + (#items * 0.042) + 0.021 -- Updated to match new item position
            
            DrawRect(menuX, footerY - 0.001, menuWidth, 0.001, 220, 20, 20, 200)
            DrawRect(menuX, footerY + 0.02, menuWidth, 0.042, 15, 15, 15, 235)
            
            SetTextFont(0)
            SetTextProportional(0)
            SetTextScale(0.3, 0.3)
            SetTextColour(180, 180, 180, 255)
            SetTextCentre(1)
            SetTextEntry("STRING")
            AddTextComponentString("~r~ENTER~w~ Select  ~r~|~w~  ~r~BACKSPACE~w~ Back")
            DrawText(menuX, footerY + 0.006)
        end
    end
end)

-- Refresh permissions periodically
Citizen.CreateThread(function()
    while true do
        Wait(60000)
        CheckPermissions()
    end
end)

-- Debug command to manually open menu (keep for convenience)
RegisterCommand('openmenu', function()
    print("^3[Off-Grid Menu] Manual menu open command executed^0")
    if menuOpen then
        CloseMenu()
    else
        OpenMenu()
    end
end, false)

-- M key is now handled in the main control thread above
-- No RegisterKeyMapping needed to avoid control conflicts

RegisterCommand('testdraw', function()
    print("^3[Off-Grid Menu] Testing draw functions^0")
    Citizen.CreateThread(function()
        for i = 1, 100 do
            Citizen.Wait(0)
            DrawRect(0.5, 0.5, 0.2, 0.1, 255, 0, 0, 255)
            SetTextFont(0)
            SetTextProportional(0)
            SetTextScale(0.5, 0.5)
            SetTextColour(255, 255, 255, 255)
            SetTextEntry("STRING")
            AddTextComponentString("TEST MENU")
            DrawText(0.45, 0.48)
        end
    end)
end, false)
