local QBCore = exports['qb-core']:GetCoreObject()

-- Debug fonksiyonu
local function DebugPrint(message)
    print("^2[666cg-Depo Debug Server] ^7" .. message)
end

-- Discord Webhook URL'leri (config'den alınıyor)
local webhookURL = {
    personal = Config.Logs.PersonalStorage,
    job = Config.Logs.JobStorage
}

-- Discord Webhook ile mesaj gönderme fonksiyonu
local function SendDiscordLog(webhookType, title, description, color, fields)
    -- Eğer log özelliği kapalıysa çık
    if not Config.Logs.Enable then return end
    
    local webhook = webhookURL[webhookType] or webhookURL.personal
    
    -- Webhook URL kontrolü
    if webhook == "" or webhook == nil then 
        DebugPrint("Webhook URL bulunamadı. Lütfen config.lua dosyasındaki URL'leri kontrol edin.")
        return 
    end
    
    -- Default renk: mavi
    if not color then color = 3447003 end
    
    local embed = {
        {
            ["title"] = title,
            ["description"] = description,
            ["type"] = "rich",
            ["color"] = color,
            ["footer"] = {
                ["text"] = "666cg Depo Sistemi | " .. os.date("%d/%m/%Y %H:%M:%S")
            },
            ["fields"] = fields
        }
    }
    
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({
        username = "Depo Logs",
        embeds = embed
    }), { ['Content-Type'] = 'application/json' })
end

-- Item değişikliği logu
local function LogItemChange(source, storageId, storageType, actionType, itemName, count)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    local playerName = Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname
    local playerJob = Player.PlayerData.job.name
    local playerID = Player.PlayerData.citizenid
    
    local title = ""
    local description = ""
    local color = 0
    
    if actionType == "add" then
        title = "Depoya Eşya Eklendi"
        description = playerName .. " (" .. playerID .. ") adlı oyuncu depoya eşya ekledi."
        color = 65280 -- Yeşil
    elseif actionType == "remove" then
        title = "Depodan Eşya Alındı"
        description = playerName .. " (" .. playerID .. ") adlı oyuncu depodan eşya aldı."
        color = 16711680 -- Kırmızı
    end
    
    local fields = {
        {
            ["name"] = "Oyuncu Bilgisi",
            ["value"] = "İsim: " .. playerName .. "\nID: " .. playerID .. "\nMeslek: " .. playerJob,
            ["inline"] = true
        },
        {
            ["name"] = "Depo Bilgisi",
            ["value"] = "Depo ID: " .. storageId .. "\nTür: " .. (storageType == "personal" and "Kişisel Depo" or "Meslek Deposu"),
            ["inline"] = true
        },
        {
            ["name"] = "Eşya Bilgisi",
            ["value"] = "Eşya: " .. itemName .. "\nMiktar: " .. count,
            ["inline"] = true
        }
    }
    
    SendDiscordLog(storageType, title, description, color, fields)
    DebugPrint("Item log gönderildi: " .. itemName .. " x" .. count .. " - " .. actionType)
end

-- Depo açma logu
local function LogStorageOpen(source, storageId, storageType, storageName)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then return end
    
    local playerName = Player.PlayerData.charinfo.firstname .. " " .. Player.PlayerData.charinfo.lastname
    local playerJob = Player.PlayerData.job.name
    local playerID = Player.PlayerData.citizenid
    
    local title = "Depo Açıldı"
    local description = playerName .. " (" .. playerID .. ") adlı oyuncu bir depo açtı."
    local color = 3447003 -- Mavi
    
    local fields = {
        {
            ["name"] = "Oyuncu Bilgisi",
            ["value"] = "İsim: " .. playerName .. "\nID: " .. playerID .. "\nMeslek: " .. playerJob,
            ["inline"] = true
        },
        {
            ["name"] = "Depo Bilgisi",
            ["value"] = "Depo Adı: " .. storageName .. "\nDepo ID: " .. storageId .. "\nTür: " .. (storageType == "personal" and "Kişisel Depo" or "Meslek Deposu"),
            ["inline"] = true
        }
    }
    
    SendDiscordLog(storageType, title, description, color, fields)
    DebugPrint("Depo açma logu gönderildi: " .. storageName)
end

-- Depo ID'sine göre tür belirleme
local function GetStorageTypeFromId(stashId)
    if string.find(stashId, "personal_") then
        return "personal"
    elseif string.find(stashId, "job_") then
        return "job"
    else
        return "personal" -- Varsayılan
    end
