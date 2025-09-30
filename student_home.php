<?php
session_start();

// Check if student is logged in
if (!isset($_SESSION['studentId']) || !isset($_SESSION['logged_in']) || $_SESSION['logged_in'] !== true) {
    if (isset($_POST['action'])) {
        echo json_encode(['error' => 'Not logged in']);
        exit();
    }
    header('Location: login.php');
    exit();
}

// Include database connection
include 'db.php';

// Get studentId from session
$studentId = $_SESSION['studentId'];

// Handle AJAX requests
if ($_SERVER['REQUEST_METHOD'] === 'POST' && isset($_POST['action'])) {
    header('Content-Type: application/json');
    
    switch ($_POST['action']) {
        case 'get_notices':
            try {
                // First, get the student's department and batch
                $stmt = $conn->prepare("SELECT departmentId, batchId FROM students WHERE studentId = ?");
                $stmt->bind_param("s", $studentId);
                $stmt->execute();
                $result = $stmt->get_result();
                
                if ($student = $result->fetch_assoc()) {
                    $departmentId = $student['departmentId'];
                    $batchId = $student['batchId'];
                    
                    // Get notices that match the student's department AND batch
                    // A notice is relevant if:
                    // 1. It has the student's department (or is not assigned to any department)
                    // 2. AND it has the student's batch (or is not assigned to any batch)
                    $noticeStmt = $conn->prepare("
                        SELECT DISTINCT n.noticeId, n.title, n.description, n.date, n.attachment
                        FROM notice n
                        WHERE n.noticeId IN (
                            SELECT n2.noticeId 
                            FROM notice n2
                            WHERE (
                                NOT EXISTS (SELECT 1 FROM notice_departments nd WHERE nd.noticeId = n2.noticeId)
                                OR EXISTS (SELECT 1 FROM notice_departments nd WHERE nd.noticeId = n2.noticeId AND nd.departmentId = ?)
                            )
                            AND (
                                NOT EXISTS (SELECT 1 FROM notice_batches nb WHERE nb.noticeId = n2.noticeId)
                                OR EXISTS (SELECT 1 FROM notice_batches nb WHERE nb.noticeId = n2.noticeId AND nb.batchId = ?)
                            )
                        )
                        ORDER BY n.date DESC
                        LIMIT 50
                    ");
                    
                    $noticeStmt->bind_param("ii", $departmentId, $batchId);
                    $noticeStmt->execute();
                    $noticeResult = $noticeStmt->get_result();
                    
                    $notices = [];
                    while ($notice = $noticeResult->fetch_assoc()) {
                        $notices[] = $notice;
                    }
                    
                    echo json_encode(['success' => true, 'notices' => $notices]);
                    $noticeStmt->close();
                } else {
                    echo json_encode(['success' => false, 'message' => 'Student not found']);
                }
                $stmt->close();
            } catch (Exception $e) {
                echo json_encode(['success' => false, 'message' => 'Error loading notices: ' . $e->getMessage()]);
            }
            break;
            
        default:
            echo json_encode(['success' => false, 'message' => 'Invalid action']);
    }
    exit();
}

// If accessed directly, redirect to HTML page
header('Location: student_home.html');
exit();
?>