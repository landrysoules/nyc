package com.kyc.app.controller;

import com.kyc.app.model.Contract;
import com.kyc.app.model.DocumentType;
import com.kyc.app.model.LegalEntity;
import com.kyc.app.model.NaturalPerson;
import com.kyc.app.model.PersonDocumentVersion;
import com.kyc.app.security.CustomUserDetails;
import com.kyc.app.service.ContractService;
import com.kyc.app.service.LegalEntityService;
import com.kyc.app.service.NaturalPersonService;
import com.kyc.app.service.PersonDocumentService;
import com.kyc.app.service.ReferenceDataService;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.Valid;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

@Controller
public class DashboardController {

    private final NaturalPersonService naturalPersonService;
    private final LegalEntityService legalEntityService;
    private final ContractService contractService;
    private final PersonDocumentService personDocumentService;
    private final ReferenceDataService referenceDataService;
    private final jakarta.validation.Validator validator;

    public DashboardController(NaturalPersonService naturalPersonService,
                               LegalEntityService legalEntityService,
                               ContractService contractService,
                               PersonDocumentService personDocumentService,
                               ReferenceDataService referenceDataService,
                               jakarta.validation.Validator validator) {
        this.naturalPersonService = naturalPersonService;
        this.legalEntityService = legalEntityService;
        this.contractService = contractService;
        this.personDocumentService = personDocumentService;
        this.referenceDataService = referenceDataService;
        this.validator = validator;
    }

    private Map<String, String> buildFieldErrors(BindingResult result) {
        Map<String, String> errors = new HashMap<>();
        result.getFieldErrors().forEach(fe -> errors.put(fe.getField(), fe.getDefaultMessage()));
        return errors;
    }

    @GetMapping({"/", "/dashboard", "/kyc/dashboard"})
    public String dashboardMain(Model model, @AuthenticationPrincipal CustomUserDetails userDetails) {
        if (userDetails != null) {
            model.addAttribute("username", userDetails.getUsername());
        }
        return "dashboard";
    }

    // --- Tabs ---

    @GetMapping("/dashboard/tab/natural-persons")
    public String tabNaturalPersons(Model model) {
        model.addAttribute("persons", naturalPersonService.findAll());
        return "fragments/tabs/natural_persons";
    }

    @GetMapping("/dashboard/tab/legal-entities")
    public String tabLegalEntities(Model model) {
        model.addAttribute("entities", legalEntityService.findAll());
        return "fragments/tabs/legal_entities";
    }

    @GetMapping("/dashboard/tab/contracts")
    public String tabContracts(Model model) {
        model.addAttribute("contracts", contractService.findAll());
        return "fragments/tabs/contracts";
    }

    // --- Details ---

    @GetMapping("/dashboard/details/natural-person/{id}")
    public String detailsNaturalPerson(@PathVariable("id") Long id, Model model) {
        NaturalPerson person = id > 0 ? naturalPersonService.findById(id).orElse(new NaturalPerson()) : new NaturalPerson();
        model.addAttribute("person", person);
        model.addAttribute("isValid", validator.validate(person).isEmpty());
        model.addAttribute("countries", referenceDataService.getCountries());
        return "fragments/details/natural_person_details";
    }

    @PostMapping("/dashboard/validate/natural-person")
    public String validateNaturalPerson(@Valid @ModelAttribute("person") NaturalPerson person, BindingResult result, Model model) {
        model.addAttribute("person", person);
        model.addAttribute("fieldErrors", buildFieldErrors(result));
        model.addAttribute("hasErrors", result.hasErrors());
        model.addAttribute("countries", referenceDataService.getCountries());
        return "fragments/details/natural_person_details_form";
    }

    @PostMapping("/dashboard/details/natural-person")
    public String saveNaturalPerson(@Valid @ModelAttribute("person") NaturalPerson person, BindingResult result, Model model, HttpServletResponse response) {
        if (result.hasErrors()) {
            response.setHeader("HX-Retarget", "#np-form-container");
            response.setHeader("HX-Reswap", "morph");
            model.addAttribute("person", person);
            model.addAttribute("fieldErrors", buildFieldErrors(result));
            model.addAttribute("hasErrors", true);
            model.addAttribute("countries", referenceDataService.getCountries());
            return "fragments/details/natural_person_details_form";
        }
        naturalPersonService.save(person);
        HxTrigger.toast(response, HxTrigger.Toast.success, "Saved successfully");
        return tabNaturalPersons(model);
    }

    // --- Natural Person Documents ---

    @GetMapping("/dashboard/details/natural-person/{id}/documents")
    public String naturalPersonDocuments(@PathVariable("id") Long id, Model model) {
        model.addAttribute("personId", id);
        model.addAttribute("providedDocuments", personDocumentService.findProvidedDocuments(id));
        model.addAttribute("missingDocuments", personDocumentService.findMissingDocuments(id));
        model.addAttribute("availableTypes", personDocumentService.getAvailableTypesToRequire(id));
        return "fragments/details/natural_person_documents";
    }

    @PostMapping("/dashboard/details/natural-person/{id}/require-document")
    public String requireDocument(@PathVariable("id") Long id,
                                  @RequestParam("documentType") DocumentType documentType,
                                  @RequestParam(value = "note", required = false) String note,
                                  @AuthenticationPrincipal CustomUserDetails userDetails,
                                  Model model) {
        String username = userDetails != null ? userDetails.getUsername() : "system";
        try {
            personDocumentService.requireDocument(id, documentType, note, username);
        } catch (IllegalStateException ignored) {
            // Already required — silently ignore duplicate
        }
        return naturalPersonDocuments(id, model);
    }

