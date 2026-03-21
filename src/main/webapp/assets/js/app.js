/**
 * Ruby Tech – App JS
 * Replaces glassmorphism.js. Utility functions for all pages.
 */

/* ── Password toggle ──────────────────────────── */
function togglePassword(inputId, btnEl) {
    const input = document.getElementById(inputId);
    if (!input) return;
    if (input.type === 'password') {
        input.type = 'text';
        if (btnEl) btnEl.textContent = 'Hide';
    } else {
        input.type = 'password';
        if (btnEl) btnEl.textContent = 'Show';
    }
}

/* ── Quantity input guard ─────────────────────── */
function initQuantityInputs() {
    document.querySelectorAll('input.qty-input').forEach(function(input) {
        input.addEventListener('input', function() {
            const max = parseInt(this.getAttribute('max'));
            const min = parseInt(this.getAttribute('min')) || 1;
            let v = parseInt(this.value);
            if (isNaN(v) || v < min) this.value = min;
            else if (!isNaN(max) && v > max) this.value = max;
        });
    });
}

/* ── Bootstrap toast notifications ───────────── */
function showToast(message, type) {
    type = type || 'info';
    const colorMap = { success: 'bg-success', error: 'bg-danger', warning: 'bg-warning text-dark', info: 'bg-primary' };
    const toastHtml = `
      <div class="toast align-items-center text-white ${colorMap[type] || 'bg-primary'} border-0 show" role="alert" style="min-width:260px">
        <div class="d-flex">
          <div class="toast-body">${message}</div>
          <button type="button" class="btn-close btn-close-white me-2 m-auto" data-bs-dismiss="toast"></button>
        </div>
      </div>`;
    let container = document.getElementById('rt-toast-container');
    if (!container) {
        container = document.createElement('div');
        container.id = 'rt-toast-container';
        container.className = 'toast-container position-fixed top-0 end-0 p-3';
        container.style.zIndex = 9999;
        document.body.appendChild(container);
    }
    container.insertAdjacentHTML('beforeend', toastHtml);
    const toastEl = container.lastElementChild;
    setTimeout(function() { toastEl.remove(); }, 4000);
}

/* ── Address / payment option highlight ────────── */
function initOptionHighlight(selector) {
    document.querySelectorAll(selector + ' input[type="radio"]').forEach(function(radio) {
        radio.addEventListener('change', function() {
            document.querySelectorAll(selector).forEach(function(opt) {
                opt.classList.remove('border-orange');
            });
            this.closest(selector).classList.add('border-orange');
        });

        // Init on load
        if (radio.checked) {
            radio.closest(selector).classList.add('border-orange');
        }
    });
}

/* ── Animate number value ─────────────────────── */
function animateValue(element, start, end, duration) {
    duration = duration || 600;
    const startTime = performance.now();
    function update(currentTime) {
        const elapsed = currentTime - startTime;
        const progress = Math.min(elapsed / duration, 1);
        const current = start + (end - start) * progress;
        element.textContent = Math.round(current).toLocaleString('vi-VN') + ' ₫';
        if (progress < 1) requestAnimationFrame(update);
    }
    requestAnimationFrame(update);
}

/* ── DOMContentLoaded init ────────────────────── */
document.addEventListener('DOMContentLoaded', function() {
    initQuantityInputs();
    initOptionHighlight('.address-option');
    initOptionHighlight('.payment-option');

    // Auto-dismiss alerts after 5 seconds
    document.querySelectorAll('.alert.auto-dismiss').forEach(function(el) {
        setTimeout(function() {
            const bsAlert = bootstrap.Alert.getOrCreateInstance(el);
            bsAlert.close();
        }, 5000);
    });
});
