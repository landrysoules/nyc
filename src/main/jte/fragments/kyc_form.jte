@param String error = null
<div id="kyc-content">
    <form hx-post="/kyc/submit" hx-target="#kyc-container" hx-swap="innerHTML" class="space-y-6">

        @if(error != null)
        <div class="bg-red-50 text-red-500 p-4 rounded-lg text-sm font-medium border border-red-100 flex items-center shadow-sm">
            <svg class="w-5 h-5 mr-3" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd"></path></svg>
            <span>${error}</span>
        </div>
        @endif

        <div>
            <label for="documentType" class="block text-sm font-medium text-gray-700 mb-1">Document Type</label>
            <select id="documentType" name="documentType" class="mt-1 block w-full pl-3 pr-10 py-3 text-base border-gray-300 focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 sm:text-sm rounded-lg border shadow-sm bg-white" required>
                <option value="STANDARD">Standard Identity Doc</option>
                <option value="STRICT_BANK">Bank Certified Document</option>
            </select>
        </div>

        <div>
            <label for="documentData" class="block text-sm font-medium text-gray-700 mb-1">Document Payload Data (JSON or text)</label>
            <textarea id="documentData" name="documentData" rows="6"
                      class="shadow-sm focus:ring-indigo-500 focus:border-indigo-500 block w-full sm:text-sm border border-gray-300 rounded-lg p-3 font-mono text-sm"
                      placeholder='{ "id": "123", "bank_certified": true }' required></textarea>
            <p class="mt-2 text-xs text-gray-400">For testing 'STRICT_BANK', ensure payload contains "bank_certified".</p>
        </div>

        <div class="flex justify-end pt-4">
            <button type="submit" id="submit-btn"
                    class="inline-flex justify-center py-3 px-6 border border-transparent shadow-md text-sm font-medium rounded-lg text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 transition-colors uppercase tracking-wider">
                Validate & Submit Document
            </button>
            <img class="htmx-indicator ml-3 w-6 h-6 self-center" src="https://htmx.org/img/bars.svg" alt="Loading...">
        </div>

        <style>
            .htmx-indicator { display:none; }
            .htmx-request .htmx-indicator { display:inline-block; }
            .htmx-request.htmx-indicator { display:inline-block; }
            .htmx-request #submit-btn { opacity: 0.7; cursor: not-allowed; pointer-events: none; }
        </style>
    </form>
</div>
