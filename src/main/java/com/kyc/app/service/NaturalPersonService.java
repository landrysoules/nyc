package com.kyc.app.service;

import com.kyc.app.model.NaturalPerson;
import com.kyc.app.repository.NaturalPersonRepository;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@Service
public class NaturalPersonService {

    private final NaturalPersonRepository repository;

    public NaturalPersonService(NaturalPersonRepository repository) {
        this.repository = repository;
    }

    public List<NaturalPerson> findAll() {
        return repository.findAll();
    }

    public Optional<NaturalPerson> findById(Long id) {
        return repository.findById(id);
    }

    public NaturalPerson save(NaturalPerson person) {
        return repository.save(person);
    }

    public void deleteById(Long id) {
        repository.deleteById(id);
    }
}
