local QBCore = exports['qb-core']:GetCoreObject()
local nearStorage = nil
local nearStorageType = nil
local nearStorageId = nil
local showingUI = false

-- UI Gösterme Fonksiyonu
local function ShowStorageUI(text)
    if showingUI then return end
    
    showingUI = true
    SendNUIMessage({
        type = "showUI",
        text = text
    })
end

-- UI Gizleme Fonksiyonu
local function HideStorageUI()
    if not showingUI then return end
    
    showingUI = false
    SendNUIMessage({
        type = "hideUI"
    })
end

-- Debug fonksiyonu
local function DebugPrint(message)
    print("^2[666cg-Depo Debug] ^7" .. message)
end

-- ox_inventory kullanılabilirliğini kontrol et
local function IsOxInventoryAvailable()
    local state = GetResourceState('ox_inventory')
    DebugPrint("ox_inventory durumu: " .. state)
    return state == 'started'
end

-- Kişisel depo açma fonksiyonu
local function OpenPersonalStorage(storageId)
    local personalStorage = Config.PersonalStorages[storageId]
    if not personalStorage then return end
    
    DebugPrint("Kişisel depo açılmaya çalışılıyor: " .. personalStorage.name)
    
    QBCore.Functions.TriggerCallback('666cg-storage:server:GetPersonalStorage', function(items)
        if items ~= false then
            QBCore.Functions.Notify("Depo açıldı", "success")
            
            -- ox_inventory ile envanteri açma
            local citizenid = QBCore.Functions.GetPlayerData().citizenid
            local stashId = 'personal_' .. citizenid .. '_' .. storageId
            
            DebugPrint("Stash ID: " .. stashId)
            DebugPrint("Depo boyutu: " .. personalStorage.size)
            DebugPrint("Depo ağırlığı: " .. personalStorage.weight)
            
            if IsOxInventoryAvailable() then
                -- ox_inventory farklı yollar deniyoruz
                local success = false
                
                -- Yöntem 1
                DebugPrint("ox_inventory açma yöntemi 1 deneniyor")
                success = exports.ox_inventory:openInventory('stash', {
                    id = stashId,
                    name = personalStorage.name,
                    slots = personalStorage.size,
                    weight = personalStorage.weight
                })
                
                -- Yöntem 2 (yöntem 1 başarısız olursa)
                if not success then
                    DebugPrint("ox_inventory açma yöntemi 2 deneniyor")
                    exports.ox_inventory:openStash({
                        id = stashId,
                        name = personalStorage.name,
                        slots = personalStorage.size,
                        weight = personalStorage.weight
                    })
                end
                
                -- Yöntem 3 (diğerleri başarısız olursa)
                if not success then
                    DebugPrint("ox_inventory açma yöntemi 3 deneniyor")
                    TriggerServerEvent('ox_inventory:openInventory', 'stash', {
                        id = stashId,
                        name = personalStorage.name,
                        slots = personalStorage.size,
                        weight = personalStorage.weight
                    })
                end
                
                -- Depo kapanınca kaydet (ox_inventory eventleri yeniden tanımlıyoruz)
                RegisterNetEvent('ox_inventory:closed')
                AddEventHandler('ox_inventory:closed', function(data)
                    if data and data.type == 'stash' and data.id == stashId then
                        DebugPrint("Depo kapandı, kayıt yapılıyor: " .. stashId)
                        TriggerServerEvent('666cg-storage:server:SavePersonalStorage', storageId, exports.ox_inventory:GetInventoryItems(stashId))
                    end
                end)
            else
                DebugPrint("HATA: ox_inventory bulunamadı!")
                QBCore.Functions.Notify("Depo sisteminde hata! (ox_inventory bulunamadı)", "error")
            end
        else
            QBCore.Functions.Notify("Depo bulunamadı", "error")
        end
    end, storageId)
end

