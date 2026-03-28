package com.kyc.app.repository;

import com.kyc.app.model.NaturalPerson;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface NaturalPersonRepository extends JpaRepository<NaturalPerson, Long> {
}
