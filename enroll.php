<?php
session_start();
include 'db.php';

if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $username = trim($_POST['username']);
    $password = trim($_POST['password']);

    // Check in students table
    $stmt = $conn->prepare("SELECT * FROM students WHERE studentId = ?");
    $stmt->bind_param("s", $username);
    $stmt->execute();
    $studentResult = $stmt->get_result();

    if ($student = $studentResult->fetch_assoc()) {
        if ($student['status'] === 'Enrolled') {
            echo "<script>
                alert('You are already enrolled');
                window.location.href = 'login.html';
            </script>";
            exit();
        } else if ($student['status'] === 'Not Enrolled' && $password === $student['password']) {
            echo "<script>
                sessionStorage.setItem('studentId', '$username');
                window.location.href = 'st_info.html';
            </script>";
            exit();
        } else {
            echo "<script>alert('Incorrect password'); window.location.href='enroll.html';</script>";
            exit();
        }
    }

    // Check in staff table
    $stmt = $conn->prepare("SELECT * FROM staff WHERE staffId = ?");
    $stmt->bind_param("s", $username);
    $stmt->execute();
    $staffResult = $stmt->get_result();

    if ($staff = $staffResult->fetch_assoc()) {
        if ($staff['status'] === 'Enrolled') {
            echo "<script>
                alert('You are already enrolled');
                window.location.href = 'login.html';
            </script>";
            exit();
        } else if ($staff['status'] === 'Not Enrolled' && $password === $staff['password']) {
            echo "<script>
                sessionStorage.setItem('staffId', '$username');
                window.location.href = 'staff_Info.html';
            </script>";
            exit();
        } else {
            echo "<script>alert('Incorrect password'); window.location.href='enroll.html';</script>";
            exit();
        }
    }

    // If no match in either table
    echo "<script>alert('Username not found'); window.location.href='enroll.html';</script>";
    exit();
}
?>
