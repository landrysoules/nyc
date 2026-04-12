package com.kyc.app.repository;

import com.kyc.app.model.DocumentType;
import com.kyc.app.model.PersonDocument;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface PersonDocumentRepository extends JpaRepository<PersonDocument, Long> {

    @Query("SELECT d FROM PersonDocument d LEFT JOIN FETCH d.versions WHERE d.naturalPerson.id = :personId ORDER BY d.documentType")
    List<PersonDocument> findByNaturalPersonIdWithVersions(@Param("personId") Long personId);

    Optional<PersonDocument> findByNaturalPersonIdAndDocumentType(Long naturalPersonId, DocumentType documentType);
}
