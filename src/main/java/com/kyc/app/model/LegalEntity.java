package com.kyc.app.model;

import jakarta.persistence.*;
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

    private String name;
    private String country;
    private String registrationNumber;

    @Embedded
    @AttributeOverrides({
        @AttributeOverride(name = "country", column = @Column(name = "address_country"))
    })
    private Address address;

    public LegalEntity(String name, String country, String registrationNumber, Address address) {
        this.name = name;
        this.country = country;
        this.registrationNumber = registrationNumber;
        this.address = address;
    }
}
