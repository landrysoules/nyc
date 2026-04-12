package com.kyc.app.repository;

import com.kyc.app.model.PersonDocumentVersion;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface PersonDocumentVersionRepository extends JpaRepository<PersonDocumentVersion, Long> {

    Optional<PersonDocumentVersion> findByDocumentIdAndVersionNumber(Long documentId, int versionNumber);

    int countByDocumentId(Long documentId);
}
