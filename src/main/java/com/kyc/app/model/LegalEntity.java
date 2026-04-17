package com.kyc.app.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "legal_entities")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class LegalEntity {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank(message = "Jurisdiction is mandatory")
    private String jurisdiction;

    @NotBlank(message = "Name is mandatory")
    private String name;
    
    @NotBlank(message = "Country is mandatory")
    private String country;
    
    @NotBlank(message = "Registration number is mandatory")
    private String registrationNumber;

    @OneToOne(cascade = CascadeType.ALL, fetch = FetchType.EAGER)
    private Address address = new Address();

    public LegalEntity(String jurisdiction, String name, String country, String registrationNumber, Address address) {
        this.jurisdiction = jurisdiction;
        this.name = name;
        this.country = country;
        this.registrationNumber = registrationNumber;
        this.address = address;
    }
}
