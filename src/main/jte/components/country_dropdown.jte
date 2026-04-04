@param String label
@param String fieldName
@param String value = ""
@param String badge = ""
@param String badgeClass = "text-orange-400"
@param String errorId = ""
@param String errorMessage = ""
@param String containerClass = "col-span-1"
<div x-data="countryDropdown('${value}')"
     class="${containerClass} border border-gray-200 rounded px-4 py-1 relative flex items-center h-[52px]"
     @click.outside="handleClickOutside()">
    <label class="absolute -top-[9px] left-3 bg-white px-1 text-[9px] text-gray-500 font-bold uppercase tracking-widest">${label}</label>
    @if(badge != null && !badge.isEmpty())
    <span class="absolute -top-[9px] right-3 bg-white px-1 text-[9px] ${badgeClass} font-bold uppercase tracking-widest">${badge}</span>
    @endif
    <input type="text" autocomplete="off" x-model="searchQuery" @focus="showList = true"
           class="w-full h-full bg-transparent outline-none text-sm text-gray-800 pt-1 cursor-pointer font-bold">
    <div class="absolute right-4 text-gray-400 pointer-events-none">
        <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path>
        </svg>
    </div>
    <input type="hidden" name="${fieldName}" x-model="value">
    <ul x-show="showList" x-cloak class="absolute top-[52px] left-0 w-full bg-white border border-gray-300 rounded-md shadow-lg max-h-40 overflow-auto z-50">
        <template x-for="c in filteredCountries" :key="c">
            <li class="p-2 hover:bg-ihub-tealLight cursor-pointer text-sm font-medium text-gray-700 transition-colors"
                @click="selectCountry(c)" x-text="c"></li>
        </template>
    </ul>
    @if(errorId != null && !errorId.isEmpty())
    <span id="${errorId}" class="text-xs text-red-600 block absolute -bottom-5">${errorMessage != null ? errorMessage : ""}</span>
    @endif
</div>
