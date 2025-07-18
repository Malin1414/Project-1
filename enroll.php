<?php
include 'db.php';

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $username = trim($_POST['username']);
    $password = trim($_POST['password']);

    // Check in students table
    $stmt = $conn->prepare("SELECT * FROM students WHERE studentId = ? AND password = ?");
    $stmt->bind_param("ss", $username, $password);
    $stmt->execute();
    $studentResult = $stmt->get_result();

    if ($student = $studentResult->fetch_assoc()) {
        if ($student['status'] === 'Enrolled') {
            echo "<script>alert('You are already enrolled as a student.'); window.location.href='enroll.html';</script>";
        } else {
            header("Location: st_info.html");
            exit();
        }
    }

    // Check in staff table
    $stmt = $conn->prepare("SELECT * FROM staff WHERE staffId = ? AND password = ?");
    $stmt->bind_param("ss", $username, $password);
    $stmt->execute();
    $staffResult = $stmt->get_result();

    if ($staff = $staffResult->fetch_assoc()) {
        if ($staff['status'] === 'Enrolled') {
            echo "<script>alert('You are already enrolled as a staff member.'); window.location.href='enroll.html';</script>";
        } else {
            header("Location: Admin_info.html");
            exit();
        }
    }

    // If no match in either table
    echo "<script>alert('Incorrect username or password.'); window.location.href='enroll.html';</script>";
}
?>
