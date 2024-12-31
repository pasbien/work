document.addEventListener('DOMContentLoaded', function () {
    // Обробка форми для додавання екскурсій
    const excursionForm = document.querySelector('#excursionForm');
    if (excursionForm) {
        excursionForm.addEventListener('submit', function (e) {
            e.preventDefault();
            const location = document.querySelector('#location').value;
            const guide = document.querySelector('#guide').value;
            const price = document.querySelector('#price').value;

            if (!location || !guide || !price) {
                alert("All fields are required!");
                return;
            }

            // Логіка для додавання екскурсії (відправка на сервер)
            const formData = new FormData();
            formData.append('location', location);
            formData.append('guide', guide);
            formData.append('price', price);

            fetch('/excursions/add', {
                method: 'POST',
                body: formData,
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert("Excursion added successfully!");
                    window.location.reload();
                } else {
                    alert("Failed to add excursion.");
                }
            })
            .catch(error => {
                console.error("Error:", error);
                alert("An error occurred while adding the excursion.");
            });
        });
    }

    // Пошук серед клієнтів
    const searchInput = document.querySelector('#searchCustomer');
    if (searchInput) {
        searchInput.addEventListener('input', function () {
            const filter = searchInput.value.toLowerCase();
            const rows = document.querySelectorAll('.customer-row');
            rows.forEach(row => {
                const nameCell = row.querySelector('.customer-name');
                const name = nameCell ? nameCell.textContent.toLowerCase() : '';
                if (name.includes(filter)) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        });
    }

    // Обробка форми для додавання клієнтів
    const customerForm = document.querySelector('#customerForm');
    if (customerForm) {
        customerForm.addEventListener('submit', function (e) {
            e.preventDefault();
            const firstName = document.querySelector('#first_name').value;
            const lastName = document.querySelector('#last_name').value;
            const email = document.querySelector('#email').value;
            const phone = document.querySelector('#phone').value;

            if (!firstName || !lastName || !email || !phone) {
                alert("All fields are required!");
                return;
            }

            const formData = new FormData();
            formData.append('first_name', firstName);
            formData.append('last_name', lastName);
            formData.append('email', email);
            formData.append('phone', phone);

            fetch('/customers/add', {
                method: 'POST',
                body: formData,
            })
            .then(response => response.json())
            .then(data => {
                if (data.success) {
                    alert("Customer added successfully!");
                    window.location.reload();
                } else {
                    alert("Failed to add customer.");
                }
            })
            .catch(error => {
                console.error("Error:", error);
                alert("An error occurred while adding the customer.");
            });
        });
    }

    // Обробка події видалення клієнта
    const deleteButtons = document.querySelectorAll('.delete-button');
    deleteButtons.forEach(button => {
        button.addEventListener('click', function (e) {
            const confirmation = confirm("Are you sure you want to delete this customer?");
            if (!confirmation) {
                e.preventDefault();
            }
        });
    });

    // Обробка події видалення екскурсії
    const deleteExcursionButtons = document.querySelectorAll('.delete-excursion-button');
    deleteExcursionButtons.forEach(button => {
        button.addEventListener('click', function (e) {
            const confirmation = confirm("Are you sure you want to delete this excursion?");
            if (!confirmation) {
                e.preventDefault();
            }
        });
    });
});