end

-- Stash ID'sini temizle
local function CleanStashId(stashId)
    if string.find(stashId, "personal_") then
        return string.sub(stashId, 10) -- "personal_" kısmını kaldır
    elseif string.find(stashId, "job_") then
        return string.sub(stashId, 5) -- "job_" kısmını kaldır
    else
        return stashId
    end
end

-- Ox Inventory kontrol et
local isOxInventoryReady = false
CreateThread(function()
    Wait(1000)
    isOxInventoryReady = GetResourceState('ox_inventory') == 'started'
    DebugPrint("ox_inventory durumu: " .. (isOxInventoryReady and "Hazır" or "Bulunamadı"))
    
    if isOxInventoryReady then
        -- Stash oluşturma işlemleri (server tarafında ox_inventory stash registrasyonu)
        DebugPrint("Stash sistemine hazırlanılıyor...")
        
        -- ox_inventory eventlerine abone ol (item logları için)
        
        -- Eşya ekleme eventi 
        AddEventHandler('ox_inventory:addItem', function(source, item, count, metadata, slot, inventory)
            if not source or source == 0 then return end -- NPC veya sistem tarafından eklendiyse yoksay
            if not inventory or not inventory.id then return end
            
            -- Depo ID'sine göre işlem yap
            if inventory.type == 'stash' then
                local stashId = inventory.id
                local storageType = GetStorageTypeFromId(stashId)
                local cleanStashId = CleanStashId(stashId)
                
                DebugPrint("Eşya ekleme tespit edildi: " .. item.name .. " x" .. count .. " > " .. stashId)
                LogItemChange(source, cleanStashId, storageType, "add", item.name, count)
            end
        end)
        
        -- Eşya çıkarma eventi
        AddEventHandler('ox_inventory:removeItem', function(source, item, count, metadata, slot, inventory)
            if not source or source == 0 then return end -- NPC veya sistem tarafından çıkarıldıysa yoksay
            if not inventory or not inventory.id then return end
            
            -- Depo ID'sine göre işlem yap
            if inventory.type == 'stash' then
                local stashId = inventory.id
                local storageType = GetStorageTypeFromId(stashId)
                local cleanStashId = CleanStashId(stashId)
                
                DebugPrint("Eşya çıkarma tespit edildi: " .. item.name .. " x" .. count .. " < " .. stashId)
                LogItemChange(source, cleanStashId, storageType, "remove", item.name, count)
            end
        end)
        
        -- Alternatif event dinleme - swap
        AddEventHandler('ox_inventory:swapItems', function(source, fromInventory, toInventory, fromSlot, toSlot)
            if not source or source == 0 then return end
            if not fromInventory or not toInventory then return end
            
            -- Stashten oyuncuya veya oyuncudan stashe eşya taşıma
            if fromInventory.type == 'stash' and toInventory.type == 'player' then
                -- Stashten oyuncuya (eşya alma)
                local stashId = fromInventory.id
                local storageType = GetStorageTypeFromId(stashId)
                local cleanStashId = CleanStashId(stashId)
                local item = fromInventory.items[fromSlot]
                
                if item then
                    DebugPrint("Swap: Stashten eşya alma tespit edildi: " .. item.name .. " x" .. item.count .. " < " .. stashId)
                    LogItemChange(source, cleanStashId, storageType, "remove", item.name, item.count)
                end
                
            elseif fromInventory.type == 'player' and toInventory.type == 'stash' then
                -- Oyuncudan stashe (eşya koyma)
                local stashId = toInventory.id
                local storageType = GetStorageTypeFromId(stashId)
                local cleanStashId = CleanStashId(stashId)
                local item = fromInventory.items[fromSlot]
                
                if item then
                    DebugPrint("Swap: Stashe eşya koyma tespit edildi: " .. item.name .. " x" .. item.count .. " > " .. stashId)
                    LogItemChange(source, cleanStashId, storageType, "add", item.name, item.count)
                end
            end
        end)
    end
end)

