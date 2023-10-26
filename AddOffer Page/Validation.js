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
            });

        } else {

            if (parseFloat($("#minSalary").val()) > parseFloat($("#maxSalary").val()))
            {
                alert("Minimum salary cannot be greater than the maximum salary.");

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
                }

            }


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
                    if (!qualification.level && qualification.field) {
                        alert("Qualification degree level is missiing.");
                        return false;
                    } else if (qualification.level && !qualification.field) {
                        alert("Qualification degree field is missing.");
                        return false;
                    }
                }
                return true;
            }

            function saveQualifications() {
                var qualifications = [];

                $("div[id^='qualification']").each(function () {
                    var degreeLevel = $(this).find("select[name^='degreeLevel']").val();
                    var degreeField = $(this).find("input[name^='degree']").val();



                    var existingQualification = qualifications.find(function (qualification) {
                        return qualification.level === degreeLevel && qualification.field === degreeField;
                    });

                    if (!existingQualification && (degreeLevel !== null || degreeField !== ""))
                    {
                        qualifications.push({
                            level: degreeLevel,
                            field: degreeField
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
                    if (!ex.field) {
                        alert("Experience field is missing.");
                        return false;
                    } else if (!ex.description) {
                        alert("Experience description is missing.");
                        return false;
                    } else if (!ex.years) {
                        alert("Experience years is missing.");
                        return false;
                    }
                }
                return true;
            }

            function saveExperiences() {
                var experiences = [];

                $("div[id^='experience']").each(function () {
                    var field = $(this).find("input[name^='experience']").eq(0).val();
                    var description = $(this).find("input[name^='experiences']").eq(0).val();
                    var years = $(this).find("input[name^='experiences']").eq(1).val();




                    // Check if the experience already exists in the experiences array
                    var exists = experiences.some(function (experience) {
                        return experience.field === field && experience.description === description && experience.years === years;
                    });

                    if (!exists && (field !== "" || description !== "" || years !== "")) {
                        experiences.push({
                            field: field,
                            description: description,
                            years: years
                        });
                    }

                });

                return experiences;
            }

        }
    });

});







