@import com.kyc.app.model.LegalEntity
@import java.util.Map
@param LegalEntity entity
@param boolean isValid = false
@param Map<String, String> fieldErrors = null
@param boolean hasErrors = false
<div class="bg-ihub-bg fade-in w-full relative pb-24" x-data="legalEntityForm(${entity.getId() == null})">

    <div class="flex flex-col lg:flex-row justify-between items-start lg:items-center bg-white border border-gray-100 px-6 py-4 rounded-t-[20px] shadow-sm mb-0 z-10 relative">
        <div class="flex items-start">
            <button hx-get="/dashboard/tab/legal-entities" hx-target="#tab-content" class="mt-1 mr-4 rounded-full border border-gray-300 w-8 h-8 flex items-center justify-center text-gray-400 hover:text-ihub-teal hover:border-ihub-teal transition-colors">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M15 19l-7-7 7-7"></path></svg>
            </button>
            <div class="w-12 h-12 rounded-full bg-gray-200 flex items-center justify-center text-gray-400 mr-4">
                <svg class="w-8 h-8" fill="currentColor" viewBox="0 0 24 24"><path d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"></path></svg>
            </div>
            <div class="flex flex-col">
                <div class="flex items-center space-x-3 mb-1">
                    <h3 class="text-xl font-bold uppercase tracking-tight text-blue-500">
                        @if(entity.getId() != null)
                        ${entity.getName()}
                        @else
                        CREATE LEGAL ENTITY
                        @endif
                    </h3>
                </div>
                @if(entity.getId() != null)
                <div class="flex items-center space-x-2 text-xs font-bold text-gray-500 mb-2">
                    <span>i-Hub ID <span class="font-normal ml-1">${entity.getId()}</span></span>
                    <span class="bg-ihub-teal text-white px-2 py-0.5 rounded text-[9px] tracking-wide ml-2">SIMPLE</span>
                </div>
                <div class="flex gap-6 mt-1 text-[10px] text-gray-500 uppercase tracking-wide">
                    <div><span class="font-bold">CREATED BY</span><br/>System<br/><span class="font-normal capitalize text-gray-400">On 28/08/2025</span></div>
                    <div><span class="font-bold">MODIFIED BY</span><br/>User<br/><span class="font-normal capitalize text-gray-400">On 28/08/2025</span></div>
                </div>
                @endif
            </div>
        </div>

        <div class="flex gap-8 items-center mt-4 lg:mt-0">
            @if(entity.getId() != null)
            <div class="flex gap-2">
                <button class="bg-orange-400 text-white rounded-full px-4 py-1.5 text-[10px] font-bold uppercase hover:bg-orange-500 transition-colors shadow-sm flex items-center">Pending update</button>
                <button class="bg-ihub-teal text-white rounded-full px-4 py-1.5 text-[10px] font-bold uppercase hover:bg-[#12a1b0] transition-colors shadow-sm flex items-center">Assign to me</button>
                <button class="w-8 h-8 rounded-full bg-ihub-teal flex items-center justify-center text-white"><svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20"><path d="M6 10a2 2 0 11-4 0 2 2 0 014 0zM12 10a2 2 0 11-4 0 2 2 0 014 0zM16 12a2 2 0 100-4 2 2 0 000 4z" /></svg></button>
            </div>
            @endif
        </div>
    </div>

    <div class="bg-ihub-tealDark px-4 flex justify-between rounded-bl-lg items-end pt-3">
        <div class="flex gap-1 overflow-x-auto hide-scrollbar">
            <button class="bg-white text-ihub-teal rounded-t-lg px-6 py-2.5 text-xs font-medium tracking-wide border-0 focus:outline-none">Data</button>
            <button class="text-white/80 hover:text-white px-5 py-2.5 text-xs font-medium tracking-wide">Documents</button>
            <button class="text-white/80 hover:text-white px-5 py-2.5 text-xs font-medium tracking-wide">Related parties</button>
        </div>
    </div>

    <div class="w-full bg-white shadow-sm border border-gray-100 p-8 min-h-[500px]">
        <div id="view-mode" x-show="!isEditMode">
            <div class="flex justify-end mb-6">
                <button type="button" @click="toggleEditMode()" class="px-6 py-2 rounded-full border text-ihub-teal border-ihub-teal font-bold text-xs uppercase hover:bg-cyan-50 transition-colors">Edit Data</button>
            </div>

            <h3 class="text-xl font-bold text-gray-700 mb-8 mt-2 border-b border-ihub-tealLight pb-4">Corporate data</h3>
            <div class="grid grid-cols-3 gap-x-8 gap-y-8 mb-12">
                <div class="col-span-3">
                    <span class="text-[10px] text-gray-400 font-bold uppercase tracking-widest block mb-1">Company Name</span>
                    <span class="text-sm font-bold text-gray-800 uppercase">${entity.getName() != null ? entity.getName() : "---"}</span>
                </div>
                <div>
                    <span class="text-[10px] text-gray-400 font-bold uppercase tracking-widest block mb-1">Registration Number</span>
                    <span class="text-sm font-bold text-gray-800">${entity.getRegistrationNumber() != null ? entity.getRegistrationNumber() : "---"}</span>
                </div>
                <div>
                    <span class="text-[10px] text-gray-400 font-bold uppercase tracking-widest block mb-1">Country of Registration</span>
                    <span class="text-sm font-bold text-gray-800">${entity.getCountry() != null ? entity.getCountry() : "---"}</span>
                </div>
            </div>

            <h3 class="text-xl font-bold text-gray-700 mb-8 border-b border-ihub-tealLight pb-4">Registered address</h3>
            <div class="grid grid-cols-3 gap-x-8 gap-y-8 mb-12">
                <div class="col-span-3">
                    <span class="text-[10px] text-gray-400 font-bold uppercase tracking-widest block mb-1">Address Line 1</span>
                    <span class="text-sm font-bold text-gray-800 uppercase">${entity.getAddress() != null && entity.getAddress().getStreetName() != null ? entity.getAddress().getStreetName() : "---"}</span>
                </div>
                <div>
                    <span class="text-[10px] text-gray-400 font-bold uppercase tracking-widest block mb-1">Zip Code</span>
                    <span class="text-sm font-bold text-gray-800">${entity.getAddress() != null && entity.getAddress().getZipCode() != null ? entity.getAddress().getZipCode() : "---"}</span>
                </div>
                <div>
                    <span class="text-[10px] text-gray-400 font-bold uppercase tracking-widest block mb-1">City</span>
                    <span class="text-sm font-bold text-gray-800 uppercase">${entity.getAddress() != null && entity.getAddress().getCity() != null ? entity.getAddress().getCity() : "---"}</span>
                </div>
                <div>
                    <span class="text-[10px] text-gray-400 font-bold uppercase tracking-widest block mb-1">Country</span>
                    <span class="text-sm font-bold text-gray-800">${entity.getAddress() != null && entity.getAddress().getCountry() != null ? entity.getAddress().getCountry() : "---"}</span>
                </div>
            </div>
        </div>

        <div id="edit-mode" x-show="isEditMode">
            @template.fragments.details.legal_entity_details_form(entity = entity, fieldErrors = fieldErrors, hasErrors = hasErrors)
        </div>
    </div>

    <div class="fixed bottom-8 right-8 flex flex-col gap-3 z-50" x-show="isEditMode" x-transition>
        <button type="button" @click="document.getElementById('le-submit-btn-hidden').click()" id="le-submit-btn"
                disabled="${hasErrors}"
                class="w-14 h-14 bg-ihub-teal hover:bg-[#12a1b0] rounded-full text-white shadow-lg flex flex-col items-center justify-center transition-transform hover:scale-105 active:scale-95 disabled:bg-gray-300 disabled:cursor-not-allowed">
            <span class="text-[10px] font-bold tracking-wider uppercase">Save</span>
        </button>
    </div>
    <div class="fixed bottom-8 left-8 z-50">
        <button type="button" hx-get="/dashboard/tab/legal-entities" hx-target="#tab-content" class="px-8 py-3 rounded-full border text-gray-600 font-bold border-gray-300 text-xs uppercase hover:bg-gray-50 transition-colors shadow-sm bg-white">Back</button>
    </div>
</div>
