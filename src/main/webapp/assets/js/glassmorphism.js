/**
 * Glassmorphism Interactive Effects
 * JavaScript enhancements for the glassmorphism design system
 */

class GlassmorphismEffects {
  constructor() {
    this.initialized = false;
    this.observers = [];
    this.init();
  }

  /**
   * Initialize all glassmorphism effects
   */
  init() {
    if (this.initialized) return;

    // Wait for DOM to be ready
    if (document.readyState === 'loading') {
      document.addEventListener('DOMContentLoaded', () => this.setupEffects());
    } else {
      this.setupEffects();
    }

    this.initialized = true;
  }

  /**
   * Set up all interactive effects
   */
  setupEffects() {
    this.addCardHoverEffects();
    this.addButtonInteractions();
    this.addFormEnhancements();
    this.addProgressAnimations();
    this.addLoadingStates();
    this.addScrollEffects();
    this.setupPasswordToggles();
    this.setupTooltips();
    this.observeNewElements();

    console.log('✨ Glassmorphism effects initialized');
  }

  /**
   * Add hover effects to glass cards
   */
  addCardHoverEffects() {
    const cards = document.querySelectorAll('.glass-card, .surface-card');

    cards.forEach(card => {
      // Skip cards that shouldn't have hover effects
      if (card.classList.contains('glass-card--static')) return;

      card.addEventListener('mouseenter', this.handleCardHover.bind(this));
      card.addEventListener('mouseleave', this.handleCardLeave.bind(this));

      // Add ripple effect on click
      card.addEventListener('click', this.handleCardClick.bind(this));
    });
  }

  /**
   * Handle card hover effect
   */
  handleCardHover(event) {
    const card = event.currentTarget;

    if (!card.style.transform || card.style.transform === 'none') {
      card.style.transform = 'translateY(-4px) scale(1.01)';

      // Add enhanced shadow for glass cards
      if (card.classList.contains('glass-card')) {
        card.style.boxShadow = '0 20px 60px rgba(37, 99, 235, 0.4)';
      }
    }
  }

  /**
   * Handle card leave effect
   */
  handleCardLeave(event) {
    const card = event.currentTarget;
    card.style.transform = '';
    card.style.boxShadow = '';
  }

  /**
   * Handle card click ripple effect
   */
  handleCardClick(event) {
    const card = event.currentTarget;
    const rect = card.getBoundingClientRect();
    const ripple = document.createElement('div');

    const x = event.clientX - rect.left;
    const y = event.clientY - rect.top;

    ripple.style.cssText = `
      position: absolute;
      border-radius: 50%;
      background: rgba(255, 255, 255, 0.6);
      transform: scale(0);
      animation: ripple 0.6s linear;
      left: ${x}px;
      top: ${y}px;
      width: 20px;
      height: 20px;
      margin-left: -10px;
      margin-top: -10px;
      pointer-events: none;
    `;

    const cardPosition = getComputedStyle(card).position;
    if (cardPosition !== 'relative' && cardPosition !== 'absolute') {
      card.style.position = 'relative';
    }

    card.appendChild(ripple);

    // Remove ripple after animation
    setTimeout(() => {
      if (ripple.parentNode) {
        ripple.parentNode.removeChild(ripple);
      }
    }, 600);
  }

  /**
   * Add button interaction effects
   */
  addButtonInteractions() {
    const buttons = document.querySelectorAll('.btn');

    buttons.forEach(button => {
      button.addEventListener('mousedown', this.handleButtonPress.bind(this));
      button.addEventListener('mouseup', this.handleButtonRelease.bind(this));
      button.addEventListener('mouseleave', this.handleButtonRelease.bind(this));
    });
  }

  /**
   * Handle button press effect
   */
  handleButtonPress(event) {
    const button = event.currentTarget;
    if (!button.disabled) {
      button.style.transform = 'translateY(0) scale(0.98)';
    }
  }

  /**
   * Handle button release effect
   */
  handleButtonRelease(event) {
    const button = event.currentTarget;
    if (!button.disabled) {
      setTimeout(() => {
        button.style.transform = '';
      }, 100);
    }
  }

  /**
   * Add form enhancement effects
   */
  addFormEnhancements() {
    const inputs = document.querySelectorAll('.form-input, .form-select, .form-textarea');

    inputs.forEach(input => {
      input.addEventListener('focus', this.handleInputFocus.bind(this));
      input.addEventListener('blur', this.handleInputBlur.bind(this));
      input.addEventListener('input', this.handleInputChange.bind(this));
    });
  }

  /**
   * Handle input focus effect
   */
  handleInputFocus(event) {
    const input = event.currentTarget;
    const formGroup = input.closest('.form-group');

    if (formGroup) {
      formGroup.classList.add('form-group--focused');
    }
  }

  /**
   * Handle input blur effect
   */
  handleInputBlur(event) {
    const input = event.currentTarget;
    const formGroup = input.closest('.form-group');

    if (formGroup) {
      formGroup.classList.remove('form-group--focused');

      // Add filled class if input has value
      if (input.value.trim() !== '') {
        formGroup.classList.add('form-group--filled');
      } else {
        formGroup.classList.remove('form-group--filled');
      }
    }
  }

