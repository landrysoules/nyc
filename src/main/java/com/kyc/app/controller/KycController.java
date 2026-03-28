package com.kyc.app.controller;

import com.kyc.app.model.KycDocument;
import com.kyc.app.model.KycStatus;
import com.kyc.app.repository.KycDocumentRepository;
import com.kyc.app.security.CustomUserDetails;
import com.kyc.app.service.KycValidatorFactory;
import com.kyc.app.strategy.KycValidationStrategy;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping("/kyc")
public class KycController {

    private final KycValidatorFactory validatorFactory;
    private final KycDocumentRepository documentRepository;

    public KycController(KycValidatorFactory validatorFactory, KycDocumentRepository documentRepository) {
        this.validatorFactory = validatorFactory;
        this.documentRepository = documentRepository;
    }


    @PostMapping("/submit")
    public String submitKyc(@RequestParam String documentType, 
                            @RequestParam String documentData,
                            @AuthenticationPrincipal CustomUserDetails userDetails,
                            Model model) {
        
        KycDocument document = new KycDocument();
        document.setUser(userDetails.getUser());
        document.setType(documentType);
        // Save raw string in formData in this simple POC
        document.setFormData(documentData);

        KycValidationStrategy strategy;
        try {
            strategy = validatorFactory.getStrategy(documentType);
        } catch (IllegalArgumentException e) {
            model.addAttribute("error", "Type de document non supporté");
            return "fragments/kyc-form";
        }

        boolean isValid = strategy.validate(document);
        
        if (isValid) {
            document.setStatus(KycStatus.APPROVED);
            documentRepository.save(document);
            return "fragments/success"; // the success template with postMessage
        } else {
            document.setStatus(KycStatus.REJECTED);
            documentRepository.save(document);
            model.addAttribute("error", "Validation KYC échouée. Données incorrectes selon la stratégie: " + documentType);
            return "fragments/kyc-form";
        }
    }
}
