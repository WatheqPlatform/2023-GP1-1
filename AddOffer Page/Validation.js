$(document).ready(function () {
    $("#SubmitButton").click(function () {




//        // Check if any item in the array is empty
//        inputValues.forEach(value => {
//            if (value == undefined || value == null || value === "") {
//                isEmpty = true;
//            }
//        });
//        
// Get the field values
        var jobTitle = $("#jobTitle").val();
        var jobDescription = $("#jobDescription").val();
        var jobAddress = $("#jobAddress").val();
        var jobType = $("#jobType").val();
        var minSalary = $("#minSalary").val();
        var maxSalary = $("#maxSalary").val();
        var jobCategories = $("#job-categories").val();
        var jobCity = $("#jobCity").val();

// Create an array to store the missing fields
        var missingFields = [];

// Check each field if it is empty
        if (jobTitle === "") {
            missingFields.push("Job Title");
        }
        if (jobType === "" || jobType === undefined || jobType === null) {
            missingFields.push("Employment Type");
        }

        if (jobCategories === "" || jobCategories === undefined || jobCategories === null) {
            missingFields.push("Job Industry");
        }

        if (jobCity === "" || jobCity === undefined || jobCity === null) {
            missingFields.push("Job City");
        }
        if (jobAddress === "" || jobAddress === undefined || jobAddress === null) {
            missingFields.push("Job Address");
        }

        if (jobDescription === "" || jobDescription === undefined || jobDescription === null) {
            missingFields.push("Job Description");
        }
        if (minSalary === "" || minSalary === undefined || minSalary === null) {
            missingFields.push("Minimum Salary");
        }
        if (maxSalary === "" || maxSalary === undefined || maxSalary === null) {
            missingFields.push("Maximum Salary");
        }

// Check if any fields are missing
        if (missingFields.length > 0) {
            if (missingFields.length !== 8) {

                var failureMessageElement = document.querySelector(".faliure_wrap p");
                failureMessageElement.textContent = "Please fill in the following fields: " + missingFields.join(", ");

                var modal_wrapper = document.querySelector(".modal_wrapper");
                var faliure_wrap = document.querySelector(".faliure_wrap");
                var shadow = document.querySelector(".shadow");



                modal_wrapper.classList.add("active");
                faliure_wrap.classList.add("active");

                //Clicking anywhere on the screen remove the sessamge
                shadow.addEventListener("click", function () {
                    modal_wrapper.classList.remove("active");
                    faliure_wrap.classList.remove("active");
                });
                // Construct the error message
//            var errorMessage = "Please fill in the following fields: " + missingFields.join(", ");

                // Display the error message
//            alert(errorMessage);
            } else {


                var modal_wrapper = document.querySelector(".modal_wrapper");
                var faliure_wrap = document.querySelector(".faliure_wrap");
                var shadow = document.querySelector(".shadow");



                modal_wrapper.classList.add("active");
                faliure_wrap.classList.add("active");

                //Clicking anywhere on the screen remove the sessamge
                shadow.addEventListener("click", function () {
                    modal_wrapper.classList.remove("active");
                    faliure_wrap.classList.remove("active");
                });


            }
        } else {
            let inputValues = [
                // REQUIRED FEILDS ONLY
                $("#jobTitle").val(),
                $("#jobDescription").val(),
                $("#jobAddress").val(),
                $("#jobType").val(),
                $("#minSalary").val(),
                $("#maxSalary").val(),
                $("#job-categories").val(),
                $("#jobCity").val()
            ];

            if ((!$("#maxSalary").val().match(/^\d+$/)))
            {
              
                
                        var failureMessageElement = document.querySelector(".faliure_wrap p");
                        failureMessageElement.textContent = "Please enter a valid number for maximum salary";

                        var modal_wrapper = document.querySelector(".modal_wrapper");
                        var faliure_wrap = document.querySelector(".faliure_wrap");
                        var shadow = document.querySelector(".shadow");



                        modal_wrapper.classList.add("active");
                        faliure_wrap.classList.add("active");

                        //Clicking anywhere on the screen remove the sessamge
                        shadow.addEventListener("click", function () {
                            modal_wrapper.classList.remove("active");
                            faliure_wrap.classList.remove("active");
                        });

            } else {
                if ((!$("#minSalary").val().match(/^\d+$/))) {
                   
                      var failureMessageElement = document.querySelector(".faliure_wrap p");
                        failureMessageElement.textContent = "Please enter a valid number for minimum salary";

                        var modal_wrapper = document.querySelector(".modal_wrapper");
                        var faliure_wrap = document.querySelector(".faliure_wrap");
                        var shadow = document.querySelector(".shadow");



                        modal_wrapper.classList.add("active");
                        faliure_wrap.classList.add("active");

                        //Clicking anywhere on the screen remove the sessamge
                        shadow.addEventListener("click", function () {
                            modal_wrapper.classList.remove("active");
                            faliure_wrap.classList.remove("active");
                        });
                } else {
                    if (parseFloat($("#minSalary").val()) > parseFloat($("#maxSalary").val())) {

                       
                        var failureMessageElement = document.querySelector(".faliure_wrap p");
                        failureMessageElement.textContent = "Minimum salary cannot be greater than the maximum salary.";

                        var modal_wrapper = document.querySelector(".modal_wrapper");
                        var faliure_wrap = document.querySelector(".faliure_wrap");
                        var shadow = document.querySelector(".shadow");



                        modal_wrapper.classList.add("active");
                        faliure_wrap.classList.add("active");

                        //Clicking anywhere on the screen remove the sessamge
                        shadow.addEventListener("click", function () {
                            modal_wrapper.classList.remove("active");
                            faliure_wrap.classList.remove("active");
                        });
                    } else {
                        if ($("#workingHours").val() !== "" && !$("#workingHours").val().match(/^\d+$/))
                        {
                           
                            var failureMessageElement = document.querySelector(".faliure_wrap p");
                            failureMessageElement.textContent = "Please enter a valid number for the working hours";

                            var modal_wrapper = document.querySelector(".modal_wrapper");
                            var faliure_wrap = document.querySelector(".faliure_wrap");
                            var shadow = document.querySelector(".shadow");



                            modal_wrapper.classList.add("active");
                            faliure_wrap.classList.add("active");

                            //Clicking anywhere on the screen remove the sessamge
                            shadow.addEventListener("click", function () {
                                modal_wrapper.classList.remove("active");
                                faliure_wrap.classList.remove("active");
                            });

                        } else {

                            var skills = getSkills();


                            // Call the saveQualifications() function and log the returned data
                            var qualifications = saveQualifications();
                            // check that if there's at least one feild filled, the other should be filled too
                            var checkQualification = checkQualifications(qualifications);

                            // Call the saveExperiences() function and log the returned data
                            var experiences = saveExperiences();
                            // check that if there's at least one feild filled, the other should be filled too
                            var checkExperiences = checkExperience(experiences);
                            if (checkQualification === true && checkExperiences === true) {

                                //Send the information to PHP File
                                $.post("AddOfferLogic.php", {
                                    jobTitle: inputValues[0],
                                    jobDescription: inputValues[1],
                                    jobAddress: inputValues[2],
                                    jobType: inputValues[3],
                                    minSalary: inputValues[4],
                                    maxSalary: inputValues[5],
                                    jobCategories: inputValues[6],
                                    jobCity: inputValues[7],

                                    // non required feilds we won't check if they are empty 
                                    startingDate: $("#date").val(),
                                    workingHours: $("#workingHours").val(),
                                    notes: $("#notes").val(),
                                    workingDays: getWorkingDays(),

                                    skills: skills,
                                    qualifications: qualifications,
                                    experiences: experiences

                                }, function (data) {

                                    if (data === "success") { // Update the condition to trim the data
                                        $('#AddForm')[0].reset(); // Delete information from the form
                                        var modal_wrapper = document.querySelector(".modal_wrapper");
                                        var success_wrap = document.querySelector(".success_wrap");
                                        var shadow = document.querySelector(".shadow");

                                        modal_wrapper.classList.add("active");
                                        success_wrap.classList.add("active");

                                        // Clicking anywhere on the screen remove the message
                                        shadow.addEventListener("click", function () {
                                            modal_wrapper.classList.remove("active");
                                            success_wrap.classList.remove("active");
                                            window.location.href = "../History Page/History.php";
                                        });
                                    } else {
                                        // Handle error case
                                     
                                         var failureMessageElement = document.querySelector(".faliure_wrap p");
                            failureMessageElement.textContent = "An error occurred during form submission. Please try again";

                            var modal_wrapper = document.querySelector(".modal_wrapper");
                            var faliure_wrap = document.querySelector(".faliure_wrap");
                            var shadow = document.querySelector(".shadow");



                            modal_wrapper.classList.add("active");
                            faliure_wrap.classList.add("active");

                            //Clicking anywhere on the screen remove the sessamge
                            shadow.addEventListener("click", function () {
                                modal_wrapper.classList.remove("active");
                                faliure_wrap.classList.remove("active");
                            });
                                        
                                        console.error("Form submission error:", data);
                                    }

                                });
                            }

                        }//
                    }
                }

            }
// end of else 

            function getWorkingDays() {
                let days = $("input[name='day']:checked").map(function () {
                    return $(this).val();
                }).get();

                return days.length > 0 ? days.join(", ") : null;
            }


            function getSkills() {
                var skills = [];

                $("input[name^='skills']").each(function () {
                    var skillValue = $(this).val().trim();
                    if (skillValue !== "") {
                        skills.push(skillValue);
                    }
                });

                return skills;
            }

            function checkQualifications(checkQualifications) {
                if (checkQualifications === null)
                {
                    return true;
                }
                for (var i = 0; i < qualifications.length; i++) {
                    var qualification = qualifications[i];
                    if (!qualification.level && qualification.field ) {
                        var failureMessageElement = document.querySelector(".faliure_wrap p");
                        failureMessageElement.textContent = "Qualification Degree Level is missing.";

                        var modal_wrapper = document.querySelector(".modal_wrapper");
                        var faliure_wrap = document.querySelector(".faliure_wrap");
                        var shadow = document.querySelector(".shadow");



                        modal_wrapper.classList.add("active");
                        faliure_wrap.classList.add("active");

                        //Clicking anywhere on the screen remove the sessamge
                        shadow.addEventListener("click", function () {
                            modal_wrapper.classList.remove("active");
                            faliure_wrap.classList.remove("active");
                        });

                        return false;
                    } else if (!qualification.field && qualification.level ) {

                        var failureMessageElement = document.querySelector(".faliure_wrap p");
                        failureMessageElement.textContent = "Qualification Degree Field is missing.";

                        var modal_wrapper = document.querySelector(".modal_wrapper");
                        var faliure_wrap = document.querySelector(".faliure_wrap");
                        var shadow = document.querySelector(".shadow");



                        modal_wrapper.classList.add("active");
                        faliure_wrap.classList.add("active");

                        //Clicking anywhere on the screen remove the sessamge
                        shadow.addEventListener("click", function () {
                            modal_wrapper.classList.remove("active");
                            faliure_wrap.classList.remove("active");
                        });
                        return false;
                    } else if (!qualification.other && qualification.field === "Other")
                    {

                        var failureMessageElement = document.querySelector(".faliure_wrap p");
                        failureMessageElement.textContent = "Qualification Degree Field is missing.";

                        var modal_wrapper = document.querySelector(".modal_wrapper");
                        var faliure_wrap = document.querySelector(".faliure_wrap");
                        var shadow = document.querySelector(".shadow");



                        modal_wrapper.classList.add("active");
                        faliure_wrap.classList.add("active");

                        //Clicking anywhere on the screen remove the sessamge
                        shadow.addEventListener("click", function () {
                            modal_wrapper.classList.remove("active");
                            faliure_wrap.classList.remove("active");
                        });
                        return false;
                    }

                }
                return true;
            }


            function saveQualifications() {
                var qualifications = [];

                $("div[id^='qualification']").each(function () {
                    var degreeLevel = $(this).find("select[name^='degreeLevel']").val();
                    var degreeField = $(this).find("select[name^='degree[']").val();
                    var qualificationOther = $(this).find("input[name^='qualificationOther']").val();

                    if (degreeLevel === "Pre-high school") {
                        degreeField = "None";
                        qualificationOther = "None";
                    }

                    if (degreeField !== "Other") {
                        qualificationOther = "None";
                    }

                    var existingQualification = qualifications.find(function (qualification) {
                        return (
                                qualification.level === degreeLevel &&
                                qualification.field === degreeField &&
                                qualification.other === qualificationOther
                                );
                    });

                    if (
                            !existingQualification &&
                            (degreeLevel !== "" || degreeField !== "" || qualificationOther !== "")
                            ) {
                        qualifications.push({
                            level: degreeLevel,
                            field: degreeField,
                            other: qualificationOther
                        });
                    }
                });

                return qualifications;
            }
            function checkExperience(experience) {
                if (experience === null)
                {
                    return true;
                }

                for (var i = 0; i < experience.length; i++)
                {
                    var ex = experience[i];
                    if (!ex.Category) {

                        var failureMessageElement = document.querySelector(".faliure_wrap p");
                        failureMessageElement.textContent = "Experience Industry is missing.";

                        var modal_wrapper = document.querySelector(".modal_wrapper");
                        var faliure_wrap = document.querySelector(".faliure_wrap");
                        var shadow = document.querySelector(".shadow");



                        modal_wrapper.classList.add("active");
                        faliure_wrap.classList.add("active");

                        //Clicking anywhere on the screen remove the sessamge
                        shadow.addEventListener("click", function () {
                            modal_wrapper.classList.remove("active");
                            faliure_wrap.classList.remove("active");
                        });

                        return false;
                    } else if (!ex.JobTitle) {

                        var failureMessageElement = document.querySelector(".faliure_wrap p");
                        failureMessageElement.textContent = "Experience Job Title is missing.";

                        var modal_wrapper = document.querySelector(".modal_wrapper");
                        var faliure_wrap = document.querySelector(".faliure_wrap");
                        var shadow = document.querySelector(".shadow");



                        modal_wrapper.classList.add("active");
                        faliure_wrap.classList.add("active");

                        //Clicking anywhere on the screen remove the sessamge
                        shadow.addEventListener("click", function () {
                            modal_wrapper.classList.remove("active");
                            faliure_wrap.classList.remove("active");
                        });
                        return false;
                    } else if (!ex.years) {

                        var failureMessageElement = document.querySelector(".faliure_wrap p");
                        failureMessageElement.textContent = "Experience Minimum Years is missing.";

                        var modal_wrapper = document.querySelector(".modal_wrapper");
                        var faliure_wrap = document.querySelector(".faliure_wrap");
                        var shadow = document.querySelector(".shadow");



                        modal_wrapper.classList.add("active");
                        faliure_wrap.classList.add("active");

                        //Clicking anywhere on the screen remove the sessamge
                        shadow.addEventListener("click", function () {
                            modal_wrapper.classList.remove("active");
                            faliure_wrap.classList.remove("active");
                        });
                        return false;
                    } else if (!ex.years.match(/^\d+$/)) {

                        var failureMessageElement = document.querySelector(".faliure_wrap p");
                        failureMessageElement.textContent = "Please enter a valid number for Experience Minimum Years";

                        var modal_wrapper = document.querySelector(".modal_wrapper");
                        var faliure_wrap = document.querySelector(".faliure_wrap");
                        var shadow = document.querySelector(".shadow");



                        modal_wrapper.classList.add("active");
                        faliure_wrap.classList.add("active");

                        //Clicking anywhere on the screen remove the sessamge
                        shadow.addEventListener("click", function () {
                            modal_wrapper.classList.remove("active");
                            faliure_wrap.classList.remove("active");
                        });
                        return false;
                    }
                }
                return true;
            }

            function saveExperiences() {
                var experiences = [];

                $("div[id^='experience']").each(function () {
                    var Category = $(this).find("select[name$='[Category]']").val();
                    var JobTitle = $(this).find("input[name$='[JobTitle]']").val();
                    var years = $(this).find("input[name$='[years]']").val();




                    // Check if the experience already exists in the experiences array
                    var exists = experiences.some(function (experience) {
                        return experience.Category === Category && experience.JobTitle === JobTitle && experience.years === years;
                    });

                    if (!exists && (Category !== "" || JobTitle !== "" || years !== "")) {
                        experiences.push({
                            Category: Category,
                            JobTitle: JobTitle,
                            years: years
                        });
                    }

                });

                return experiences;
            }

        }
    });

});







