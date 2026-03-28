package com.kyc.app.model;

import jakarta.persistence.Embeddable;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Embeddable
@Data
@NoArgsConstructor
@AllArgsConstructor
public class Address {

    private String streetNumber;
    private String streetName;
    private String building;
    private String addressComplement;
    private String zipCode;
    private String city;
    private String country;
}
