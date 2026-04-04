@import com.kyc.app.model.NaturalPerson
@import java.util.List
@param List<NaturalPerson> persons
<div class="fade-in w-full pb-20 relative min-h-[500px]">

    <div class="flex flex-wrap w-full gap-8 mb-6 px-2 text-sm text-gray-800">
        <div class="flex flex-col">
            <h4 class="font-bold mb-2">Pending update</h4>
            <div class="flex items-center space-x-4">
                <div class="flex items-center"><svg class="w-4 h-4 mr-1 text-gray-400" fill="currentColor" viewBox="0 0 20 20"><path d="M9 2a1 1 0 000 2h2a1 1 0 100-2H9z" /><path fill-rule="evenodd" d="M4 5a2 2 0 012-2 3 3 0 003 3h2a3 3 0 003-3 2 2 0 012 2v11a2 2 0 01-2 2H6a2 2 0 01-2-2V5zm3 4a1 1 0 000 2h.01a1 1 0 100-2H7zm3 0a1 1 0 000 2h3a1 1 0 100-2h-3zm-3 4a1 1 0 100 2h.01a1 1 0 100-2H7zm3 0a1 1 0 100 2h3a1 1 0 100-2h-3z" clip-rule="evenodd" /></svg> <span class="text-xs text-gray-500 mr-1">Client</span> <span class="font-bold text-ihub-teal text-lg">2568</span></div>
                <div class="flex items-center"><svg class="w-4 h-4 mr-1 text-gray-400" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 9a3 3 0 100-6 3 3 0 000 6zm-7 9a7 7 0 1114 0H3z" clip-rule="evenodd" /></svg> <span class="text-xs text-gray-500 mr-1">i-Hub</span> <span class="font-bold text-blue-500 text-lg">9733</span></div>
            </div>
        </div>
        <div class="flex flex-col">
            <h4 class="font-bold mb-2">Pending creation</h4>
            <div class="flex items-center space-x-4">
                <div class="flex items-center"><svg class="w-4 h-4 mr-1 text-gray-400" fill="currentColor" viewBox="0 0 20 20"><path d="M8 9a3 3 0 100-6 3 3 0 000 6zM8 11a6 6 0 016 6H2a6 6 0 016-6zM16 7a1 1 0 10-2 0v1h-1a1 1 0 100 2h1v1a1 1 0 102 0v-1h1a1 1 0 100-2h-1V7z" /></svg> <span class="text-xs text-gray-500 mr-1">Client</span> <span class="font-bold text-ihub-teal text-lg">8735</span></div>
                <div class="flex items-center"><svg class="w-4 h-4 mr-1 text-gray-400" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 9a3 3 0 100-6 3 3 0 000 6zm-7 9a7 7 0 1114 0H3z" clip-rule="evenodd" /></svg> <span class="text-xs text-gray-500 mr-1">i-Hub</span> <span class="font-bold text-blue-500 text-lg">469</span></div>
            </div>
        </div>
    </div>

    <div class="bg-white rounded-[20px] shadow-sm border border-gray-100 overflow-visible w-full pb-4">
        <div class="overflow-x-auto w-full">
            <table class="table w-full">
                <thead>
                    <tr>
                        <th class="text-[11px] font-bold text-gray-400 uppercase tracking-widest rounded-tl-[20px]">
                            <div class="flex items-center gap-1">
                                <svg class="w-3 h-3" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M5 9V7a5 5 0 0110 0v2a2 2 0 012 2v5a2 2 0 01-2 2H5a2 2 0 01-2-2v-5a2 2 0 012-2zm8-2v2H7V7a3 3 0 016 0z" clip-rule="evenodd" /></svg>
                                Creation
                            </div>
                        </th>
                        <th class="text-[11px] font-bold text-gray-400 uppercase tracking-widest">i-Hub ID</th>
                        <th class="text-[11px] font-bold text-gray-400 uppercase tracking-widest">Last name</th>
                        <th class="text-[11px] font-bold text-gray-400 uppercase tracking-widest">First name</th>
                        <th class="text-[11px] font-bold text-gray-400 uppercase tracking-widest text-center">Clients</th>
                        <th class="text-[11px] font-bold text-gray-400 uppercase tracking-widest">Nationalities</th>
                        <th class="w-16 rounded-tr-[20px]"></th>
                    </tr>
                </thead>
                <tbody>
                    @if(persons.isEmpty())
                    <tr>
                        <td colspan="7" class="text-center py-10 text-gray-500 text-sm">No natural persons found.</td>
                    </tr>
                    @else
                    @for(var person : persons)
                    <tr hx-get="/dashboard/details/natural-person/${person.getId()}" hx-target="#tab-content"
                        class="hover:bg-ihub-tealLight cursor-pointer transition-colors group">
                        <td class="text-xs font-bold text-gray-600">28/08/2025</td>
                        <td class="text-xs font-bold text-gray-500 tracking-wide">${person.getId()}</td>
                        <td class="text-xs font-bold text-gray-800 uppercase">${person.getLastName()}</td>
                        <td class="text-xs font-bold text-gray-800 uppercase">${person.getFirstName()}</td>
                        <td class="text-center">
                            <div class="inline-flex items-center justify-center w-6 h-6 rounded bg-gray-200 text-gray-600">
                                <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20"><path d="M10.394 2.08a1 1 0 00-.788 0l-7 3a1 1 0 000 1.84L5.25 8.051a.999.999 0 01.356-.257l4-1.714a1 1 0 11.788 1.838L7.667 9.088l1.94.831a1 1 0 00.787 0l7-3a1 1 0 000-1.838l-7-3zM3.31 8.56l-1.42.61a1 1 0 000 1.838l7 3a1 1 0 00.788 0l7-3a1 1 0 000-1.838l-1.42-.61-5.186 2.222a1 1 0 01-.788 0L3.31 8.56z"/></svg>
                            </div>
                        </td>
                        <td class="text-xs font-medium text-gray-700">${person.getNationality()}</td>
                        <td class="text-right">
                            <button type="button" class="btn btn-circle btn-sm bg-ihub-teal hover:bg-[#12a1b0] text-white border-0 opacity-80 group-hover:opacity-100">
                                <svg class="w-4 h-4" fill="currentColor" viewBox="0 0 20 20"><path d="M6 10a2 2 0 11-4 0 2 2 0 014 0zM12 10a2 2 0 11-4 0 2 2 0 014 0zM16 12a2 2 0 100-4 2 2 0 000 4z" /></svg>
                            </button>
                        </td>
                    </tr>
                    @endfor
                    @endif
                </tbody>
            </table>
        </div>

        <div class="flex items-center justify-between px-8 py-4 mt-2">
            <div class="flex items-end gap-2 text-gray-400 leading-none">
                <span class="text-3xl font-extrabold text-gray-300 tracking-tighter">${persons.size()}</span>
                <span class="text-[10px] font-bold uppercase mb-1">NATURAL PERSONS</span>
            </div>
            <div class="flex items-center gap-4 text-xs font-bold text-gray-400">
                <span>1</span>
                <span class="text-gray-300">of 100</span>
                <svg class="w-4 h-4 text-gray-300" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M14 5l7 7m0 0l-7 7m7-7H3"></path></svg>
            </div>
            <div class="flex items-center text-xs font-bold text-gray-600 border border-gray-200 rounded-lg px-3 py-2 cursor-pointer">
                10 Per Page
                <svg class="w-3 h-3 ml-2 text-gray-400" fill="none" stroke="currentColor" stroke-width="3" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M19 9l-7 7-7-7"></path></svg>
            </div>
        </div>
    </div>

    <div class="fixed bottom-8 right-8 flex flex-col gap-3 z-50">
        <button hx-get="/dashboard/details/natural-person/0" hx-target="#tab-content"
                class="btn btn-circle btn-sm bg-ihub-teal hover:bg-[#12a1b0] text-white border-0 shadow-lg">
            <svg class="w-5 h-5" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M12 4v16m8-8H4"></path></svg>
        </button>
        <button class="btn btn-circle bg-ihub-teal hover:bg-[#12a1b0] text-white border-0 shadow-lg w-14 h-14">
            <svg class="w-7 h-7" fill="currentColor" viewBox="0 0 20 20"><path d="M6 10a2 2 0 11-4 0 2 2 0 014 0zM12 10a2 2 0 11-4 0 2 2 0 014 0zM16 12a2 2 0 100-4 2 2 0 000 4z" /></svg>
        </button>
    </div>
</div>
