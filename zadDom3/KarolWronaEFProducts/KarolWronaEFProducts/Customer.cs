using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace KarolWronaEFProducts
{
    [Table("Customers")]
    public class Customer : Company
    {
        public decimal? Discount { get; set; }
    }
}
