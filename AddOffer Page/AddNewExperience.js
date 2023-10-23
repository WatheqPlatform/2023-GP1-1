$(document).ready(function () {
    var experienceCount = 1;
    var numberCount = 5;
 

    $("#addExperience").click(function (e) {
        e.preventDefault();

        var experienceFields = `
        <div class="input_wrap Multiable" id="experience${experienceCount}">
            <h4> Experience ${experienceCount + 1}: </h4>
            <label for="experienceField${experienceCount}">Experience Field</label>
            <input type="text" name="experience[${experienceCount}][field]" class="input">

            <label for="experienceDescription${experienceCount}">Experience Description <span class="MaybeRequiredExperince"></span></label>
            <input type="text" name="experiences[${experienceCount}][description]" class="input">

            <label for="experienceYears${experienceCount}">Minimum Years of Experience <span class="MaybeRequiredExperince"></span></label>
            <input type="number" name="experiences[${experienceCount}][years]" class="input" onkeyup="validateNumericInput(this, '${numberCount}')">
            <span id="warningMessage${numberCount}" style="color: red; display: none;">Please enter a valid number</span>

            <ion-icon name="close-circle-outline" class="removeExperience remove" data-experience="${experienceCount}"></ion-icon>   
        </div>
    `;

        $("#experienceFields").append(experienceFields);
        experienceCount++;
        numberCount++;
    });

    $(document).on("click", ".removeExperience", function (e) {
        e.preventDefault();
        var experienceId = $(this).data("experience");
        $("#experience" + experienceId).remove();
       
    });
    
    
});