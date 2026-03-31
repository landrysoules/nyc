@import com.kyc.app.model.NaturalPerson
@import java.util.Map
@param NaturalPerson person
@param boolean isValid = false
@param Map<String, String> fieldErrors = null
@param boolean hasErrors = false
<div class="bg-ihub-bg fade-in w-full relative pb-24" x-data="naturalPersonForm(${person.getId() == null})">

    <div class="flex flex-col lg:flex-row justify-between items-start lg:items-center bg-white border border-gray-100 px-6 py-4 rounded-t-[20px] shadow-sm mb-0 z-10 relative">
        <div class="flex items-start">
            <button hx-get="/dashboard/tab/natural-persons" hx-target="#tab-content" class="mt-1 mr-4 rounded-full border border-gray-300 w-8 h-8 flex items-center justify-center text-gray-400 hover:text-ihub-teal hover:border-ihub-teal transition-colors">
                <svg class="w-4 h-4" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M15 19l-7-7 7-7"></path></svg>
            </button>
            <div class="w-12 h-12 rounded-full bg-gray-200 flex items-center justify-center text-gray-400 mr-4">
                <svg class="w-8 h-8" fill="currentColor" viewBox="0 0 24 24"><path fill-rule="evenodd" d="M12 2a5 5 0 015 5v2a5 5 0 01-10 0V7a5 5 0 015-5zm-7 14a7 7 0 1114 0c0 1.28-.48 2.5-1.3 3.42C16.89 20.31 15.5 21 12 21s-4.89-.69-5.7-1.58C5.48 18.5 5 17.28 5 16z" clip-rule="evenodd" /></svg>
            </div>
            <div class="flex flex-col">
                <div class="flex items-center space-x-3 mb-1">
                    <h3 class="text-xl font-bold uppercase tracking-tight text-blue-500">
                        @if(person.getId() != null)
                        ${person.getFirstName()} ${person.getLastName()}
                        @else
                        CREATE NATURAL PERSON
                        @endif
                    </h3>
                </div>
                @if(person.getId() != null)
                <div class="flex items-center space-x-2 text-xs font-bold text-gray-500 mb-2">
                    <span>i-Hub ID <span class="font-normal ml-1">${person.getId()}</span></span>
                    <span class="bg-ihub-teal text-white px-2 py-0.5 rounded text-[9px] tracking-wide ml-2">SIMPLE</span>
                    <span class="bg-ihub-teal text-white w-5 h-5 rounded-full flex items-center justify-center text-[9px]"><svg class="w-3 h-3 mr-0.5" fill="currentColor" viewBox="0 0 20 20"><path d="M13 6a3 3 0 11-6 0 3 3 0 016 0zM18 8a2 2 0 11-4 0 2 2 0 014 0zM14 15a4 4 0 00-8 0v3h8v-3zM6 8a2 2 0 11-4 0 2 2 0 014 0zM16 18v-3a5.972 5.972 0 00-.75-2.906A3.005 3.005 0 0119 15v3h-3zM4.75 12.094A5.973 5.973 0 004 15v3H1v-3a3 3 0 013.75-2.906z" /></svg> 1</span>
                </div>
                <div class="flex gap-6 mt-1 text-[10px] text-gray-500 uppercase tracking-wide">
                    <div><span class="font-bold">CREATED BY</span><br/>System<br/><span class="font-normal capitalize text-gray-400">On 28/08/2025</span></div>
                    <div><span class="font-bold">MODIFIED BY</span><br/>User<br/><span class="font-normal capitalize text-gray-400">On 28/08/2025</span></div>
                    <div><span class="font-bold">VERIFIED BY</span><br/>IHUDIB0<br/><span class="font-normal capitalize text-gray-400">On 28/08/2025</span></div>
                </div>
                @endif
            </div>
        </div>

        <div class="flex gap-8 items-center mt-4 lg:mt-0">
            @if(person.getId() != null)
            <div class="flex gap-2">
                <button class="bg-orange-400 text-white rounded-full px-4 py-1.5 text-[10px] font-bold uppercase hover:bg-orange-500 transition-colors shadow-sm flex items-center">
                    <svg class="w-3 h-3 mr-1" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M12 8v4l3 3m6-3a9 9 0 11-18 0 9 9 0 0118 0z"></path></svg>
                    Pending update
                </button>
                <button class="bg-ihub-teal text-white rounded-full px-4 py-1.5 text-[10px] font-bold uppercase hover:bg-[#12a1b0] transition-colors shadow-sm flex items-center">
                    <svg class="w-3 h-3 mr-1" fill="currentColor" viewBox="0 0 20 20"><path d="M8 9a3 3 0 100-6 3 3 0 000 6zM8 11a6 6 0 016 6H2a6 6 0 016-6zM16 7a1 1 0 10-2 0v1h-1a1 1 0 100 2h1v1a1 1 0 102 0v-1h1a1 1 0 100-2h-1V7z" /></svg>
                    Assign to me
                </button>
                <button class="w-8 h-8 rounded-full bg-ihub-teal flex items-center justify-center text-white"><svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20"><path d="M6 10a2 2 0 11-4 0 2 2 0 014 0zM12 10a2 2 0 11-4 0 2 2 0 014 0zM16 12a2 2 0 100-4 2 2 0 000 4z" /></svg></button>
            </div>
            <div class="flex flex-col gap-2 border-l border-gray-200 pl-6 text-[10px] font-bold text-gray-500 uppercase">
                <div class="flex justify-end items-center gap-2">I-HUB ID STATUS <svg class="w-4 h-4 text-red-500" fill="none" stroke="currentColor" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10" stroke-width="2"></circle><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 9l-6 6M9 9l6 6"></path></svg></div>
                <div class="flex justify-end items-center gap-2">GLOBAL ACTION STATUS <svg class="w-4 h-4 text-orange-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10" stroke-width="2"></circle><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3"></path></svg></div>
                <div class="flex justify-end items-center gap-2">SCREENING <svg class="w-4 h-4 text-orange-400" fill="none" stroke="currentColor" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10" stroke-width="2"></circle><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4l3 3"></path></svg></div>
                <div class="flex justify-end items-center gap-2">COMPLETENESS <svg class="w-4 h-4 text-green-500" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"></path></svg></div>
                <div class="flex justify-end items-center gap-2">DUE DILIGENCE <div class="w-3.5 h-3.5 rounded-full border-2 border-gray-400"></div></div>
            </div>
            @endif
        </div>
    </div>

    <div class="bg-ihub-tealDark px-4 flex justify-between rounded-bl-lg items-end pt-3">
        <div class="flex gap-1 overflow-x-auto hide-scrollbar">
            <button class="bg-white text-ihub-teal rounded-t-lg px-6 py-2.5 text-xs font-medium tracking-wide border-0 focus:outline-none">Data</button>
            <button class="text-white/80 hover:text-white px-5 py-2.5 text-xs font-medium tracking-wide">Documents</button>
            <button class="text-white/80 hover:text-white px-5 py-2.5 text-xs font-medium tracking-wide flex items-center gap-2">Related parties <span class="bg-white/20 text-white rounded-full px-1.5 py-0.5 text-[10px]">0</span></button>
            <button class="text-white/80 hover:text-white px-5 py-2.5 text-xs font-medium tracking-wide flex items-center gap-2">Roles <span class="bg-white/20 text-white rounded-full px-1.5 py-0.5 text-[10px]">0</span></button>
            <button class="text-white/80 hover:text-white px-5 py-2.5 text-xs font-medium tracking-wide">Relationships</button>
            <button class="text-white/80 hover:text-white px-5 py-2.5 text-xs font-medium tracking-wide">Scoring</button>
            <button class="text-white/80 hover:text-white px-5 py-2.5 text-xs font-medium tracking-wide">Due Diligence</button>
            <button class="text-white/80 hover:text-white px-5 py-2.5 text-xs font-medium tracking-wide">Contact</button>
            <button class="text-white/80 hover:text-white px-5 py-2.5 text-xs font-medium tracking-wide">Enquiries</button>
        </div>
        <button class="bg-white text-gray-700 rounded-t-lg px-5 py-2.5 text-xs font-medium tracking-wide">Audit trail</button>
    </div>

    <div class="w-full bg-white shadow-sm border border-gray-100 p-8 min-h-[500px]">
        <div id="view-mode" x-show="!isEditMode">
            <div class="flex justify-end mb-6">
                <button type="button" @click="toggleEditMode()" class="px-6 py-2 rounded-full border text-ihub-teal border-ihub-teal font-bold text-xs uppercase hover:bg-cyan-50 transition-colors">
                    Edit Data
                </button>
            </div>

            <h3 class="text-xl font-bold text-gray-700 mb-8 mt-2 border-b border-ihub-tealLight pb-4">Personal data</h3>
            <div class="grid grid-cols-3 gap-x-8 gap-y-8 mb-12">
                <div>
                    <span class="text-[10px] text-gray-400 font-bold uppercase tracking-widest block mb-1">Last Name</span>
                    <span class="text-sm font-bold text-gray-800">${person.getLastName() != null ? person.getLastName() : "---"}</span>
                </div>
                <div>
                    <span class="text-[10px] text-gray-400 font-bold uppercase tracking-widest block mb-1">First Name</span>
                    <span class="text-sm font-bold text-gray-800">${person.getFirstName() != null ? person.getFirstName() : "---"}</span>
                </div>
                <div>
                    <span class="text-[10px] text-gray-400 font-bold uppercase tracking-widest block mb-1">Date of Birth</span>
                    <span class="text-sm font-bold text-gray-800">${person.getDateOfBirth() != null ? person.getDateOfBirth().toString() : "---"}</span>
                </div>
                <div>
                    <span class="text-[10px] text-gray-400 font-bold uppercase tracking-widest block mb-1">Nationality</span>
                    <span class="text-sm font-bold text-gray-800">${person.getNationality() != null ? person.getNationality() : "---"}</span>
                </div>
            </div>

            <h3 class="text-xl font-bold text-gray-700 mb-8 border-b border-ihub-tealLight pb-4">Residence address</h3>
            <div class="grid grid-cols-3 gap-x-8 gap-y-8 mb-12">
                <div class="col-span-3">
                    <span class="text-[10px] text-gray-400 font-bold uppercase tracking-widest block mb-1">Address Line 1</span>
                    <span class="text-sm font-bold text-gray-800 uppercase">${person.getAddress() != null && person.getAddress().getStreetName() != null ? person.getAddress().getStreetName() : "---"}</span>
                </div>
                <div>
                    <span class="text-[10px] text-gray-400 font-bold uppercase tracking-widest block mb-1">Zip Code</span>
                    <span class="text-sm font-bold text-gray-800">${person.getAddress() != null && person.getAddress().getZipCode() != null ? person.getAddress().getZipCode() : "---"}</span>
                </div>
                <div>
                    <span class="text-[10px] text-gray-400 font-bold uppercase tracking-widest block mb-1">City</span>
                    <span class="text-sm font-bold text-gray-800 uppercase">${person.getAddress() != null && person.getAddress().getCity() != null ? person.getAddress().getCity() : "---"}</span>
                </div>
                <div>
                    <span class="text-[10px] text-gray-400 font-bold uppercase tracking-widest block mb-1">Country</span>
                    <span class="text-sm font-bold text-gray-800">${person.getAddress() != null && person.getAddress().getCountry() != null ? person.getAddress().getCountry() : "---"}</span>
                </div>
            </div>
        </div>

        <div id="edit-mode" x-show="isEditMode">
            @template.fragments.details.natural_person_details_form(person = person, fieldErrors = fieldErrors, hasErrors = hasErrors)
        </div>
    </div>

    <div class="fixed bottom-8 right-8 flex flex-col gap-3 z-50" x-show="isEditMode" x-transition>
        <button type="button" @click="document.getElementById('np-submit-btn-hidden').click()" id="np-submit-btn"
                disabled="${hasErrors}"
                class="w-14 h-14 bg-ihub-teal hover:bg-[#12a1b0] rounded-full text-white shadow-lg flex flex-col items-center justify-center transition-transform hover:scale-105 active:scale-95 disabled:bg-gray-300 disabled:cursor-not-allowed">
            <span class="text-[10px] font-bold tracking-wider uppercase">Save</span>
        </button>
        <button class="w-12 h-12 bg-ihub-teal hover:bg-[#12a1b0] rounded-full text-white shadow-lg flex items-center justify-center transition-transform ml-auto hover:scale-105 active:scale-95">
            <svg class="w-6 h-6" fill="currentColor" viewBox="0 0 20 20"><path d="M6 10a2 2 0 11-4 0 2 2 0 014 0zM12 10a2 2 0 11-4 0 2 2 0 014 0zM16 12a2 2 0 100-4 2 2 0 000 4z" /></svg>
        </button>
    </div>
    <div class="fixed bottom-8 left-8 z-50">
        <button type="button" hx-get="/dashboard/tab/natural-persons" hx-target="#tab-content" class="px-8 py-3 rounded-full border text-gray-600 font-bold border-gray-300 text-xs uppercase hover:bg-gray-50 transition-colors shadow-sm bg-white">
            Back
        </button>
    </div>
</div>
