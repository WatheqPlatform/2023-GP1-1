document.addEventListener("DOMContentLoaded", function () {
// Get the attribute list element
    const attributeList = document.querySelector('.attribute-list');
    const Checkbox = document.getElementById('checkboxContainer');
// Define the initial list of attributes
    const initialAttributes = ['City'];
    generateAttributeList(initialAttributes);

    function generateAttributeList(attributes) {
        // Clear the existing attribute list
        attributeList.innerHTML = '';
        // Generate the new attribute list
        attributes.forEach(attribute => {
            const li = document.createElement('li');
            li.textContent = attribute;
            li.draggable = true;
            attributeList.appendChild(li);
        });
    }
// Get the button element
    const btnNext = document.querySelector('#check');
// Add event listener to the button
    btnNext.addEventListener('click', checkAttributes);


    function checkAttributes() {
         var numberOfAttributes= 0;
        // Code for function a
        const skillsInput = document.getElementById('skillInput');
        const hasSkills = skillsInput.value.trim() !== '';

        if (hasSkills && !initialAttributes.includes('Skills')) {
            // Add 'Skills' to the attribute list
            initialAttributes.push('Skills');
            generateAttributeList(initialAttributes);
            numberOfAttributes++;

        } else if (!hasSkills && initialAttributes.includes('Skills')) {
            // Remove 'Skills' from the attribute list
            const index = initialAttributes.indexOf('Skills');
            if (index !== -1) {
                initialAttributes.splice(index, 1);
                generateAttributeList(initialAttributes);
            }
        }


        const qualDInput = document.getElementById('degreeLevel0');
        const hasQual = qualDInput.value !== "";

        const qualFInput = document.getElementById('degreeField0');
        const hasQual2 = qualFInput.value !== "";


        if ((hasQual || hasQual2) && !initialAttributes.includes('Qualifications')) {

            initialAttributes.push('Qualifications');
            generateAttributeList(initialAttributes);
            numberOfAttributes++;
        } else if (!hasQual && !hasQual2) {
            // Remove 'Qualification' from the attribute list
            const index = initialAttributes.indexOf('Qualifications');
            if (index !== -1) {
                initialAttributes.splice(index, 1);

                generateAttributeList(initialAttributes);
            }
        }

        const ExpCInput = document.getElementById('experienceCategory0');
        const hasExp = ExpCInput.value !== "";

        const ExpTInput = document.getElementById('EJobTitle');
        const hasExp2 = ExpTInput.value !== "";

        const ExpYInput = document.getElementById('EYears');
        const hasExp3 = ExpYInput.value.trim() !== "";




        if ((hasExp || hasExp2 || hasExp3) && !initialAttributes.includes('Experiences')) {
            initialAttributes.push('Experiences');
            generateAttributeList(initialAttributes);
            numberOfAttributes++;

        } else if (!hasExp && !hasExp2 && !hasExp3) {
            // Remove 'Experience' from the attribute list
            const index = initialAttributes.indexOf('Experiences');
            if (index !== -1) {
                initialAttributes.splice(index, 1);

                generateAttributeList(initialAttributes);
            }

        }

        const attributeOrder = Array.from(document.querySelectorAll('.attribute-list li')).map(li => li.textContent);
        console.log(attributeOrder);
        
 if (numberOfAttributes === 0)
 {
     Checkbox.style.display = "none";
 }
 else {
        Checkbox.style.display = "block";
    }
 
// Add event listener to the button again
        btnNext.addEventListener('click', checkAttributes);
    }




});

