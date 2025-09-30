<?php
session_start();

// Check if staff is logged in
if (!isset($_SESSION['staffId']) || !isset($_SESSION['logged_in']) || $_SESSION['logged_in'] !== true) {
    if (isset($_POST['action'])) {
        echo json_encode(['error' => 'Not logged in']);
        exit();
    }
    header('Location: login.php');
    exit();
}

// Include database connection
include 'db.php';

// Get staffId from session
$staffId = $_SESSION['staffId'];

// Handle AJAX requests
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['action'])) {
    header('Content-Type: application/json');
    
    switch ($_POST['action']) {
        case 'get_profile':
            try {
                $stmt = $conn->prepare("SELECT staffId, name, email, status, profile_picture FROM staff WHERE staffId = ?");
                $stmt->bind_param("s", $staffId);
                $stmt->execute();
                $result = $stmt->get_result();

                if ($staff = $result->fetch_assoc()) {
                    // Ensure all fields exist even if NULL
                    $staff = array_merge([
                        'staffId' => '',
                        'name' => '',
                        'email' => '',
                        'status' => '',
                        'profile_picture' => ''
                    ], $staff);

                    echo json_encode(['success' => true, 'staff' => $staff]);
                } else {
                    echo json_encode(['success' => false, 'message' => 'Staff profile not found']);
                }
                $stmt->close();
            } catch (Exception $e) {
                echo json_encode(['success' => false, 'message' => 'Error loading profile: ' . $e->getMessage()]);
            }
            break;
            
        case 'update_profile_picture':
            try {
                if (isset($_FILES['profile_picture']) && $_FILES['profile_picture']['error'] === UPLOAD_ERR_OK) {
                    $uploadDir = 'uploads/profiles/';
                    if (!is_dir($uploadDir)) {
                        mkdir($uploadDir, 0755, true);
                    }
                    
                    // Validate file type
                    $allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif'];
                    $fileType = $_FILES['profile_picture']['type'];
                    
                    if (!in_array($fileType, $allowedTypes)) {
                        echo json_encode(['success' => false, 'message' => 'Invalid file type. Only JPG, PNG, and GIF are allowed.']);
                        break;
                    }
                    
                    // Check file size (max 2MB)
                    if ($_FILES['profile_picture']['size'] > 2 * 1024 * 1024) {
                        echo json_encode(['success' => false, 'message' => 'File size too large. Maximum 2MB allowed.']);
                        break;
                    }
                    
                    $fileExtension = pathinfo($_FILES['profile_picture']['name'], PATHINFO_EXTENSION);
                    $fileName = $staffId . '_' . time() . '.' . $fileExtension;
                    $uploadPath = $uploadDir . $fileName;
                    
                    if (move_uploaded_file($_FILES['profile_picture']['tmp_name'], $uploadPath)) {
                        // Update database with profile picture path
                        $stmt = $conn->prepare("UPDATE staff SET profile_picture = ? WHERE staffId = ?");
                        $stmt->bind_param("ss", $uploadPath, $staffId);
                        
                        if ($stmt->execute()) {
                            echo json_encode(['success' => true, 'message' => 'Profile picture updated successfully', 'profile_picture' => $uploadPath]);
                        } else {
                            echo json_encode(['success' => false, 'message' => 'Failed to update profile picture in database']);
                        }
                        $stmt->close();
                    } else {
                        echo json_encode(['success' => false, 'message' => 'Failed to upload file']);
                    }
                } else {
                    echo json_encode(['success' => false, 'message' => 'No file uploaded or upload error']);
                }
            } catch (Exception $e) {
                echo json_encode(['success' => false, 'message' => 'Error updating profile picture: ' . $e->getMessage()]);
            }
            break;
            
        default:
            echo json_encode(['success' => false, 'message' => 'Invalid action']);
    }
    exit();
}

// If accessed directly, redirect to HTML page
header('Location: staff-profile.html');
exit();
?>