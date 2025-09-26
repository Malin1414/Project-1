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

$staffId = $_SESSION['staffId']; 

// Handle AJAX requests for notice management
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['action'])) {
    header('Content-Type: application/json');
    
    switch ($_POST['action']) {
        case 'get_notices':
            try {
                $stmt = $conn->prepare("SELECT noticeId, title, description, date, attachment FROM notice WHERE staffId = ? ORDER BY date DESC");
                $stmt->bind_param("s", $staffId);
                $stmt->execute();
                $result = $stmt->get_result();
                
                $notices = [];
                while ($row = $result->fetch_assoc()) {
                    $row['formattedDate'] = date('d-M-Y', strtotime($row['date']));
                    $notices[] = $row;
                }
                
                echo json_encode(['success' => true, 'notices' => $notices]);
                $stmt->close();
            } catch (Exception $e) {
                echo json_encode(['success' => false, 'message' => 'Error loading notices: ' . $e->getMessage()]);
            }
            break;
            
        case 'get_notice':
            try {
                $noticeId = intval($_POST['noticeId']);
                $stmt = $conn->prepare("SELECT * FROM notice WHERE noticeId = ? AND staffId = ?");
                $stmt->bind_param("is", $noticeId, $staffId);
                $stmt->execute();
                $result = $stmt->get_result();
                
                if ($notice = $result->fetch_assoc()) {
                    // Get associated departments
                    $stmt2 = $conn->prepare("SELECT departmentId FROM notice_departments WHERE noticeId = ?");
                    $stmt2->bind_param("i", $noticeId);
                    $stmt2->execute();
                    $deptResult = $stmt2->get_result();
                    $departments = [];
                    while ($row = $deptResult->fetch_assoc()) {
                        $departments[] = $row['departmentId'];
                    }
                    $stmt2->close();
                    
                    // Get associated batches
                    $stmt3 = $conn->prepare("SELECT batchId FROM notice_batches WHERE noticeId = ?");
                    $stmt3->bind_param("i", $noticeId);
                    $stmt3->execute();
                    $batchResult = $stmt3->get_result();
                    $batches = [];
                    while ($row = $batchResult->fetch_assoc()) {
                        $batches[] = $row['batchId'];
                    }
                    $stmt3->close();
                    
                    $notice['departments'] = $departments;
                    $notice['batches'] = $batches;
                    
                    echo json_encode(['success' => true, 'notice' => $notice]);
                } else {
                    echo json_encode(['success' => false, 'message' => 'Notice not found']);
                }
                $stmt->close();
            } catch (Exception $e) {
                echo json_encode(['success' => false, 'message' => 'Error loading notice: ' . $e->getMessage()]);
            }
            break;

        case 'get_departments_batches':
            try {
                // Get departments
                $stmt = $conn->prepare("SELECT departmentId as id, departmentName as name FROM departments ORDER BY departmentName");
                $stmt->execute();
                $departments = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
                $stmt->close();
                
                // Get batches
                $stmt = $conn->prepare("SELECT batchId as id, batch as name FROM batch ORDER BY batch");
                $stmt->execute();
                $batches = $stmt->get_result()->fetch_all(MYSQLI_ASSOC);
                $stmt->close();
                
                echo json_encode(['success' => true, 'departments' => $departments, 'batches' => $batches]);
            } catch (Exception $e) {
                echo json_encode(['success' => false, 'message' => 'Error loading departments and batches: ' . $e->getMessage()]);
            }
            break;
            
        case 'update':
            try {
                $noticeId = intval($_POST['noticeId']);
                $title = trim($_POST['title']);
                $description = trim($_POST['description']);
                // Date is automatically set to current date when updating
                $date = date('Y-m-d');
                
                if (empty($title) || empty($description)) {
                    echo json_encode(['success' => false, 'message' => 'Please fill all required fields']);
                    break;
                }
                
                // Handle file upload if new file is provided
                $attachment = null;
                if (isset($_FILES['attachment']) && $_FILES['attachment']['error'] === UPLOAD_ERR_OK) {
                    $uploadDir = 'uploads/';
                    if (!is_dir($uploadDir)) {
                        mkdir($uploadDir, 0755, true);
                    }
                    
                    $fileName = time() . '_' . basename($_FILES['attachment']['name']);
                    $uploadPath = $uploadDir . $fileName;
                    
                    if (move_uploaded_file($_FILES['attachment']['tmp_name'], $uploadPath)) {
                        $attachment = $uploadPath;
                    }
                }
                
                // Update notice with current date
                if ($attachment) {
                    $stmt = $conn->prepare("UPDATE notice SET title = ?, description = ?, date = ?, attachment = ? WHERE noticeId = ? AND staffId = ?");
                    $stmt->bind_param("ssssis", $title, $description, $date, $attachment, $noticeId, $staffId);
                } else {
                    $stmt = $conn->prepare("UPDATE notice SET title = ?, description = ?, date = ? WHERE noticeId = ? AND staffId = ?");
                    $stmt->bind_param("sssis", $title, $description, $date, $noticeId, $staffId);
                }
                
                if ($stmt->execute()) {
                    $stmt->close();
                    
                    // Update departments
                    $stmt = $conn->prepare("DELETE FROM notice_departments WHERE noticeId = ?");
                    $stmt->bind_param("i", $noticeId);
                    $stmt->execute();
                    $stmt->close();
                    
                    if (isset($_POST['editDepartments']) && is_array($_POST['editDepartments'])) {
                        foreach ($_POST['editDepartments'] as $deptId) {
                            $stmt = $conn->prepare("INSERT INTO notice_departments (noticeId, departmentId) VALUES (?, ?)");
                            $stmt->bind_param("ii", $noticeId, $deptId);
                            $stmt->execute();
                            $stmt->close();
                        }
                    }
                    
                    // Update batches
                    $stmt = $conn->prepare("DELETE FROM notice_batches WHERE noticeId = ?");
                    $stmt->bind_param("i", $noticeId);
                    $stmt->execute();
                    $stmt->close();
                    
                    if (isset($_POST['editBatches']) && is_array($_POST['editBatches'])) {
                        foreach ($_POST['editBatches'] as $batchId) {
                            $stmt = $conn->prepare("INSERT INTO notice_batches (noticeId, batchId) VALUES (?, ?)");
                            $stmt->bind_param("ii", $noticeId, $batchId);
                            $stmt->execute();
                            $stmt->close();
                        }
                    }
                    
                    echo json_encode(['success' => true, 'message' => 'Notice updated successfully']);
                } else {
                    echo json_encode(['success' => false, 'message' => 'Failed to update notice']);
                }
            } catch (Exception $e) {
                echo json_encode(['success' => false, 'message' => 'Error updating notice: ' . $e->getMessage()]);
            }
            break;
            
        case 'delete':
            try {
                $noticeId = intval($_POST['noticeId']);
                
                // First get the attachment path to delete file
                $stmt = $conn->prepare("SELECT attachment FROM notice WHERE noticeId = ? AND staffId = ?");
                $stmt->bind_param("is", $noticeId, $staffId);
                $stmt->execute();
                $result = $stmt->get_result();
                $notice = $result->fetch_assoc();
                $stmt->close();
                
                if ($notice) {
                    // Delete related records first (due to foreign key constraints)
                    $stmt = $conn->prepare("DELETE FROM notice_batches WHERE noticeId = ?");
                    $stmt->bind_param("i", $noticeId);
                    $stmt->execute();
                    $stmt->close();
                    
                    $stmt = $conn->prepare("DELETE FROM notice_departments WHERE noticeId = ?");
                    $stmt->bind_param("i", $noticeId);
                    $stmt->execute();
                    $stmt->close();
                    
                    // Delete the notice from database
                    $stmt = $conn->prepare("DELETE FROM notice WHERE noticeId = ? AND staffId = ?");
                    $stmt->bind_param("is", $noticeId, $staffId);
                    
                    if ($stmt->execute()) {
                        // Delete attachment file if exists
                        if ($notice['attachment'] && file_exists($notice['attachment'])) {
                            unlink($notice['attachment']);
                        }
                        echo json_encode(['success' => true, 'message' => 'Notice deleted successfully']);
                    } else {
                        echo json_encode(['success' => false, 'message' => 'Failed to delete notice']);
                    }
                    $stmt->close();
                } else {
                    echo json_encode(['success' => false, 'message' => 'Notice not found']);
                }
            } catch (Exception $e) {
                echo json_encode(['success' => false, 'message' => 'Error deleting notice: ' . $e->getMessage()]);
            }
            break;
            
        default:
            echo json_encode(['success' => false, 'message' => 'Invalid action']);
    }
    exit();
}

// If this is accessed directly (not AJAX), redirect to the HTML file
header('Location: staff_home.html');
exit();
?>