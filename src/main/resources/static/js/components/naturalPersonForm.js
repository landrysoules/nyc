export default function naturalPersonForm(isEditMode) {
    return {
        isEditMode: isEditMode,
        currentTab: 'data',
        firstName: '',
        lastName: '',
        dateOfBirth: '',

        toggleEditMode() {
            this.isEditMode = true;
        }
    }
}
