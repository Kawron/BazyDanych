package com.company;

import javax.persistence.EntityManager;
import javax.persistence.EntityManagerFactory;
import javax.persistence.EntityTransaction;
import javax.persistence.Persistence;


public class Main {

    public static void main(final String[] args) throws Exception {
        EntityManagerFactory emf = Persistence.
                createEntityManagerFactory("myDatabaseConfig");
        EntityManager em = emf.createEntityManager();
        EntityTransaction etx = em.getTransaction();
        etx.begin();

        try {
            Address address1 = new Address("Marszalkowsa", "Warszawa");
            Address address2 = new Address("6th avenue", "New York City");
            Address address3 = new Address("Krakowsa", "Lublin");
            Address address4 = new Address("Francuska", "Wroclaw");

            Supplier supplier1 = new Supplier("HomeArticles", address1);
            Supplier supplier2 = new Supplier("DunderMifflin", address2);
            Company comp1 = new Company("ExampleCompany",address3);
            Company comp2 = new Company("SuperCompany",address4);

            Invoice invoice1 = new Invoice(1234);
            Invoice invoice2 = new Invoice(9876);

            Category category1 = new Category("Artykuly biurowe");
            Category category2 = new Category("Meble biurowe");

            Product kreda = new Product("Kreda", 5);
            Product paper = new Product("paper", 564);
            Product biurko = new Product("biurko", 32);
            Product krzeslo = new Product("krzeslo obrotowe", 44);

            invoice1.addProduct(kreda);
            invoice1.addProduct(paper);
            invoice1.addProduct(biurko);
            invoice2.addProduct(krzeslo);

            category1.addProduct(kreda);
            category1.addProduct(paper);
            category2.addProduct(biurko);
            category2.addProduct(krzeslo);

            kreda.addSupplier(supplier1);
            paper.addSupplier(supplier2);
            biurko.addSupplier(supplier1);
            krzeslo.addSupplier(supplier1);
//             database operations
            em.persist(biurko);
            em.persist(krzeslo);
            em.persist(kreda);
            em.persist(paper);
            em.persist(supplier1);
            em.persist(supplier2);
            em.persist(comp1);
            em.persist(comp2);
            em.persist(category1);
            em.persist(category2);
            em.persist(invoice1);
            em.persist(invoice2);
            etx.commit();
        } finally {
            em.close();
        }
    }
}