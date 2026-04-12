@import com.kyc.app.model.PersonDocument
@import com.kyc.app.model.PersonDocumentVersion
@import com.kyc.app.model.DocumentType
@import com.kyc.app.model.KycStatus
@import java.util.List
@param Long personId
@param List<PersonDocument> providedDocuments
@param List<PersonDocument> missingDocuments
@param List<DocumentType> availableTypes

<div id="np-documents-tab"
     x-data="{
        personId: ${personId},
        showRequireForm: false,
        expandedDoc: null,
        viewingVersion: null,
        toggleDoc(id) { this.expandedDoc = this.expandedDoc === id ? null : id },
        openViewer(docId, versionId, fileName) { this.viewingVersion = { docId, versionId, fileName } },
        closeViewer() { this.viewingVersion = null }
     }"
     class="p-6">

    <!-- Version viewer modal -->
    <div x-show="viewingVersion !== null"
         x-transition:enter="transition ease-out duration-200"
         x-transition:enter-start="opacity-0"
         x-transition:enter-end="opacity-100"
         x-transition:leave="transition ease-in duration-150"
         x-transition:leave-start="opacity-100"
         x-transition:leave-end="opacity-0"
         @keydown.escape.window="closeViewer()"
         class="fixed inset-0 bg-black/60 z-50 flex items-center justify-center p-4"
         style="display:none">
        <div class="bg-white rounded-2xl w-full max-w-5xl h-[85vh] flex flex-col shadow-2xl">
            <div class="flex justify-between items-center px-6 py-4 border-b border-gray-100">
                <div class="flex items-center gap-3">
                    <svg class="w-5 h-5 text-ihub-teal" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"/></svg>
                    <span class="font-bold text-gray-700 text-sm" x-text="viewingVersion?.fileName"></span>
                </div>
                <button @click="closeViewer()" class="w-8 h-8 flex items-center justify-center rounded-full hover:bg-gray-100 text-gray-400 hover:text-gray-600 transition-colors">
                    <svg class="w-5 h-5" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M6 18L18 6M6 6l12 12"/></svg>
                </button>
            </div>
            <div class="flex-1 overflow-hidden rounded-b-2xl">
                <template x-if="viewingVersion !== null">
                    <iframe :src="'/dashboard/details/natural-person/' + personId + '/document/' + viewingVersion.docId + '/version/' + viewingVersion.versionId + '/view'"
                            class="w-full h-full border-0"
                            :data-key="viewingVersion.versionId">
                    </iframe>
                </template>
            </div>
        </div>
    </div>

    <!-- Header row -->
    <div class="flex justify-between items-center mb-6">
        <h3 class="text-base font-bold text-gray-700 uppercase tracking-wide">Document Management</h3>
        @if(!availableTypes.isEmpty())
        <button @click="showRequireForm = !showRequireForm"
                class="flex items-center gap-2 bg-ihub-teal text-white rounded-full px-5 py-2 text-xs font-bold uppercase hover:bg-[#12a1b0] transition-colors shadow-sm">
            <svg class="w-4 h-4" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M12 4v16m8-8H4"/></svg>
            <span x-text="showRequireForm ? 'Cancel' : 'Require Document'"></span>
        </button>
        @endif
    </div>

    <!-- Require document form -->
    <div x-show="showRequireForm"
         x-transition:enter="transition ease-out duration-200"
         x-transition:enter-start="opacity-0 -translate-y-2"
         x-transition:enter-end="opacity-100 translate-y-0"
         class="bg-ihub-tealDark/5 border border-ihub-tealLight rounded-xl p-5 mb-6"
         style="display:none">
        <h4 class="text-xs font-bold uppercase tracking-widest text-ihub-teal mb-4">Request a New Document</h4>
        <form hx-post="/dashboard/details/natural-person/${personId}/require-document"
              hx-target="#np-documents-tab"
              hx-swap="outerHTML"
              @htmx:after-request="showRequireForm = false"
              class="flex flex-wrap gap-4 items-end">
            <div class="flex flex-col gap-1 min-w-[220px]">
                <label class="text-[10px] font-bold uppercase tracking-widest text-gray-500">Document Type <span class="text-red-400">*</span></label>
                <select name="documentType" required
                        class="border border-gray-200 rounded-lg px-3 py-2 text-sm text-gray-700 focus:outline-none focus:ring-2 focus:ring-ihub-teal/40 bg-white">
                    <option value="">— Select type —</option>
                    @for(DocumentType t : availableTypes)
                    <option value="${t.name()}">${t.getLabel()}</option>
                    @endfor
                </select>
            </div>
            <div class="flex flex-col gap-1 flex-1 min-w-[260px]">
                <label class="text-[10px] font-bold uppercase tracking-widest text-gray-500">Instruction / Note</label>
                <input type="text" name="note" placeholder="e.g. Document must be less than 3 months old"
                       class="border border-gray-200 rounded-lg px-3 py-2 text-sm text-gray-700 focus:outline-none focus:ring-2 focus:ring-ihub-teal/40 bg-white"/>
            </div>
            <button type="submit"
                    class="bg-ihub-teal text-white rounded-lg px-6 py-2 text-xs font-bold uppercase hover:bg-[#12a1b0] transition-colors">
                Require
            </button>
        </form>
    </div>

    <!-- Provided Documents -->
    <div class="mb-8">
        <div class="flex items-center gap-2 mb-3">
            <svg class="w-4 h-4 text-green-500" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zm3.707-9.293a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z" clip-rule="evenodd"/></svg>
            <h4 class="text-xs font-bold uppercase tracking-widest text-gray-500">Provided Documents</h4>
            <span class="bg-green-100 text-green-700 text-[10px] font-bold px-2 py-0.5 rounded-full">${providedDocuments.size()}</span>
        </div>

        @if(providedDocuments.isEmpty())
        <div class="bg-white rounded-xl border border-gray-100 p-8 text-center text-gray-400 text-sm">
            No documents have been provided yet.
        </div>
        @else
        <div class="bg-white rounded-xl border border-gray-100 overflow-hidden">
            <table class="w-full text-sm">
                <thead>
                    <tr class="border-b border-gray-100">
                        <th class="text-left text-[10px] font-bold uppercase tracking-widest text-gray-400 px-4 py-3">Document Type</th>
                        <th class="text-left text-[10px] font-bold uppercase tracking-widest text-gray-400 px-4 py-3">Required By</th>
                        <th class="text-left text-[10px] font-bold uppercase tracking-widest text-gray-400 px-4 py-3">Required On</th>
                        <th class="text-left text-[10px] font-bold uppercase tracking-widest text-gray-400 px-4 py-3">Versions</th>
                        <th class="text-left text-[10px] font-bold uppercase tracking-widest text-gray-400 px-4 py-3">Latest Status</th>
                        <th class="px-4 py-3"></th>
                    </tr>
                </thead>
                <tbody>
                    @for(PersonDocument doc : providedDocuments)
                    <tr class="border-b border-gray-50 hover:bg-gray-50/50 transition-colors">
                        <td class="px-4 py-3">
                            <span class="font-bold text-gray-800 text-xs">${doc.getDocumentType().getLabel()}</span>
                        </td>
                        <td class="px-4 py-3 text-xs text-gray-500">${doc.getRequiredBy() != null ? doc.getRequiredBy() : "—"}</td>
                        <td class="px-4 py-3 text-xs text-gray-500">
                            ${doc.getRequiredAt() != null ? doc.getRequiredAt().toLocalDate().toString() : "—"}
                        </td>
                        <td class="px-4 py-3">
                            <button @click="toggleDoc(${doc.getId()})"
                                    class="flex items-center gap-1 text-ihub-teal text-xs font-bold hover:underline">
                                <span>${doc.getVersions().size()}</span>
                                <svg class="w-3 h-3 transition-transform" :class="expandedDoc === ${doc.getId()} ? 'rotate-180' : ''" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M19 9l-7 7-7-7"/></svg>
                            </button>
                        </td>
                        <td class="px-4 py-3">
                            @if(!doc.getVersions().isEmpty())
                            !{var latestStatus = doc.getVersions().get(0).getStatus();}
                            @if(latestStatus == KycStatus.APPROVED)
                            <span class="bg-green-100 text-green-700 text-[10px] font-bold px-2 py-0.5 rounded-full uppercase">Approved</span>
                            @elseif(latestStatus == KycStatus.REJECTED)
                            <span class="bg-red-100 text-red-700 text-[10px] font-bold px-2 py-0.5 rounded-full uppercase">Rejected</span>
                            @else
                            <span class="bg-orange-100 text-orange-700 text-[10px] font-bold px-2 py-0.5 rounded-full uppercase">Pending Review</span>
                            @endif
                            @endif
                        </td>
                        <td class="px-4 py-3 text-right">
                            <label class="cursor-pointer flex items-center justify-end gap-1 text-xs text-ihub-teal font-bold hover:underline">
                                <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-8l-4-4m0 0L8 8m4-4v12"/></svg>
                                New version
                                <input type="file" class="hidden"
                                       hx-post="/dashboard/details/natural-person/${personId}/document/${doc.getId()}/upload"
                                       hx-target="#np-documents-tab"
                                       hx-swap="outerHTML"
                                       hx-encoding="multipart/form-data"
                                       hx-trigger="upload"
                                       name="file"
                                       onchange="if(this.files.length) htmx.trigger(this, 'upload')"/>
                            </label>
                        </td>
                    </tr>
                    <!-- Expanded versions row -->
                    <tr x-show="expandedDoc === ${doc.getId()}" class="bg-gray-50/70" style="display:none">
                        <td colspan="6" class="px-6 py-4">
                            <div class="text-[10px] font-bold uppercase tracking-widest text-gray-400 mb-3">Version History</div>
                            <div class="flex flex-col gap-2">
                                @for(PersonDocumentVersion v : doc.getVersions())
                                <div class="flex items-center gap-4 bg-white rounded-lg border border-gray-100 px-4 py-3 text-xs">
                                    <span class="font-bold text-gray-600 w-20">v${v.getVersionNumber()}</span>
                                    <span class="text-gray-500 flex-1">${v.getFileName()}</span>
                                    <span class="text-gray-400">${v.getUploadedAt() != null ? v.getUploadedAt().toLocalDate().toString() : "—"}</span>
                                    <span class="text-gray-400">by ${v.getUploadedBy() != null ? v.getUploadedBy() : "—"}</span>
                                    @if(v.getStatus() == KycStatus.APPROVED)
                                    <span class="bg-green-100 text-green-700 text-[10px] font-bold px-2 py-0.5 rounded-full uppercase">Approved</span>
                                    @elseif(v.getStatus() == KycStatus.REJECTED)
                                    <span class="bg-red-100 text-red-700 text-[10px] font-bold px-2 py-0.5 rounded-full uppercase">Rejected</span>
                                    @else
                                    <span class="bg-orange-100 text-orange-700 text-[10px] font-bold px-2 py-0.5 rounded-full uppercase">Pending</span>
                                    @endif
                                    <button @click="openViewer(${doc.getId()}, ${v.getId()}, '${v.getFileName()}')"
                                            class="flex items-center gap-1 text-ihub-teal font-bold hover:underline ml-2">
                                        <svg class="w-3.5 h-3.5" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"/><path stroke-linecap="round" stroke-linejoin="round" d="M2.458 12C3.732 7.943 7.523 5 12 5c4.478 0 8.268 2.943 9.542 7-1.274 4.057-5.064 7-9.542 7-4.477 0-8.268-2.943-9.542-7z"/></svg>
                                        View
                                    </button>
                                </div>
                                @endfor
                            </div>
                        </td>
                    </tr>
                    @endfor
                </tbody>
            </table>
        </div>
        @endif
    </div>

    <!-- Missing Documents -->
    <div>
        <div class="flex items-center gap-2 mb-3">
            <svg class="w-4 h-4 text-orange-400" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><circle cx="12" cy="12" r="10" stroke-width="2"/><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 8v4m0 4h.01"/></svg>
            <h4 class="text-xs font-bold uppercase tracking-widest text-gray-500">Missing Documents</h4>
            <span class="bg-orange-100 text-orange-700 text-[10px] font-bold px-2 py-0.5 rounded-full">${missingDocuments.size()}</span>
        </div>

        @if(missingDocuments.isEmpty())
        <div class="bg-white rounded-xl border border-gray-100 p-8 text-center text-gray-400 text-sm">
            @if(providedDocuments.isEmpty() && availableTypes.size() == availableTypes.size())
            No documents have been required yet. Use "Require Document" to start.
            @else
            All required documents have been provided.
            @endif
        </div>
        @else
        <div class="bg-white rounded-xl border border-gray-100 overflow-hidden">
            <table class="w-full text-sm">
                <thead>
                    <tr class="border-b border-gray-100">
                        <th class="text-left text-[10px] font-bold uppercase tracking-widest text-gray-400 px-4 py-3">Document Type</th>
                        <th class="text-left text-[10px] font-bold uppercase tracking-widest text-gray-400 px-4 py-3">Required By</th>
                        <th class="text-left text-[10px] font-bold uppercase tracking-widest text-gray-400 px-4 py-3">Required On</th>
                        <th class="text-left text-[10px] font-bold uppercase tracking-widest text-gray-400 px-4 py-3">Note</th>
                        <th class="px-4 py-3"></th>
                    </tr>
                </thead>
                <tbody>
                    @for(PersonDocument doc : missingDocuments)
                    <tr class="border-b border-gray-50 hover:bg-gray-50/50 transition-colors">
                        <td class="px-4 py-3">
                            <div class="flex items-center gap-2">
                                <div class="w-1.5 h-1.5 rounded-full bg-orange-400"></div>
                                <span class="font-bold text-gray-800 text-xs">${doc.getDocumentType().getLabel()}</span>
                            </div>
                        </td>
                        <td class="px-4 py-3 text-xs text-gray-500">${doc.getRequiredBy() != null ? doc.getRequiredBy() : "—"}</td>
                        <td class="px-4 py-3 text-xs text-gray-500">
                            ${doc.getRequiredAt() != null ? doc.getRequiredAt().toLocalDate().toString() : "—"}
                        </td>
                        <td class="px-4 py-3 text-xs text-gray-400 italic max-w-xs truncate">
                            ${doc.getNote() != null ? doc.getNote() : "—"}
                        </td>
                        <td class="px-4 py-3 text-right">
                            <label class="cursor-pointer inline-flex items-center gap-1.5 bg-ihub-teal text-white rounded-full px-4 py-1.5 text-[10px] font-bold uppercase hover:bg-[#12a1b0] transition-colors">
                                <svg class="w-3 h-3" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-8l-4-4m0 0L8 8m4-4v12"/></svg>
                                Upload
                                <input type="file" class="hidden"
                                       hx-post="/dashboard/details/natural-person/${personId}/document/${doc.getId()}/upload"
                                       hx-target="#np-documents-tab"
                                       hx-swap="outerHTML"
                                       hx-encoding="multipart/form-data"
                                       hx-trigger="upload"
                                       name="file"
                                       onchange="if(this.files.length) htmx.trigger(this, 'upload')"/>
                            </label>
                        </td>
                    </tr>
                    @endfor
                </tbody>
            </table>
        </div>
        @endif
    </div>

</div>
