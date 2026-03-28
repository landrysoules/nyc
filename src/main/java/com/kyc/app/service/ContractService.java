package com.kyc.app.service;

import com.kyc.app.model.Contract;
import com.kyc.app.repository.ContractRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class ContractService {

    private final ContractRepository repository;

    public ContractService(ContractRepository repository) {
        this.repository = repository;
    }

    public List<Contract> findAll() {
        return repository.findAll();
    }

    public Optional<Contract> findById(Long id) {
        return repository.findById(id);
    }

    public Contract save(Contract contract) {
        return repository.save(contract);
    }

    public void deleteById(Long id) {
        repository.deleteById(id);
    }
}
