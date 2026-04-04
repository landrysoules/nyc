const countriesList = ["Afghanistan","Albania","Algeria","Andorra","Angola","Argentina","Armenia","Australia","Austria","Bahamas","Bahrain","Bangladesh","Barbados","Belarus","Belgium","Belize","Benin","Bhutan","Bolivia","Bosnia","Botswana","Brazil","Bulgaria","Burkina Faso","Burundi","Cambodia","Cameroon","Canada","Chad","Chile","China","Colombia","Comoros","Congo","Costa Rica","Croatia","Cuba","Cyprus","Czech Republic","Denmark","Djibouti","Dominica","Dominican Republic","Ecuador","Egypt","El Salvador","Estonia","Eswatini","Ethiopia","Fiji","Finland","France","Gabon","Gambia","Georgia","Germany","Ghana","Greece","Guatemala","Guinea","Haiti","Honduras","Hungary","Iceland","India","Indonesia","Iran","Iraq","Ireland","Israel","Italy","Jamaica","Japan","Jordan","Kazakhstan","Kenya","Kuwait","Latvia","Lebanon","Libya","Lithuania","Luxembourg","Madagascar","Malaysia","Maldives","Mali","Malta","Mexico","Monaco","Mongolia","Morocco","Myanmar","Namibia","Nepal","Netherlands","New Zealand","Nicaragua","Niger","Nigeria","Norway","Oman","Pakistan","Panama","Paraguay","Peru","Philippines","Poland","Portugal","Qatar","Romania","Russia","Rwanda","Saudi Arabia","Senegal","Serbia","Singapore","Slovakia","Slovenia","Somalia","South Africa","South Korea","Spain","Sri Lanka","Sudan","Sweden","Switzerland","Syria","Taiwan","Tajikistan","Tanzania","Thailand","Togo","Tunisia","Turkey","Turkmenistan","Uganda","Ukraine","United Arab Emirates","United Kingdom","United States","Uruguay","Uzbekistan","Vatican City","Venezuela","Vietnam","Yemen","Zambia","Zimbabwe"];

export default function countryDropdown(initialValue) {
    return {
        value: initialValue || '',
        searchQuery: initialValue || '',
        showList: false,

        get filteredCountries() {
            if (this.searchQuery === '') return countriesList;
            return countriesList.filter(c => c.toLowerCase().includes(this.searchQuery.toLowerCase()));
        },

        selectCountry(country) {
            this.searchQuery = country;
            this.value = country;
            this.showList = false;
            this.$nextTick(() => {
                document.body.dispatchEvent(new Event('customValidation'));
            });
        },

        handleClickOutside() {
            this.showList = false;
            if (!countriesList.includes(this.searchQuery)) {
                this.searchQuery = '';
                this.value = '';
            } else {
                this.value = this.searchQuery;
            }
            this.$nextTick(() => {
                document.body.dispatchEvent(new Event('customValidation'));
            });
        },
    };
}
