package com.kyc.app.service;

import com.kyc.app.model.*;
import com.kyc.app.repository.NaturalPersonRepository;
import com.kyc.app.repository.PersonDocumentRepository;
import com.kyc.app.repository.PersonDocumentVersionRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class PersonDocumentService {

    private final PersonDocumentRepository documentRepository;
    private final PersonDocumentVersionRepository versionRepository;
    private final NaturalPersonRepository naturalPersonRepository;

    public PersonDocumentService(PersonDocumentRepository documentRepository,
                                 PersonDocumentVersionRepository versionRepository,
                                 NaturalPersonRepository naturalPersonRepository) {
        this.documentRepository = documentRepository;
        this.versionRepository = versionRepository;
        this.naturalPersonRepository = naturalPersonRepository;
    }

    @Transactional(readOnly = true)
    public List<PersonDocument> findAllForPerson(Long personId) {
        return documentRepository.findByNaturalPersonIdWithVersions(personId);
    }

    @Transactional(readOnly = true)
    public List<PersonDocument> findProvidedDocuments(Long personId) {
        return findAllForPerson(personId).stream()
                .filter(PersonDocument::isProvided)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<PersonDocument> findMissingDocuments(Long personId) {
        return findAllForPerson(personId).stream()
                .filter(d -> !d.isProvided())
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<DocumentType> getAvailableTypesToRequire(Long personId) {
        List<PersonDocument> existing = findAllForPerson(personId);
        List<DocumentType> alreadyRequired = existing.stream()
                .map(PersonDocument::getDocumentType)
                .collect(Collectors.toList());
        return Arrays.stream(DocumentType.values())
                .filter(t -> !alreadyRequired.contains(t))
                .collect(Collectors.toList());
    }

    @Transactional
    public PersonDocument requireDocument(Long personId, DocumentType documentType, String note, String requiredBy) {
        NaturalPerson person = naturalPersonRepository.findById(personId)
                .orElseThrow(() -> new IllegalArgumentException("Natural person not found: " + personId));

        if (documentRepository.findByNaturalPersonIdAndDocumentType(personId, documentType).isPresent()) {
            throw new IllegalStateException("Document type already required: " + documentType);
        }

        PersonDocument doc = new PersonDocument();
        doc.setNaturalPerson(person);
        doc.setDocumentType(documentType);
        doc.setNote(note);
        doc.setRequiredBy(requiredBy);
        return documentRepository.save(doc);
    }

    @Transactional
    public PersonDocumentVersion uploadVersion(Long documentId, MultipartFile file, String uploadedBy) throws IOException {
        PersonDocument doc = documentRepository.findById(documentId)
                .orElseThrow(() -> new IllegalArgumentException("Document not found: " + documentId));

        int nextVersion = versionRepository.countByDocumentId(documentId) + 1;

        PersonDocumentVersion version = new PersonDocumentVersion();
        version.setDocument(doc);
        version.setVersionNumber(nextVersion);
        version.setFileName(file.getOriginalFilename());
        version.setContentType(file.getContentType());
        version.setFileData(file.getBytes());
        version.setUploadedBy(uploadedBy);
        version.setStatus(KycStatus.PENDING);
        return versionRepository.save(version);
    }

    @Transactional(readOnly = true)
    public Optional<PersonDocumentVersion> findVersion(Long versionId) {
        return versionRepository.findById(versionId);
    }

    @Transactional(readOnly = true)
    public Optional<PersonDocument> findDocument(Long documentId) {
        return documentRepository.findById(documentId);
    }
}
