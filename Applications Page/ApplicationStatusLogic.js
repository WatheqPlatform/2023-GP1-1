// script.js

// Add event listeners to the accept and reject buttons
document.addEventListener('DOMContentLoaded', function() {
    var acceptButtons = document.getElementsByClassName('accept-button');
    var rejectButtons = document.getElementsByClassName('reject-button');

    // Event listener for accept button
    Array.from(acceptButtons).forEach(function(button) {
        button.addEventListener('click', function() {
            var applicationId = this.getAttribute('data-application-id');
            updateApplicationStatus(applicationId, 'Accepted');
        });
    });

    // Event listener for reject button
    Array.from(rejectButtons).forEach(function(button) {
        button.addEventListener('click', function() {
            var applicationId = this.getAttribute('data-application-id');
            updateApplicationStatus(applicationId, 'Rejected');
        });
    });

    // Function to update the application status via AJAX
    function updateApplicationStatus(applicationId, status) {
        var xhr = new XMLHttpRequest();
        xhr.open('POST', 'update_status.php', true);
        xhr.setRequestHeader('Content-type', 'application/x-www-form-urlencoded');
        xhr.onreadystatechange = function() {
            if (xhr.readyState === 4 && xhr.status === 200) {
                // Handle the response if needed
                console.log(xhr.responseText);
                location.reload();
            }
        };
        xhr.send('applicationId=' + applicationId + '&status=' + status);
    }
});