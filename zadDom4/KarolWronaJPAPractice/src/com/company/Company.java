package com.company;

import javax.persistence.*;

@Entity
@Inheritance(strategy = InheritanceType.TABLE_PER_CLASS)
public class Company {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int ID;

    private String companyName;

    @Embedded
    private Address address;

    public Company() {
    }

    public Company(String companyName, Address address) {
        this.companyName = companyName;
        this.address = address;
    }
}
