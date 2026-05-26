/**
 * Hotline Interaction Utility Library
 * Handles secure clipboard copying with fallback and shows Toast Notifications
 */
(function() {
    // Copy text to clipboard
    window.copyToClipboard = function(text) {
        if (!text) return;
        
        // Clean text (remove spaces/non-numbers if copying raw number is preferred, 
        // but let's copy exactly what is passed)
        text = text.trim();
        
        if (navigator.clipboard && window.isSecureContext) {
            navigator.clipboard.writeText(text)
                .then(function() {
                    showCopyToast("Đã sao chép số điện thoại: " + text);
                })
                .catch(function(err) {
                    console.error("Clipboard API failed, using fallback: ", err);
                    fallbackCopyText(text);
                });
        } else {
            fallbackCopyText(text);
        }
    };

    // Fallback for older browsers or non-secure contexts
    function fallbackCopyText(text) {
        var textArea = document.createElement("textarea");
        textArea.value = text;
        
        // Avoid scrolling to bottom
        textArea.style.top = "0";
        textArea.style.left = "0";
        textArea.style.position = "fixed";
        textArea.style.opacity = "0";
        textArea.style.pointerEvents = "none";
        
        document.body.appendChild(textArea);
        textArea.focus();
        textArea.select();
        
        try {
            var successful = document.execCommand('copy');
            if (successful) {
                showCopyToast("Đã sao chép số điện thoại: " + text);
            } else {
                console.error('Fallback copy command was unsuccessful');
                alert("Không thể sao chép. Số điện thoại: " + text);
            }
        } catch (err) {
            console.error('Fallback copy failed: ', err);
            alert("Không thể sao chép. Số điện thoại: " + text);
        }
        
        document.body.removeChild(textArea);
    }

    // Show Toast Notification
    function showCopyToast(message) {
        // Remove existing toast if present to prevent stacking
        var existingToast = document.querySelector('.copy-toast');
        if (existingToast) {
            existingToast.remove();
        }
        
        // Create new toast element
        var toast = document.createElement('div');
        toast.className = 'copy-toast';
        toast.innerHTML = '<i class="fa-solid fa-circle-check"></i><span>' + message + '</span>';
        
        document.body.appendChild(toast);
        
        // Automatically remove toast after animation completed (3 seconds)
        setTimeout(function() {
            if (toast && toast.parentNode) {
                toast.parentNode.removeChild(toast);
            }
        }, 3000);
    }
})();
