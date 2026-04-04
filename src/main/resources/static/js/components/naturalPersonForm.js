export default function naturalPersonForm(isEditMode) {
    return {
        isEditMode: isEditMode,
        firstName: '',
        lastName: '',
        dateOfBirth: '',

        toggleEditMode() {
            this.isEditMode = true;
        }
    }
}
