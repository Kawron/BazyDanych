package com.company;

import javax.persistence.*;
import java.util.ArrayList;
import java.util.List;

@Entity
public class Product {

    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private int ID;

    private String productName;
    private int unitsOnStock;

    @ManyToOne
    private Category category;

    @ManyToOne
    private Supplier isSuppliedBy;

    @ManyToMany(mappedBy = "includes", cascade = {CascadeType.PERSIST})
    private List<Invoice> canBeSoldIn;

    public Product() {

    }

    public Product(String productName, int unitsOnStock) {
        this.productName = productName;
        this.unitsOnStock = unitsOnStock;
        this.canBeSoldIn = new ArrayList<>();
    }

    public void addSupplier(Supplier supplier) {
        this.isSuppliedBy = supplier;
        supplier.addProduct(this);
    }

    public void changeCategory(Category category) {
        this.category = category;
    }

    public List<Invoice> getCanBeSoldIn() {
        return canBeSoldIn;
    }
}
