// Yetkili Discord ID'leri
const authorizedUsers = [
    "712579734332112896", // Örnek ID 1
    "987654321098765432"  // Örnek ID 2
];

// Discord ID kontrolü
function checkAuthorization(discordId) {
    return authorizedUsers.includes(discordId);
}

document.addEventListener('DOMContentLoaded', () => {
    // Tab switching functionality
    const tabButtons = document.querySelectorAll('.tab-btn');
    const tabContents = document.querySelectorAll('.tab-content');
    
    tabButtons.forEach(button => {
        button.addEventListener('click', () => {
            // Remove active class from all buttons and contents
            tabButtons.forEach(btn => btn.classList.remove('active'));
            tabContents.forEach(content => content.classList.add('hidden'));
            
            // Add active class to clicked button and show corresponding content
            button.classList.add('active');
            const targetId = button.getAttribute('data-target');
            document.getElementById(targetId).classList.remove('hidden');
        });
    });

    // Close button functionality
    const closeButton = document.getElementById('close-btn');
    closeButton.addEventListener('click', () => {
        // Discord ID kontrolü
        const discordId = prompt("Discord ID'nizi girin:");
        if (checkAuthorization(discordId)) {
            window.close();
        } else {
            alert("Bu işlem için yetkiniz bulunmamaktadır.");
        }
    });

    // Back button functionality
    const backButton = document.getElementById('back-btn');
    backButton.addEventListener('click', () => {
        document.getElementById('storage-info').classList.add('hidden');
        document.querySelector('.tab-content:not(.hidden)').classList.remove('hidden');
    });

    // Storage item click functionality
    const storageItems = document.querySelectorAll('.storage-item');
    storageItems.forEach(item => {
        item.addEventListener('click', () => {
            // Hide current content and show storage info
            document.querySelector('.tab-content:not(.hidden)').classList.add('hidden');
            document.getElementById('storage-info').classList.remove('hidden');
            
            // Depo detaylarını doldur
            const details = document.querySelector('.storage-details');
            details.innerHTML = `
                <h3>${item.querySelector('h3').textContent}</h3>
                <p>${item.querySelector('p').textContent}</p>
                <p>Depo ID: ${item.dataset.id}</p>
            `;
        });
    });

    // Example function to fetch storage info
    function fetchStorageInfo(storageId) {
        // Implement your API call here
        // This is just a placeholder
        console.log(`Fetching info for storage ${storageId}`);
    }
}); 