$(document).ready(function () {
var qualificationCount = 1;
        $("#addQualification").click(function (e) {
e.preventDefault();
        var qualificationFields = `
        <div class="input_wrap Multiable" id="qualification${qualificationCount}">
            <h4> Qualification ${qualificationCount + 1}: </h4>
            <label for="degreeLevel${qualificationCount}">Degree Level</label>   
        <select name="degreeLevel${qualificationCount}" id="degreeLevel" class="input select">
                                            <option disabled selected></option>
                                            <option value="Pre-high school education">Pre-high school</option>
                                            <option value="High School">High School</option>
                                            <option value="Diploma">Diploma</option>
                                            <option value="Bachelor">Bachelor</option>
                                            <option value="Master">Master</option>
                                            <option value="Doctorate">Doctorate</option>
                                            <option value="Post Doctorate">Post Doctorate</option>
                                        </select>
    
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
});
        });