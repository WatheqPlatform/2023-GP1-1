function sortApplications() {
    var selectedOption = document.getElementById("sorting").value;
    if(selectedOption!=""){
        // Perform AJAX request to fetch sorted data
        $.ajax({
            type: "POST",
            url: "SortApplications.php",
            data: { sort: selectedOption },
            success: function (data) {
                document.getElementById("pending").innerHTML=data;
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
            },
            error: function () {
                alert("There is an error, try again later");
            }
        });
    }
}
