window.onload = function () {
    const studentId = sessionStorage.getItem("studentId");

    if (!studentId) {
        alert("Access denied. Please enroll first.");
        window.location.href = 'enroll.html';
        return;
    }

    // Fill the hidden input already in HTML
    document.getElementById("studentIdInput").value = studentId;
};

