<?php
session_start();
// Connect to MySQL database
include 'db.php'; 

// Check if form was submitted
if ($_SERVER["REQUEST_METHOD"] == "POST") {

    // Get studentId from session
    if (!isset($_POST['studentId'])) {
        echo "<script>alert('Unauthorized access.'); window.location.href='enroll.html';</script>";
        exit();
    }

    $studentId = mysqli_real_escape_string($conn, $_POST['studentId']);
    $name      = mysqli_real_escape_string($conn, $_POST['name']);
    $email     = mysqli_real_escape_string($conn, $_POST['email']);
    $department = mysqli_real_escape_string($conn, $_POST['departmentId']);
    $batch     = mysqli_real_escape_string($conn, $_POST['batchId']);
    $password  = mysqli_real_escape_string($conn, $_POST['password']);
    $confirm   = mysqli_real_escape_string($conn, $_POST['confirm']);

    // Check if passwords match
    if ($password !== $confirm) {
        echo "<script>alert('Passwords do not match'); window.history.back();</script>";
        exit();
    }

    //hash password
    $hashedPassword = password_hash($password, PASSWORD_DEFAULT);

    //UPDATE records
    $sql = "UPDATE students
            SET name = '$name', email = '$email', departmentId = '$department',
                batchId = '$batch', password = '$hashedPassword', status = 'Enrolled'
            WHERE studentId = '$studentId'";



    if (mysqli_query($conn, $sql)) {
        unset($_SESSION['studentId']);
        header("Location:student_home.html");
        exit();
    } else {
        echo "Error: " . mysqli_error($conn);
    }
}
mysqli_close($conn);
?>
