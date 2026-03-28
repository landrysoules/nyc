package com.kyc.app.service;

import com.kyc.app.model.LegalEntity;
import com.kyc.app.repository.LegalEntityRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class LegalEntityService {

    private final LegalEntityRepository repository;

    public LegalEntityService(LegalEntityRepository repository) {
        this.repository = repository;
    }

    public List<LegalEntity> findAll() {
        return repository.findAll();
    }

    public Optional<LegalEntity> findById(Long id) {
        return repository.findById(id);
    }

    public LegalEntity save(LegalEntity entity) {
        return repository.save(entity);
    }

    public void deleteById(Long id) {
        repository.deleteById(id);
    }
}
