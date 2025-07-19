 <?php
 include 'db.php';
 ?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Profile | Notification Dashboard</title>
    <link rel="stylesheet" href="profiles.css">
</head>
<body class="staff">

    <!-- Blurred Background -->
    <div class="background"></div>

    <!-- Logo at the top-right -->
    <img src="../logo.jpg" alt="Logo" class="logo">

    <div class="profile-container">
        <header class="profile-header">
            <h1>Staff Profile</h1>
            <div class="profile-pic"></div>
        </header>
        
        <main class="profile-details">
            <div class="detail-row">
                <span class="detail-label">Name:</span>
                <span class="detail-value" id="staff-name">Dr. Jane Smith</span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Email:</span>
                <span class="detail-value" id="staff-email">jane.smith@university.edu</span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Staff Id :</span>
                <span class="detail-value" id="staff-id">fc122252</span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Status :</span>
                <span class="detail-value" id="staff-status">Enrolled</span>
            </div>
            
            <button id="change-password-btn" class="action-btn">Change Password</button>
        </main>
    </div>
    
    <script src="profile.js"></script>
</body>
</html>
