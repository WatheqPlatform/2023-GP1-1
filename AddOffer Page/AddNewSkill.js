$(document).ready(function() {
    var skillCount = 1;
    
    $("#addSkill").click(function(e) {
        e.preventDefault();

        var skillsContainer = `
            <div  class="input_wrap Multiable" id="skill${skillCount}"> 
                <h4> Skill ${skillCount+1}: </h4>
                <input type="text" name="skills[${skillCount}]" class="input" id="company" maxlength="255" required>           
             
                <ion-icon name="close-circle-outline" class="removeSkill remove" data-skill="${skillCount}"></ion-icon>         
            </div>
        `;

        $("#skillsContainer").append(skillsContainer);
        skillCount++;
    });

    $(document).on("click", ".removeSkill", function(e) {
        e.preventDefault();
        var skillId = $(this).data("skill");
        $("#skill" + skillId).remove();
        
    });
});
