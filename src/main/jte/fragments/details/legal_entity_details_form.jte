@import com.kyc.app.model.LegalEntity
@import java.util.Map
@param LegalEntity entity
@param Map<String, String> fieldErrors = null
@param boolean hasErrors = false
<div id="le-form-container">
<form hx-post="/dashboard/details/legal-entity" hx-target="#tab-content" id="le-form">
    <fieldset x-bind:disabled="!isEditMode" class="w-full border-none p-0 m-0">
    <div hx-post="/dashboard/validate/legal-entity" hx-trigger="keyup delay:500ms from:input, change from:select, customValidation from:body" hx-include="#le-form" hx-target="#le-form-container" hx-swap="morph"></div>
    <input type="hidden" name="id" value="${entity.getId() != null ? entity.getId().toString() : ""}"/>

    <h3 class="text-xl font-bold text-gray-700 mb-8 mt-2 border-b border-ihub-tealLight pb-4">Corporate data</h3>

    <div class="grid grid-cols-1 md:grid-cols-2 gap-x-8 gap-y-6">
        <div class="col-span-1 md:col-span-2 border border-gray-200 rounded px-4 py-1 relative flex items-center h-[52px]">
            <label class="absolute -top-[9px] left-3 bg-white px-1 text-[9px] text-gray-500 font-bold uppercase tracking-widest">Company Name</label>
            <span class="absolute -top-[9px] right-3 bg-white px-1 text-[9px] text-ihub-red font-bold uppercase tracking-widest">Mandatory</span>
            <input type="text" name="name" value="${entity.getName() != null ? entity.getName() : ""}" class="w-full h-full bg-transparent outline-none text-sm text-gray-800 pt-1 font-bold uppercase">
            <span id="err-le-name" class="text-xs text-red-600 block absolute -bottom-5">${fieldErrors != null ? fieldErrors.getOrDefault("name", "") : ""}</span>
        </div>

        <div class="col-span-1 border border-gray-200 rounded px-4 py-1 relative flex items-center h-[52px]">
            <label class="absolute -top-[9px] left-3 bg-white px-1 text-[9px] text-gray-500 font-bold uppercase tracking-widest">Registration Number</label>
            <span class="absolute -top-[9px] right-3 bg-white px-1 text-[9px] text-ihub-red font-bold uppercase tracking-widest">Mandatory</span>
            <input type="text" name="registrationNumber" value="${entity.getRegistrationNumber() != null ? entity.getRegistrationNumber() : ""}" class="w-full h-full bg-transparent outline-none text-sm text-gray-800 pt-1">
            <span id="err-le-registrationNumber" class="text-xs text-red-600 block absolute -bottom-5">${fieldErrors != null ? fieldErrors.getOrDefault("registrationNumber", "") : ""}</span>
        </div>

        @template.components.country_dropdown(
            label = "Country of Registration",
            fieldName = "country",
            value = entity.getCountry() != null ? entity.getCountry() : "",
            badge = "Mandatory",
            badgeClass = "text-ihub-red",
            errorId = "err-le-country",
            errorMessage = fieldErrors != null ? fieldErrors.getOrDefault("country", "") : ""
        )
    </div>

    <h3 class="text-xl font-bold text-gray-700 mb-8 mt-12 border-b border-ihub-tealLight pb-4">Registered address</h3>

    <div class="grid grid-cols-1 md:grid-cols-3 gap-x-6 gap-y-6">
        <div class="col-span-3 border border-gray-200 rounded px-4 py-1 relative flex items-center h-[52px]">
            <label class="absolute -top-[9px] left-3 bg-white px-1 text-[9px] text-gray-500 font-bold uppercase tracking-widest">Address Line 1</label>
            <input type="text" name="address.streetName" value="${entity.getAddress() != null && entity.getAddress().getStreetName() != null ? entity.getAddress().getStreetName() : ""}" class="w-full h-full bg-transparent outline-none text-sm text-gray-800 pt-1 uppercase">
        </div>
        <div class="col-span-1 border border-gray-200 rounded px-4 py-1 relative flex items-center h-[52px]">
            <label class="absolute -top-[9px] left-3 bg-white px-1 text-[9px] text-gray-500 font-bold uppercase tracking-widest">Zip Code</label>
            <input type="text" name="address.zipCode" value="${entity.getAddress() != null && entity.getAddress().getZipCode() != null ? entity.getAddress().getZipCode() : ""}" class="w-full h-full bg-transparent outline-none text-sm text-gray-800 pt-1">
        </div>
        <div class="col-span-1 border border-gray-200 rounded px-4 py-1 relative flex items-center h-[52px]">
            <label class="absolute -top-[9px] left-3 bg-white px-1 text-[9px] text-gray-500 font-bold uppercase tracking-widest">City</label>
            <input type="text" name="address.city" value="${entity.getAddress() != null && entity.getAddress().getCity() != null ? entity.getAddress().getCity() : ""}" class="w-full h-full bg-transparent outline-none text-sm text-gray-800 pt-1 uppercase">
        </div>
        @template.components.country_dropdown(
            label = "Country",
            fieldName = "address.country",
            value = entity.getAddress() != null && entity.getAddress().getCountry() != null ? entity.getAddress().getCountry() : ""
        )
    </div>

    <button type="submit" id="le-submit-btn-hidden" class="hidden">Save Hidden</button>
    </fieldset>
</form>

<div class="fixed bottom-8 right-8 z-50">
    <button type="button" @click="document.getElementById('le-submit-btn-hidden').click()" id="le-submit-btn"
            disabled="${hasErrors}"
            class="btn btn-circle bg-ihub-teal hover:bg-[#12a1b0] text-white border-0 shadow-lg w-14 h-14 flex flex-col disabled:bg-gray-300 disabled:cursor-not-allowed">
        <span class="text-[10px] font-bold tracking-wider uppercase">Save</span>
    </button>
</div>
</div>
