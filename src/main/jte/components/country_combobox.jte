@param String name
@param String label
@param java.util.Map<String, String> countries
@param String initialCode = ""
@param String badge = ""
@param String badgeClass = "text-orange-400"
@param String errorId = ""
@param String errorMessage = ""
@param String containerClass = "col-span-1"

<div class="${containerClass}">
<div x-data="{
        isOpen: false,
        search: '',
        selectedCode: '${initialCode}',

        allItems: [
            @for(var entry : countries.entrySet())
                { code: '${entry.getKey()}', name: '${entry.getValue().replace("'", "\\'")}' },
            @endfor
        ],
        filteredList: [],

        init() {
            this.filteredList = this.allItems;

            /* Pre-select initial value when editing an existing record */
            if (this.selectedCode) {
                const match = this.allItems.find(c => c.code === this.selectedCode);
                if (match) this.search = match.name;
            }

            this.$watch('search', (value) => {
                if (!value || value.trim() === '') {
                    this.filteredList = this.allItems;
                    if (this.search === '') this.selectedCode = '';
                } else {
                    const lower = value.toLowerCase();
                    this.filteredList = this.allItems.filter(c =>
                        c.name.toLowerCase().includes(lower) ||
                        c.code.toLowerCase().includes(lower)
                    );
                }
            });
        },

        selectItem(item) {
            this.selectedCode = item.code;
            this.search = item.name;
            this.isOpen = false;
            document.body.dispatchEvent(new Event('customValidation'));
        },

        openDropdown() {
            this.isOpen = true;
            this.filteredList = this.allItems;
        }
    }"
    @click.outside="isOpen = false"
    @keydown.escape.window="isOpen = false"
    class="relative w-full">

    <label class="block text-sm font-medium text-gray-700 mb-1">
        ${label}
        @if(badge != null && !badge.isEmpty())
        <span class="ml-1 text-[10px] font-bold uppercase tracking-widest ${badgeClass}">${badge}</span>
        @endif
    </label>

    <div class="relative">
        <!-- Flag display when a country is selected -->
        <div x-show="selectedCode !== ''"
             class="absolute inset-y-0 left-0 flex items-center pl-3 pointer-events-none"
             style="display: none;">
            <img :src="`https://flagcdn.com/w20/` + selectedCode.toLowerCase() + `.png`"
                 class="w-5 h-auto rounded-sm shadow-sm" alt="flag">
        </div>

        <!-- Search input -->
        <input type="text"
               x-model="search"
               @focus="openDropdown()"
               @keydown.arrow-down.prevent="isOpen = true"
               :class="selectedCode !== '' ? 'pl-10' : 'pl-3'"
               class="w-full border border-gray-300 rounded-md shadow-sm py-2 pr-10 focus:ring-blue-500 focus:border-blue-500 sm:text-sm transition-all"
               placeholder="Search for a country..."
               autocomplete="off">

        <!-- Hidden field: ISO code submitted to the server -->
        <input type="hidden" name="${name}" :value="selectedCode">

        <!-- Chevron icon -->
        <div class="absolute inset-y-0 right-0 flex items-center pr-2 pointer-events-none">
            <svg class="w-5 h-5 text-gray-400" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 20 20" fill="currentColor">
                <path fill-rule="evenodd" d="M10 3a.75.75 0 01.55.24l3.25 3.5a.75.75 0 11-1.1 1.02L10 4.852 7.3 7.76a.75.75 0 01-1.1-1.02l3.25-3.5A.75.75 0 0110 3zm-3.76 9.2a.75.75 0 011.06.04l2.7 2.908 2.7-2.908a.75.75 0 111.1 1.02l-3.25 3.5a.75.75 0 01-1.1 0l-3.25-3.5a.75.75 0 01.04-1.06z" clip-rule="evenodd" />
            </svg>
        </div>
    </div>

    <!-- Dropdown list -->
    <ul x-show="isOpen"
        x-transition:enter="transition ease-out duration-100"
        x-transition:enter-start="opacity-0 scale-95"
        x-transition:enter-end="opacity-100 scale-100"
        x-transition:leave="transition ease-in duration-75"
        x-transition:leave-start="opacity-100 scale-100"
        x-transition:leave-end="opacity-0 scale-95"
        class="absolute z-50 w-full py-1 mt-1 overflow-auto text-base bg-white border border-gray-200 rounded-md shadow-lg max-h-60 focus:outline-none sm:text-sm"
        style="display: none;"
        x-cloak>

        <template x-for="(item, index) in filteredList" :key="index">
            <li @mousedown.prevent="selectItem(item)"
                class="relative flex items-center py-2 pl-3 pr-9 text-gray-900 cursor-pointer select-none hover:bg-blue-50 hover:text-blue-700 transition-colors">
                <img :src="`https://flagcdn.com/w20/` + item.code.toLowerCase() + `.png`"
                     class="w-5 h-auto mr-3 rounded-sm shadow-sm" alt="flag">
                <span x-text="item.name" class="block truncate font-medium"></span>
                <span x-show="selectedCode === item.code" class="absolute inset-y-0 right-0 flex items-center pr-4 text-blue-600">
                    <svg class="w-5 h-5" viewBox="0 0 20 20" fill="currentColor">
                        <path fill-rule="evenodd" d="M16.704 4.153a.75.75 0 01.143 1.052l-8 10.5a.75.75 0 01-1.127.075l-4.5-4.5a.75.75 0 011.06-1.06l3.894 3.893 7.48-9.817a.75.75 0 011.05-.143z" clip-rule="evenodd" />
                    </svg>
                </span>
            </li>
        </template>

        <li x-show="filteredList.length === 0" class="relative py-2 pl-3 text-gray-500 select-none">
            No matching countries.
        </li>
    </ul>

    @if(errorId != null && !errorId.isEmpty())
    <span id="${errorId}" class="text-xs text-red-600 block mt-1">${errorMessage != null ? errorMessage : ""}</span>
    @endif
</div>
</div>
