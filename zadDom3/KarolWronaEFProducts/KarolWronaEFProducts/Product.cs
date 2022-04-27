using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace KarolWronaEFProducts
{
    public class Product
    {
        public int ProductID { get; set; }
        public string ProductName { get; set; }
        public int UnitsOnStock{ get; set; }

        public Supplier? SuppliedBy { get; set; }

        public ICollection<Invoice> CanBeSoldIn { get; set; }

    }
}