  /**
   * Handle input change effect
   */
  handleInputChange(event) {
    const input = event.currentTarget;
    const formGroup = input.closest('.form-group');

    if (formGroup) {
      // Remove error state when user starts typing
      if (input.classList.contains('form-input--error')) {
        input.classList.remove('form-input--error');
      }
    }
  }

  /**
   * Add progress bar animations
   */
  addProgressAnimations() {
    const progressBars = document.querySelectorAll('.loyalty-progress-fill');

    // Use Intersection Observer to animate when in view
    const observer = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          const progressFill = entry.target;
          const targetWidth = progressFill.dataset.width || progressFill.style.width;

          // Animate from 0 to target width
          progressFill.style.width = '0%';
          setTimeout(() => {
            progressFill.style.width = targetWidth;
          }, 100);

          observer.unobserve(progressFill);
        }
      });
    });

    progressBars.forEach(bar => observer.observe(bar));
    this.observers.push(observer);
  }

  /**
   * Add loading state effects
   */
  addLoadingStates() {
    const forms = document.querySelectorAll('form');

    forms.forEach(form => {
      form.addEventListener('submit', this.handleFormSubmit.bind(this));
    });
  }

  /**
   * Handle form submit with loading state
   */
  handleFormSubmit(event) {
    const form = event.currentTarget;
    const submitButton = form.querySelector('button[type="submit"], input[type="submit"]');

    if (submitButton && !submitButton.disabled) {
      const originalText = submitButton.textContent || submitButton.value;

      // Add loading state
      submitButton.disabled = true;
      submitButton.classList.add('btn--loading');

      if (submitButton.tagName === 'BUTTON') {
        submitButton.innerHTML = `
          <span class="loading-spinner loading-spinner--sm"></span>
          Loading...
        `;
      } else {
        submitButton.value = 'Loading...';
      }

      // Reset after 5 seconds if no redirect happens
      setTimeout(() => {
        if (submitButton.tagName === 'BUTTON') {
          submitButton.textContent = originalText;
        } else {
          submitButton.value = originalText;
        }
        submitButton.disabled = false;
        submitButton.classList.remove('btn--loading');
      }, 5000);
    }
  }

  /**
   * Add scroll-based effects
   */
  addScrollEffects() {
    const scrollElements = document.querySelectorAll('.animate-on-scroll');

    const scrollObserver = new IntersectionObserver((entries) => {
      entries.forEach(entry => {
        if (entry.isIntersecting) {
          entry.target.classList.add('animate-fade-in');
          scrollObserver.unobserve(entry.target);
        }
      });
    });

    scrollElements.forEach(el => scrollObserver.observe(el));
    this.observers.push(scrollObserver);
  }

  /**
   * Setup password toggle functionality
   */
  setupPasswordToggles() {
    const toggleButtons = document.querySelectorAll('.password-toggle');

    toggleButtons.forEach(button => {
      button.addEventListener('click', this.handlePasswordToggle.bind(this));
    });
  }

  /**
   * Handle password field toggle
   */
  handlePasswordToggle(event) {
    const button = event.currentTarget;
    const wrapper = button.closest('.password-wrapper');
    const input = wrapper.querySelector('input[type="password"], input[type="text"]');

    if (input) {
      if (input.type === 'password') {
        input.type = 'text';
        button.textContent = 'Hide';
      } else {
        input.type = 'password';
        button.textContent = 'Show';
      }
    }
  }

  /**
   * Setup tooltip functionality
   */
  setupTooltips() {
    const tooltipElements = document.querySelectorAll('[data-tooltip]');

    tooltipElements.forEach(element => {
      element.addEventListener('mouseenter', this.showTooltip.bind(this));
      element.addEventListener('mouseleave', this.hideTooltip.bind(this));
    });
  }

  /**
   * Show tooltip
   */
  showTooltip(event) {
    const element = event.currentTarget;
    const text = element.dataset.tooltip;

    if (!text) return;

    const tooltip = document.createElement('div');
    tooltip.className = 'glassmorphism-tooltip';
    tooltip.textContent = text;
    tooltip.style.cssText = `
      position: absolute;
      background: var(--glass-bg-dark);
      color: var(--text-inverse);
      padding: var(--space-2) var(--space-3);
      border-radius: var(--radius-md);
      font-size: var(--text-sm);
      backdrop-filter: var(--glass-backdrop);
      border: 1px solid var(--glass-border);
      z-index: var(--z-tooltip);
      pointer-events: none;
      opacity: 0;
      transform: translateY(5px);
      transition: var(--transition-glass);
      white-space: nowrap;
    `;

    document.body.appendChild(tooltip);

    // Position tooltip
    const rect = element.getBoundingClientRect();
    const tooltipRect = tooltip.getBoundingClientRect();

    tooltip.style.left = rect.left + (rect.width - tooltipRect.width) / 2 + 'px';
    tooltip.style.top = rect.bottom + 8 + 'px';

    // Show tooltip with animation
    requestAnimationFrame(() => {
      tooltip.style.opacity = '1';
      tooltip.style.transform = 'translateY(0)';
    });

    element.tooltipElement = tooltip;
  }

  /**
   * Hide tooltip
   */
  hideTooltip(event) {
    const element = event.currentTarget;
    const tooltip = element.tooltipElement;

    if (tooltip) {
      tooltip.style.opacity = '0';
      tooltip.style.transform = 'translateY(5px)';

      setTimeout(() => {
        if (tooltip.parentNode) {
          tooltip.parentNode.removeChild(tooltip);
        }
      }, 200);

      element.tooltipElement = null;
    }
  }

  /**
   * Observe new elements added to the DOM
   */
  observeNewElements() {
    const observer = new MutationObserver((mutations) => {
      mutations.forEach((mutation) => {
        mutation.addedNodes.forEach((node) => {
          if (node.nodeType === Node.ELEMENT_NODE) {
            // Re-initialize effects for new elements
            this.addCardHoverEffects();
            this.addButtonInteractions();
            this.addFormEnhancements();
            this.setupPasswordToggles();
            this.setupTooltips();
          }
        });
      });
    });

    observer.observe(document.body, {
      childList: true,
      subtree: true
    });

    this.observers.push(observer);
  }

  /**
   * Cleanup when page unloads
   */
  destroy() {
    this.observers.forEach(observer => observer.disconnect());
    this.observers = [];
    this.initialized = false;
  }
}

