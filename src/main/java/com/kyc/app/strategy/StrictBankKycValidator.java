package com.kyc.app.strategy;

import com.kyc.app.model.KycDocument;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

@Component
@Order(1)
public class StrictBankKycValidator implements KycValidationStrategy {

    @Override
    public boolean validate(KycDocument doc) {
        // Strict bank validation rule: must have a specific field or pattern
        if (doc.getFormData() == null) return false;
        
        // Simulating a stricter check, e.g. a specific keyword in formData
        return doc.getFormData().contains("bank_certified");
    }

    @Override
    public boolean supports(String documentType) {
        return "STRICT_BANK".equalsIgnoreCase(documentType);
    }
}
