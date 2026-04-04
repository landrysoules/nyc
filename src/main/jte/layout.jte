@import gg.jte.Content
@param String title = "KYC Backoffice"
@param Content content
<!DOCTYPE html>
<html lang="en" data-theme="light">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${title}</title>
    <link href="https://cdn.jsdelivr.net/npm/daisyui@4/dist/full.min.css" rel="stylesheet" type="text/css"/>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; }
        [data-theme="light"] {
            --p: 72% 0.13 198;
            --pf: 51% 0.11 196;
            --pc: 100% 0 0;
            --a: 66% 0.22 22;
            --af: 56% 0.22 22;
            --ac: 100% 0 0;
            --rounded-btn: 9999px;
        }
    </style>
    <script src="https://unpkg.com/htmx.org@1.9.11"></script>
    <script src="https://unpkg.com/htmx.org@1.9.11/dist/ext/alpine-morph.js"></script>
    <script type="module" src="/js/app.js"></script>
    <!-- Alpine morph plugin must load before Alpine core -->
    <script defer src="https://cdn.jsdelivr.net/npm/@alpinejs/morph@3.x.x/dist/cdn.min.js"></script>
    <script defer src="https://cdn.jsdelivr.net/npm/alpinejs@3.x.x/dist/cdn.min.js"></script>
    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: {
                        ihub: {
                            red: '#FE595A',
                            navy: '#2C3545',
                            teal: '#15B7C8',
                            tealLight: '#E8F8FA',
                            tealDark: '#0D6E7E',
                            bg: '#F8F9FA',
                            border: '#E2E8F0'
                        }
                    }
                }
            }
        }
    </script>
</head>
<body hx-ext="alpine-morph" class="bg-gray-50 text-gray-800 antialiased min-h-screen flex flex-col font-sans">
    <div class="flex flex-col flex-grow">
        ${content}
    </div>
    <div class="toast toast-top toast-end z-[200]"
         x-data="{ show: false, message: '', type: 'success' }"
         @showtoast.window="message = $event.detail.message; type = $event.detail.type ?? 'success'; show = true; setTimeout(() => show = false, 3000)">
        <div x-show="show" x-transition :class="'alert shadow-lg alert-' + type">
            <svg x-show="type === 'success'" xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                <path stroke-linecap="round" stroke-linejoin="round" d="M5 13l4 4L19 7"/>
            </svg>
            <svg x-show="type === 'error'" xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                <path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12"/>
            </svg>
            <svg x-show="type === 'warning'" xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                <path stroke-linecap="round" stroke-linejoin="round" d="M12 9v4m0 4h.01M10.29 3.86L1.82 18a2 2 0 001.71 3h16.94a2 2 0 001.71-3L13.71 3.86a2 2 0 00-3.42 0z"/>
            </svg>
            <svg x-show="type === 'info'" xmlns="http://www.w3.org/2000/svg" class="h-5 w-5 shrink-0" fill="none" viewBox="0 0 24 24" stroke="currentColor" stroke-width="2">
                <path stroke-linecap="round" stroke-linejoin="round" d="M13 16h-1v-4h-1m1-4h.01M12 2a10 10 0 100 20A10 10 0 0012 2z"/>
            </svg>
            <span class="text-sm font-semibold" x-text="message"></span>
        </div>
    </div>
</body>
</html>
