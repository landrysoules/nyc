@import gg.jte.Content
@param String title = "KYC Backoffice"
@param Content content
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${title}</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body { font-family: 'Inter', sans-serif; }
    </style>
    <script src="https://unpkg.com/htmx.org@1.9.11"></script>
    <script type="module" src="/js/app.js"></script>
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
<body class="bg-gray-50 text-gray-800 antialiased min-h-screen flex flex-col font-sans">
    <div class="flex flex-col flex-grow">
        ${content}
    </div>
</body>
</html>
