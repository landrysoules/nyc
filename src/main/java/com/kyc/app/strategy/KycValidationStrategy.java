package com.kyc.app.strategy;

import com.kyc.app.model.KycDocument;

public interface KycValidationStrategy {
    boolean validate(KycDocument doc);
    boolean supports(String documentType); // Used to match document type if needed
}
