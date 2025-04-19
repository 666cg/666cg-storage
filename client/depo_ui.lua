local QBCore = exports['qb-core']:GetCoreObject()

-- UI değişkenleri
local isDepoUIOpen = false
local allowedDiscordIds = {
    "712579734332112896", -- Buraya izin verdiğiniz Discord ID'leri ekleyin
}

-- Discord ID kontrolü
local function HasPermission()
    local discordId = nil
    for _, id in ipairs(GetPlayerIdentifiers(PlayerId())) do
        if string.find(id, "discord:") then
            discordId = string.gsub(id, "discord:", "")
            break
        end
    end
    
    if not discordId then return false end
    
    for _, allowedId in ipairs(allowedDiscordIds) do
        if discordId == allowedId then
            return true
        end
    end
    
    return false
end

-- UI oluşturma
local function CreateDepoUI()
    if not HasPermission() then
        QBCore.Functions.Notify("Bu komutu kullanma yetkiniz yok!", "error")
        return
    end

    if isDepoUIOpen then return end
    isDepoUIOpen = true

    SetNuiFocus(true, true)
    SendNUIMessage({
        action = "openDepoUI",
        personalStorages = Config.PersonalStorages,
        jobStorages = Config.JobStorages
    })
end

-- NUI Callback'leri
RegisterNUICallback('closeUI', function(_, cb)
    isDepoUIOpen = false
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('getStorageInfo', function(data, cb)
    local storageType = data.type
    local storageId = data.id
    
    if storageType == "personal" then
        local storage = Config.PersonalStorages[storageId]
        if storage then
            cb({
                name = storage.name,
                size = storage.size,
                weight = storage.weight,
                coords = storage.coords
            })
        end
    elseif storageType == "job" then
        local storage = Config.JobStorages[storageId]
        if storage then
            cb({
                name = storage.name,
                size = storage.size,
                weight = storage.weight,
                coords = storage.coords,
                jobs = storage.jobs
            })
        end
    end
end)

-- Komut kaydı
RegisterCommand('depolar', function()
    CreateDepoUI()
end, false) 