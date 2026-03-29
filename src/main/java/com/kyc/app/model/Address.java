package com.kyc.app.model;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@Table(name = "addresses")
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Address {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private String streetNumber;
    private String streetName;
    private String building;
    private String addressComplement;
    private String zipCode;
    private String city;
    private String country;

    public Address(String streetNumber, String streetName, String building, String addressComplement, String zipCode, String city, String country) {
        this.streetNumber = streetNumber;
        this.streetName = streetName;
        this.building = building;
        this.addressComplement = addressComplement;
        this.zipCode = zipCode;
        this.city = city;
        this.country = country;
    }
}
