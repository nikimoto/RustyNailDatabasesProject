using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RustyNail.Data
{
    public class Entry
    {
        public int ProductId { get; set; }
        public double QuantityValue { get; set; }
        public String ProductName { get; set; }
        public String Quantity { get; set; }
        public Decimal UnitPrice { get; set; }
        public String Location { get; set; }
        public Decimal Sum { get; set; }
    }
}
