<?php
session_start();

// Check if user is logged in
if (!isset($_SESSION['logged_in']) || $_SESSION['logged_in'] !== true) {
    echo json_encode([
        'success' => false,
        'message' => 'Unauthorized access. Please login first.'
    ]);
    exit();
}

// Check if user_type is set
if (!isset($_SESSION['user_type'])) {
    echo json_encode([
        'success' => false,
        'message' => 'Session error. Please login again.'
    ]);
    exit();
}

// Database connection
include 'db.php';

// Get POST data
$currentPassword = $_POST['currentPassword'] ?? '';
$newPassword = $_POST['newPassword'] ?? '';
$confirmPassword = $_POST['confirmPassword'] ?? '';

// Validate input
if (empty($currentPassword) || empty($newPassword) || empty($confirmPassword)) {
    echo json_encode([
        'success' => false,
        'message' => 'All fields are required.'
    ]);
    exit();
}

// Check if new passwords match
if ($newPassword !== $confirmPassword) {
    echo json_encode([
        'success' => false,
        'message' => 'New passwords do not match.'
    ]);
    exit();
}

// Validate password strength (minimum 8 characters)
if (strlen($newPassword) < 8) {
    echo json_encode([
        'success' => false,
        'message' => 'Password must be at least 8 characters long.'
    ]);
    exit();
}

// Get user details from session
$userType = $_SESSION['user_type']; // 'student' or 'staff'

// Determine which table and ID to use
if ($userType === 'student') {
    $userId = $_SESSION['studentId'];
    $table = 'students';
    $idColumn = 'studentId';
} else if ($userType === 'staff') {
    $userId = $_SESSION['staffId'];
    $table = 'staff';
    $idColumn = 'staffId';
} else {
    echo json_encode([
        'success' => false,
        'message' => 'Invalid user type.'
    ]);
    exit();
}

// Escape the user ID for security
$userId = mysqli_real_escape_string($conn, $userId);

// Fetch current password hash from database
$query = "SELECT password FROM $table WHERE $idColumn = '$userId'";
$result = mysqli_query($conn, $query);

if (!$result || mysqli_num_rows($result) === 0) {
    echo json_encode([
        'success' => false,
        'message' => 'User not found.'
    ]);
    exit();
}

$user = mysqli_fetch_assoc($result);

// Verify current password
if (!password_verify($currentPassword, $user['password'])) {
    echo json_encode([
        'success' => false,
        'message' => 'Current password is incorrect.'
    ]);
    exit();
}

// Hash new password
$hashedPassword = password_hash($newPassword, PASSWORD_DEFAULT);

// Update password in database
$updateQuery = "UPDATE $table SET password = '$hashedPassword' WHERE $idColumn = '$userId'";
$updateResult = mysqli_query($conn, $updateQuery);

if ($updateResult) {
    echo json_encode([
        'success' => true,
        'message' => 'Password changed successfully!'
    ]);
} else {
    echo json_encode([
        'success' => false,
        'message' => 'Failed to update password. Please try again.'
    ]);
}

// Close connection
mysqli_close($conn);
?>