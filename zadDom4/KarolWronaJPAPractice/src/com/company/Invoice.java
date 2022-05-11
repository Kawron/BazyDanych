package com.company;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
public class Invoice {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int ID;

    private int invoiceNumber;
    private int quantity;

    @ManyToMany (cascade = {CascadeType.PERSIST})
    private List<Product> includes;

    public Invoice() {

    }

    public Invoice(int invoiceNumber) {
        this.invoiceNumber = invoiceNumber;
        this.includes = new ArrayList<>();
        this.quantity = 0;
    }

    public void addProduct(Product product) {
        includes.add(product);
        product.getCanBeSoldIn().add(this);
        this.quantity++;
    }
}
