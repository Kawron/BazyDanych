package com.company;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
public class Supplier extends Company {

    @OneToMany (mappedBy = "isSuppliedBy")
    private List<Product> supplies;

    public Supplier() {

    }

    public Supplier(String companyName, Address address) {
        super(companyName, address);
        this.supplies = new ArrayList<>();
    }

    public void addProduct(Product product) {
        this.supplies.add(product);
    }
}
