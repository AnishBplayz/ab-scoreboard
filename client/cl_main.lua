local QBCore = exports['qb-core']:GetCoreObject()
local shouldDraw = false
local menu = false

RegisterNetEvent('qb-scoreboard:open', function()
    QBCore.Functions.TriggerCallback('qb-scoreboard:CurrentPlayers', function(player)
        exports['qb-menu']:showHeader({
            {
                header = Config.ServerName,
                isMenuHeader = true
            },
            {
                header = "👩🏼‍🤝‍👨🏻Total Players : "..player,
                txt = "",
                params = {
                    event = "",
                },
                isMenuHeader = true
            },
            {
                header = "➡️Jobs ?",
                txt = "",
                params = {
                    event = "qb-scoreboard:jobinfo",
                }
            },
            {
                header = "Close",
                txt = "",
                params = {
                    event = "qb-scoreboard:closeall",
                },
            },
        })
    end)
end)

RegisterNetEvent('qb-scoreboard:jobinfo', function()
    QBCore.Functions.TriggerCallback('qb-scoreboard:CurrentPlayers', function(player,police,ems)
        local text = "❌"
        if police > 0 then
            text = "✅"
        end
        exports['qb-menu']:showHeader({
            {
                header = " Police : "..text,
                txt = "",
                params = {
                    event = "",
                },
                isMenuHeader = true
            },
            {
                header = " Ems : "..ems,
                txt = "",
                params = {
                    event = "",
                },
                isMenuHeader = true
            },
            {
                header = "Close",
                txt = "",
                params = {
                    event = "qb-scoreboard:closeall",
                },
            },
        })
    end)
end)

RegisterNetEvent('qb-scoreboard:closeall', function()
    TriggerEvent("qb-menu:client:closeMenu") 
    shouldDraw = false
    menu = false
end)

RegisterCommand(Config.Command, function()
    menu = not menu
    if not menu then  
        TriggerEvent("qb-menu:client:closeMenu") 
    else
        TriggerEvent("qb-scoreboard:open")
    end
end)

RegisterKeyMapping(Config.Command, 'Open Scoreboard', 'keyboard', Config.Keymapping)

local function DrawText3D(x, y, z, text)
	SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(true)
    AddTextComponentString(text)
    SetDrawOrigin(x,y,z, 0)
    DrawText(0.0, 0.0)
    local factor = (string.len(text)) / 370
    DrawRect(0.0, 0.0+0.0125, 0.017+ factor, 0.03, 0, 0, 0, 75)
    ClearDrawOrigin()
end

local function GetPlayers()
    local players = {}
    for _, player in ipairs(GetActivePlayers()) do
        local ped = GetPlayerPed(player)
        if DoesEntityExist(ped) then
            players[#players+1] = player
        end
    end
    return players
end

local function GetPlayersFromCoords(coords, distance)
    local players = GetPlayers()
    local closePlayers = {}

    if coords == nil then
		coords = GetEntityCoords(PlayerPedId())
    end
    if distance == nil then
        distance = Config.DrawDistance
    end
    for _, player in pairs(players) do
		local target = GetPlayerPed(player)
		local targetCoords = GetEntityCoords(target)
		local targetdistance = #(targetCoords - vector3(coords.x, coords.y, coords.z))
		if targetdistance <= distance then
            closePlayers[#closePlayers+1] = player
		end
    end
    return closePlayers
end

CreateThread(function()
    while true do
        shouldDraw = IsControlPressed(0, Config.Keylist) --For the Drawtext above the Head
        if shouldDraw then
            for _, player in pairs(GetPlayersFromCoords(GetEntityCoords(PlayerPedId()), Config.DrawDistance)) do
                local PlayerId = GetPlayerServerId(player)
                local PlayerPed = GetPlayerPed(player)
                local PlayerCoords = GetEntityCoords(PlayerPed)
                DrawText3D(PlayerCoords.x, PlayerCoords.y, PlayerCoords.z + 1.0, '['..PlayerId..']')
            end
        end
        Wait(5)
    end
end)