$(document).ready(function () {
    var qualificationCount = 1;

    $("#addQualification").click(function (e) {
        e.preventDefault();

        var qualificationFields = `
        <div class="input_wrap Multiable" id="qualification${qualificationCount}">
            <h4> Qualification ${qualificationCount + 1}: </h4>
            <label for="degreeLevel${qualificationCount}">Degree Level</label>   
            <input type="text" name="degree[${qualificationCount}][level]" class="input" >
            <label for="degreeField${qualificationCount}">Degree Field <span id="MaybeRequiredQualification"></span></label> 
            <input type="text" name="degree[${qualificationCount}][field]" class="input">

            <ion-icon name="close-circle-outline" class="removeQualification remove" data-qualification="${qualificationCount}"></ion-icon>   
        </div>
    `;

        $("#qualificationFields").append(qualificationFields);
        qualificationCount++;
    });

    $(document).on("click", ".removeQualification", function (e) {
        e.preventDefault();
        var qualificationId = $(this).data("qualification");
        $("#qualification" + qualificationId).remove();
        qualificationCount--;
        
    });
});