    @PostMapping("/dashboard/details/natural-person/{id}/document/{docId}/upload")
    public String uploadDocumentVersion(@PathVariable("id") Long id,
                                        @PathVariable("docId") Long docId,
                                        @RequestParam("file") MultipartFile file,
                                        @AuthenticationPrincipal CustomUserDetails userDetails,
                                        Model model,
                                        HttpServletResponse response) {
        if (file.isEmpty()) {
            HxTrigger.toast(response, HxTrigger.Toast.error, "Please select a file to upload");
            return naturalPersonDocuments(id, model);
        }
        String username = userDetails != null ? userDetails.getUsername() : "system";
        try {
            personDocumentService.uploadVersion(docId, file, username);
            HxTrigger.toast(response, HxTrigger.Toast.success, "Document uploaded successfully");
        } catch (IOException e) {
            HxTrigger.toast(response, HxTrigger.Toast.error, "Upload failed: " + e.getMessage());
        }
        return naturalPersonDocuments(id, model);
    }

    @GetMapping("/dashboard/details/natural-person/{id}/document/{docId}/version/{versionId}/view")
    public ResponseEntity<byte[]> viewDocumentVersion(@PathVariable("id") Long id,
                                                      @PathVariable("docId") Long docId,
                                                      @PathVariable("versionId") Long versionId) {
        return personDocumentService.findVersion(versionId)
                .filter(v -> v.getDocument().getId().equals(docId))
                .map(v -> {
                    String ct = v.getContentType() != null ? v.getContentType() : MediaType.APPLICATION_OCTET_STREAM_VALUE;
                    return ResponseEntity.ok()
                            .header(HttpHeaders.CONTENT_TYPE, ct)
                            .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=\"" + v.getFileName() + "\"")
                            .body(v.getFileData());
                })
                .orElse(ResponseEntity.notFound().build());
    }

    @GetMapping("/dashboard/details/legal-entity/{id}")
    public String detailsLegalEntity(@PathVariable("id") Long id, Model model) {
        LegalEntity entity = id > 0 ? legalEntityService.findById(id).orElse(new LegalEntity()) : new LegalEntity();
        model.addAttribute("entity", entity);
        model.addAttribute("isValid", validator.validate(entity).isEmpty());
        model.addAttribute("countries", referenceDataService.getCountries());
        return "fragments/details/legal_entity_details";
    }

    @PostMapping("/dashboard/validate/legal-entity")
    public String validateLegalEntity(@Valid @ModelAttribute("entity") LegalEntity entity, BindingResult result, Model model) {
        model.addAttribute("entity", entity);
        model.addAttribute("fieldErrors", buildFieldErrors(result));
        model.addAttribute("hasErrors", result.hasErrors());
        model.addAttribute("countries", referenceDataService.getCountries());
        return "fragments/details/legal_entity_details_form";
    }

    @PostMapping("/dashboard/details/legal-entity")
    public String saveLegalEntity(@Valid @ModelAttribute("entity") LegalEntity entity, BindingResult result, Model model, HttpServletResponse response) {
        if (result.hasErrors()) {
            response.setHeader("HX-Retarget", "#le-form-container");
            response.setHeader("HX-Reswap", "morph");
            model.addAttribute("entity", entity);
            model.addAttribute("fieldErrors", buildFieldErrors(result));
            model.addAttribute("hasErrors", true);
            model.addAttribute("countries", referenceDataService.getCountries());
            return "fragments/details/legal_entity_details_form";
        }
        legalEntityService.save(entity);
        HxTrigger.toast(response, HxTrigger.Toast.success, "Saved successfully");
        return tabLegalEntities(model);
    }

    @GetMapping("/dashboard/details/contract/{id}")
    public String detailsContract(@PathVariable("id") Long id, Model model) {
        Contract contract = id > 0 ? contractService.findById(id).orElse(new Contract()) : new Contract();
        model.addAttribute("contract", contract);
        model.addAttribute("isValid", validator.validate(contract).isEmpty());
        return "fragments/details/contract_details";
    }

    @PostMapping("/dashboard/validate/contract")
    public String validateContract(@Valid @ModelAttribute("contract") Contract contract, BindingResult result, Model model) {
        model.addAttribute("contract", contract);
        model.addAttribute("fieldErrors", buildFieldErrors(result));
        model.addAttribute("hasErrors", result.hasErrors());
        return "fragments/details/contract_details_form";
    }

    @PostMapping("/dashboard/details/contract")
    public String saveContract(@Valid @ModelAttribute("contract") Contract contract, BindingResult result, Model model, HttpServletResponse response) {
        if (result.hasErrors()) {
            response.setHeader("HX-Retarget", "#contract-form-container");
            response.setHeader("HX-Reswap", "morph");
            model.addAttribute("contract", contract);
            model.addAttribute("fieldErrors", buildFieldErrors(result));
            model.addAttribute("hasErrors", true);
            return "fragments/details/contract_details_form";
        }
        contractService.save(contract);
        HxTrigger.toast(response, HxTrigger.Toast.success, "Saved successfully");
        return tabContracts(model);
    }
}
