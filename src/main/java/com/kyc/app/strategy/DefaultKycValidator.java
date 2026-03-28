package com.kyc.app.strategy;

import com.kyc.app.model.KycDocument;
import org.springframework.core.annotation.Order;
import org.springframework.stereotype.Component;

@Component
@Order(2)
public class DefaultKycValidator implements KycValidationStrategy {

    @Override
    public boolean validate(KycDocument doc) {
        // Basic validation: Just ensure formData isn't totally empty
        return doc.getFormData() != null && doc.getFormData().length() > 5;
    }

    @Override
    public boolean supports(String documentType) {
        return "STANDARD".equalsIgnoreCase(documentType);
    }
}
