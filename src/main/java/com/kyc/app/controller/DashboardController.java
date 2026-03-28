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
import org.springframework.web.bind.annotation.*;

@Controller
public class DashboardController {

    private final NaturalPersonService naturalPersonService;
    private final LegalEntityService legalEntityService;
    private final ContractService contractService;

    public DashboardController(NaturalPersonService naturalPersonService,
                               LegalEntityService legalEntityService,
                               ContractService contractService) {
        this.naturalPersonService = naturalPersonService;
        this.legalEntityService = legalEntityService;
        this.contractService = contractService;
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

    // --- Modals (Read Only & Forms) ---
    
    @GetMapping("/dashboard/modal/natural-person/{id}")
    public String modalNaturalPerson(@PathVariable("id") Long id, Model model) {
        if(id > 0) {
            model.addAttribute("person", naturalPersonService.findById(id).orElse(new NaturalPerson()));
        } else {
            model.addAttribute("person", new NaturalPerson());
        }
        return "fragments/modals/natural-person-modal :: modal";
    }

    @PostMapping("/dashboard/modal/natural-person")
    public String saveNaturalPerson(@ModelAttribute NaturalPerson person, Model model) {
        naturalPersonService.save(person);
        return tabNaturalPersons(model); // refresh the list
    }
    
    @GetMapping("/dashboard/modal/legal-entity/{id}")
    public String modalLegalEntity(@PathVariable("id") Long id, Model model) {
        if(id > 0) {
            model.addAttribute("entity", legalEntityService.findById(id).orElse(new LegalEntity()));
        } else {
            model.addAttribute("entity", new LegalEntity());
        }
        return "fragments/modals/legal-entity-modal :: modal";
    }

    @PostMapping("/dashboard/modal/legal-entity")
    public String saveLegalEntity(@ModelAttribute LegalEntity entity, Model model) {
        legalEntityService.save(entity);
        return tabLegalEntities(model); // refresh the list
    }
    
    @GetMapping("/dashboard/modal/contract/{id}")
    public String modalContract(@PathVariable("id") Long id, Model model) {
        if(id > 0) {
            model.addAttribute("contract", contractService.findById(id).orElse(new Contract()));
        } else {
            model.addAttribute("contract", new Contract());
        }
        return "fragments/modals/contract-modal :: modal";
    }

    @PostMapping("/dashboard/modal/contract")
    public String saveContract(@ModelAttribute Contract contract, Model model) {
        contractService.save(contract);
        return tabContracts(model); // refresh the list
    }
}
