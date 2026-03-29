export default function contractForm(isEditMode) {
    return {
        isEditMode: isEditMode,
        
        toggleEditMode() {
            this.isEditMode = true;
        }
    }
}
