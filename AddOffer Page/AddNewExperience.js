

$(document).ready(function () {
    var experienceCount = 1;
    var numberCount = 5;

    $("#addExperience").click(function (e) {
        e.preventDefault();

        var experienceFields = `
        <div class="input_wrap Multiable" id="experience${experienceCount}">
            <h4> Experience ${experienceCount + 1}: </h4>
            <label for="experienceCategory${experienceCount}">Experience Industry</label>
            <select name="experiences[${experienceCount}][Category]" id="experienceCategory${experienceCount}" class="input select">
                <option disabled selected></option>
            </select>
 
            <label for="experienceJobTitle${experienceCount}" maxlength="100">Job Title <span class="MaybeRequiredExperince"></span></label>
            <input type="text" name="experiences[${experienceCount}][JobTitle]" class="input">

            <label for="experienceYears${experienceCount}">Minimum Years of Experience <span class="MaybeRequiredExperince"></span></label>
            <input type="number" name="experiences[${experienceCount}][years]" class="input" onkeyup="validateNumericInput(this, '${numberCount}')">
            <span id="warningMessage${numberCount}" style="color: red; display: none;">Please enter a valid number</span>

            <ion-icon name="close-circle-outline" class="removeExperience remove" data-experience="${experienceCount}"></ion-icon>
        </div>
    `;

        $("#experienceFields").append(experienceFields);
           // Load category options for the initial experience field
         loadCategoryOptions(experienceCount);
        experienceCount++;
        numberCount++;
        
     
    });

    $(document).on("click", ".removeExperience", function (e) {
        e.preventDefault();
        var experienceId = $(this).data("experience");
        $("#experience" + experienceId).remove();
    });

    

    // Function to load category options for a specific experience field
    function loadCategoryOptions(experienceId) {
        $.ajax({
            url: "categories.php", 
            type: "GET",
            success: function (response) {
                var options = JSON.parse(response);
                var select = $("#experienceCategory" + experienceId);

                select.empty(); // Clear existing options

                if (options.length > 0) {
                    select.append('<option disabled selected></option>');

                    options.forEach(function (option) {
                        select.append('<option value="' + option.CategoryName + '">' + option.CategoryName + '</option>');
                    });
                } else {
                    select.append('<option disabled selected>No categories found</option>');
                }
            },
            error: function (xhr, status, error) {
                console.log(error); // Handle the error case
            }
        });
    }
});