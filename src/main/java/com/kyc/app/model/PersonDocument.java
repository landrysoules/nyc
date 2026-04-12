package com.kyc.app.model;

import jakarta.persistence.*;
import org.hibernate.annotations.CreationTimestamp;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "person_documents",
        uniqueConstraints = @UniqueConstraint(columnNames = {"natural_person_id", "document_type"}))
public class PersonDocument {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "natural_person_id", nullable = false)
    private NaturalPerson naturalPerson;

    @Enumerated(EnumType.STRING)
    @Column(name = "document_type", nullable = false)
    private DocumentType documentType;

    @Column(length = 500)
    private String note;

    @CreationTimestamp
    private LocalDateTime requiredAt;

    private String requiredBy;

    @OneToMany(mappedBy = "document", cascade = CascadeType.ALL, fetch = FetchType.LAZY, orphanRemoval = true)
    @OrderBy("versionNumber DESC")
    private List<PersonDocumentVersion> versions = new ArrayList<>();

    public boolean isProvided() {
        return versions.stream().anyMatch(v -> v.getStatus() != KycStatus.REJECTED);
    }

    // Getters and setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public NaturalPerson getNaturalPerson() { return naturalPerson; }
    public void setNaturalPerson(NaturalPerson naturalPerson) { this.naturalPerson = naturalPerson; }

    public DocumentType getDocumentType() { return documentType; }
    public void setDocumentType(DocumentType documentType) { this.documentType = documentType; }

    public String getNote() { return note; }
    public void setNote(String note) { this.note = note; }

    public LocalDateTime getRequiredAt() { return requiredAt; }
    public void setRequiredAt(LocalDateTime requiredAt) { this.requiredAt = requiredAt; }

    public String getRequiredBy() { return requiredBy; }
    public void setRequiredBy(String requiredBy) { this.requiredBy = requiredBy; }

    public List<PersonDocumentVersion> getVersions() { return versions; }
    public void setVersions(List<PersonDocumentVersion> versions) { this.versions = versions; }
}
