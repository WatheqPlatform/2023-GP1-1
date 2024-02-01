document.addEventListener("DOMContentLoaded", function () {



    const attributeList = document.querySelector('.attribute-list');

    let draggedItem = null;

    attributeList.addEventListener('dragstart', (e) => {
        draggedItem = e.target;
        e.dataTransfer.effectAllowed = 'move';
        e.dataTransfer.setData('text/plain', e.target.textContent);
        e.target.classList.add('dragging');
    });

    attributeList.addEventListener('dragover', (e) => {
        e.preventDefault();
        const afterElement = getDragAfterElement(attributeList, e.clientY);
        const draggableItem = document.querySelector('.dragging');
        if (afterElement === null) {
            attributeList.appendChild(draggableItem);
        } else {
            attributeList.insertBefore(draggableItem, afterElement);
        }
    });

    attributeList.addEventListener('dragend', (e) => {
        draggedItem.classList.remove('dragging');
        draggedItem = null;
    });

    function getDragAfterElement(container, y) {
        const draggableElements = Array.from(container.querySelectorAll('li:not(.dragging)'));

        return draggableElements.reduce((closest, child) => {
            const box = child.getBoundingClientRect();
            const offset = y - box.top - box.height / 2;
            if (offset < 0 && offset > closest.offset) {
                return {offset: offset, element: child};
            } else {
                return closest;
            }
        }, {offset: Number.NEGATIVE_INFINITY}).element;
    }


});