<?php
session_start();

// Include database connection
include 'db.php';

// Check if staff is logged in
if (!isset($_SESSION['staffId']) || !isset($_SESSION['logged_in']) || $_SESSION['logged_in'] !== true) {
    header('Location: login.php');
    exit();
}

// Process form submission
if ($_SERVER["REQUEST_METHOD"] == "POST") {
    try {
        // Get form data
        $noticeTitle = trim($_POST['noticeTitle']);
        $description = trim($_POST['description']);
        $departments = isset($_POST['department']) ? $_POST['department'] : [];
        $batches = isset($_POST['batch']) ? $_POST['batch'] : [];
        $staffId = $_SESSION['staffId'];
        
        // Validate required fields
        if (empty($noticeTitle) || empty($description) || empty($departments) || empty($batches)) {
            throw new Exception("Please fill in all required fields and select at least one department and batch.");
        }
        
        // Handle file upload if provided
        $attachmentPath = null;
        if (isset($_FILES['attachment']) && $_FILES['attachment']['error'] == UPLOAD_ERR_OK) {
            $uploadDir = 'uploads/notices/';
            
            // Create directory if it doesn't exist
            if (!is_dir($uploadDir)) {
                if (!mkdir($uploadDir, 0777, true)) {
                    throw new Exception("Failed to create upload directory.");
                }
            }
            
            // Generate unique filename
            $fileExtension = strtolower(pathinfo($_FILES['attachment']['name'], PATHINFO_EXTENSION));
            $fileName = time() . '_' . uniqid() . '.' . $fileExtension;
            $targetPath = $uploadDir . $fileName;
            
            // Validate file size (limit to 10MB)
            if ($_FILES['attachment']['size'] > 10485760) {
                throw new Exception("File size too large. Maximum size is 10MB.");
            }
            
            // Validate file type
            $allowedTypes = ['pdf', 'doc', 'docx', 'txt', 'jpg', 'jpeg', 'png', 'gif'];
            
            if (!in_array($fileExtension, $allowedTypes)) {
                throw new Exception("File type not allowed. Allowed types: " . implode(', ', $allowedTypes));
            }
            
            // Move uploaded file
            if (move_uploaded_file($_FILES['attachment']['tmp_name'], $targetPath)) {
                $attachmentPath = $targetPath;
            } else {
                throw new Exception("Error uploading file. Please try again.");
            }
        }
        
        // Start database transaction
        $conn->begin_transaction();
        
        // Insert notice into notice table
        $stmt = $conn->prepare("INSERT INTO notice (title, description, date, staffId, attachment) VALUES (?, ?, CURDATE(), ?, ?)");
        if (!$stmt) {
            throw new Exception("Database prepare failed: " . $conn->error);
        }
        
        $stmt->bind_param("ssss", $noticeTitle, $description, $staffId, $attachmentPath);
        
        if (!$stmt->execute()) {
            throw new Exception("Error saving notice: " . $stmt->error);
        }
        
        $noticeId = $conn->insert_id;
        $stmt->close();
        
        // Insert selected departments
        $deptStmt = $conn->prepare("INSERT INTO notice_departments (noticeId, departmentId) VALUES (?, ?)");
        if (!$deptStmt) {
            throw new Exception("Database prepare failed for departments: " . $conn->error);
        }
        
        foreach ($departments as $departmentName) {
            // Get department ID
            $getDeptStmt = $conn->prepare("SELECT departmentId FROM departments WHERE departmentName = ?");
            $getDeptStmt->bind_param("s", $departmentName);
            $getDeptStmt->execute();
            $result = $getDeptStmt->get_result();
            
            if ($row = $result->fetch_assoc()) {
                $departmentId = $row['departmentId'];
                $deptStmt->bind_param("ii", $noticeId, $departmentId);
                
                if (!$deptStmt->execute()) {
                    throw new Exception("Error linking department: " . $deptStmt->error);
                }
            }
            $getDeptStmt->close();
        }
        $deptStmt->close();
        
        // Insert selected batches with batch name mapping
        $batchStmt = $conn->prepare("INSERT INTO notice_batches (noticeId, batchId) VALUES (?, ?)");
        if (!$batchStmt) {
            throw new Exception("Database prepare failed for batches: " . $conn->error);
        }
        
        foreach ($batches as $batchName) {
            // Map form batch names to database batch names
            $dbBatchName = $batchName;
            if ($batchName == '2021/22') $dbBatchName = '2021/2022';
            if ($batchName == '2022/23') $dbBatchName = '2022/2023';
            if ($batchName == '2023/24') $dbBatchName = '2023/2024';
            
            // Check if batch exists in database
            $getBatchStmt = $conn->prepare("SELECT batchId FROM batch WHERE batch = ?");
            $getBatchStmt->bind_param("s", $dbBatchName);
            $getBatchStmt->execute();
            $result = $getBatchStmt->get_result();
            
            if ($row = $result->fetch_assoc()) {
                $batchId = $row['batchId'];
            } else {
                // Create new batch if it doesn't exist
                $createBatchStmt = $conn->prepare("INSERT INTO batch (batch) VALUES (?)");
                $createBatchStmt->bind_param("s", $dbBatchName);
                $createBatchStmt->execute();
                $batchId = $conn->insert_id;
                $createBatchStmt->close();
            }
            $getBatchStmt->close();
            
            // Link batch to notice
            $batchStmt->bind_param("ii", $noticeId, $batchId);
            if (!$batchStmt->execute()) {
                throw new Exception("Error linking batch: " . $batchStmt->error);
            }
        }
        $batchStmt->close();
        
        // Commit all changes
        $conn->commit();
        
        // Set success message
        $_SESSION['success_message'] = "Notice added successfully!" . 
            ($attachmentPath ? " File uploaded: " . basename($attachmentPath) : "");
        
        // Redirect to staff home
        header('Location: staff_home.html');
        exit();
        
    } catch (Exception $e) {
        // Rollback transaction on error
        if (isset($conn)) {
            $conn->rollback();
        }
        
        // Delete uploaded file if there was an error after upload
        if (isset($attachmentPath) && file_exists($attachmentPath)) {
            unlink($attachmentPath);
        }
        
        // Set error message
        $_SESSION['error_message'] = "Error: " . $e->getMessage();
        
        // Redirect back to form
        header('Location: Add Notice.html');
        exit();
    }
} else {
    // If not POST request, redirect to form
    header('Location: Add Notice.html');
    exit();
}

// Close database connection
if (isset($conn)) {
    $conn->close();
}
?>