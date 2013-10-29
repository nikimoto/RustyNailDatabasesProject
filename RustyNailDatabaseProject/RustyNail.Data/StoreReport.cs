using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace RustyNail.Data
{
    public class StoreReport
    {
        public String MarketName { get; set; }
        public DateTime Date { get; set; }
        public List<Entry> Products { get; set; }
        public Decimal TotalSum { get; set; }
        
        public StoreReport()
        {
            this.Products = new List<Entry>();
        }
    }
}
