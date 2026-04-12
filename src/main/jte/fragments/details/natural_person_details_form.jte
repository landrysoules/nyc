@import com.kyc.app.model.NaturalPerson
@import com.kyc.app.model.Gender
@import java.util.Map
@param NaturalPerson person
@param Map<String, String> fieldErrors = null
@param boolean hasErrors = false
<div id="np-form-container">
<form hx-post="/dashboard/details/natural-person" hx-target="#tab-content" id="np-form">
    <fieldset x-bind:disabled="!isEditMode" class="w-full border-none p-0 m-0">
    <%-- hx-sync="this:drop" : si une requête de validation est en cours, les nouveaux déclencheurs
         sont ignorés (pas d'annulation = pas d'erreur console). Le debounce 500ms gère la fréquence. --%>
    <div hx-post="/dashboard/validate/natural-person" hx-trigger="keyup delay:500ms from:input, change from:select, customValidation from:body" hx-include="#np-form" hx-target="#np-form-container" hx-swap="morph" hx-sync="this:drop"></div>
    <input type="hidden" name="id" value="${person.getId() != null ? person.getId().toString() : ""}"/>

    <h3 class="text-xl font-bold text-gray-700 mb-8 mt-2 border-b border-ihub-tealLight pb-4">Personal data</h3>

    <div class="grid grid-cols-1 md:grid-cols-2 gap-x-8 gap-y-6">

        <%-- Gender — checked dynamique basé sur person.getGender() (fix: ne plus hardcoder MALE) --%>
        <div class="col-span-1 border border-gray-200 rounded px-4 py-3 relative">
            <label class="absolute -top-[9px] left-3 bg-white px-1 text-[9px] text-gray-500 font-bold uppercase tracking-widest">Gender</label>
            <div class="flex items-center space-x-6 text-sm text-gray-600 font-medium h-full pt-1">
                <label class="flex items-center cursor-pointer">
                    <input type="radio" name="gender" value="FEMALE"
                           checked="${person.getGender() != null && person.getGender() == Gender.FEMALE}"
                           class="appearance-none w-4 h-4 border-[4px] border-gray-300 bg-white rounded-full mr-2 ring-1 ring-ihub-teal transition-all focus:outline-none cursor-pointer checked:border-ihub-teal checked:bg-ihub-teal checked:shadow-[inset_0_0_0_2px_white]" />
                    <span class="uppercase text-xs tracking-wider">Female</span>
                </label>
                <label class="flex items-center cursor-pointer">
                    <input type="radio" name="gender" value="MALE"
                           checked="${person.getGender() == null || person.getGender() == Gender.MALE}"
                           class="appearance-none w-4 h-4 border-[4px] border-gray-300 bg-white rounded-full mr-2 ring-1 ring-ihub-teal transition-all focus:outline-none cursor-pointer checked:border-ihub-teal checked:bg-ihub-teal checked:shadow-[inset_0_0_0_2px_white]" />
                    <span class="uppercase text-xs tracking-wider">Male</span>
                </label>
                <label class="flex items-center cursor-pointer">
                    <input type="radio" name="gender" value="OTHER"
                           checked="${person.getGender() != null && person.getGender() == Gender.OTHER}"
                           class="appearance-none w-4 h-4 border-[4px] border-gray-300 bg-white rounded-full mr-2 ring-1 ring-ihub-teal transition-all focus:outline-none cursor-pointer checked:border-ihub-teal checked:bg-ihub-teal checked:shadow-[inset_0_0_0_2px_white]" />
                    <span class="uppercase text-xs tracking-wider">Other</span>
                </label>
            </div>
        </div>

        <%-- Title — name="title" ajouté (fix: le champ n'était pas soumis dans le formulaire) --%>
        <div class="col-span-1 border border-gray-200 rounded px-4 py-1 relative flex items-center h-[52px]">
            <label class="absolute -top-[9px] left-3 bg-white px-1 text-[9px] text-gray-500 font-bold uppercase tracking-widest">Title</label>
            <select name="title" class="w-full bg-transparent outline-none text-sm text-gray-800 appearance-none pt-1 cursor-pointer">
                <option value="">—</option>
                <option value="Mr.">Mr.</option>
                <option value="Mrs.">Mrs.</option>
                <option value="Ms.">Ms.</option>
                <option value="Dr.">Dr.</option>
                <option value="Prof.">Prof.</option>
            </select>
            <div class="absolute right-4 text-gray-400 pointer-events-none">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7"></path></svg>
            </div>
        </div>

        <div class="col-span-1 border border-gray-200 rounded px-4 py-1 relative flex items-center h-[52px]">
            <label class="absolute -top-[9px] left-3 bg-white px-1 text-[9px] text-gray-500 font-bold uppercase tracking-widest">Last Name</label>
            <span class="absolute -top-[9px] right-3 bg-white px-1 text-[9px] text-ihub-red font-bold uppercase tracking-widest">Mandatory</span>
            <input type="text" x-model.fill="lastName" name="lastName" value="${person.getLastName() != null ? person.getLastName() : ""}" class="w-full h-full bg-transparent outline-none text-sm text-gray-800 pt-1 font-bold">
            <span id="err-lastName" class="text-xs text-red-600 block absolute -bottom-5">${fieldErrors != null ? fieldErrors.getOrDefault("lastName", "") : ""}</span>
        </div>

        <div class="col-span-1 border border-gray-200 rounded px-4 py-1 relative flex items-center h-[52px]">
            <label class="absolute -top-[9px] left-3 bg-white px-1 text-[9px] text-gray-500 font-bold uppercase tracking-widest">First Name</label>
            <span class="absolute -top-[9px] right-3 bg-white px-1 text-[9px] text-ihub-red font-bold uppercase tracking-widest">Mandatory</span>
            <input type="text" x-model.fill="firstName" name="firstName" value="${person.getFirstName() != null ? person.getFirstName() : ""}" class="w-full h-full bg-transparent outline-none text-sm text-gray-800 pt-1">
            <span id="err-firstName" class="text-xs text-red-600 block absolute -bottom-5">${fieldErrors != null ? fieldErrors.getOrDefault("firstName", "") : ""}</span>
        </div>

        <%-- Middle Name — name="middleName" ajouté (fix: le champ n'était pas soumis dans le formulaire) --%>
        <div class="col-span-1 border border-gray-200 rounded px-4 py-1 relative flex items-center h-[52px]">
            <label class="absolute -top-[9px] left-3 bg-white px-1 text-[9px] text-gray-500 font-bold uppercase tracking-widest">Middle Name</label>
            <input type="text" name="middleName" class="w-full h-full bg-transparent outline-none text-sm text-gray-800 pt-1">
        </div>

        <div class="col-span-1 border border-gray-200 rounded px-4 py-1 relative flex items-center h-[52px]">
            <label class="absolute -top-[9px] left-3 bg-white px-1 text-[9px] text-gray-500 font-bold uppercase tracking-widest">Date of Birth</label>
            <span class="absolute -top-[9px] right-3 bg-white px-1 text-[9px] text-orange-400 font-bold uppercase tracking-widest">Recommended</span>
            <input type="date" x-model.fill="dateOfBirth" name="dateOfBirth" value="${person.getDateOfBirth() != null ? person.getDateOfBirth().toString() : ""}" class="w-full h-full bg-transparent outline-none text-sm text-gray-800 pt-1">
            <span id="err-dateOfBirth" class="text-xs text-red-600 block absolute -bottom-5">${fieldErrors != null ? fieldErrors.getOrDefault("dateOfBirth", "") : ""}</span>
        </div>

        @template.components.country_dropdown(
            label = "Nationality",
            fieldName = "nationality",
            value = person.getNationality() != null ? person.getNationality() : "",
            badge = "Recommended",
            badgeClass = "text-orange-400",
            errorId = "err-nationality",
            errorMessage = fieldErrors != null ? fieldErrors.getOrDefault("nationality", "") : ""
        )

        <div class="col-span-1 border border-gray-200 rounded px-4 py-1 relative flex items-center h-[52px]">
            <label class="absolute -top-[9px] left-3 bg-white px-1 text-[9px] text-gray-500 font-bold uppercase tracking-widest">Tax ID Number (TIN / NIF)</label>
            <input type="text" name="taxIdentificationNumber" value="${person.getTaxIdentificationNumber() != null ? person.getTaxIdentificationNumber() : ""}" class="w-full h-full bg-transparent outline-none text-sm text-gray-800 pt-1 font-mono tracking-wider">
        </div>

    </div>

    <h3 class="text-xl font-bold text-gray-700 mb-8 mt-12 border-b border-ihub-tealLight pb-4">Birth details</h3>

    <div class="grid grid-cols-1 md:grid-cols-2 gap-x-8 gap-y-6">

        <div class="col-span-1 border border-gray-200 rounded px-4 py-1 relative flex items-center h-[52px]">
            <label class="absolute -top-[9px] left-3 bg-white px-1 text-[9px] text-gray-500 font-bold uppercase tracking-widest">Place of Birth</label>
            <span class="absolute -top-[9px] right-3 bg-white px-1 text-[9px] text-orange-400 font-bold uppercase tracking-widest">Recommended</span>
            <input type="text" name="placeOfBirth" value="${person.getPlaceOfBirth() != null ? person.getPlaceOfBirth() : ""}" class="w-full h-full bg-transparent outline-none text-sm text-gray-800 pt-1">
            <span id="err-placeOfBirth" class="text-xs text-red-600 block absolute -bottom-5">${fieldErrors != null ? fieldErrors.getOrDefault("placeOfBirth", "") : ""}</span>
        </div>

        @template.components.country_dropdown(
            label = "Country of Birth",
            fieldName = "countryOfBirth",
            value = person.getCountryOfBirth() != null ? person.getCountryOfBirth() : "",
            badge = "Recommended",
            badgeClass = "text-orange-400",
            errorId = "err-countryOfBirth",
            errorMessage = fieldErrors != null ? fieldErrors.getOrDefault("countryOfBirth", "") : ""
        )

    </div>

    <h3 class="text-xl font-bold text-gray-700 mb-8 mt-12 border-b border-ihub-tealLight pb-4">Residence address</h3>

    <div class="grid grid-cols-1 md:grid-cols-3 gap-x-6 gap-y-6">
        <div class="col-span-3 border border-gray-200 rounded px-4 py-1 relative flex items-center h-[52px]">
            <label class="absolute -top-[9px] left-3 bg-white px-1 text-[9px] text-gray-500 font-bold uppercase tracking-widest">Address Line 1</label>
            <input type="text" name="address.streetName" value="${person.getAddress() != null && person.getAddress().getStreetName() != null ? person.getAddress().getStreetName() : ""}" class="w-full h-full bg-transparent outline-none text-sm text-gray-800 pt-1 uppercase">
        </div>
        <div class="col-span-1 border border-gray-200 rounded px-4 py-1 relative flex items-center h-[52px]">
            <label class="absolute -top-[9px] left-3 bg-white px-1 text-[9px] text-gray-500 font-bold uppercase tracking-widest">Zip Code</label>
            <input type="text" name="address.zipCode" value="${person.getAddress() != null && person.getAddress().getZipCode() != null ? person.getAddress().getZipCode() : ""}" class="w-full h-full bg-transparent outline-none text-sm text-gray-800 pt-1">
        </div>
        <div class="col-span-1 border border-gray-200 rounded px-4 py-1 relative flex items-center h-[52px]">
            <label class="absolute -top-[9px] left-3 bg-white px-1 text-[9px] text-gray-500 font-bold uppercase tracking-widest">City</label>
            <input type="text" name="address.city" value="${person.getAddress() != null && person.getAddress().getCity() != null ? person.getAddress().getCity() : ""}" class="w-full h-full bg-transparent outline-none text-sm text-gray-800 pt-1 uppercase">
        </div>
        @template.components.country_dropdown(
            label = "Country",
            fieldName = "address.country",
            value = person.getAddress() != null && person.getAddress().getCountry() != null ? person.getAddress().getCountry() : ""
        )
    </div>

    <button type="submit" id="np-submit-btn-hidden" class="hidden">Save Hidden</button>
    </fieldset>
</form>

<div class="fixed bottom-8 right-8 flex flex-col gap-3 z-50">
    <button type="button" @click="document.getElementById('np-submit-btn-hidden').click()" id="np-submit-btn"
            disabled="${hasErrors}"
            class="btn btn-circle bg-ihub-teal hover:bg-[#12a1b0] text-white border-0 shadow-lg w-14 h-14 flex flex-col disabled:bg-gray-300 disabled:cursor-not-allowed">
        <span class="text-[10px] font-bold tracking-wider uppercase">Save</span>
    </button>
    <button class="btn btn-circle btn-sm bg-ihub-teal hover:bg-[#12a1b0] text-white border-0 shadow-lg ml-auto">
        <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20"><path d="M6 10a2 2 0 11-4 0 2 2 0 014 0zM12 10a2 2 0 11-4 0 2 2 0 014 0zM16 12a2 2 0 100-4 2 2 0 000 4z" /></svg>
    </button>
</div>
</div>
