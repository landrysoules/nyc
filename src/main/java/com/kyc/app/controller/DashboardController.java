package com.kyc.app.controller;

import com.kyc.app.model.Contract;
import com.kyc.app.model.LegalEntity;
import com.kyc.app.model.NaturalPerson;
import com.kyc.app.security.CustomUserDetails;
import com.kyc.app.service.ContractService;
import com.kyc.app.service.LegalEntityService;
import com.kyc.app.service.NaturalPersonService;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.*;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.validation.Valid;

@Controller
public class DashboardController {

    private final NaturalPersonService naturalPersonService;
    private final LegalEntityService legalEntityService;
    private final ContractService contractService;
    private final jakarta.validation.Validator validator;

    public DashboardController(NaturalPersonService naturalPersonService,
                               LegalEntityService legalEntityService,
                               ContractService contractService,
                               jakarta.validation.Validator validator) {
        this.naturalPersonService = naturalPersonService;
        this.legalEntityService = legalEntityService;
        this.contractService = contractService;
        this.validator = validator;
    }

    @GetMapping({"/", "/dashboard", "/kyc/dashboard"})
    public String dashboardMain(Model model, @AuthenticationPrincipal CustomUserDetails userDetails) {
        if (userDetails != null) {
            model.addAttribute("username", userDetails.getUsername());
        }
        return "dashboard";
    }

    // --- Tabs Data ---
    
    @GetMapping("/dashboard/tab/natural-persons")
    public String tabNaturalPersons(Model model) {
        model.addAttribute("persons", naturalPersonService.findAll());
        return "fragments/tabs/natural-persons :: content";
    }
    
    @GetMapping("/dashboard/tab/legal-entities")
    public String tabLegalEntities(Model model) {
        model.addAttribute("entities", legalEntityService.findAll());
        return "fragments/tabs/legal-entities :: content";
    }
    
    @GetMapping("/dashboard/tab/contracts")
    public String tabContracts(Model model) {
        model.addAttribute("contracts", contractService.findAll());
        return "fragments/tabs/contracts :: content";
    }

    // --- Details Panels (Read Only & Forms) ---
    
    @GetMapping("/dashboard/details/natural-person/{id}")
    public String detailsNaturalPerson(@PathVariable("id") Long id, Model model) {
        NaturalPerson person;
        if(id > 0) {
            person = naturalPersonService.findById(id).orElse(new NaturalPerson());
        } else {
            person = new NaturalPerson();
        }
        model.addAttribute("person", person);
        model.addAttribute("isValid", validator.validate(person).isEmpty());
        return "fragments/details/natural-person-details :: panel";
    }

    @PostMapping("/dashboard/validate/natural-person")
    public String validateNaturalPerson(@Valid @ModelAttribute("person") NaturalPerson person, BindingResult result) {
        // Return only the validation fragment with HTMX Out-Of-Band swaps
        return "fragments/details/natural-person-validation :: validation";
    }

    @PostMapping("/dashboard/details/natural-person")
    public String saveNaturalPerson(@Valid @ModelAttribute("person") NaturalPerson person, BindingResult result, Model model, HttpServletResponse response) {
        if (result.hasErrors()) {
            // Retarget the HTMX response to update only the form using its ID
            response.setHeader("HX-Retarget", "#np-form");
            return "fragments/details/natural-person-details :: edit-form";
        }
        naturalPersonService.save(person);
        return tabNaturalPersons(model); // refresh the list
    }
    
    @GetMapping("/dashboard/details/legal-entity/{id}")
    public String detailsLegalEntity(@PathVariable("id") Long id, Model model) {
        LegalEntity entity;
        if(id > 0) {
            entity = legalEntityService.findById(id).orElse(new LegalEntity());
        } else {
            entity = new LegalEntity();
        }
        model.addAttribute("entity", entity);
        model.addAttribute("isValid", validator.validate(entity).isEmpty());
        return "fragments/details/legal-entity-details :: panel";
    }

    @PostMapping("/dashboard/validate/legal-entity")
    public String validateLegalEntity(@Valid @ModelAttribute("entity") LegalEntity entity, BindingResult result) {
        return "fragments/details/legal-entity-validation :: validation";
    }

    @PostMapping("/dashboard/details/legal-entity")
    public String saveLegalEntity(@Valid @ModelAttribute("entity") LegalEntity entity, BindingResult result, Model model, HttpServletResponse response) {
        if (result.hasErrors()) {
            response.setHeader("HX-Retarget", "#le-form");
            return "fragments/details/legal-entity-details :: edit-form";
        }
        legalEntityService.save(entity);
        return tabLegalEntities(model); // refresh the list
    }
    
    @GetMapping("/dashboard/details/contract/{id}")
    public String detailsContract(@PathVariable("id") Long id, Model model) {
        Contract contract;
        if(id > 0) {
            contract = contractService.findById(id).orElse(new Contract());
        } else {
            contract = new Contract();
        }
        model.addAttribute("contract", contract);
        model.addAttribute("isValid", validator.validate(contract).isEmpty());
        return "fragments/details/contract-details :: panel";
    }

    @PostMapping("/dashboard/validate/contract")
    public String validateContract(@Valid @ModelAttribute("contract") Contract contract, BindingResult result) {
        return "fragments/details/contract-validation :: validation";
    }

    @PostMapping("/dashboard/details/contract")
    public String saveContract(@Valid @ModelAttribute("contract") Contract contract, BindingResult result, Model model, HttpServletResponse response) {
        if (result.hasErrors()) {
            response.setHeader("HX-Retarget", "#contract-form");
            return "fragments/details/contract-details :: edit-form";
        }
        contractService.save(contract);
        return tabContracts(model); // refresh the list
    }
}
