@import gg.jte.Content
@param String error = null
@template.layout(title = "Login - KYC Backoffice", content = @`
<div class="w-full flex-grow flex flex-col bg-ihub-bg">
    <div class="flex h-14 w-full text-white text-sm shrink-0">
        <div class="bg-ihub-red px-6 flex items-center justify-center min-w-[120px]">
            <div class="flex items-center justify-center font-bold text-3xl tracking-tighter cursor-pointer">
                <span class="text-white relative">
                    <span class="absolute -top-1 -left-2 text-[8px] text-white">●</span>
                    <span class="absolute top-1 -right-2 text-[8px] text-white">●</span>
                    ihub
                </span>
            </div>
        </div>
        <div class="bg-ihub-navy px-8 flex items-center">
            <span class="font-medium text-base">Test</span>
        </div>
        <div class="bg-ihub-red flex-grow flex justify-end items-center px-6">
            <div class="flex items-center space-x-1 cursor-pointer font-bold text-xs">
                <span>EN</span>
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path></svg>
            </div>
        </div>
    </div>

    <div class="flex-grow flex items-center justify-center flex-col relative pb-10">
        <div class="mb-6 flex justify-center">
            <span class="font-bold text-6xl tracking-tighter text-ihub-teal relative">
                <span class="absolute top-1 -left-3 text-xs text-ihub-teal">●</span>
                <span class="absolute top-4 -right-3 text-xs text-ihub-teal">●</span>
                ihub
            </span>
        </div>

        <div class="w-[450px] bg-white rounded-xl shadow-sm border border-gray-100 px-10 py-8">
            <div id="auth-container">
                @template.fragments.login_form(error = error)
            </div>
        </div>

        <div class="absolute bottom-6 w-full text-center text-[10px] text-gray-400 font-medium">
            © i-Hub 2026 - Version 55.2.0_RC2 &nbsp;|&nbsp; Terms of use &nbsp;|&nbsp; Cookie policy &nbsp;|&nbsp; Privacy policy &nbsp;|&nbsp; Legal notices
        </div>
    </div>
</div>
`)
