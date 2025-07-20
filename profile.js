document.addEventListener('DOMContentLoaded', function() {
    // Shared functionality for both student and staff profiles
    
    const changePasswordBtn = document.getElementById('change-password-btn');
    
    if (changePasswordBtn) {
        changePasswordBtn.addEventListener('click', function() {
            // This would redirect to the change password page made by your teammate
            alert('Redirecting to change password page...');
            // window.location.href = 'change-password.html';
        });
    }
    
    // You can add more shared interactive features here
});