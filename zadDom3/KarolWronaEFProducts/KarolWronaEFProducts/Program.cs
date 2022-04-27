// See https://aka.ms/new-console-template for more information

using KarolWronaEFProducts;
using System.Linq;

ProductContext productContext = new ProductContext();

//Product flamaster = new Product { ProductName = "flamaster", UnitsOnStock = 2, CanBeSoldIn = new LinkedList<Invoice>() };
//Product kreda = new Product { ProductName = "kreda", UnitsOnStock = 3, CanBeSoldIn = new LinkedList<Invoice>() };
//Product dlugopis = new Product { ProductName = "dlugopis", UnitsOnStock = 1, CanBeSoldIn = new LinkedList<Invoice>() };
//Product linijka = new Product { ProductName = "linijka", UnitsOnStock = 5, CanBeSoldIn = new LinkedList<Invoice>() };
//Product ekierka = new Product { ProductName = "ekierka", UnitsOnStock = 3, CanBeSoldIn = new LinkedList<Invoice>() };

//Invoice invoice1 = new Invoice { Quantity = 1 , Includes = new LinkedList<Product>()};
//Invoice invoice2 = new Invoice { Quantity = 1 , Includes = new LinkedList<Product>() };

//flamaster.CanBeSoldIn.Add(invoice1);
//flamaster.CanBeSoldIn.Add(invoice2);
//kreda.CanBeSoldIn.Add(invoice1);
//dlugopis.CanBeSoldIn.Add(invoice1);
//linijka.CanBeSoldIn.Add(invoice2);
//ekierka.CanBeSoldIn.Add(invoice2);

//invoice1.Includes.Add(flamaster);
//invoice1.Includes.Add(kreda);
//invoice1.Includes.Add(dlugopis);
//invoice2.Includes.Add(linijka);
//invoice2.Includes.Add(ekierka);
//invoice2.Includes.Add(flamaster);

//Company supplier1 = new Supplier { CompanyName = "PisadlaCompany", City = "Cracow", Street = "Reymonta", ZipCode = "12-123", BankAccountNumber = "123456789" };
//Company supplier2 = new Supplier { CompanyName = "Linijka&Ekierka", City = "Cracow", Street = "Nawojki", ZipCode = "12-345", BankAccountNumber = "987654321" };

//Company person1 = new Customer { CompanyName = "Maciej", City = "Warsaw", Street = "Marszalkowska", ZipCode = "31-234", Discount = 0.12M };
//Company person2 = new Customer { CompanyName = "Adam", City = "Wroclaw", Street = "Slodowa", ZipCode = "35-234", Discount = 0.8M };

//supplier1.Supplies.Add(flamaster);
//supplier1.Supplies.Add(kreda);
//supplier1.Supplies.Add(dlugopis);
//supplier2.Supplies.Add(linijka);
//supplier2.Supplies.Add(ekierka);

//flamaster.SuppliedBy = supplier1;
//kreda.SuppliedBy = supplier1;
//dlugopis.SuppliedBy = supplier1;
//linijka.SuppliedBy = supplier2;
//ekierka.SuppliedBy = supplier2;

//productContext.Products.Add(flamaster);
//productContext.Products.Add(kreda);
//productContext.Products.Add(dlugopis);
//productContext.Products.Add(linijka);
//productContext.Products.Add(ekierka);

//productContext.Invoices.Add(invoice1);
//productContext.Invoices.Add(invoice2);

//productContext.Companies.Add(person1);
//productContext.Companies.Add(person2);
//productContext.Companies.Add(supplier1);
//productContext.Companies.Add(supplier2);


var query = from comp in productContext.Companies
            where comp.CompanyID == 1
            select comp.CompanyName;

Console.WriteLine("Name of company with CompanyID = 1");
foreach (var name in query)
{
    Console.WriteLine(name);
}

var query2 = from comp in productContext.Companies
             where comp.CompanyID == 3
             select comp.CompanyName;

Console.WriteLine("Name of company with CompanyID = 3");
foreach (var name in query2)
{
    Console.WriteLine(name);
}

//var query = from product in productContext.Products
//            where product.ProductID == 1
//            select product.CanBeSoldIn;

//Console.WriteLine("Invoices where product nr.1 was sold: ");
//foreach (var item in query)
//{
//    foreach (var invoice in item)
//    {
//        Console.WriteLine(invoice.InvoiceNumber);
//    }
//}

//var query2 = from sup in productContext.Suppliers
//             select sup;

//foreach (var product in query)
//{
//    productContext.Remove(product);
//}

//foreach (var sup in query2)
//{
//    productContext.Remove(sup);
//}

productContext.SaveChanges();