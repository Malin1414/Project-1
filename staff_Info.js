window.onload = function () {
    const staffId = sessionStorage.getItem("staffId");

    if (!staffId) {
        alert("Access denied. Please enroll first.");
        window.location.href = 'enroll.html';
        return;
    }

    document.getElementById("staffIdInput").value = staffId;
};
