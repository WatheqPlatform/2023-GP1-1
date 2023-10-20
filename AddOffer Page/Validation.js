$(document).ready(function () {
    $("#SubmitButton").click(function () {

        let inputValues = [
            // REQUIRED FEILDS ONLY
            $("#jobTitle").val(),
            $("#jobDescription").val(),
            $("#jobField").val(),
            $("#jobAddress").val(),
            $("#jobType").val(),
            $("#minSalary").val(),
            $("#maxSalary").val(),
            $("#job-categories").val(),
            $("#jobCity").val()
        ];

        let isEmpty = false;
        // Check if any item in the array is empty
        inputValues.forEach(value => {
            if (value == undefined || value == null || value === "") {
                isEmpty = true;
            }
        });

        if (isEmpty) {
            var modal_wrapper = document.querySelector(".modal_wrapper");
            var faliure_wrap = document.querySelector(".faliure_wrap");
            var shadow = document.querySelector(".shadow");

            modal_wrapper.classList.add("active");
            faliure_wrap.classList.add("active");

            //Clicking anywhere on the screen remove the sessamge
            shadow.addEventListener("click", function () {
                modal_wrapper.classList.remove("active");
                faliure_wrap.classList.remove("active");
            })

        } else {


            var skills = getSkills();
           

// Call the saveQualifications() function and log the returned data
            var qualifications = saveQualifications();
           

// Call the saveExperiences() function and log the returned data
            var experiences = saveExperiences();
           
            //Send the information to PHP File
            $.post("AddOffer.php", {
                jobTitle: inputValues[0],
                jobDescription: inputValues[1],
                jobField: inputValues[2],
                jobAddress: inputValues[3],
                jobType: inputValues[4],
                minSalary: inputValues[5],
                maxSalary: inputValues[6],
                jobCategories: inputValues[7],
                jobCity: inputValues[8],

                // non required feilds we won't check if they are empty 
                startingDate: $("#date").val(),
                workingHours: $("#workingHours").val(),
                notes: $("#notes").val(),
                workingDays: getWorkingDays(),
                //skills: getSkills(),
                // qualifications: saveQualifications(),
                //s experiences: saveExperiences(),
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
                    alert("An error occurred during form submission. Please try again");
                    console.error("Form submission error:", data);
                }

            });

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

            function saveQualifications() {
                var qualifications = [];

                $("div[id^='qualification']").each(function () {
                    var degreeLevel = $(this).find("select[name^='degreeLevel']").val();
                    var degreeField = $(this).find("input[name^='degree']").val();

                    if (degreeLevel && degreeField) {
                        degreeLevel = degreeLevel.trim();
                        degreeField = degreeField.trim();

                        if (degreeLevel !== "" && degreeField !== "") {
                            // Check if the qualification already exists in the qualifications array
                            var exists = qualifications.some(function (qualification) {
                                return qualification.level === degreeLevel && qualification.field === degreeField;
                            });

                            if (!exists) {
                                qualifications.push({
                                    level: degreeLevel,
                                    field: degreeField
                                });
                            }
                        }
                    }
                });

                return qualifications;
            }


            function saveExperiences() {
                var experiences = [];

                $("div[id^='experience']").each(function () {
                    var field = $(this).find("input[name^='experience']").eq(0).val().trim();
                    var description = $(this).find("input[name^='experiences']").eq(0).val().trim();
                    var years = $(this).find("input[name^='experiences']").eq(1).val();

                    if (field !== "" && description !== "" && years !== "") {
                        // Check if the experience already exists in the experiences array
                        var exists = experiences.some(function (experience) {
                            return experience.field === field && experience.description === description && experience.years === years;
                        });

                        if (!exists) {
                            experiences.push({
                                field: field,
                                description: description,
                                years: years
                            });
                        }
                    }
                });

                return experiences;
            }

        }
    });

});








