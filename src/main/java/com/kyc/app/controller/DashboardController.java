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

import java.util.HashMap;
import java.util.Map;

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

    // --- Tabs Data ---

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

    // --- Details Panels (Read Only & Forms) ---

    @GetMapping("/dashboard/details/natural-person/{id}")
    public String detailsNaturalPerson(@PathVariable("id") Long id, Model model) {
        NaturalPerson person;
        if (id > 0) {
            person = naturalPersonService.findById(id).orElse(new NaturalPerson());
        } else {
            person = new NaturalPerson();
        }
        model.addAttribute("person", person);
        model.addAttribute("isValid", validator.validate(person).isEmpty());
        return "fragments/details/natural_person_details";
    }

    @PostMapping("/dashboard/validate/natural-person")
    public String validateNaturalPerson(@Valid @ModelAttribute("person") NaturalPerson person, BindingResult result, Model model) {
        model.addAttribute("fieldErrors", buildFieldErrors(result));
        model.addAttribute("hasErrors", result.hasErrors());
        return "fragments/details/natural_person_validation";
    }

    @PostMapping("/dashboard/details/natural-person")
    public String saveNaturalPerson(@Valid @ModelAttribute("person") NaturalPerson person, BindingResult result, Model model, HttpServletResponse response) {
        if (result.hasErrors()) {
            response.setHeader("HX-Retarget", "#np-form");
            model.addAttribute("fieldErrors", buildFieldErrors(result));
            model.addAttribute("hasErrors", true);
            return "fragments/details/natural_person_details_form";
        }
        naturalPersonService.save(person);
        return tabNaturalPersons(model);
    }

    @GetMapping("/dashboard/details/legal-entity/{id}")
    public String detailsLegalEntity(@PathVariable("id") Long id, Model model) {
        LegalEntity entity;
        if (id > 0) {
            entity = legalEntityService.findById(id).orElse(new LegalEntity());
        } else {
            entity = new LegalEntity();
        }
        model.addAttribute("entity", entity);
        model.addAttribute("isValid", validator.validate(entity).isEmpty());
        return "fragments/details/legal_entity_details";
    }

    @PostMapping("/dashboard/validate/legal-entity")
    public String validateLegalEntity(@Valid @ModelAttribute("entity") LegalEntity entity, BindingResult result, Model model) {
        model.addAttribute("fieldErrors", buildFieldErrors(result));
        model.addAttribute("hasErrors", result.hasErrors());
        return "fragments/details/legal_entity_validation";
    }

    @PostMapping("/dashboard/details/legal-entity")
    public String saveLegalEntity(@Valid @ModelAttribute("entity") LegalEntity entity, BindingResult result, Model model, HttpServletResponse response) {
        if (result.hasErrors()) {
            response.setHeader("HX-Retarget", "#le-form");
            model.addAttribute("fieldErrors", buildFieldErrors(result));
            model.addAttribute("hasErrors", true);
            return "fragments/details/legal_entity_details_form";
        }
        legalEntityService.save(entity);
        return tabLegalEntities(model);
    }

    @GetMapping("/dashboard/details/contract/{id}")
    public String detailsContract(@PathVariable("id") Long id, Model model) {
        Contract contract;
        if (id > 0) {
            contract = contractService.findById(id).orElse(new Contract());
        } else {
            contract = new Contract();
        }
        model.addAttribute("contract", contract);
        model.addAttribute("isValid", validator.validate(contract).isEmpty());
        return "fragments/details/contract_details";
    }

    @PostMapping("/dashboard/validate/contract")
    public String validateContract(@Valid @ModelAttribute("contract") Contract contract, BindingResult result, Model model) {
        model.addAttribute("fieldErrors", buildFieldErrors(result));
        model.addAttribute("hasErrors", result.hasErrors());
        return "fragments/details/contract_validation";
    }

    @PostMapping("/dashboard/details/contract")
    public String saveContract(@Valid @ModelAttribute("contract") Contract contract, BindingResult result, Model model, HttpServletResponse response) {
        if (result.hasErrors()) {
            response.setHeader("HX-Retarget", "#contract-form");
            model.addAttribute("fieldErrors", buildFieldErrors(result));
            model.addAttribute("hasErrors", true);
            return "fragments/details/contract_details_form";
        }
        contractService.save(contract);
        return tabContracts(model);
    }
}
