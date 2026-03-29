export default function dashboard() {
    return {
        activeTab: 'natural-persons',
        
        setActiveTab(tabName) {
            this.activeTab = tabName;
        },
        
        isTabActive(tabName) {
            return this.activeTab === tabName;
        }
    }
}
