<?php
// Connect to MySQL (with database selected)
$conn = mysqli_connect("localhost", "root", "", "mydb");

// Check connection
if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}

// Check if login form was submitted
if (isset($_POST['btnn'])) {
    $username = mysqli_real_escape_string($conn, $_POST['username']);
    $password = mysqli_real_escape_string($conn, $_POST['password']);

    // Option 1: Hardcoded admin credentials
    if ($username === 'admin' && $password === 'admin123') {
        header("Location: admin.html");
        exit();
    }

    // Option 2: Check in admin table
    $adminQuery = "SELECT * FROM admin WHERE adminId = '$username'";
    $adminResult = mysqli_query($conn, $adminQuery);

    if (mysqli_num_rows($adminResult) > 0) {
        $adminRow = mysqli_fetch_assoc($adminResult);
        if ($password == $adminRow['password']) {
            header("Location: admin.html");
            exit();
        } else {
            echo "<script>alert('Incorrect password'); window.location.href='index.php';</script>";
            exit();
        }
    }

    // Option 3: Check in students table
    $studentQuery = "SELECT * FROM students WHERE studentId = '$username'";
    $studentResult = mysqli_query($conn, $studentQuery);

    if (mysqli_num_rows($studentResult) > 0) {
        $studentRow = mysqli_fetch_assoc($studentResult);
        if ($password == $studentRow['password']) {
            header("Location: student.html");
            exit();
        } else {
            echo "<script>alert('Incorrect password'); window.location.href='index.php';</script>";
            exit();
        }
    }

    // If no match in either table
    echo "<script>alert('User not found'); window.location.href='index.php';</script>";
}
?>