-- Meslek deposu açma fonksiyonu
local function OpenJobStorage(jobName)
    local jobStorage = Config.JobStorages[jobName]
    if not jobStorage then return end
    
    DebugPrint("Meslek deposu açılmaya çalışılıyor: " .. jobStorage.name)
    
    QBCore.Functions.TriggerCallback('666cg-storage:server:GetJobStorage', function(items)
        if items ~= false then
            QBCore.Functions.Notify("Depo açıldı", "success")
            
            -- ox_inventory ile envanteri açma
            local stashId = 'job_' .. jobName
            
            DebugPrint("Stash ID: " .. stashId)
            DebugPrint("Depo boyutu: " .. jobStorage.size)
            DebugPrint("Depo ağırlığı: " .. jobStorage.weight)
            
            if IsOxInventoryAvailable() then
                -- ox_inventory farklı yollar deniyoruz
                local success = false
                
                -- Yöntem 1
                DebugPrint("ox_inventory açma yöntemi 1 deneniyor")
                success = exports.ox_inventory:openInventory('stash', {
                    id = stashId,
                    name = jobStorage.name,
                    slots = jobStorage.size,
                    weight = jobStorage.weight
                })
                
                -- Yöntem 2 (yöntem 1 başarısız olursa)
                if not success then
                    DebugPrint("ox_inventory açma yöntemi 2 deneniyor")
                    exports.ox_inventory:openStash({
                        id = stashId,
                        name = jobStorage.name,
                        slots = jobStorage.size,
                        weight = jobStorage.weight
                    })
                end
                
                -- Yöntem 3 (diğerleri başarısız olursa)
                if not success then
                    DebugPrint("ox_inventory açma yöntemi 3 deneniyor")
                    TriggerServerEvent('ox_inventory:openInventory', 'stash', {
                        id = stashId,
                        name = jobStorage.name,
                        slots = jobStorage.size,
                        weight = jobStorage.weight
                    })
                end
                
                -- Depo kapanınca kaydet (ox_inventory eventleri yeniden tanımlıyoruz)
                RegisterNetEvent('ox_inventory:closed')
                AddEventHandler('ox_inventory:closed', function(data)
                    if data and data.type == 'stash' and data.id == stashId then
                        DebugPrint("Depo kapandı, kayıt yapılıyor: " .. stashId)
                        TriggerServerEvent('666cg-storage:server:SaveJobStorage', jobName, exports.ox_inventory:GetInventoryItems(stashId))
                    end
                end)
            else
                DebugPrint("HATA: ox_inventory bulunamadı!")
                QBCore.Functions.Notify("Depo sisteminde hata! (ox_inventory bulunamadı)", "error")
            end
        else
            QBCore.Functions.Notify("Depo bulunamadı", "error")
        end
    end, jobName)
end

-- Depoları kontrol etme
CreateThread(function()
    while true do
        local sleep = 1000
        local playerPed = PlayerPedId()
        local playerCoords = GetEntityCoords(playerPed)
        local playerJob = QBCore.Functions.GetPlayerData().job
        local isNearStorage = false
        
        -- Kişisel depoları kontrol et
        for i, storage in ipairs(Config.PersonalStorages) do
            local distance = #(playerCoords - storage.coords)
            if distance < 2.0 then
                isNearStorage = true
                nearStorage = storage
                nearStorageType = "personal"
                nearStorageId = i
                sleep = 0
                
                -- UI göster
                ShowStorageUI(storage.name)
                
                -- E tuşuna basma
                if IsControlJustPressed(0, 38) then -- E tuşu
                    OpenPersonalStorage(i)
                end
                break
            end
        end
        
        -- Meslek depolarını kontrol et
        if not isNearStorage then
            for jobName, storage in pairs(Config.JobStorages) do
                local distance = #(playerCoords - storage.coords)
                
                if distance < 2.0 then
                    -- İş kontrolü
                    local hasJob = false
                    for _, job in pairs(storage.jobs) do
                        if playerJob.name == job then
                            hasJob = true
                            break
                        end
                    end
                    
                    if hasJob then
                        isNearStorage = true
                        nearStorage = storage
                        nearStorageType = "job"
                        nearStorageId = jobName
                        sleep = 0
                        
                        -- UI göster
                        ShowStorageUI(storage.name)
                        
                        -- E tuşuna basma
                        if IsControlJustPressed(0, 38) then -- E tuşu
                            OpenJobStorage(jobName)
                        end
                    end
                    break
                end
            end
        end
        
        -- UI gizleme
        if not isNearStorage and showingUI then
            HideStorageUI()
        end
        
        Wait(sleep)
    end
end)

-- Oyuncu yüklendiğinde
RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    -- ox_inventory check
    if not IsOxInventoryAvailable() then
        DebugPrint("UYARI: ox_inventory bulunamadı veya başlatılmadı!")
    else
        DebugPrint("ox_inventory başarıyla başlatıldı, depo sistemi hazır.")
    end
end)

-- Kaynak durduğunda
AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    HideStorageUI()
end) 