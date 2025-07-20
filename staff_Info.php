<?php
session_start();
// Connect to MySQL database
 include 'db.php'; 

// Check if form was submitted
if ($_SERVER["REQUEST_METHOD"] == "POST") {

    // Get staffId from session
    if (!isset($_POST['staffId'])) {
        echo "<script>alert('Unauthorized access.'); window.location.href='enroll.html';</script>";
        exit();
    }

    $staffId = mysqli_real_escape_string($conn, $_POST['staffId']);
    $name     = mysqli_real_escape_string($conn, $_POST['name']);
    $email    = mysqli_real_escape_string($conn, $_POST['email']);
    $password = mysqli_real_escape_string($conn, $_POST['password']);
    $confirm  = mysqli_real_escape_string($conn, $_POST['confirm']);

    // Check if passwords match
    if ($password !== $confirm) {
        echo "<script>alert('Passwords do not match'); window.history.back();</script>";
        exit();
    }

    //hash password
    $hashedPassword = password_hash($password, PASSWORD_DEFAULT);

    //UPDATE records
    $sql = "UPDATE staff
            SET name = '$name', email = '$email', password = '$hashedPassword', status = 'Enrolled'
            WHERE staffId = '$staffId'";

    if (mysqli_query($conn, $sql)) {
        unset($_SESSION['staffId']);
        header("Location:staff_home.html");
        exit();
    } else {
        echo "Error: " . mysqli_error($conn);
    }
}
mysqli_close($conn);
?>
