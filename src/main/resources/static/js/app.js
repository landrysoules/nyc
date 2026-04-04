import dashboard from './components/dashboard.js';
import naturalPersonForm from './components/naturalPersonForm.js';
import legalEntityForm from './components/legalEntityForm.js';
import contractForm from './components/contractForm.js';
import kycSuccess from './components/kycSuccess.js';
import otpForm from './components/otpForm.js';
import countryDropdown from './components/countryDropdown.js';

function registerAlpineComponents() {
    // Assign directly to window as a fallback context since type="module" isolates scope
    window.dashboard = dashboard;
    window.naturalPersonForm = naturalPersonForm;
    window.legalEntityForm = legalEntityForm;
    window.contractForm = contractForm;
    window.kycSuccess = kycSuccess;
    window.otpForm = otpForm;
    window.countryDropdown = countryDropdown;

    if (window.Alpine) {
        window.Alpine.data('dashboard', dashboard);
        window.Alpine.data('naturalPersonForm', naturalPersonForm);
        window.Alpine.data('legalEntityForm', legalEntityForm);
        window.Alpine.data('contractForm', contractForm);
        window.Alpine.data('kycSuccess', kycSuccess);
        window.Alpine.data('otpForm', otpForm);
        window.Alpine.data('countryDropdown', countryDropdown);
    }
}

// Call immediately in case Alpine is already loaded
registerAlpineComponents();

// Or wait for it if it loads after this script
document.addEventListener('alpine:init', registerAlpineComponents);
