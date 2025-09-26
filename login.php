<?php
// START SESSION FIRST
session_start();

// Connect to MySQL database
 include 'db.php'; 

// Check if login form was submitted
if (isset($_POST['btnn'])) {
    $username = mysqli_real_escape_string($conn, $_POST['username']);
    $password = mysqli_real_escape_string($conn, $_POST['password']);

    
    // Option 1: Check in staff table
    $staffQuery = "SELECT * FROM staff WHERE staffId = '$username'";
    $staffResult = mysqli_query($conn, $staffQuery);

    if (mysqli_num_rows($staffResult) > 0) {
        $staffRow = mysqli_fetch_assoc($staffResult);
        
        // Check status first
        if ($staffRow['status'] === 'Not Enrolled') {
            echo "<script>alert('You have not enrolled yet.'); window.location.href='enroll.html';</script>";
            exit();
        }
        
        // If enrolled, check hashed password
        if (password_verify($password, $staffRow['password'])) {
            // SET SESSION VARIABLES FOR STAFF
            $_SESSION['staffId'] = $staffRow['staffId']; // Store the actual staff ID
            $_SESSION['logged_in'] = true;
            $_SESSION['user_type'] = 'staff'; // Optional: track user type

            header("Location: staff_home.html");
            exit();
        } else {
            echo "<script>alert('Incorrect password'); window.location.href='login.html';</script>";
            exit();
        }
    }
    // Option 2: Check in students table
     $studentQuery = "SELECT * FROM students WHERE studentId = '$username'";
    $studentResult = mysqli_query($conn, $studentQuery);

    if (mysqli_num_rows($studentResult) > 0) {
        $studentRow = mysqli_fetch_assoc($studentResult);
        
        // Check status first
        if ($studentRow['status'] === 'Not Enrolled') {
            echo "<script>alert('You have not enrolled yet.'); window.location.href='enroll.html';</script>";
            exit();
        }
        
        // If enrolled, check hashed password
        if (password_verify($password, $studentRow['password'])) {
            // SET SESSION VARIABLES FOR STUDENT
            $_SESSION['studentId'] = $studentRow['studentId']; // Store the actual student ID
            $_SESSION['logged_in'] = true;
            $_SESSION['user_type'] = 'student'; // Optional: track user type
            
            header("Location: student_home.html");
            exit();
        } else {
            echo "<script>alert('Incorrect password'); window.location.href='login.html';</script>";
            exit();
        }
    }


    // If no match in either table
    echo "<script>alert('User not found'); window.location.href='login.html';</script>";
}
?>
