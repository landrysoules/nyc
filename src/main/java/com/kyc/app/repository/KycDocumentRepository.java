package com.kyc.app.repository;

import com.kyc.app.model.KycDocument;
import org.springframework.data.jpa.repository.JpaRepository;

public interface KycDocumentRepository extends JpaRepository<KycDocument, Long> {
}
