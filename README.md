# 666cg-storage | Depo Sistemi

## 🇹🇷 Türkçe

### Açıklama
FiveM için QBCore tabanlı, ox_inventory kullanarak kişisel ve meslek depo sistemi sunan gelişmiş bir kaynak.

### Özellikler
- **Kişisel Depo Sistemi**: Her oyuncuya özel, kişiselleştirilmiş envanterler
- **Meslek Depo Sistemi**: Belirli meslekler için paylaşımlı envanterler
- **Kolay Yapılandırma**: Depo konumları için basit ve anlaşılır yapılandırma
- **Discord Log Desteği**: Depo etkileşimleri için detaylı log sistemi
- **Optimize Edilmiş Performans**: Düşük kaynak kullanımı
- **Özelleştirilebilir UI**: İsteğe bağlı özel kullanıcı arayüzü

### Gereksinimler
- [QBCore Framework](https://github.com/qbcore-framework)
- [ox_inventory](https://github.com/overextended/ox_inventory)
- [oxmysql](https://github.com/overextended/oxmysql)

### Kurulum
1. Bu kaynağı FiveM resources klasörünüze indirin
2. Server.cfg dosyanıza `ensure 666cg-storage` satırını ekleyin
3. Veritabanı tablosu, kaynak başlatıldığında otomatik olarak oluşturulacaktır

### Yapılandırma
`config.lua` dosyasını düzenleyerek:

1. Depo konumlarını ayarlayın (koordinatlar)
2. Depo boyutlarını ve ağırlık sınırlarını yapılandırın
3. Mesleğe özel depoları ekleyin
4. Discord webhook URL'lerini ayarlayın
5. Log sistemini etkinleştirin/devre dışı bırakın

### Örnek Yapılandırma

```lua
Config.PersonalStorages = {
    {
        name = "Kişisel Depo 1", 
        coords = vector3(251.5, -1003.4, -99.0), -- Daire konumu
        size = 30, -- Slot sayısı
        weight = 50000, -- Maksimum ağırlık (gram)
    }
}

Config.JobStorages = {
    ['police'] = {
        name = "Polis Kanıt Dolabı",
        coords = vector3(453.5, -980.6, 30.7), -- MRPD konumu
        size = 50,
        weight = 100000,
        jobs = {"police"} -- Bu depoya erişebilecek meslekler
    }
}
```

### Nasıl Çalışır
- **Kişisel Depo**: Her oyuncunun her kişisel depo konumunda kendine özel envanteri vardır
- **Meslek Deposu**: Belirli bir mesleğe sahip tüm oyuncular aynı envanteri paylaşırlar

---

## 🇬🇧 English

### Description
An advanced resource for FiveM that provides personal and job storage systems using QBCore framework and ox_inventory.

### Features
- **Personal Storage System**: Personalized inventories for each player
- **Job Storage System**: Shared inventories for specific jobs
- **Easy Configuration**: Simple and clear configuration for storage locations
- **Discord Log Support**: Detailed logging system for storage interactions
- **Optimized Performance**: Low resource usage
- **Customizable UI**: Optional custom user interface

### Requirements
- [QBCore Framework](https://github.com/qbcore-framework)
- [ox_inventory](https://github.com/overextended/ox_inventory)
- [oxmysql](https://github.com/overextended/oxmysql)

### Installation
1. Download this resource to your FiveM resources folder
2. Add `ensure 666cg-storage` to your server.cfg file
3. The database table will be created automatically when the resource starts

### Configuration
Edit the `config.lua` file to:

1. Set storage locations (coordinates)
2. Configure storage sizes and weight limits
3. Add job-specific storages
4. Set Discord webhook URLs
5. Enable/disable logging system

### Example Configuration

```lua
Config.PersonalStorages = {
    {
        name = "Personal Storage 1", 
        coords = vector3(251.5, -1003.4, -99.0), -- Apartment location
        size = 30, -- Number of slots
        weight = 50000, -- Maximum weight (grams)
    }
}

Config.JobStorages = {
    ['police'] = {
        name = "Police Evidence Locker",
        coords = vector3(453.5, -980.6, 30.7), -- MRPD location
        size = 50,
        weight = 100000,
        jobs = {"police"} -- Jobs that can access this storage
    }
}
```

### How It Works
- **Personal Storage**: Each player has their own unique inventory at each personal storage location
- **Job Storage**: All players with a specific job share the same inventory

## Credits
- Developed by 666cg
- Visit [GitHub](https://github.com/666cg) for more resources 