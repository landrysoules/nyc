@param String error = null
<div id="auth-content" class="flex flex-col items-center w-full relative pt-2 pb-6 px-4">
    <div class="absolute top-0 left-0">
        <button type="button" @click="window.location.reload()" class="btn btn-ghost btn-sm gap-1">
            <svg class="w-4 h-4 mr-1" fill="none" stroke="currentColor" stroke-width="2.5" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M15 19l-7-7 7-7"></path></svg>
            Back
        </button>
    </div>

    <div class="mt-4 mb-6 text-center w-full">
        <h2 class="text-2xl font-bold text-gray-800 mb-4">Type the OTP</h2>
        <div class="flex items-center justify-center text-xs text-gray-600 font-medium space-x-2">
            <svg class="w-4 h-4 text-gray-400" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24"><path stroke-linecap="square" d="M12 4v1m0 14v1m8-9h1M3 12h1m11.36 6.36l.71.71m-10.82-10.82l.71.71m10.82 0l-.71.71M5.64 19.36l.71-.71"></path></svg>
            <p>Please type the OTP provided by your<br/>Authenticator app to complete your login</p>
        </div>
    </div>

    <form class="w-full flex flex-col items-center gap-8" action="/auth/verify-otp" method="POST" hx-post="/auth/verify-otp" hx-target="#auth-container" hx-swap="innerHTML">
        @if(error != null)
        <div class="bg-red-50 text-red-500 p-3 rounded-lg text-sm font-medium border border-red-100 flex items-center w-full">
            <svg class="w-5 h-5 mr-2 shrink-0" fill="currentColor" viewBox="0 0 20 20"><path fill-rule="evenodd" d="M10 18a8 8 0 100-16 8 8 0 000 16zM8.707 7.293a1 1 0 00-1.414 1.414L8.586 10l-1.293 1.293a1 1 0 101.414 1.414L10 11.414l1.293 1.293a1 1 0 001.414-1.414L11.414 10l1.293-1.293a1 1 0 00-1.414-1.414L10 8.586 8.707 7.293z" clip-rule="evenodd"></path></svg>
            <span>${error}</span>
        </div>
        @endif

        <div x-data="otpForm()" class="flex flex-col items-center w-full">
            <input type="hidden" name="otpCode" :value="combined" required pattern="\d{6}" />
            <div class="flex space-x-3 justify-center">
                <input type="text" maxlength="1" x-ref="otp0" x-model="otp[0]" @input="handleInput(0)" @keydown="handleBackspace($event, 0)" inputmode="numeric" class="input w-12 h-12 border border-gray-300 rounded-lg text-center text-xl font-bold text-gray-800 bg-white focus:outline-none focus:border-ihub-teal focus:ring-1 focus:ring-ihub-teal transition-colors" />
                <input type="text" maxlength="1" x-ref="otp1" x-model="otp[1]" @input="handleInput(1)" @keydown="handleBackspace($event, 1)" inputmode="numeric" class="input w-12 h-12 border border-gray-300 rounded-lg text-center text-xl font-bold text-gray-800 bg-white focus:outline-none focus:border-ihub-teal focus:ring-1 focus:ring-ihub-teal transition-colors" />
                <input type="text" maxlength="1" x-ref="otp2" x-model="otp[2]" @input="handleInput(2)" @keydown="handleBackspace($event, 2)" inputmode="numeric" class="input w-12 h-12 border border-gray-300 rounded-lg text-center text-xl font-bold text-gray-800 bg-white focus:outline-none focus:border-ihub-teal focus:ring-1 focus:ring-ihub-teal transition-colors" />
                <input type="text" maxlength="1" x-ref="otp3" x-model="otp[3]" @input="handleInput(3)" @keydown="handleBackspace($event, 3)" inputmode="numeric" class="input w-12 h-12 border border-gray-300 rounded-lg text-center text-xl font-bold text-gray-800 bg-white focus:outline-none focus:border-ihub-teal focus:ring-1 focus:ring-ihub-teal transition-colors" />
                <input type="text" maxlength="1" x-ref="otp4" x-model="otp[4]" @input="handleInput(4)" @keydown="handleBackspace($event, 4)" inputmode="numeric" class="input w-12 h-12 border border-gray-300 rounded-lg text-center text-xl font-bold text-gray-800 bg-white focus:outline-none focus:border-ihub-teal focus:ring-1 focus:ring-ihub-teal transition-colors" />
                <input type="text" maxlength="1" x-ref="otp5" x-model="otp[5]" @input="handleInput(5)" @keydown="handleBackspace($event, 5)" inputmode="numeric" class="input w-12 h-12 border border-gray-300 rounded-lg text-center text-xl font-bold text-gray-800 bg-white focus:outline-none focus:border-ihub-teal focus:ring-1 focus:ring-ihub-teal transition-colors" />
            </div>
        </div>

        <div class="w-full flex justify-center mt-2">
            <button type="submit" class="btn rounded-full uppercase px-8 bg-ihub-teal hover:bg-[#12a1b0] text-white border-ihub-teal hover:border-[#12a1b0] group">
                Continue
                <svg class="w-4 h-4 ml-1 !duration-300 group-hover:translate-x-1" fill="none" stroke="currentColor" stroke-width="3" viewBox="0 0 24 24"><path stroke-linecap="round" stroke-linejoin="round" d="M9 5l7 7-7 7"></path></svg>
            </button>
        </div>
    </form>
</div>
