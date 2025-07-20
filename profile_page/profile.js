document.addEventListener('DOMContentLoaded', function() {
    // ===== Change Password Feature =====
    const changePasswordBtn = document.getElementById('change-password-btn');
    if (changePasswordBtn) {
        changePasswordBtn.addEventListener('click', function() {
            alert('Redirecting to change password page...');
            // window.location.href = 'change-password.html';
        });
    }

    // ===== Change Profile Picture Feature =====
    const changeProfilePicBtn = document.getElementById('change-profile-pic-btn');
    const uploadProfilePic = document.getElementById('upload-profile-pic');
    const profilePicDiv = document.getElementById('profile-pic');

    if (changeProfilePicBtn && uploadProfilePic && profilePicDiv) {
        // Open file selector on button click
        changeProfilePicBtn.addEventListener('click', () => {
            uploadProfilePic.click();
        });

        // Preview selected image and save in localStorage
        uploadProfilePic.addEventListener('change', (event) => {
            const file = event.target.files[0];
            if (file && file.type.startsWith('image/')) {
                const reader = new FileReader();
                reader.onload = function(e) {
                    profilePicDiv.style.backgroundImage = `url('${e.target.result}')`;

                    // Save to local storage (Temporary)
                    localStorage.setItem('profilePic', e.target.result);
                };
                reader.readAsDataURL(file);
            }
        });

        // Load saved profile picture from local storage on page load
        const savedPic = localStorage.getItem('profilePic');
        if (savedPic) {
            profilePicDiv.style.backgroundImage = `url('${savedPic}')`;
        }
    }
});