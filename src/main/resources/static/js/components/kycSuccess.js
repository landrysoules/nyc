export default function kycSuccess() {
    return {
        init() {
            console.log("Transmission du succès au parent via postMessage...");
            if (window.parent && window.parent !== window) {
                window.parent.postMessage({ type: 'KYC_STATUS', status: 'SUCCESS' }, '*');
            } else {
                console.log("Pas de parent détecté (non chargé via iframe).");
            }
        }
    }
}
