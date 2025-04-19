$(function() {
    window.addEventListener('message', function(event) {
        if (event.data.type === "showUI") {
            // UI'ı gösterme
            $('#storage-prompt').removeClass('hidden');
            $('.storage-name').text(event.data.text);
        } else if (event.data.type === "hideUI") {
            // UI'ı gizleme
            $('#storage-prompt').addClass('hidden');
        }
    });
}); 