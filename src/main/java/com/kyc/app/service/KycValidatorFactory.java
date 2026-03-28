package com.kyc.app.service;

import com.kyc.app.strategy.KycValidationStrategy;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class KycValidatorFactory {

    private final List<KycValidationStrategy> strategies;

    public KycValidatorFactory(List<KycValidationStrategy> strategies) {
        this.strategies = strategies; // Spring automatically injects all beans implementing the interface
    }

    public KycValidationStrategy getStrategy(String documentType) {
        return strategies.stream()
                .filter(strategy -> strategy.supports(documentType))
                .findFirst()
                .orElseThrow(() -> new IllegalArgumentException("No validation strategy found for document type: " + documentType));
    }
}
