using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations.Schema;

namespace KarolWronaEFProducts
{
    [Table("Suppliers")]
    public class Supplier : Company
    {
        public string? BankAccountNumber { get; set; }
    }
}
