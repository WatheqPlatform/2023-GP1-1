
$(document).ready(function () {
    
    
    
    var qualificationCount = 1;

    $("#addQualification").click(function (e) {
        e.preventDefault();

        var qualificationFields = `
            <div class="input_wrap Multiable" id="qualification${qualificationCount}">
                <h4> Qualification ${qualificationCount + 1}: </h4>
                <label for="degreeLevel${qualificationCount}">Degree Level</label>   
                <select name="degreeLevel${qualificationCount}" id="degreeLevel${qualificationCount}" class="input select" onchange="handleDegreeLevelChange(event, ${qualificationCount})">
                    <option disabled selected></option>
                    <option value="Pre-high school">Pre-high school</option>
                    <option value="High School">High School</option>
                    <option value="Diploma">Diploma</option>
                    <option value="Bachelor">Bachelor</option>
                    <option value="Master">Master</option>
                    <option value="Doctorate">Doctorate</option>
                    <option value="Post Doctorate">Post Doctorate</option>
                </select>

                <label id= "DegreeFieldLabel${qualificationCount}" for="degreeFieldLabel${qualificationCount}">Degree Field <span class="MaybeRequiredQualification"></span></label> 
                <select name="degree[${qualificationCount}][field]" id="degreeField${qualificationCount}" class="input select" onchange="handleDegreeFieldChange(event, ${qualificationCount})">
                   
                </select>

                <span id="EnterMessage${qualificationCount}" style="display: none;" class ="EnterMessage">Please enter your qualification field below</span>
                <input type="text" id="qualificationOther${qualificationCount}" name="qualificationOther${qualificationCount}" class="input" style="display: none;" maxlength="100">

                <ion-icon name="close-circle-outline" class="removeQualification remove" data-qualification="${qualificationCount}"></ion-icon>   
            </div>
        `;

        $("#qualificationFields").append(qualificationFields);
        loadFieldOptions(qualificationCount); // Load field options for the new qualification
        qualificationCount++;
    });

    $(document).on("click", ".removeQualification", function (e) {
        e.preventDefault();
        var qualificationId = $(this).data("qualification");
        $("#qualification" + qualificationId).remove();
    });
});

// Function to load field options for a specific qualification
function loadFieldOptions(qualificationId) {
    $.ajax({
      url: "fields.php", 
      type: "GET",
      success: function (response) {
          var options = JSON.parse(response);
          var select = $("#degreeField" + qualificationId);

          select.empty(); // Clear existing options

          if (options.length > 0) {
              select.append('<option disabled selected></option>');

              options.forEach(function (option) {
                  select.append('<option value="' + option.Field + '">' + option.Field + '</option>');
              });
              select.append('<option value="Other"> Other </option>');
              
          } else {
              select.append('<option disabled selected>No fields found</option>');
          }
      },
      error: function (xhr, status, error) {
          console.log(error); // Handle the error case
      }
    });
}

// Function to handle degreeLevel change
function handleDegreeLevelChange(event, qualificationId) {
  var selectedValue = event.target.value;
  var degreeFieldLabel = $("#DegreeFieldLabel" + qualificationId);
  var degreeField = $("#degreeField" + qualificationId);
   var qualificationOther = $("#qualificationOther" + qualificationId);
  var enterMessage = $("#EnterMessage" + qualificationId);
  var otherFieldLabel = $("#LableOther" + qualificationId);

  if (selectedValue === "Pre-high school") {
    degreeFieldLabel.hide();
    degreeField.hide();
    enterMessage.hide();
    qualificationOther.hide();
    otherFieldLabel.hide();
  } else {
    degreeFieldLabel.show();
    degreeField.show();
  }
}

function handleDegreeFieldChange(event, qualificationId) {
  var selectedValue = event.target.value;
  var qualificationOther = $("#qualificationOther" + qualificationId);
  var enterMessage = $("#EnterMessage" + qualificationId);
  var otherFieldLabel = $("#LableOther" + qualificationId);

    if (selectedValue === "Other") {
      //enterMessage.show();
      qualificationOther.show();
      otherFieldLabel.show();
      enterMessage.show();
    } else {
      //enterMessage.hide();
      qualificationOther.hide();
      otherFieldLabel.hide();
      enterMessage.hide();
    }
 

  qualificationOther.on("input", function () {
    var inputValue = $(this).val();

    if (inputValue.trim() !== "") { // trim any white space before or after the string provided
      enterMessage.hide();
    } else {
      enterMessage.show();
    }
  });

 
}