<?php
// Connect to MySQL database
$conn = mysqli_connect("localhost", "root", "Chandu@2002", "mydb");

// Check connection
if (!$conn) {
    die("Connection failed: " . mysqli_connect_error());
}

// Check if form was submitted
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    $staffId  = mysqli_real_escape_string($conn, $_POST['staffId']);
    $name     = mysqli_real_escape_string($conn, $_POST['name']);
    $email    = mysqli_real_escape_string($conn, $_POST['email']);
    $password = mysqli_real_escape_string($conn, $_POST['password']);
    $confirm  = mysqli_real_escape_string($conn, $_POST['confirm']);

    // Check if passwords match
    if ($password !== $confirm) {
        echo "<script>alert('Passwords do not match'); window.history.back();</script>";
        exit();
    }

    // ✅ UPDATE existing record instead of INSERT
    $sql = "UPDATE faculty 
            SET name = '$name', email = '$email', password = '$password' 
            WHERE staffId = '$staffId'";

    if (mysqli_query($conn, $sql)) {
        header("Location:admin.html");
        exit();
    } else {
        echo "Error: " . mysqli_error($conn);
    }
}
mysqli_close($conn);
?>
