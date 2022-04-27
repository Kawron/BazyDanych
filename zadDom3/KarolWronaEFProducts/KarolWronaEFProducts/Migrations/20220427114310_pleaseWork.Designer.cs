﻿// <auto-generated />
using System;
using KarolWronaEFProducts;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Infrastructure;
using Microsoft.EntityFrameworkCore.Migrations;
using Microsoft.EntityFrameworkCore.Storage.ValueConversion;

#nullable disable

namespace KarolWronaEFProducts.Migrations
{
    [DbContext(typeof(ProductContext))]
    [Migration("20220427114310_pleaseWork")]
    partial class pleaseWork
    {
        protected override void BuildTargetModel(ModelBuilder modelBuilder)
        {
#pragma warning disable 612, 618
            modelBuilder.HasAnnotation("ProductVersion", "6.0.4");

            modelBuilder.Entity("InvoiceProduct", b =>
                {
                    b.Property<int>("CanBeSoldInInvoiceNumber")
                        .HasColumnType("INTEGER");

                    b.Property<int>("IncludesProductID")
                        .HasColumnType("INTEGER");

                    b.HasKey("CanBeSoldInInvoiceNumber", "IncludesProductID");

                    b.HasIndex("IncludesProductID");

                    b.ToTable("InvoiceProduct");
                });

            modelBuilder.Entity("KarolWronaEFProducts.Company", b =>
                {
                    b.Property<int>("CompanyID")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("INTEGER");

                    b.Property<string>("City")
                        .IsRequired()
                        .HasColumnType("TEXT");

                    b.Property<string>("CompanyName")
                        .IsRequired()
                        .HasColumnType("TEXT");

                    b.Property<string>("Street")
                        .IsRequired()
                        .HasColumnType("TEXT");

                    b.Property<string>("ZipCode")
                        .IsRequired()
                        .HasColumnType("TEXT");

                    b.HasKey("CompanyID");

                    b.ToTable("Companies");
                });

            modelBuilder.Entity("KarolWronaEFProducts.Invoice", b =>
                {
                    b.Property<int>("InvoiceNumber")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("INTEGER");

                    b.Property<int>("Quantity")
                        .HasColumnType("INTEGER");

                    b.HasKey("InvoiceNumber");

                    b.ToTable("Invoices");
                });

            modelBuilder.Entity("KarolWronaEFProducts.Product", b =>
                {
                    b.Property<int>("ProductID")
                        .ValueGeneratedOnAdd()
                        .HasColumnType("INTEGER");

                    b.Property<string>("ProductName")
                        .IsRequired()
                        .HasColumnType("TEXT");

                    b.Property<int?>("SuppliedByCompanyID")
                        .HasColumnType("INTEGER");

                    b.Property<int>("UnitsOnStock")
                        .HasColumnType("INTEGER");

                    b.HasKey("ProductID");

                    b.HasIndex("SuppliedByCompanyID");

                    b.ToTable("Products");
                });

            modelBuilder.Entity("KarolWronaEFProducts.Customer", b =>
                {
                    b.HasBaseType("KarolWronaEFProducts.Company");

                    b.Property<decimal?>("Discount")
                        .HasColumnType("TEXT");

                    b.ToTable("Customers");
                });

            modelBuilder.Entity("KarolWronaEFProducts.Supplier", b =>
                {
                    b.HasBaseType("KarolWronaEFProducts.Company");

                    b.Property<string>("BankAccountNumber")
                        .HasColumnType("TEXT");

                    b.ToTable("Suppliers");
                });

            modelBuilder.Entity("InvoiceProduct", b =>
                {
                    b.HasOne("KarolWronaEFProducts.Invoice", null)
                        .WithMany()
                        .HasForeignKey("CanBeSoldInInvoiceNumber")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();

                    b.HasOne("KarolWronaEFProducts.Product", null)
                        .WithMany()
                        .HasForeignKey("IncludesProductID")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();
                });

            modelBuilder.Entity("KarolWronaEFProducts.Product", b =>
                {
                    b.HasOne("KarolWronaEFProducts.Supplier", "SuppliedBy")
                        .WithMany()
                        .HasForeignKey("SuppliedByCompanyID");

                    b.Navigation("SuppliedBy");
                });

            modelBuilder.Entity("KarolWronaEFProducts.Customer", b =>
                {
                    b.HasOne("KarolWronaEFProducts.Company", null)
                        .WithOne()
                        .HasForeignKey("KarolWronaEFProducts.Customer", "CompanyID")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();
                });

            modelBuilder.Entity("KarolWronaEFProducts.Supplier", b =>
                {
                    b.HasOne("KarolWronaEFProducts.Company", null)
                        .WithOne()
                        .HasForeignKey("KarolWronaEFProducts.Supplier", "CompanyID")
                        .OnDelete(DeleteBehavior.Cascade)
                        .IsRequired();
                });
#pragma warning restore 612, 618
        }
    }
}
