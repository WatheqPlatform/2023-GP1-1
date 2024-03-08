document.addEventListener('DOMContentLoaded', function() {
    var notificationDiv = document.getElementById('NotificationDiv');

    document.getElementById('Bell').addEventListener('click', function(event) {
        // Toggle the visibility of the notification div
        notificationDiv.style.display = notificationDiv.style.display === 'none' ? 'block' : 'none';

        // Add event listener to close the notification div when the mouse leaves
        notificationDiv.addEventListener('mouseleave', function() {
            notificationDiv.style.display = 'none';
        });

        // Prevent the click event from propagating to the document
        event.stopPropagation();

        $.ajax({
            type: "POST",
            url: "../Functions/UpdateSeen.php",
            success: function(data) {
            },
            error: function(xhr, status, error) {
            }
        });
        
    });

    // Add event listener to close the notification div when the document is clicked
    document.addEventListener('click', function() {
        notificationDiv.style.display = 'none';
    });
});
