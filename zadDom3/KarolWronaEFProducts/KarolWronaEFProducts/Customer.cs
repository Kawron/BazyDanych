using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace KarolWronaEFProducts
{
    public class Customer : Company
    {
        public decimal? Discount { get; set; }
    }
}