-- Open personal storage
QBCore.Functions.CreateCallback('666cg-storage:server:GetPersonalStorage', function(source, cb, storageId)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then
        DebugPrint("Oyuncu bulunamadı")
        cb(false)
        return
    end
    
    local identifier = Player.PlayerData.citizenid .. '_' .. storageId
    DebugPrint("Kişisel depo açılıyor: " .. identifier)
    
    -- ox_inventory stash oluşturmayı deneyelim (eğer daha önce oluşturulmadıysa)
    if isOxInventoryReady then
        local personalStorage = Config.PersonalStorages[storageId]
        if not personalStorage then
            DebugPrint("HATA: Config içinde bu storage ID bulunamadı: " .. storageId)
            cb(false)
            return
        end
        
        local stashId = 'personal_' .. identifier
        DebugPrint("Server: Stash ID oluşturuluyor: " .. stashId)
        
        -- ox_inventory stash yaratma/tanımlama
        exports.ox_inventory:RegisterStash(stashId, personalStorage.name, personalStorage.size, personalStorage.weight, true)
        DebugPrint("ox_inventory RegisterStash çağrıldı: " .. stashId)
        
        -- Depo açma logu
        LogStorageOpen(source, identifier, "personal", personalStorage.name)
    end
    
    -- Boş bir dizi döndür, ox_inventory kendi veritabanını kullanacak
    cb({})
end)

-- Save personal storage (artık gereksiz çünkü ox_inventory otomatik kaydediyor)
RegisterNetEvent('666cg-storage:server:SavePersonalStorage', function(storageId, items)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then 
        DebugPrint("Oyuncu bulunamadı, kayıt yapılamadı")
        return 
    end
    
    local identifier = Player.PlayerData.citizenid .. '_' .. storageId
    DebugPrint("Kişisel depo kaydediliyor: " .. identifier)
    
    -- ox_inventory kendi verilerini saklıyor, manuel bir şey yapmaya gerek yok
    DebugPrint("Kişisel depo başarıyla kaydedildi (ox_inventory tarafından): " .. identifier)
end)

-- Open job storage
QBCore.Functions.CreateCallback('666cg-storage:server:GetJobStorage', function(source, cb, jobName)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then
        DebugPrint("Oyuncu bulunamadı")
        cb(false)
        return
    end
    
    -- Check if player has the required job
    local jobConfig = Config.JobStorages[jobName]
    local hasAccess = false
    
    if jobConfig and jobConfig.jobs then
        for _, job in pairs(jobConfig.jobs) do
            if Player.PlayerData.job.name == job then
                hasAccess = true
                break
            end
        end
    end
    
    if not hasAccess then
        DebugPrint("Oyuncu meslek deposuna erişim izni yok: " .. Player.PlayerData.name)
        TriggerClientEvent('QBCore:Notify', src, "Bu depoya erişim izniniz yok", 'error')
        cb(false)
        return
    end
    
    local identifier = 'job_' .. jobName
    DebugPrint("Meslek deposu açılıyor: " .. identifier)
    
    -- ox_inventory stash oluşturmayı deneyelim (eğer daha önce oluşturulmadıysa)
    if isOxInventoryReady then
        local stashId = 'job_' .. jobName
        DebugPrint("Server: Job Stash ID oluşturuluyor: " .. stashId)
        
        -- ox_inventory stash yaratma/tanımlama
        exports.ox_inventory:RegisterStash(stashId, jobConfig.name, jobConfig.size, jobConfig.weight, true)
        DebugPrint("ox_inventory RegisterStash çağrıldı: " .. stashId)
        
        -- Depo açma logu
        LogStorageOpen(source, jobName, "job", jobConfig.name)
    end
    
    -- Boş bir dizi döndür, ox_inventory kendi veritabanını kullanacak
    cb({})
end)

-- Save job storage (artık gereksiz çünkü ox_inventory otomatik kaydediyor)
RegisterNetEvent('666cg-storage:server:SaveJobStorage', function(jobName, items)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    
    if not Player then 
        DebugPrint("Oyuncu bulunamadı, kayıt yapılamadı")
        return 
    end
    
    -- Check if player has the required job
    local jobConfig = Config.JobStorages[jobName]
    local hasAccess = false
    
    if jobConfig and jobConfig.jobs then
        for _, job in pairs(jobConfig.jobs) do
            if Player.PlayerData.job.name == job then
                hasAccess = true
                break
            end
        end
    end
    
    if not hasAccess then 
        DebugPrint("Oyuncu meslek deposuna erişim izni yok: " .. Player.PlayerData.name)
        return 
    end
    
    local identifier = 'job_' .. jobName
    DebugPrint("Meslek deposu kaydediliyor: " .. identifier)
    
    -- ox_inventory kendi verilerini saklıyor, manuel bir şey yapmaya gerek yok
    DebugPrint("Meslek deposu başarıyla kaydedildi (ox_inventory tarafından): " .. identifier)
end) 