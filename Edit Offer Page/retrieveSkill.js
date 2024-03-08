//$(document).ready(function() {
var skillCount = 1;
function retrieveSkills(retrievedskills) {
    var skills = retrievedskills;
    skillCount = $("input[name^='skills']").length;
    if (skillCount >= skills.length)
    {
        return;
    }
    
    // Using a for loop
    skills.forEach(function (skill, index) {
        if (index === 0) {
            // Skip the first skill
            return;
        }

        var skillsContainer = `
            <div  class="input_wrap Multiable" id="skill${skillCount}"> 
                <h4> Skill ${skillCount + 1}: </h4>
                <input type="text" name="skills[${skillCount}]" class="input" id="company" maxlength="255" value="${skill}" required>           
             
                <ion-icon name="close-circle-outline" class="removeSkill remove" data-skill="${skillCount}"></ion-icon>         
            </div>
        `;

        $("#skillsContainer").append(skillsContainer);
        skillCount++;
    });
    $("#skillsContainer").on("click", ".removeSkill", function (e) {
        e.preventDefault();
        var skillId = $(this).data("skill");
        $("#skill" + skillId).remove();
    });
}
//   $(document).on("click", ".removeSkill", function(e) {
//        e.preventDefault();
//        var skillId = $(this).data("skill");
//        $("#skill" + skillId).remove();
//        
//    });


//});