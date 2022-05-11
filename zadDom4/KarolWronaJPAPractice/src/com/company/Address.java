package com.company;

import javax.persistence.Embeddable;
import javax.persistence.Entity;

@Embeddable
public class Address {

    private String street;
    private String city;

    public Address() {

    }

    public Address(String street, String city) {
        this.street = street;
        this.city = city;
    }
}
