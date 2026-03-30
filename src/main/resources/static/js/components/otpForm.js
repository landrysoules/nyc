export default function otpForm() {
    return {
        otp: ['', '', '', '', '', ''],
        init() {
            this.$nextTick(() => this.$refs.otp0.focus());
        },
        handleInput(index) {
            if (this.otp[index] && index < 5) {
                this.$refs['otp' + (index + 1)].focus();
            }
        },
        handleBackspace(e, index) {
            if (e.key === 'Backspace' && !this.otp[index] && index > 0) {
                this.$refs['otp' + (index - 1)].focus();
            }
        },
        get combined() {
            return this.otp.join('');
        }
    };
}
