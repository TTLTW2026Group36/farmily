


document.addEventListener('DOMContentLoaded', function () {
  const form = document.getElementById('contactForm');
  const notice = document.getElementById('notice');
  const errorNotice = document.getElementById('error-notice');
  const submitBtn = form.querySelector('.btn-submit');
  const btnText = submitBtn.querySelector('.btn-text');
  const btnLoading = submitBtn.querySelector('.btn-loading');

  
  const validators = {
    name: {
      validate: (value) => value.trim().length >= 2,
      message: 'Họ và tên phải có ít nhất 2 ký tự.'
    },
    email: {
      validate: (value) => /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(value.trim()),
      message: 'Email chưa đúng định dạng.'
    },
    phone: {
      validate: (value) => /^(0|\+84)[0-9]{9,10}$/.test(value.replace(/\s/g, '')),
      message: 'Số điện thoại phải bắt đầu bằng 0 hoặc +84 và có 10-11 số.'
    },
    subject: {
      validate: (value) => value.trim().length >= 3,
      message: 'Tiêu đề phải có ít nhất 3 ký tự.'
    },
    message: {
      validate: (value) => value.trim().length >= 10,
      message: 'Nội dung phải có ít nhất 10 ký tự.'
    }
  };

  
  function showError(fieldId, message) {
    const field = document.getElementById(fieldId);
    const errorDiv = document.getElementById('err-' + fieldId);
    if (field) {
      field.classList.add('input-error');
    }
    if (errorDiv) {
      errorDiv.textContent = message;
      errorDiv.style.display = 'block';
    }
  }

  
  function clearError(fieldId) {
    const field = document.getElementById(fieldId);
    const errorDiv = document.getElementById('err-' + fieldId);
    if (field) {
      field.classList.remove('input-error');
    }
    if (errorDiv) {
      errorDiv.style.display = 'none';
    }
  }

  
  function clearAllErrors() {
    Object.keys(validators).forEach(fieldId => clearError(fieldId));
    if (errorNotice) {
      errorNotice.style.display = 'none';
      errorNotice.textContent = '';
    }
  }

  
  function validateForm() {
    let isValid = true;
    clearAllErrors();

    Object.keys(validators).forEach(fieldId => {
      const field = document.getElementById(fieldId);
      if (field) {
        const value = field.value;
        const validator = validators[fieldId];
        if (!validator.validate(value)) {
          showError(fieldId, validator.message);
          isValid = false;
        }
      }
    });

    return isValid;
  }

  
  function setLoading(loading) {
    submitBtn.disabled = loading;
    if (loading) {
      btnText.style.display = 'none';
      btnLoading.style.display = 'inline';
      submitBtn.classList.add('loading');
    } else {
      btnText.style.display = 'inline';
      btnLoading.style.display = 'none';
      submitBtn.classList.remove('loading');
    }
  }

  
  function showSuccess(message) {
    if (notice) {
      notice.textContent = message;
      notice.style.display = 'block';
      notice.scrollIntoView({ behavior: 'smooth', block: 'center' });
    }
  }

  
  function showServerError(message) {
    if (errorNotice) {
      errorNotice.textContent = message;
      errorNotice.style.display = 'block';
      errorNotice.scrollIntoView({ behavior: 'smooth', block: 'center' });
    }
  }

  
  Object.keys(validators).forEach(fieldId => {
    const field = document.getElementById(fieldId);
    if (field) {
      field.addEventListener('blur', function () {
        const validator = validators[fieldId];
        if (!validator.validate(this.value)) {
          showError(fieldId, validator.message);
        } else {
          clearError(fieldId);
        }
      });

      field.addEventListener('input', function () {
        clearError(fieldId);
      });
    }
  });

  
  if (form) {
    form.addEventListener('submit', async function (e) {
      e.preventDefault();

      
      if (notice) notice.style.display = 'none';
      if (errorNotice) errorNotice.style.display = 'none';

      
      if (!validateForm()) {
        return;
      }

      
      setLoading(true);

      try {
        
        const formData = new FormData(form);

        
        const response = await fetch(form.action, {
          method: 'POST',
          body: new URLSearchParams(formData),
          headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
          }
        });

        const data = await response.json();

        if (response.ok && data.success) {
          
          showSuccess(data.message);
          form.reset();
        } else {
          
          showServerError(data.message || 'Đã có lỗi xảy ra. Vui lòng thử lại.');
        }

      } catch (error) {
        console.error('Error:', error);
        showServerError('Không thể kết nối đến máy chủ. Vui lòng thử lại sau.');
      } finally {
        setLoading(false);
      }
    });
  }
});