/**
 * Utility functions for common glassmorphism effects
 */
const GlassUtils = {
  /**
   * Add glass loading overlay to an element
   */
  showLoadingOverlay(element, message = 'Loading...') {
    const overlay = document.createElement('div');
    overlay.className = 'loading-overlay';
    overlay.innerHTML = `
      <div class="loading-card">
        <div class="loading-spinner loading-spinner--lg loading-spinner--glass mb-3"></div>
        <div>${message}</div>
      </div>
    `;

    element.style.position = 'relative';
    element.appendChild(overlay);

    return overlay;
  },

  /**
   * Remove glass loading overlay
   */
  hideLoadingOverlay(element) {
    const overlay = element.querySelector('.loading-overlay');
    if (overlay) {
      overlay.remove();
    }
  },

  /**
   * Show glass notification
   */
  showNotification(message, type = 'success', duration = 3000) {
    const notification = document.createElement('div');
    notification.className = `message message--glass-${type} animate-slide-in-top`;
    notification.textContent = message;
    notification.style.cssText = `
      position: fixed;
      top: var(--space-lg);
      right: var(--space-lg);
      z-index: var(--z-toast);
      min-width: 300px;
      max-width: 500px;
    `;

    document.body.appendChild(notification);

    // Auto remove
    setTimeout(() => {
      notification.style.transform = 'translateX(100%)';
      notification.style.opacity = '0';
      setTimeout(() => {
        if (notification.parentNode) {
          notification.parentNode.removeChild(notification);
        }
      }, 300);
    }, duration);
  },

  /**
   * Animate number counting
   */
  animateCounter(element, start, end, duration = 1000) {
    const range = end - start;
    const minTimer = 50;
    const stepTime = Math.abs(Math.floor(duration / range));
    const timer = stepTime < minTimer ? minTimer : stepTime;

    const startTime = new Date().getTime();
    const endTime = startTime + duration;

    const run = () => {
      const now = new Date().getTime();
      const remaining = Math.max((endTime - now) / duration, 0);
      const value = Math.round(end - (remaining * range));

      element.textContent = value.toLocaleString();

      if (value !== end) {
        requestAnimationFrame(run);
      }
    };

    run();
  }
};

/**
 * Add CSS for dynamic effects
 */
const addDynamicStyles = () => {
  const style = document.createElement('style');
  style.textContent = `
    @keyframes ripple {
      to {
        transform: scale(4);
        opacity: 0;
      }
    }

    .form-group--focused .form-label {
      color: var(--glass-primary);
    }

    .form-group--focused .form-input--glass {
      border-color: var(--glass-border-dark);
    }

    .btn--loading {
      pointer-events: none;
      opacity: 0.7;
    }

    .glassmorphism-tooltip {
      box-shadow: var(--glass-shadow);
    }
  `;

  document.head.appendChild(style);
};

// Initialize when DOM is ready
if (typeof window !== 'undefined') {
  // Add dynamic styles
  addDynamicStyles();

  // Initialize effects
  const glassmorphismEffects = new GlassmorphismEffects();

  // Cleanup on page unload
  window.addEventListener('beforeunload', () => {
    glassmorphismEffects.destroy();
  });

  // Make utils globally available
  window.GlassUtils = GlassUtils;

  // Make effects instance globally available for debugging
  window.glassmorphismEffects = glassmorphismEffects;
}