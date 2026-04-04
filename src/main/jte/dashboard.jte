@import gg.jte.Content
@param String username = null
@template.layout(title = "Dashboard - KYC SecurePortal", content = @`
<div x-data="dashboard()" class="w-full flex-grow flex flex-col bg-ihub-bg">
    <div class="flex h-14 w-full text-white text-sm">
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
            <div class="flex items-center space-x-6">
                <div class="flex items-center space-x-2 cursor-pointer">
                    <svg class="w-5 h-5" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 9a3 3 0 100-6 3 3 0 000 6zm-7 9a7 7 0 1114 0H3z" clip-rule="evenodd" /></svg>
                    <div class="flex flex-col text-right leading-tight">
                        <span class="font-bold text-xs uppercase">${username != null ? username : "LSO-IHUB-BO"}</span>
                        <span class="text-[10px] opacity-90 tracking-wide">Backoffice</span>
                    </div>
                </div>
                <div class="flex items-center space-x-1 cursor-pointer font-bold text-xs">
                    <span>EN</span>
                    <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path></svg>
                </div>
                <form action="/auth/logout" method="POST" class="ml-4 pl-4 border-l border-white/30">
                    <button type="submit" class="hover:text-gray-200 transition-colors" title="Sign out">
                        <svg class="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 16l4-4m0 0l-4-4m4 4H7m6 4v1a3 3 0 01-3 3H6a3 3 0 01-3-3V7a3 3 0 013-3h4a3 3 0 013 3v1"></path></svg>
                    </button>
                </form>
            </div>
        </div>
    </div>

    <div class="w-full bg-white shadow-sm flex justify-center border-b border-gray-200">
        <nav class="flex space-x-12 px-8" aria-label="Tabs" id="tabs-container">
            <button hx-get="/dashboard/tab/natural-persons" hx-target="#tab-content" hx-trigger="click, load"
                    @click="setActiveTab('natural-persons')"
                    :class="isTabActive('natural-persons') ? 'text-ihub-teal border-ihub-teal' : 'border-transparent text-gray-400 hover:text-gray-600'"
                    class="uppercase tracking-widest font-bold py-4 border-b-[3px] text-xs transition-colors">
                Natural Persons
            </button>
            <button hx-get="/dashboard/tab/legal-entities" hx-target="#tab-content"
                    @click="setActiveTab('legal-entities')"
                    :class="isTabActive('legal-entities') ? 'text-ihub-teal border-ihub-teal' : 'border-transparent text-gray-400 hover:text-gray-600'"
                    class="uppercase tracking-widest font-bold py-4 border-b-[3px] text-xs transition-colors">
                Legal Entities
            </button>
            <button hx-get="/dashboard/tab/contracts" hx-target="#tab-content"
                    @click="setActiveTab('contracts')"
                    :class="isTabActive('contracts') ? 'text-ihub-teal border-ihub-teal' : 'border-transparent text-gray-400 hover:text-gray-600'"
                    class="uppercase tracking-widest font-bold py-4 border-b-[3px] text-xs transition-colors">
                Contracts
            </button>
            <button class="uppercase tracking-widest font-bold py-4 border-b-[3px] text-xs border-transparent text-gray-400 hover:text-gray-600 cursor-not-allowed">
                Enquiries
            </button>
        </nav>
    </div>

    <div class="flex-grow w-full px-2 sm:px-4 lg:px-8 py-4 overflow-y-auto" id="tab-content">
        <div class="flex justify-center items-center py-20">
            <span class="loading loading-spinner loading-lg text-primary"></span>
        </div>
    </div>
</div>
`)
