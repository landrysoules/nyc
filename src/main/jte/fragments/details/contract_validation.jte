@import java.util.Map
@param Map<String, String> fieldErrors
@param boolean hasErrors
<div style="display: none;">
    <span id="err-contract-name" hx-swap-oob="true" class="text-xs text-red-600 block absolute -bottom-5">${fieldErrors.getOrDefault("name", "")}</span>
    <span id="err-contract-status" hx-swap-oob="true" class="text-xs text-red-600 block absolute -bottom-5">${fieldErrors.getOrDefault("status", "")}</span>
    <button id="contract-submit-btn" hx-swap-oob="true" type="button" @click="document.getElementById('contract-submit-btn-hidden').click()"
            disabled="${hasErrors}"
            class="w-14 h-14 bg-ihub-teal hover:bg-[#12a1b0] rounded-full text-white shadow-lg flex flex-col items-center justify-center transition-transform hover:scale-105 active:scale-95 disabled:bg-gray-300 disabled:cursor-not-allowed">
        <span class="text-[10px] font-bold tracking-wider uppercase">Save</span>
    </button>
</div>
