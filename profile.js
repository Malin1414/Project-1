// Detect whether we're on staff or student profile page
function getProfileType() {
    return document.body.classList.contains('staff') ? 'staff' : 'student';
}

// Get the appropriate PHP endpoint based on profile type
function getEndpoint() {
    return getProfileType() === 'staff' ? 'staff-profile.php' : 'student-profile.php';
}

// Load profile data when page loads
document.addEventListener('DOMContentLoaded', function() {
    loadProfileData();
    setupProfilePictureUpload();
});

function loadProfileData() {
    showLoading(true);
    const profileType = getProfileType();
    
    fetch(getEndpoint(), {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: 'action=get_profile'
    })
    .then(response => {
        if (!response.ok) {
            throw new Error('Network response was not ok');
        }
        return response.json();
    })
    .then(data => {
        showLoading(false);
        console.log('Profile data received:', data);
        
        if (data.success) {
            if (profileType === 'staff') {
                displayStaffProfileData(data.staff);
            } else {
                displayStudentProfileData(data.student);
            }
        } else if (data.error) {
            console.error('Not logged in:', data.error);
            window.location.href = 'login.php';
        } else {
            console.error('Error loading profile:', data.message);
            showMessage(data.message || 'Error loading profile', 'error');
            showFallbackData();
        }
    })
    .catch(error => {
        showLoading(false);
        console.error('Error loading profile:', error);
        showMessage('Error loading profile data', 'error');
        showFallbackData();
    });
}

function displayStaffProfileData(staff) {
    const fallbackContainer = document.getElementById('fallback-profile');
    const dynamicContainer = document.getElementById('dynamic-profile');
    
    console.log('Displaying staff profile data:', staff);
    
    fallbackContainer.style.display = 'none';
    dynamicContainer.style.display = 'block';
    
    document.getElementById('staff-name').textContent = staff.name || 'Name not available';
    document.getElementById('staff-email').textContent = staff.email || 'Email not available';
    document.getElementById('staff-id').textContent = staff.staffId || 'ID not available';
    document.getElementById('staff-status').textContent = staff.status || 'Status not available';
    
    if (staff.profile_picture) {
        const profilePic = document.getElementById('profile-pic');
        profilePic.style.backgroundImage = `url('${staff.profile_picture}')`;
        profilePic.style.backgroundSize = 'cover';
        profilePic.style.backgroundPosition = 'center';
    }
}

function displayStudentProfileData(student) {
    const fallbackContainer = document.getElementById('fallback-profile');
    const dynamicContainer = document.getElementById('dynamic-profile');
    
    console.log('Displaying student profile data:', student);
    
    fallbackContainer.style.display = 'none';
    dynamicContainer.style.display = 'block';
    
    document.getElementById('student-name').textContent = student.name || 'Name not available';
    document.getElementById('student-email').textContent = student.email || 'Email not available';
    document.getElementById('student-id').textContent = student.studentId || 'ID not available';
    document.getElementById('student-dept').textContent = student.departmentName || 'Department not available';
    document.getElementById('student-batch').textContent = student.batch || 'Batch not available';
    document.getElementById('student-status').textContent = student.status || 'Status not available';
    
    if (student.profile_picture) {
        const profilePic = document.getElementById('profile-pic');
        profilePic.style.backgroundImage = `url('${student.profile_picture}')`;
        profilePic.style.backgroundSize = 'cover';
        profilePic.style.backgroundPosition = 'center';
    }
}

function showFallbackData() {
    const fallbackContainer = document.getElementById('fallback-profile');
    const dynamicContainer = document.getElementById('dynamic-profile');
    
    fallbackContainer.style.display = 'block';
    dynamicContainer.style.display = 'none';
    
    console.log('Using fallback profile data');
}

function setupProfilePictureUpload() {
    const uploadBtn = document.getElementById('change-profile-pic-btn');
    const fileInput = document.getElementById('upload-profile-pic');
    
    uploadBtn.addEventListener('click', function() {
        fileInput.click();
    });
    
    fileInput.addEventListener('change', function(e) {
        const file = e.target.files[0];
        if (file) {
            uploadProfilePicture(file);
        }
    });
}

function uploadProfilePicture(file) {
    if (file.size > 2 * 1024 * 1024) {
        showMessage('File size too large. Maximum 2MB allowed.', 'error');
        return;
    }
    
    const allowedTypes = ['image/jpeg', 'image/jpg', 'image/png', 'image/gif'];
    if (!allowedTypes.includes(file.type)) {
        showMessage('Invalid file type. Only JPG, PNG, and GIF are allowed.', 'error');
        return;
    }
    
    const formData = new FormData();
    formData.append('action', 'update_profile_picture');
    formData.append('profile_picture', file);
    
    showLoading(true);
    
    fetch(getEndpoint(), {
        method: 'POST',
        body: formData
    })
    .then(response => response.json())
    .then(data => {
        showLoading(false);
        
        if (data.success) {
            showMessage(data.message, 'success');
            const profilePic = document.getElementById('profile-pic');
            profilePic.style.backgroundImage = `url('${data.profile_picture}?t=${Date.now()}')`;
            profilePic.style.backgroundSize = 'cover';
            profilePic.style.backgroundPosition = 'center';
        } else {
            showMessage(data.message, 'error');
        }
    })
    .catch(error => {
        showLoading(false);
        console.error('Error uploading profile picture:', error);
        showMessage('Error uploading profile picture', 'error');
    });
}

function showLoading(show) {
    const loader = document.getElementById('loading-indicator');
    loader.style.display = show ? 'block' : 'none';
}

function showMessage(message, type) {
    const messageContainer = document.getElementById('message-container');
    const messageDiv = document.createElement('div');
    messageDiv.className = 'message ' + type;
    messageDiv.style.cssText = `
        padding: 10px 20px;
        margin-bottom: 10px;
        border-radius: 4px;
        color: white;
        font-weight: bold;
        ${type === 'success' ? 'background-color: #28a745;' : 'background-color: #dc3545;'}
    `;
    messageDiv.textContent = message;
    
    messageContainer.appendChild(messageDiv);
    
    setTimeout(() => {
        if (messageDiv.parentNode) {
            messageDiv.parentNode.removeChild(messageDiv);
        }
    }, 3000);
}