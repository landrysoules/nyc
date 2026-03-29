export default function legalEntityForm(isEditMode) {
    const countriesList = ["Afghanistan","Albania","Algeria","Andorra","Angola","Argentina","Armenia","Australia","Austria","Bahamas","Bahrain","Bangladesh","Barbados","Belarus","Belgium","Belize","Benin","Bhutan","Bolivia","Bosnia","Botswana","Brazil","Bulgaria","Burkina Faso","Burundi","Cambodia","Cameroon","Canada","Chad","Chile","China","Colombia","Comoros","Congo","Costa Rica","Croatia","Cuba","Cyprus","Czech Republic","Denmark","Djibouti","Dominica","Dominican Republic","Ecuador","Egypt","El Salvador","Estonia","Eswatini","Ethiopia","Fiji","Finland","France","Gabon","Gambia","Georgia","Germany","Ghana","Greece","Guatemala","Guinea","Haiti","Honduras","Hungary","Iceland","India","Indonesia","Iran","Iraq","Ireland","Israel","Italy","Jamaica","Japan","Jordan","Kazakhstan","Kenya","Kuwait","Latvia","Lebanon","Libya","Lithuania","Luxembourg","Madagascar","Malaysia","Maldives","Mali","Malta","Mexico","Monaco","Mongolia","Morocco","Myanmar","Namibia","Nepal","Netherlands","New Zealand","Nicaragua","Niger","Nigeria","Norway","Oman","Pakistan","Panama","Paraguay","Peru","Philippines","Poland","Portugal","Qatar","Romania","Russia","Rwanda","Saudi Arabia","Senegal","Serbia","Singapore","Slovakia","Slovenia","Somalia","South Africa","South Korea","Spain","Sri Lanka","Sudan","Sweden","Switzerland","Syria","Taiwan","Tajikistan","Tanzania","Thailand","Togo","Tunisia","Turkey","Turkmenistan","Uganda","Ukraine","United Arab Emirates","United Kingdom","United States","Uruguay","Uzbekistan","Vatican City","Venezuela","Vietnam","Yemen","Zambia","Zimbabwe"];

    return {
        isEditMode: isEditMode,
        country: '',
        searchQuery: '',
        showCountryList: false,

        init() {
            this.$watch('searchQuery', (value) => {
                if (!countriesList.includes(value)) {
                    this.country = '';
                } else {
                    this.country = value;
                }
            });
            setTimeout(() => {
                if (this.country && !this.searchQuery) {
                    this.searchQuery = this.country;
                }
            }, 0);
        },

        get filteredCountries() {
            if (this.searchQuery === '') return countriesList;
            return countriesList.filter(c => c.toLowerCase().includes(this.searchQuery.toLowerCase()));
        },

        selectCountry(country) {
            this.searchQuery = country;
            this.country = country;
            this.showCountryList = false;
        },

        handleClickOutside() {
            this.showCountryList = false;
            if(!countriesList.includes(this.searchQuery)) {
                this.searchQuery = '';
                this.country = '';
            } else {
                this.country = this.searchQuery;
            }
        },

        toggleEditMode() {
            this.isEditMode = true;
        }
    }
}
