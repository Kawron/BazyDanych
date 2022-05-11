package com.company;

import javax.persistence.Entity;

@Entity
public class Customer extends Company {

    private float discount;

    public Customer() {

    }

    public Customer(String companyName, Address address) {
        super(companyName, address);
    }
}
