export default function legalEntityForm(isEditMode) {
    return {
        isEditMode: isEditMode,

        toggleEditMode() {
            this.isEditMode = true;
        }
    }
}
