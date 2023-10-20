$(document).ready(function() {
    $("#SubmitButton").click(function() {

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
            $("#jobCity").val(),          
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
            shadow.addEventListener("click", function(){
                modal_wrapper.classList.remove("active");
                faliure_wrap.classList.remove("active");
            })

        } else { 
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
                
                // non required feilds we won't check if they are empty or not
                startingDate: $("#date").val(),
                workingHours: $("#workingHours").val(),
                notes: $("#notes").val(),
                workingDays: getWorkingDays(),
                skills: getSkills(),
                qualifications: saveQualifications(),
                experiences: saveExperiences()
                
            }, function(data) {
                
                    if (data === "success") {
                        $('#AddForm')[0].reset(); // Delete information from the form
                        var modal_wrapper = document.querySelector(".modal_wrapper");
                        var success_wrap = document.querySelector(".success_wrap");
                        var shadow = document.querySelector(".shadow");       

                        modal_wrapper.classList.add("active");
                        success_wrap.classList.add("active");

                        // Clicking anywhere on the screen remove the message
                        shadow.addEventListener("click", function(){
                            modal_wrapper.classList.remove("active");
                            success_wrap.classList.remove("active");
                            window.location.href = "../History Page/History.php";
                        });
                    }
                    else {
                            // Handle error case
                            alert("An error occurred during form submission. Please try again");
                            console.error("Form submission error:", data);
                        }
                
            });
            
            function getWorkingDays() {
                let days = $("input[name='day']:checked").map(function() {
                    return $(this).val();
                }).get();

                return days.length > 0 ? days.join(", ") : null;
            }
    

            function getSkills() {
                var skills = [];

                $("input[name^='skills']").each(function() {
                    var skillValue = $(this).val().trim();
                    if (skillValue !== "") {
                        skills.push(skillValue);
                    }
                });
      
                return skills;
            }
    
            function saveQualifications() {
                var qualifications = [];

                $("div[id^='qualification']").each(function() {
                    
                    var degreeLevel = $(this).find("input[name^='degree']").eq(0).val().trim();
                    var degreeField = $(this).find("input[name^='degree']").eq(1).val().trim();

                    if (degreeLevel !== "" && degreeField!==""  ) {
                        qualifications.push({
                            level: degreeLevel,
                            field: degreeField
                        });
                    }
                });
    
                return qualifications;
            }
            
            
            function saveExperiences() {
                var experiences = [];

                $("div[id^='experience']").each(function() {
                    var field = $(this).find("input[name^='experience']").eq(0).val().trim();
                    var description = $(this).find("input[name^='experiences']").eq(0).val().trim();
                    var years = $(this).find("input[name^='experiences']").eq(1).val();

                    if (field !== "" && description !== "" && years !== "") {
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







   
