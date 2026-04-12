package com.kyc.app.model;

public enum DocumentType {

    PASSPORT("Passport"),
    NATIONAL_ID("National Identity Card"),
    DRIVERS_LICENSE("Driver's License"),
    RESIDENCE_PERMIT("Residence Permit"),
    PROOF_OF_ADDRESS("Proof of Address"),
    TAX_CERTIFICATE("Tax Certificate / TIN"),
    BANK_STATEMENT("Bank Statement"),
    PEP_DECLARATION("PEP Declaration"),
    SOURCE_OF_WEALTH("Source of Wealth Declaration"),
    EMPLOYMENT_CONTRACT("Employment Contract");

    private final String label;

    DocumentType(String label) {
        this.label = label;
    }

    public String getLabel() {
        return label;
    }
}
