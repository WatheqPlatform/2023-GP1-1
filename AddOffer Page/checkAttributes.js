document.addEventListener("DOMContentLoaded", function () {

// Get the attribute list element
    const attributeList = document.querySelector('.attribute-list');
    const ImportanceCheckbox = document.getElementById('checkboxContainer');
    const CustomizeCheckbox = document.getElementById('CustomizeBoxContainer');
// Define the initial list of attributes
    const initialAttributes = ['City'];
    generateAttributeList(initialAttributes);
    // Get the button element
    const btnNext = document.querySelector('#check');
// Add event listener to the button
    btnNext.addEventListener('click', checkAttributes);


    function generateAttributeList(attributes) {
        const attributeWeights = {};
        // Clear the existing attribute list
        attributeList.innerHTML = '';

        const numAttributes = attributes.length;
        
           if (numAttributes === 1)
        {
            ImportanceCheckbox.style.display = "none";
            CustomizeCheckbox.style.display = "none";
        } else {

            ImportanceCheckbox.style.display = "block";
            CustomizeCheckbox.style.display = "block";

        }

        // Calculate the total weight for the attributes
        let totalWeight = 0;

        if (numAttributes > 1) {
            const weightStep = 100 / (numAttributes * (numAttributes + 1) / 2);
            let weight = numAttributes * weightStep;

            attributes.forEach(attribute => {
                attributeWeights[attribute] = weight;
                totalWeight += weight;
                weight -= weightStep;
            });
        } else if (numAttributes === 1) {
            attributeWeights[attributes[0]] = 100;
            totalWeight = 100;
        }


        // Generate the new attribute list
        attributes.forEach(attribute => {
            const li = document.createElement('li');
            li.draggable = true;
            const percentage = ((attributeWeights[attribute] / totalWeight) * 100).toFixed(0);
            li.setAttribute('data-weight', attributeWeights[attribute]); // Set the data attribute

            const attributeSpan = document.createElement('span');
            attributeSpan.textContent = attribute;
            li.appendChild(attributeSpan);

            const percentageSpan = document.createElement('span');
            percentageSpan.textContent = `${percentage}%`;
            percentageSpan.classList.add('percentage'); // Add the 'percentage' class to the span
            li.appendChild(percentageSpan);

            attributeList.appendChild(li);
        });
        updatePercentages();
    }




    function checkAttributes() {
        var numberOfAttributes = 0;
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



        if (numberOfAttributes === 0)
        {
            ImportanceCheckbox.style.display = "none";
            CustomizeCheckbox.style.display = "none";
        } else {

            ImportanceCheckbox.style.display = "block";
            CustomizeCheckbox.style.display = "block";

        }

// Add event listener to the button again
        btnNext.addEventListener('click', checkAttributes);

    }

// Make the attribute list sortable
    const sortable = Sortable.create(attributeList, {
        animation: 150,
        onEnd: function (event) {
            // Update the attribute order based on the new sorting
            const attributeItems = Array.from(document.querySelectorAll('.attribute-list li'));
            // Update the attribute order based on the new sorting
            const attributes = Array.from(attributeList.getElementsByTagName('li')).map(li => li.textContent);
//      generateAttributeList(attributes);
// Update the weights based on the new order
            const totalWeight = attributeItems.length;
            attributeItems.forEach((item, index) => {
                const weight = ((totalWeight - index) / totalWeight) * 100;
                item.setAttribute('data-weight', weight);
                item.querySelector('.percentage').textContent = `${weight.toFixed(0)}%`;
            });

            updatePercentages();
//            const attributeOrder = Array.from(document.querySelectorAll('.attribute-list li')).map(li => {
//                const attribute = li.querySelector('span:first-child').textContent;
//                const percentage = li.querySelector('.percentage').textContent;
//                return `${percentage}`;
//            });
            const attributeOrder = Array.from(document.querySelectorAll('.attribute-list li')).map(li => {
                const attribute = li.querySelector('span:first-child').textContent;

                return `${attribute}`;
            });
            console.log(attributeOrder);
        }
    });

    function updatePercentages() {

        const attributeList = document.querySelector('.attribute-list');
        const attributeItems = Array.from(attributeList.getElementsByTagName('li'));

        attributeItems.sort((a, b) => {
            const weightA = parseFloat(a.getAttribute('data-weight'));
            const weightB = parseFloat(b.getAttribute('data-weight'));
            return weightB - weightA; // Sort in descending order based on weight (percentage)
        });

        // Calculate the total weight based on the updated attribute items
        let totalWeight = 0;
        attributeItems.forEach((item, index) => {
            const weight = ((attributeItems.length - index) / attributeItems.length) * 100;
            item.setAttribute('data-weight', weight);
            item.querySelector('.percentage').textContent = `${weight.toFixed(0)}%`;
            totalWeight += weight;
        });

        attributeItems.forEach((item, index) => {
            attributeList.appendChild(item); // Append the items in the new order
        });

        // Check if the total weight is not 100% and adjust the weights accordingly
        if (totalWeight !== 100) {
            const adjustmentFactor = 100 / totalWeight;
            attributeItems.forEach((item) => {
                const weight = parseFloat(item.getAttribute('data-weight')) * adjustmentFactor;
                item.setAttribute('data-weight', weight);
                item.querySelector('.percentage').textContent = `${weight.toFixed(0)}%`;
            });
        }
    }


    const minimumScoreSelect = document.getElementById('minimum-score-select');

    // Generate the options dynamically using a loop
    for (let i = 1; i <= 100; i++) {
        const option = document.createElement('option');
        option.value = i;
        option.textContent = i + "%";
        if (i === 50) {
            option.selected = true; // Set the default selected value to 50
        }
        minimumScoreSelect.appendChild(option);
    }


    const customizeBox = document.getElementById('Customize');

    customizeBox.addEventListener('change', function () {

        const DragAndDropDiv = document.getElementById('dragAndDrop');
        const custimozeDiv = document.getElementById('Customized_wrap');
        if (customizeBox.checked)
        {



            DragAndDropDiv.style.display = "none";



            custimozeDiv.style.display = "block";
            CustomizeWeights(initialAttributes);
        } else {


            DragAndDropDiv.style.display = "block";



            custimozeDiv.style.display = "none";
            const attributeList = document.querySelector('.customization-list');
            const selectListDiv = document.querySelector('.select-list-div');
            // Clear the existing attribute list
            attributeList.innerHTML = '';
            selectListDiv.innerHTML = '';

        }
    });

    function CustomizeWeights(Attributes) {



        const attributeList = document.querySelector('.customization-list');
        const selectListDiv = document.querySelector('.select-list-div');
        const selectValues = {}; // Object to store the select values


        Attributes.forEach(attribute => {
            const li = document.createElement('li');
            const attributeSpan = document.createElement('span');
            const select = document.createElement('select');

            attributeSpan.textContent = attribute;
            li.appendChild(attributeSpan);
            attributeList.appendChild(li);

            // Generate select options
            for (let i = 0; i <= 100; i++) {
                const option = document.createElement('option');
                option.value = i;
                option.textContent = i + "%";
                select.appendChild(option);
            }

            selectListDiv.appendChild(select);

        });



    }


    const sameImportanceCheckbox = document.getElementById('sameImportance');
    sameImportanceCheckbox.addEventListener('change', function () {
        const attributeList = document.querySelector('.attribute-list');
        const liElements = document.querySelectorAll('.attribute-list li');




        if (sameImportanceCheckbox.checked) {

            const numAttributes = liElements.length;
            const equalPercentage = 100 / numAttributes;

            // Disable dragging
            for (let i = 0; i < liElements.length; i++) {
                liElements[i].draggable = false;
            }

            // Set equal percentages
            for (let i = 0; i < liElements.length; i++) {
                liElements[i].setAttribute('data-weight', equalPercentage);
                liElements[i].querySelector('.percentage').textContent = `${equalPercentage.toFixed(0)}%`;
            }
            const attributeOrder = Array.from(document.querySelectorAll('.attribute-list li')).map(li => {
                const attribute = li.querySelector('span:first-child').textContent;
                const percentage = li.querySelector('.percentage').textContent;
                return `${percentage}`;
            });

            console.log(attributeOrder);

        } else {


            generateAttributeList(initialAttributes);
        }
    });




});



