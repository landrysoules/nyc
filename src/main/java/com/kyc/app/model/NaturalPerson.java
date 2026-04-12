package com.kyc.app.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.time.LocalDate;
import java.time.LocalDateTime;
import org.hibernate.annotations.CreationTimestamp;
import org.hibernate.annotations.UpdateTimestamp;

@Entity
@Table(name = "natural_persons")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class NaturalPerson {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank(message = "First name is mandatory")
    private String firstName;
    
    @NotBlank(message = "Last name is mandatory")
    private String lastName;
    
    @NotBlank(message = "Nationality is mandatory")
    private String nationality;

    @NotNull(message = "Date of Birth is mandatory")
    private LocalDate dateOfBirth;

    @Enumerated(EnumType.STRING)
    private Gender gender;

    // ── Birth details ─────────────────────────────────────────────────────────
    private String placeOfBirth;

    private String countryOfBirth;

    // ── Identity documents ────────────────────────────────────────────────────
    private String taxIdentificationNumber;

    // ── Audit ─────────────────────────────────────────────────────────────────
    @CreationTimestamp
    private LocalDateTime createdAt;

    @UpdateTimestamp
    private LocalDateTime updatedAt;

    @OneToOne(cascade = CascadeType.ALL, fetch = FetchType.EAGER)
    private Address address = new Address();

    public NaturalPerson(String firstName, String lastName, String nationality, LocalDate dateOfBirth, Address address) {
        this.firstName = firstName;
        this.lastName = lastName;
        this.nationality = nationality;
        this.dateOfBirth = dateOfBirth;
        this.address = address;
    }
}
