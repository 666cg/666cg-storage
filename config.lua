Config = {}

-- Genel ayarlar
Config.UseCustomUI = true -- Özel UI kullanmak için

-- Log ayarları
Config.Logs = {
    PersonalStorage = "https://discord.com/api/webhooks/1361346985868787763/IWXNpnRWDxTq1tgjdZM3VOmZ9PktbVtYAZdXenSN0wvTWr62v_owiF2hdQhT0LiyhGNU", -- Kişisel depolar için webhook URL
    JobStorage = "https://discord.com/api/webhooks/1361346862346666024/-TRKSwsQBUgym2BVz-oedYTYVCrO_x-vA53Ao85DjXyFwWWqk2OAAOftaCw-O-wbIOqF",      -- Meslek depoları için webhook URL
    Enable = true         -- Log özelliğini açmak/kapatmak için
}

-- Kişisel Depo konumları
Config.PersonalStorages = {
    {
        name = "Kişisel Depo 1", 
        coords = vector3(-583.32, -1059.39, 22.34), -- Örnek konum (daire)
        size = 30, -- Slot sayısı
        weight = 50000, -- Maksimum ağırlık (gram)
    },
    {
        name = "Kişisel Depo 2",
        coords = vector3(302.8, -274.3, 54.0), -- Örnek konum (motel)
        size = 20,
        weight = 30000, -- Maksimum ağırlık (gram)
    },
}

-- Meslek Depo konumları
Config.JobStorages = {
    ['police'] = {
        name = "Polis Kanıt Dolabı",
        coords = vector3(453.5, -980.6, 30.7), -- Örnek konum (MRPD)
        size = 50,
        weight = 100000, -- Maksimum ağırlık (gram)
        jobs = {"police"} -- Bu depoya erişebilecek meslekler
    },
    ['ambulance'] = {
        name = "Sağlık Malzeme Dolabı",
        coords = vector3(309.8, -562.9, 43.3), -- Örnek konum (Pillbox)
        size = 40, 
        weight = 80000, -- Maksimum ağırlık (gram)
        jobs = {"ambulance"}
    },
    ['mechanic'] = {
        name = "Tamirci Deposu",
        coords = vector3(-347.4, -133.8, 39.0), -- Örnek konum (LS Customs)
        size = 60,
        weight = 150000, -- Maksimum ağırlık (gram)
        jobs = {"mechanic"}
    }
} 