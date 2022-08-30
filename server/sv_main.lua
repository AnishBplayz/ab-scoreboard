local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback('qb-scoreboard:CurrentPlayers', function(source, cb)
    local TotalPlayers = 0
    local PoliceCount = 0
    local AmbulanceCount = 0
    for k, v in pairs(QBCore.Functions.GetPlayers()) do
        local Player = QBCore.Functions.GetPlayer(v)
        TotalPlayers = TotalPlayers + 1

        if Player.PlayerData.job.name == "police" then
            PoliceCount = PoliceCount + 1
        end

        if Player.PlayerData.job.name == "ambulance" then
            AmbulanceCount = AmbulanceCount + 1
        end
    end
    cb(TotalPlayers, PoliceCount, AmbulanceCount)
end)