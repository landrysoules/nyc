@import com.kyc.app.model.Contract
@import java.util.Map
@param Contract contract
@param Map<String, String> fieldErrors = null
@param boolean hasErrors = false
<form hx-post="/dashboard/details/contract" hx-target="#tab-content" id="contract-form">
    <fieldset x-bind:disabled="!isEditMode" class="w-full border-none p-0 m-0">
    <div hx-post="/dashboard/validate/contract" hx-trigger="keyup delay:500ms from:input, change from:select" hx-include="#contract-form" hx-swap="none"></div>
    <input type="hidden" name="id" value="${contract.getId() != null ? contract.getId().toString() : ""}"/>

    <h3 class="text-xl font-bold text-gray-700 mb-8 mt-2 border-b border-ihub-tealLight pb-4">Contract settings</h3>

    <div class="grid grid-cols-1 md:grid-cols-2 gap-x-8 gap-y-6">
        <div class="col-span-1 md:col-span-2 border border-gray-200 rounded px-4 py-1 relative flex items-center h-[52px]">
            <label class="absolute -top-[9px] left-3 bg-white px-1 text-[9px] text-gray-500 font-bold uppercase tracking-widest">Contract Name</label>
            <span class="absolute -top-[9px] right-3 bg-white px-1 text-[9px] text-ihub-red font-bold uppercase tracking-widest">Mandatory</span>
            <input type="text" name="name" value="${contract.getName() != null ? contract.getName() : ""}" class="w-full h-full bg-transparent outline-none text-sm text-gray-800 pt-1 font-bold uppercase">
            <span id="err-contract-name" class="text-xs text-red-600 block absolute -bottom-5">${fieldErrors != null ? fieldErrors.getOrDefault("name", "") : ""}</span>
        </div>

        <div class="col-span-1 border border-gray-200 rounded px-4 py-1 relative flex items-center h-[52px]">
            <label class="absolute -top-[9px] left-3 bg-white px-1 text-[9px] text-gray-500 font-bold uppercase tracking-widest">Status</label>
            <span class="absolute -top-[9px] right-3 bg-white px-1 text-[9px] text-ihub-red font-bold uppercase tracking-widest">Mandatory</span>
            <select name="status" class="w-full bg-transparent outline-none text-sm text-gray-800 appearance-none pt-1 cursor-pointer font-bold">
                <option value="DRAFT" ${"DRAFT".equals(contract.getStatus()) ? "selected" : ""}>Draft</option>
                <option value="ACTIVE" ${"ACTIVE".equals(contract.getStatus()) ? "selected" : ""}>Active</option>
                <option value="TERMINATED" ${"TERMINATED".equals(contract.getStatus()) ? "selected" : ""}>Terminated</option>
            </select>
            <div class="absolute right-4 text-gray-400 pointer-events-none">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path></svg>
            </div>
            <span id="err-contract-status" class="text-xs text-red-600 block absolute -bottom-5">${fieldErrors != null ? fieldErrors.getOrDefault("status", "") : ""}</span>
        </div>
    </div>

    <button type="submit" id="contract-submit-btn-hidden" class="hidden">Save Hidden</button>
    </fieldset>
</form>
